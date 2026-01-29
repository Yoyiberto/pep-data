#!/usr/bin/env python3
"""
Simple VHDLEval - Pure Python implementation
Skips Makefile completely, runs tests and generates statistics directly.
Based and simplified from Nvidia's verilog-eval repo.
"""

import os
import subprocess
import glob
import re
import csv
from pathlib import Path
from dataclasses import dataclass
from collections import OrderedDict

@dataclass
class ResultRecord:
    passfail: str = '?'
    num_mismatch: int = 0
    prompt_tokens: int = 0
    resp_tokens: int = 0
    cost: float = 0.0

class VHDLEvaluator:
    def __init__(self, dataset_dir="dataset_spec-to-rtl", build_dir="build", ghdl_cmd="ghdl"):
        self.dataset_dir = Path(dataset_dir)
        self.build_dir = Path(build_dir)
        self.ghdl_cmd = ghdl_cmd
        self.results = OrderedDict()
        
    def get_problems(self):
        """Get list of problems from problems.txt or by scanning directory"""
        problems_file = self.dataset_dir / "problems.txt"
        if problems_file.exists():
            with open(problems_file, 'r') as f:
                return [line.strip() for line in f if line.strip()]
        else:
            # Fallback: scan for Prob* directories
            return [p.stem for p in self.dataset_dir.glob("Prob*_prompt.txt")]
    
    def compile_and_test(self, problem, sample_num):
        """Compile and test a single sample"""
        problem_dir = self.build_dir / problem
        
        # File paths
        solution_file = problem_dir / f"{problem}_sample{sample_num:02d}.vhd"
        test_file = self.dataset_dir / f"{problem}_test.vhd"
        ref_file = self.dataset_dir / f"{problem}_ref.vhd"
        
        binary_file = problem_dir / f"{problem}_sample{sample_num:02d}"
        log_file = problem_dir / f"{problem}_sample{sample_num:02d}-vhd-ghdl-test.log"
        
        if not solution_file.exists():
            print(f"Warning: {solution_file} does not exist")
            return None
            
        # Compile with ghdl
        work_dir = problem_dir / f"work_sample{sample_num:02d}"
        work_dir.mkdir(exist_ok=True)
        
        compile_cmd = [
            self.ghdl_cmd,
            "-a", "--std=08", f"--workdir={work_dir}",
            str(ref_file), str(solution_file), str(test_file)
        ]
        
        print(f"Testing {problem} sample {sample_num:02d}")
        
        try:
            # Run compilation
            result = subprocess.run(
                compile_cmd, 
                capture_output=True, 
                text=True, 
                timeout=30
            )
            
            # Write compilation output to log
            with open(log_file, 'w') as f:
                f.write(result.stderr)
                if result.returncode != 0:
                    f.write(f"\nCompilation failed with return code {result.returncode}\n")
            
            # If compilation succeeded, run the test
            if result.returncode == 0:
                try:
                    # Run simulation directly with ghdl
                    run_cmd = [self.ghdl_cmd, "-r", "--std=08", f"--workdir={work_dir}", "tb", "--stop-time=1ms"]
                    test_result = subprocess.run(
                        run_cmd, 
                        capture_output=True, 
                        text=True, 
                        timeout=30
                    )
                    
                    # Append test output to log
                    with open(log_file, 'a') as f:
                        f.write(test_result.stdout)
                        f.write(test_result.stderr)
                        if test_result.returncode != 0:
                            f.write(f"\nSimulation failed with return code {test_result.returncode}\n")
                        
                except subprocess.TimeoutExpired:
                    with open(log_file, 'a') as f:
                        f.write("TIMEOUT\n")
                        
        except subprocess.TimeoutExpired:
            with open(log_file, 'a') as f:
                f.write("COMPILATION TIMEOUT\n")
                
        return log_file
    
    def analyze_result(self, problem, sample_num, log_file, solution_file):
        """Analyze test results (adapted for VHDL)"""
        result_record = ResultRecord()
        
        if not log_file.exists():
            return result_record
            
        # Process compile/test log
        with open(log_file, 'r') as file:
            error_C = False
            error_p = False
            no_mismatch = False
            
            mismatch_pattern = r'^Mismatches: (\d+) in \d+ samples$'
            
            for line in file:
                line = line.lower()
                
                if "syntax error" in line or "parse error" in line:
                    result_record.passfail = 'S'
                    break
                    
                if "error:" in line:
                    error_C = True
                    
                if "elaboration failed" in line:
                    result_record.passfail = 'e'
                    break
                    
                if "timeout" in line:
                    result_record.passfail = 'T'
                    break
                    
                if "can't elaborate" in line:
                    result_record.passfail = 'm'
                    break
                    
                if "not declared" in line or "undeclared" in line:
                    error_p = True
                    
                # Look for VHDL specific patterns
                match = re.search(r'mismatches:\s*(\d+)\s*in\s*(\d+)\s*samples', line)
                if match:
                    num_mismatch = int(match.group(1))
                    if num_mismatch == 0:
                        no_mismatch = True
                    else:
                        result_record.num_mismatch = num_mismatch
                        
                # Check for assertion messages indicating success
                if "passed" in line and "note" in line:
                    no_mismatch = True
                elif "failed" in line and "error" in line:
                    if result_record.num_mismatch == 0:
                        result_record.num_mismatch = 1
        
        # Set final pass/fail status
        if result_record.passfail == '?' and error_p:
            result_record.passfail = 'p'
        elif result_record.passfail == '?' and error_C:
            result_record.passfail = 'C'
        elif result_record.passfail == '?' and no_mismatch:
            result_record.passfail = '.'
        elif result_record.passfail == '?' and solution_file.exists():
            # Check for runtime issues in VHDL code
            with open(solution_file, 'r') as f:
                content = f.read().lower()
                if "rising_edge(reset)" in content or "falling_edge(reset)" in content:
                    result_record.passfail = 'r'
                else:
                    result_record.passfail = 'R'
        
        return result_record
    
    def run_evaluation(self, problems=None):
        """Run complete evaluation"""
        if problems is None:
            problems = self.get_problems()
            
        print(f"Found {len(problems)} problems")
        
        for problem in problems:
            problem_dir = self.build_dir / problem
            
            if not problem_dir.exists():
                print(f"Warning: {problem_dir} does not exist, skipping")
                continue
                
            # Find all sample files for this problem
            sample_files = list(problem_dir.glob(f"{problem}_sample*.vhd"))
            
            if not sample_files:
                print(f"Warning: No sample files found for {problem}")
                continue
                
            problem_results = []
            
            for sample_file in sorted(sample_files):
                # Extract sample number
                match = re.search(r'sample(\d+)\.vhd$', sample_file.name)
                if not match:
                    continue
                    
                sample_num = int(match.group(1))
                
                # Run test
                log_file = self.compile_and_test(problem, sample_num)
                
                if log_file:
                    # Analyze result
                    result = self.analyze_result(problem, sample_num, log_file, sample_file)
                    problem_results.append((sample_num, result))
            
            if problem_results:
                self.results[problem] = problem_results
    
    def print_summary(self):
        """Print summary results"""
        if not self.results:
            print("No results to display")
            return
            
        print("\nSUMMARY:")
        print("=" * 80)
        
        total_pass = 0
        total_samples = 0
        
        for problem, results in self.results.items():
            passes = sum(1 for _, result in results if result.passfail == '.')
            total = len(results)
            pass_rate = (passes / total * 100) if total > 0 else 0
            
            # Create result string
            result_str = ""
            for i, (sample_num, result) in enumerate(results):
                if i > 0 and i % 5 == 0:
                    result_str += " "
                result_str += result.passfail
            
            print(f"{problem:<30} {pass_rate:6.1f}% ({passes:2d}/{total:2d}) {result_str}")
            
            total_pass += passes
            total_samples += total
        
        overall_pass_rate = (total_pass / total_samples * 100) if total_samples > 0 else 0
        print("=" * 80)
        print(f"{'OVERALL':<30} {overall_pass_rate:6.1f}% ({total_pass:3d}/{total_samples:3d})")
    
    def write_csv(self, filename):
        """Write results to CSV file"""
        with open(filename, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['Problem', 'Sample', 'Result', 'Pass', 'Mismatches'])
            
            for problem, results in self.results.items():
                for sample_num, result in results:
                    writer.writerow([
                        problem, 
                        sample_num, 
                        result.passfail,
                        1 if result.passfail == '.' else 0,
                        result.num_mismatch
                    ])

