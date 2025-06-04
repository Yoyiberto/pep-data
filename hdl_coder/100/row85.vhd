library IEEE;
use IEEE.Std_Logic_1164.all;

entity myAnd2_tb is
end myAnd2_tb;

architecture behavioral of myAnd2_tb is

    component myAnd2
        port(a: in std_logic; b: in std_logic; s: out std_logic);
    end component;

    -- signals used for testing
    signal s1: std_logic;
    signal s2: std_logic;
    signal o1: std_logic;

begin
    -- component instantiation
    myAnd2_1: myAnd2 port map(a => s1, b => s2, s => o1);

    process
    begin
        s1 <= '0';
        s2 <= '0';
        wait for 1 ns;
        assert o1 = '0' report "and('0', '0') was not '0'" severity error;

        s1 <= '0';
        s2 <= '1';
        wait for 1 ns;
        assert o1 = '0' report "and('0', '1') was not '0'" severity error;

        s1 <= '1';
        s2 <= '0';
        wait for 1 ns;
        assert o1 = '0' report "and('1', '0') was not '0'" severity error;

        s1 <= '1';
        s2 <= '1';
        wait for 1 ns;
        assert o1 = '1' report "and('1', '1') was not '1'" severity error;

        assert false report "test complete" severity note;
        wait;
    end process;
end behavioral;
