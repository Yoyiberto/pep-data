----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:24:26 11/18/2016 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( --FLASH_A : out  STD_LOGIC_VECTOR (22 downto 0);
           --FLASH_D : inout  STD_LOGIC_VECTOR (15 downto 0);
           --FPGA_KEY : in  STD_LOGIC_VECTOR (3 downto 0);
           CLK2 : in  STD_LOGIC;
           --CLK1 : in  STD_LOGIC;
           --LCD_CS1 : out  STD_LOGIC;
           --LCD_CS2 : out  STD_LOGIC;
           --LCD_DB : inout  STD_LOGIC_VECTOR (7 downto 0);
           --LCD_E : out  STD_LOGIC;
           --LCD_RESET : out  STD_LOGIC;
           --LCD_RS : out  STD_LOGIC;
           --LCD_RW : out  STD_LOGIC;
           --VGA_R : out  STD_LOGIC_VECTOR (2 downto 0);
           --VGA_G : out  STD_LOGIC_VECTOR (2 downto 0);
           --VGA_B : out  STD_LOGIC_VECTOR (2 downto 0);
           --VGA_HHYNC : out  STD_LOGIC;
           --VGA_VHYNC : out  STD_LOGIC;
           --PS2KB_CLOCK : out  STD_LOGIC;
           --PS2KB_DATA : in  STD_LOGIC;
           RAM1DATA : inout  STD_LOGIC_VECTOR (15 downto 0);
           --SW_DIP : in  STD_LOGIC_VECTOR (15 downto 0);
           --FLASH_BYTE : out  STD_LOGIC;
           --FLASH_CE : out  STD_LOGIC;
           --FLASH_CE1 : out  STD_LOGIC;
			  --FLASH_CE2 : out  STD_LOGIC;
           --FLASH_OE : out  STD_LOGIC;
           --FLASH_RP : out  STD_LOGIC;
           --FLASH_STS : out  STD_LOGIC;
           --FLASH_VPEN : out  STD_LOGIC;
           --FLASH_WE : out  STD_LOGIC;
           --U_RXD : out  STD_LOGIC;
           --U_TXD : out  STD_LOGIC;
           RAM2DATA : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM1EN : out  STD_LOGIC;
           RAM1OE : out  STD_LOGIC;
           RAM1WE : out  STD_LOGIC;
           L : out  STD_LOGIC_VECTOR (15 downto 0);
           RAM2EN : out  STD_LOGIC;
           RAM2OE : out  STD_LOGIC;
           RAM2WE : out  STD_LOGIC;
           RAM1ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM2ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           --DYP0 : out  STD_LOGIC_VECTOR (6 downto 0);
           --DYP1 : out  STD_LOGIC_VECTOR (6 downto 0);
           --CLK_FROM_KEY : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           rdn: out  STD_LOGIC;
           wrn: out  STD_LOGIC;
           data_ready: in  STD_LOGIC;
           tbre: in  STD_LOGIC;
           tsre: in  STD_LOGIC
); 
end main;

