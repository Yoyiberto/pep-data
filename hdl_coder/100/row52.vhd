library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlasherTestBench is
end FlasherTestBench;

architecture Behavioral of FlasherTestBench is
	signal led : std_ulogic_vector(3 downto 0);
	signal clock : std_ulogic := '0';
begin
	uut : entity work.Flasher(FlasherArchitecture)
	generic map (WIDTH => 6)
	port map (
		LED => led,
		CLK_66MHZ => clock
	);
	
	clock <= not clock after 7.57575757 ns;
		
	stimuli : process
		variable lastledstate : std_ulogic_vector(3 downto 0);
	begin
		wait for 5 sec;
	end process;
end Behavioral;