def copy_reference_solutions_demo(evaluator, num_samples=3):
    """Demo function: Copy reference solutions as samples for testing"""
    problems = evaluator.get_problems()
    
    print(f"Creating demo with {num_samples} samples per problem...")
    
    for problem in problems[:2]:  # Just first 2 problems for demo
        problem_dir = evaluator.build_dir / problem
        problem_dir.mkdir(parents=True, exist_ok=True)
        
        ref_file = evaluator.dataset_dir / f"{problem}_ref.vhd"
        
        if ref_file.exists():
            for i in range(1, num_samples + 1):
                sample_file = problem_dir / f"{problem}_sample{i:02d}.vhd"
                
                # Read reference and modify module name
                with open(ref_file, 'r') as f:
                    content = f.read()
                
                # Change RefModule to TopModule (expected by testbench)
                content = content.replace('RefModule', 'TopModule')
                
                with open(sample_file, 'w') as f:
                    f.write(content)
                    
            print(f"Created samples for {problem}")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Simple VHDLEval')
    parser.add_argument('--dataset', default='dataset_spec-to-rtl', help='Dataset directory')
    parser.add_argument('--build', default='build', help='Build directory') 
    parser.add_argument('--csv', help='Output CSV file')
    parser.add_argument('--demo', action='store_true', help='Create demo by copying reference solutions')
    parser.add_argument('--samples', type=int, default=3, help='Number of samples for demo')
    parser.add_argument('problems', nargs='*', help='Specific problems to evaluate')
    
    args = parser.parse_args()
    
    evaluator = VHDLEvaluator(args.dataset, args.build)
    
    if args.demo:
        copy_reference_solutions_demo(evaluator, args.samples)
    
    evaluator.run_evaluation(args.problems)
    evaluator.print_summary()
    
    if args.csv:
        evaluator.write_csv(args.csv)
        print(f"Results written to {args.csv}")