architecture Behavioral of main is
component ALU is
    Port ( OP : in  STD_LOGIC_VECTOR (3 downto 0);
           ALUIN1 : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUIN2 : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUOUT : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component ALUMUX1 is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           MEMOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUctrl1 : in  STD_LOGIC_VECTOR (1 downto 0);
           ALUIN1 : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component ALUMUX2 is
    Port ( B : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           MEMOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUctrl2 : in  STD_LOGIC_VECTOR (1 downto 0);
           ALUIN2 : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component control is
    Port ( Inst : in  STD_LOGIC_VECTOR (15 downto 0);
           A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           Imm : in  STD_LOGIC_VECTOR (15 downto 0);
           T : in  STD_LOGIC;
        NPC : in STD_LOGIC_VECTOR (15 downto 0);
           OP : out  STD_LOGIC_VECTOR (3 downto 0);
           PCctrl : out  STD_LOGIC_VECTOR (1 downto 0);
           RFctrl : out  STD_LOGIC_VECTOR (2 downto 0);
           Immctrl : out  STD_LOGIC_VECTOR (3 downto 0);
           Rs : out  STD_LOGIC_VECTOR (3 downto 0);
           Rt : out  STD_LOGIC_VECTOR (3 downto 0);
           Rd : out  STD_LOGIC_VECTOR (3 downto 0);
           AccMEM : out  STD_LOGIC;
           memWE : out  STD_LOGIC;
           regWE : out  STD_LOGIC;
           DataIN : out  STD_LOGIC_VECTOR (15 downto 0);
           ALUIN1 : out STD_LOGIC_VECTOR (15 downto 0);
           ALUIN2 : out STD_LOGIC_VECTOR (15 downto 0);
           newT : out  STD_LOGIC;
           TE : out STD_LOGIC);
end component;

component EXE_MEM is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           
           EXE_ALUOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           EXE_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           EXE_AccMEM : in  STD_LOGIC;
           EXE_memWE : in  STD_LOGIC;
           EXE_regWE : in  STD_LOGIC;
           EXE_DataIN : in  STD_LOGIC_VECTOR (15 downto 0);

           MEM_ALUOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           MEM_Rd : out  STD_LOGIC_VECTOR (3 downto 0);
           MEM_AccMEM : out  STD_LOGIC;
           MEM_memWE : out  STD_LOGIC;
           MEM_regWE : out  STD_LOGIC;
           MEM_DataIN : out  STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RAM2: in  STD_LOGIC
           );
end component;

component Forwarding is
    Port ( ID_Rs : in  STD_LOGIC_VECTOR (3 downto 0);
           ID_Rt : in  STD_LOGIC_VECTOR (3 downto 0);

           ID_EXE_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           ID_EXE_regWE : in  STD_LOGIC;
           ID_EXE_AccMEM : in  STD_LOGIC;

           EXE_MEM_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           EXE_MEM_regWE : in  STD_LOGIC;


           PCReg_enable : out STD_LOGIC;
           IF_ID_enable : out STD_LOGIC;
           ID_EXE_enable : out STD_LOGIC;
           ID_EXE_bubble : out STD_LOGIC;
           ALUctrl1 : out STD_LOGIC_VECTOR (1 downto 0);
           ALUctrl2 : out STD_LOGIC_VECTOR (1 downto 0)
           );
end component;

component ID_EXE is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           bubble : in STD_LOGIC;

           ID_ALUIN1 : in  STD_LOGIC_VECTOR (15 downto 0);
           ID_ALUIN2 : in  STD_LOGIC_VECTOR (15 downto 0);
           ID_OP : in  STD_LOGIC_VECTOR (3 downto 0);
           ID_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           ID_AccMEM : in  STD_LOGIC;
           ID_memWE : in  STD_LOGIC;
           ID_regWE : in  STD_LOGIC;
           ID_DataIN : in  STD_LOGIC_VECTOR (15 downto 0);

           EXE_ALUIN1 : out  STD_LOGIC_VECTOR (15 downto 0);
           EXE_ALUIN2 : out  STD_LOGIC_VECTOR (15 downto 0);
           EXE_OP : out  STD_LOGIC_VECTOR (3 downto 0);
           EXE_Rd : out  STD_LOGIC_VECTOR (3 downto 0);
           EXE_AccMEM : out  STD_LOGIC;
           EXE_memWE : out  STD_LOGIC;
           EXE_regWE : out  STD_LOGIC;
           EXE_DataIN : out  STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RAM2 : in STD_LOGIC
           );
end component;

component IF_ID is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;

           IF_Inst : in  STD_LOGIC_VECTOR (15 downto 0);
           IF_NPC : in STD_LOGIC_VECTOR(15 DOWNTO 0);

           ID_Inst : out  STD_LOGIC_VECTOR (15 downto 0);
           ID_NPC : out STD_LOGIC_VECTOR(15 DOWNTO 0);
			  MEM_RAM2 : in STD_LOGIC
           );
end component;

component IM is
    Port ( PC : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  --stateclk : in STD_LOGIC;
           rst : in  STD_LOGIC;
           Ram2OE : out  STD_LOGIC;
           Ram2WE : out  STD_LOGIC;
           Ram2EN : out  STD_LOGIC;
           Ram2Addr : out  STD_LOGIC_VECTOR (17 downto 0);
           Ram2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           Inst : out STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RAM2: in  STD_LOGIC;
			  MEM_ACCMEM: in  STD_LOGIC;
			  MEM_ALUOUT:in  STD_LOGIC_VECTOR (15 downto 0);
			  MEM_DATAIN: in  STD_LOGIC_VECTOR (15 downto 0)
			  );
end component;


component Imm is
    Port ( Immctrl : in  STD_LOGIC_VECTOR (3 downto 0);
           Inst : in  STD_LOGIC_VECTOR (10 downto 0);
           Imm : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component MEM_WB is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;

           
           MEM_MEMOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           MEM_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           MEM_regWE : in  STD_LOGIC;

           WB_MEMOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           WB_Rd : out  STD_LOGIC_VECTOR (3 downto 0);
           WB_regWE : out  STD_LOGIC
           );
end component;

component MEMMUX is
    Port ( ALUOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           ACCMEM : in  STD_LOGIC;
           MEMOUT : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  IMOUT: in  STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RAM2:in STD_LOGIC);
end component;

