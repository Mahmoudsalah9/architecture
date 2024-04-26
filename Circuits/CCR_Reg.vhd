LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CCR_Reg IS

	PORT (
		Clk, Rst : IN STD_LOGIC;
		CCR, CCR_Enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --CCR<0>:=zero flag,CCR<1>:=negative flag,CCR<2>:=carry flag,CCR<3>:=overflow flag
		q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);

END CCR_Reg;

ARCHITECTURE CCR_Reg_Design OF CCR_Reg IS

	COMPONENT myDFF IS
		PORT (
			d, Clk, Rst : IN STD_LOGIC;
			q : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT Mux2x1 IS
		GENERIC (n : INTEGER := 32);
		PORT (
			in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			sel : IN STD_LOGIC;
			MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL Q0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL Q1 : STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN

	My_Mux2x1_0 : Mux2x1 GENERIC MAP(1) PORT MAP(Q0(0), CCR(0), CCR_Enable(0), Q1(0));
	My_Mux2x1_1 : Mux2x1 GENERIC MAP(1) PORT MAP(Q0(1), CCR(1), CCR_Enable(1), Q1(1));
	My_Mux2x1_2 : Mux2x1 GENERIC MAP(1) PORT MAP(Q0(2), CCR(2), CCR_Enable(2), Q1(2));
	My_Mux2x1_3 : Mux2x1 GENERIC MAP(1) PORT MAP(Q0(3), CCR(3), CCR_Enable(3), Q1(3));

	loop1 : FOR i IN 0 TO 3 GENERATE
		fx : myDFF PORT MAP(Q1(i), Clk, Rst, Q0(i));
	END GENERATE;

	q <= Q0;

END ARCHITECTURE;