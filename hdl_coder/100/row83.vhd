----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:51:13 07/09/2016 
-- Design Name: 
-- Module Name:    audio_scancode_to_divisor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audio_scancode_to_divisor is port (
	scancode 		: in  STD_LOGIC_VECTOR(7 downto 0);
	clock_divisor	: out INTEGER);
end audio_scancode_to_divisor;

architecture Behavioral of audio_scancode_to_divisor is

begin

process(scancode)
	begin
		case scancode is
			when "00100011" => clock_divisor <= 3367000; -- 297 Hz (d')
			when "00100100" => clock_divisor <= 30303000; -- 330 Hz (e')
			when "00101011" => clock_divisor <= 284091000; -- 352 Hz (f')
			when "00110100" => clock_divisor <= 25252; -- 396 Hz (g')
			when "00011100" => clock_divisor <= 22727; -- 440 Hz (a')
			when "00110011" => clock_divisor <= 2020; -- 495 Hz (h')
			when others => clock_divisor <= 378788; -- 264 Hz (c');
		end case;
	end process;

end Behavioral;

