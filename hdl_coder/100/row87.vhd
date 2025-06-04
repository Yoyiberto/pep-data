library IEEE;
use IEEE.Std_Logic_1164.all;

entity myOr16_tb is
end myOr16_tb;

architecture behavioral of myOr16_tb is

    component myOr16
        port(a: in std_logic_vector(15 downto 0); b: in std_logic_vector(15 downto 0); s: out std_logic_vector(15 downto 0));
    end component;

    -- signals used for testing
    signal s1: std_logic_vector(15 downto 0);
    signal s2: std_logic_vector(15 downto 0);
    signal o1: std_logic_vector(15 downto 0);

begin
    -- component instantiation
    myOr16_1: myOr16 port map(a => s1, b => s2, s => o1);

    process
    begin
        s1 <= "0000000000000000";
        s2 <= "0000000000000000";
        wait for 1 ns;
        assert o1 = "0000000000000000" report "or('0000000000000000', '0000000000000000') was not '0000000000000000'" severity error;

        s1 <= "1111111100000000";
        s2 <= "0000000011111111";
        wait for 1 ns;
        assert o1 = "1111111111111111" report "or('1111111100000000', '0000000011111111') was not '1111111111111111'" severity error;

        s1 <= "0000111100001111";
        s2 <= "0000111111110000";
        wait for 1 ns;
        assert o1 = "0000111111111111" report "or('0000111100001111', '0000111111110000') was not '0000111111111111'" severity error;

        assert false report "test complete" severity note;
        wait;
    end process;
end behavioral;