component PCMUX is
    Port ( NPC : in  STD_LOGIC_VECTOR (15 downto 0);
           A : in  STD_LOGIC_VECTOR (15 downto 0);
           adderOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           PCctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           PCIN : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component PCReg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;

           NPC : in  STD_LOGIC_VECTOR (15 downto 0);

           PC : out  STD_LOGIC_VECTOR (15 downto 0);
			  
					 MEM_RAM2: in STD_LOGIC;
					 L:out STD_LOGIC_VECTOR (15 downto 0)
           
           );
end component;

component RAM_UART is
    Port (
 CLK : in  STD_LOGIC;
			RST : in STD_LOGIC;
			ACCMEM : in  STD_LOGIC;
			MEM_WE : in  STD_LOGIC;
			addr : in  STD_LOGIC_VECTOR (15 downto 0);
			data : in  STD_LOGIC_VECTOR (15 downto 0);
			data_out : out STD_LOGIC_VECTOR (15 downto 0);
			Ram1Addr : out  STD_LOGIC_VECTOR (17 downto 0);
			Ram1Data : inout  STD_LOGIC_VECTOR (15 downto 0);
			Ram1OE : out  STD_LOGIC;
			Ram1WE : out  STD_LOGIC;
			Ram1EN : out  STD_LOGIC;
			wrn : out STD_LOGIC;
			rdn : out STD_LOGIC;

			data_ready : in  STD_LOGIC;
			tbre : in  STD_LOGIC;
			tsre : in  STD_LOGIC;
			MEM_RAM2: in STD_LOGIC); 
end component;

