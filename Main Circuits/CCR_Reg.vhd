LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CCR_Reg IS
	PORT (
		Clk, Rst,CCR_Enable : IN STD_LOGIC;
		CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --CCR<0>:=zero flag,CCR<1>:=negative flag,CCR<2>:=carry flag,CCR<3>:=overflow flag
		q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END CCR_Reg;

ARCHITECTURE my_CCR_Reg OF CCR_Reg IS
	COMPONENT myDFF IS
		PORT (
			d, Clk, Rst : IN STD_LOGIC;
			q : OUT STD_LOGIC);
	END COMPONENT;
COMPONENT Mux2x1 IS
	GENERIC (n : INTEGER := 32);
	PORT (
		in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		sel : IN STD_LOGIC;
		MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
	);
END COMPONENT;
Signal Q:STD_LOGIC_VECTOR (3 DOWNTO 0);
Signal Q1:STD_LOGIC_VECTOR (3 DOWNTO 0);
BEGIN
   My_Mux2x1:Mux2x1 GENERIC MAP(4) PORT MAP(Q,CCR,CCR_Enable,Q1);
  
	loop1 : FOR i IN 0 TO 3 GENERATE
		fx : myDFF PORT MAP(Q1(i), Clk, Rst, Q(i));
	END GENERATE;
	
		q<=Q;

  
END my_CCR_Reg;