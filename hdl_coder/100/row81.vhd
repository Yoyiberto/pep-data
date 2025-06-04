--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:53:20 11/25/2016
-- Design Name:   
-- Module Name:   Z:/Documents/COP/COPproject/project/maintester.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY maintester IS
END maintester;
 
ARCHITECTURE behavior OF maintester IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         CLK0 : IN  std_logic;
         CLK1 : IN  std_logic;
         RAM1DATA : INOUT  std_logic_vector(15 downto 0);
         RAM2DATA : INOUT  std_logic_vector(15 downto 0);
         RAM1EN : OUT  std_logic;
         RAM1OE : OUT  std_logic;
         RAM1WE : OUT  std_logic;
         RAM2EN : OUT  std_logic;
         RAM2OE : OUT  std_logic;
         RAM2WE : OUT  std_logic;
         RAM1ADDR : OUT  std_logic_vector(17 downto 0);
         RAM2ADDR : OUT  std_logic_vector(17 downto 0);
         RESET : IN  std_logic;
         rdn : OUT  std_logic;
         wrn : OUT  std_logic;
         data_ready : IN  std_logic;
         tbre : IN  std_logic;
         tsre : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK0 : std_logic := '0';
   signal CLK1 : std_logic := '0';
   signal RESET : std_logic := '1';
   signal data_ready : std_logic := '0';
   signal tbre : std_logic := '0';
   signal tsre : std_logic := '0';

	--BiDirs
   signal RAM1DATA : std_logic_vector(15 downto 0);
   signal RAM2DATA : std_logic_vector(15 downto 0);

 	--Outputs
   signal RAM1EN : std_logic;
   signal RAM1OE : std_logic;
   signal RAM1WE : std_logic;
   signal RAM2EN : std_logic;
   signal RAM2OE : std_logic;
   signal RAM2WE : std_logic;
   signal RAM1ADDR : std_logic_vector(17 downto 0);
   signal RAM2ADDR : std_logic_vector(17 downto 0);
   signal rdn : std_logic;
   signal wrn : std_logic;

   -- Clock period definitions
   constant CLK0_period : time := 1 sec;
   constant CLK1_period : time := 1 sec;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          CLK0 => CLK0,
          CLK1 => CLK1,
          RAM1DATA => RAM1DATA,
          RAM2DATA => RAM2DATA,
          RAM1EN => RAM1EN,
          RAM1OE => RAM1OE,
          RAM1WE => RAM1WE,
          RAM2EN => RAM2EN,
          RAM2OE => RAM2OE,
          RAM2WE => RAM2WE,
          RAM1ADDR => RAM1ADDR,
          RAM2ADDR => RAM2ADDR,
          RESET => RESET,
          rdn => rdn,
          wrn => wrn,
          data_ready => data_ready,
          tbre => tbre,
          tsre => tsre
        );

   -- Clock process definitions
   CLK0_process :process
   begin
		CLK0 <= '0';
		wait for CLK0_period/2;
		CLK0 <= '1';
		wait for CLK0_period/2;
   end process;
 
   CLK1 <= '1';
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK0_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
