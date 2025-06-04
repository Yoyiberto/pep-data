library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LEDPWM_tb is
end LEDPWM_tb;

architecture Behavioral of LEDPWM_tb is
	signal led : std_ulogic_vector(3 downto 0);
	signal clock : std_ulogic := '0';
begin
	
	uut : entity work.Dimmer(DimmerArchitecture)
	generic map (WIDTH => 25)
	port map (
		LED => led,
		CLK_66MHZ => clock
	);

clock <= not clock after 7.57575757 ns;
		
stimuli : process
	begin
		wait for 5 sec;
	end process;

end Behavioral;
