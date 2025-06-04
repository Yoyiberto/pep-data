library IEEE;
use IEEE.Std_Logic_1164.all;

entity myMux2_tb is
end myMux2_tb;

architecture behavioral of myMux2_tb is

    component myMux2
        port(a: in std_logic; b: in std_logic; sel: in std_logic; s: out std_logic);
    end component;

    -- signals used for testing
    signal s1: std_logic;
    signal s2: std_logic;
    signal sel: std_logic;
    signal o1: std_logic;

begin
    -- component instantiation
    myMux2_1: myMux2 port map(a => s1, b => s2, sel => sel, s => o1);

    process
    begin
        s1 <= '0';
        s2 <= '0';
        sel <= '0';
        wait for 1 ns;
        assert o1 = '0' report "0,0,0 was not 0" severity error;

        s1 <= '0';
        s2 <= '1';
        sel <= '0';
        wait for 1 ns;
        assert o1 = '0' report "0,1,0 was not 0" severity error;

        s1 <= '1';
        s2 <= '0';
        sel <= '0';
        wait for 1 ns;
        assert o1 = '1' report "1,0,0 was not 1" severity error;

        s1 <= '1';
        s2 <= '1';
        sel <= '0';
        wait for 1 ns;
        assert o1 = '1' report "1,1,0 was not 1" severity error;

        s1 <= '0';
        s2 <= '0';
        sel <= '1';
        wait for 1 ns;
        assert o1 = '0' report "0,0,1 was not 0" severity error;

        s1 <= '0';
        s2 <= '1';
        sel <= '1';
        wait for 1 ns;
        assert o1 = '1' report "0,1,1 was not 1" severity error;

        s1 <= '1';
        s2 <= '0';
        sel <= '1';
        wait for 1 ns;
        assert o1 = '0' report "1,0,1 was not 0" severity error;

        s1 <= '1';
        s2 <= '1';
        sel <= '1';
        wait for 1 ns;
        assert o1 = '1' report "1,1,1 was not 1" severity error;

        assert false report "test complete" severity note;
        wait;
    end process;
end behavioral;
