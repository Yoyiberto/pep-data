library ieee;
use ieee.std_logic_1164.all;
entity decodificador2x4 is
    port(
        inpt: in std_logic_vector(1 downto 0);
        enable: in std_logic;
        outp: out std_logic_vector(3 downto 0)
        );
end decodificador2x4;
architecture decoder of decodificador2x4 is
begin
    process(inpt, enable)
    begin
    	if enable='1' then
    		case inpt is
    			when "00" =>
    				outp <= "0001";
    			when "01" =>
    				outp <= "0010";
    			when "10" =>
    				outp <= "0100";
    			when others =>
    				outp <= "1000";
    		end case;
    	else
    		outp <= "0000";
    	end if;
    end process;
end decoder;
