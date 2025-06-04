library IEEE;
use IEEE.Std_Logic_1164.all;

entity myXor2_tb is
end myXor2_tb;

architecture behavorial of myXor2_tb is

    component myXor2
        port(a: in std_logic; b: in std_logic; s: out std_logic);
    end component;

    signal s1: std_logic;
    signal s2: std_logic;
    signal o1: std_logic;

begin

    myXor2_1: myXor2 port map(a => s1, b => s2, s => o1);

    process
    begin

        s1 <= '0';
        s2 <= '0';
        wait for 1 ns;
        assert o1 = '0' report "0 xor 0 should be 0" severity error;

        s1 <= '0';
        s2 <= '1';
        wait for 1 ns;
        assert o1 = '1' report "0 xor 1 should be 1" severity error;

        s1 <= '1';
        s2 <= '0';
        wait for 1 ns;
        assert o1 = '1' report "1 xor 0 should be 1" severity error;

        s1 <= '1';
        s2 <= '1';
        wait for 1 ns;
        assert o1 = '0' report "1 xor 1 should be 0" severity error;

        assert false report "Tests complete" severity note;
        wait;

    end process;

end behavorial;