component RF is
    Port ( regWE : in  STD_LOGIC;
           RFctrl : in  STD_LOGIC_VECTOR (2 downto 0);
           MEMOUT : in  STD_LOGIC_VECTOR (15 downto 0);
           Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           Inst : in STD_LOGIC_VECTOR (5 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           A : out  STD_LOGIC_VECTOR (15 downto 0);
           B : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end component;

component T is
    Port (
  clk : in STD_LOGIC;
	 rst : in STD_LOGIC;
	 enable : in STD_LOGIC;
	T_in : in  STD_LOGIC;
	T_reg : out  STD_LOGIC);
end component;

component Adder is
    Port (
  NPC : in  STD_LOGIC_VECTOR(15 downto 0);
        Imm : in  STD_LOGIC_VECTOR(15 downto 0);
        RPC : out  STD_LOGIC_VECTOR(15 downto 0));
end component;

component PC_Adder is
    Port (
  PC : in  STD_LOGIC_VECTOR(15 downto 0);
  NPC : out  STD_LOGIC_VECTOR(15 downto 0));
end component;

signal MEM_RAM2,ID_T,ID_AccMEM,ID_memWE,ID_regWE,ID_newT,ID_TE,EXE_AccMEM,EXE_memWE,EXE_regWE,MEM_AccMEM,MEM_memWE,MEM_regWE,PCReg_enable,IF_ID_enable,ID_EXE_enable,ID_EXE_bubble,WB_regWE : STD_LOGIC:='0';
signal ALUctrl1,ALUctrl2,PCctrl :STD_LOGIC_VECTOR(1 DOWNTO 0);
signal RFctrl :STD_LOGIC_VECTOR(2 DOWNTO 0);
signal ID_OP,EXE_OP,Immctrl,ID_Rs,ID_Rt,ID_Rd,EXE_Rd,MEM_Rd,WB_Rd :STD_LOGIC_VECTOR(3 DOWNTO 0);
signal EXE_ALUOUT,EXE_ALUIN1,EXE_ALUIN2,ID_A0,ID_B0,MEM_MEMOUT,ID_A,ID_B,ID_Inst,ID_DataIN,ID_ALUIN1,ID_ALUIN2,EXE_DataIN,MEM_ALUOUT,MEM_DataIN,IF_Inst,IF_NPC,ID_NPC,ID_Imm,WB_MEMOUT,DataOUT,adderOUT,PCIN,PC    :STD_LOGIC_VECTOR(15 downto 0):="1111111111111111";
signal state0, state1, CLK0, CLK1 : STD_LOGIC := '0';

begin

ALU_module:ALU PORT MAP(EXE_OP,EXE_ALUIN1,EXE_ALUIN2,EXE_ALUOUT);
ALUMUX1_module:ALUMUX1 PORT MAP(ID_A0,EXE_ALUOUT,MEM_MEMOUT,ALUctrl1,ID_A);
ALUMUX2_module:ALUMUX2 PORT MAP(ID_B0,EXE_ALUOUT,MEM_MEMOUT,ALUctrl2,ID_B);
control_module:control PORT MAP(ID_Inst,ID_A,ID_B,ID_Imm,ID_T,ID_NPC,ID_OP,PCctrl,RFctrl,Immctrl,ID_Rs,ID_Rt,ID_Rd,ID_AccMEM,ID_memWE,ID_regWE,ID_DataIN,ID_ALUIN1,ID_ALUIN2,ID_newT,ID_TE);
EXE_MEM_module:EXE_MEM PORT MAP(CLK0,RESET,'1',EXE_ALUOUT,EXE_Rd,EXE_AccMEM,EXE_memWE,EXE_regWE,EXE_DataIN,MEM_ALUOUT,MEM_Rd,MEM_AccMEM,MEM_memWE,MEM_regWE,MEM_DataIN,MEM_RAM2);
Forwarding_module:Forwarding PORT MAP(ID_Rs ,ID_Rt ,EXE_Rd ,EXE_regWE ,EXE_AccMEM ,MEM_Rd ,MEM_regWE ,PCReg_enable ,IF_ID_enable ,ID_EXE_enable ,ID_EXE_bubble ,ALUctrl1 ,ALUctrl2);
ID_EXE_module:ID_EXE PORT MAP(CLK0 ,RESET ,ID_EXE_enable ,ID_EXE_bubble ,ID_ALUIN1 ,ID_ALUIN2 ,ID_OP ,ID_Rd ,ID_AccMEM ,ID_memWE ,ID_regWE ,ID_DataIN ,EXE_ALUIN1 ,EXE_ALUIN2 ,EXE_OP ,EXE_Rd ,EXE_AccMEM ,EXE_memWE ,EXE_regWE ,EXE_DataIN,MEM_RAM2);
IF_ID_module:IF_ID PORT MAP(CLK0 ,RESET ,IF_ID_enable ,IF_Inst ,IF_NPC ,ID_Inst ,ID_NPC,MEM_RAM2);
IM_module:IM PORT MAP(PC ,CLK1 , RESET ,RAM2OE ,RAM2WE ,RAM2EN ,RAM2ADDR ,RAM2DATA ,IF_Inst,MEM_RAM2,MEM_AccMEM,MEM_ALUOUT,MEM_DataIN);
Imm_module:Imm PORT MAP(Immctrl,ID_Inst(10 downto 0),ID_Imm);
MEM_WB_module:MEM_WB PORT MAP(CLK0 ,RESET ,'1' ,MEM_MEMOUT ,MEM_Rd ,MEM_regWE ,WB_MEMOUT ,WB_Rd ,WB_regWE);
MEMMUX_module:MEMMUX PORT MAP(MEM_ALUOUT ,DataOUT ,MEM_AccMEM ,MEM_MEMOUT,IF_Inst,MEM_RAM2);
PCMUX_module:PCMUX PORT MAP(IF_NPC ,ID_A ,adderOUT ,PCctrl ,PCIN);
PCReg_module:PCReg PORT MAP(CLK0 ,RESET ,PCReg_enable ,PCIN ,PC,MEM_RAM2,L);
RAM_UART_module:RAM_UART PORT MAP(CLK1 ,RESET,MEM_AccMEM ,MEM_memWE ,MEM_ALUOUT ,MEM_DataIN ,DataOUT,RAM1ADDR ,RAM1DATA ,RAM1OE ,RAM1WE ,RAM1EN ,wrn ,rdn,data_ready,tbre,tsre,MEM_RAM2);
RF_module:RF PORT MAP(WB_regWE ,RFctrl ,WB_MEMOUT ,WB_Rd ,ID_Inst(10 downto 5) ,CLK0 ,RESET ,ID_A0 ,ID_B0);
T_module:T PORT MAP(CLK0,RESET, ID_TE, ID_newT,ID_T);
Adder_module:Adder PORT MAP(ID_NPC, ID_Imm,adderOUT);
PC_Adder_module:PC_Adder PORT MAP(PC,IF_NPC);

process(MEM_ALUOUT,MEM_ACCMEM,MEM_MEMWE)
	begin
		if (MEM_ALUOUT(15) = '0')and(MEM_ALUOUT(14) = '1')and((MEM_ACCMEM = '1')or(MEM_MEMWE = '1')) then
				MEM_RAM2 <= '1';
			 else
				MEM_RAM2 <= '0';
			end if;
	end process;
	
process(CLK1)
begin
	if (CLK1'event and CLK1 = '1') then
		if (state0 = '0') then
			CLK0 <= '1';
		else
			CLK0 <= '0';
		end if;
		state0 <= not state0;
	end if;
end process;

--process(CLK2)
--begin
--	if (CLK2'event and CLK2 = '1') then
--		if (state1 = '0') then
--			CLK1 <= '1';
--		else
--			CLK1 <= '0';
--		end if;
--		state1 <= not state1;
--	end if;
--end process;
CLK1 <= CLK2;
end Behavioral;

 
           













