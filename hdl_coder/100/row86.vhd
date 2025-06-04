library IEEE;
use IEEE.Std_Logic_1164.all;

entity myNot is
    port(a: in std_logic; s: out std_logic);
end myNot;

architecture behavioral of myNot is

    component myNand2
        port(a: in std_logic; b: in std_logic; s: out std_logic);
    end component;

    signal one: std_logic;

begin
    one <= '1';

    myNand2_1: myNand2 port map(a => a, b => '1', s => s);

end behavioral;
