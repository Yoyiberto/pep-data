library ieee;
	use ieee.std_logic_1164.all;
--	use ieee.numeric_std.all;

entity fullAdderWithRegisters is
-- fullAdderWithRegisters
-- Prend a, b, en entrée
-- Prend c NREGSBEFORE coups d'horloge après
-- Rend s au bout de NREGSBEFORE+NREGSAFTER+1 coups d'horloge
-- NREGSBEFORE+NREGSAFTER+1
	generic (
		NREGSBEFORE: natural   :=  0;
		NREGSAFTER : natural   :=  0;
		ISCREG     : natural   :=  0;
		ISRESET    : std_logic := '0'
	);
	port (
		clk, rst : in  std_logic;
		a, b, c  : in  std_logic;
		r, s     : out std_logic
	);
end entity fullAdderWithRegisters;

architecture rtl of fullAdderWithRegisters is
	--signal Ar, Br, S, C, Bc: bit_vector(NBITS-1 downto 0);
	signal Ar_B, Br_B: std_logic_vector(NREGSBEFORE downto 0);
	signal Cr        : std_logic_vector(ISCREG downto 0);
	signal Sr_A      : std_logic_vector(NREGSAFTER downto 0);
	signal st        : std_logic;
	
	component fullAdder
		port(
			a, b, c : in  std_logic;
			r, s    : out std_logic
		);
	end component fullAdder;
begin
	G0: if ISCREG = 1 generate
		process (clk)
		begin
			if clk'event and clk = '1' then
				Cr(0) <= Cr(1);
			end if;
		end process;
	end generate G0;
	G1: if NREGSBEFORE > 0 generate
		process (clk, rst)
		begin
			if ISRESET= '1' and rst = '1' then
				Ar_B(NREGSBEFORE-1 downto 0) <= (others => '0');
				Br_B(NREGSBEFORE-1 downto 0) <= (others => '0');
			elsif clk'event and clk = '1' then
				Ar_B(NREGSBEFORE-1 downto 0) <= Ar_B(NREGSBEFORE downto 1);
				Br_B(NREGSBEFORE-1 downto 0) <= Br_B(NREGSBEFORE downto 1);
			end if;
		end process;
	end generate G1;
	G2: if NREGSAFTER > 0 generate
		process (clk, rst)
		begin
			if ISRESET= '1' and rst = '1' then
				Sr_A(NREGSAFTER-1 downto 0) <= (others => '0');
			elsif clk'event and clk = '1' then
				for i in 0 to NREGSAFTER-1 loop
					Sr_A(NREGSAFTER-1 downto 0) <= Sr_A(NREGSAFTER downto 1);
				end loop;
			end if;
		end process;
		Sr_A(NREGSAFTER) <= st;
		s <= Sr_A(0);
	end generate G2;
	G3: if NREGSAFTER = 0 generate
		s <= st;
	end generate G3;
	Cr(ISCREG)        <= c;
	Ar_B(NREGSBEFORE) <= a;
	Br_B(NREGSBEFORE) <= b;
	
	inst: fullAdder port map(a=>Ar_B(0), b=>Br_B(0), c=>Cr(0), r=>r, s=>st);
end rtl;
