LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CCR_Reg IS
	PORT (
		Clk, Rst : IN STD_LOGIC;
		CCR_input_from_alu, Result_MEM, CCR_Arithmetic, CCR_Select : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		CCR_output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY CCR_Reg;

ARCHITECTURE CCR_Reg_Design OF CCR_Reg IS
	COMPONENT myDFF IS
		PORT (
			d, Clk, Rst : IN STD_LOGIC;
			q : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT Mux2x1_standard IS
		PORT (
		in0, in1 : IN STD_LOGIC;
		sel : IN STD_LOGIC;
		MUX_Out : OUT STD_LOGIC
	);
	END COMPONENT;

	SIGNAL Q0 : STD_ULOGIC_VECTOR(3 DOWNTO 0); -- old flags
	SIGNAL Q1 : STD_LOGIC_VECTOR(3 DOWNTO 0); -- flags output from ccr mux 1
	SIGNAL Q2 : STD_LOGIC_VECTOR(3 DOWNTO 0); -- flags output from ccr mux 2
	SIGNAL Q3 : STD_LOGIC_VECTOR(3 DOWNTO 0); -- intermediate signal
BEGIN
	My_Mux2x1_0_level_1 : Mux2x1_standard  PORT MAP(Q0(0), CCR_input_from_alu(0), CCR_Arithmetic(0), Q1(0));
	My_Mux2x1_1_level_1 : Mux2x1_standard  PORT MAP(Q0(1), CCR_input_from_alu(1), CCR_Arithmetic(1), Q1(1));
	My_Mux2x1_2_level_1 : Mux2x1_standard PORT MAP(Q0(2), CCR_input_from_alu(2), CCR_Arithmetic(2), Q1(2));
	My_Mux2x1_3_level_1 : Mux2x1_standard PORT MAP(Q0(3), CCR_input_from_alu(3), CCR_Arithmetic(3), Q1(3));

	My_Mux2x1_0_level_2 : Mux2x1_standard  PORT MAP(Q1(0), Result_MEM(0), CCR_Select(0), Q2(0));
	My_Mux2x1_1_level_2 : Mux2x1_standard  PORT MAP(Q1(1), Result_MEM(1), CCR_Select(1), Q2(1));
	My_Mux2x1_2_level_2 : Mux2x1_standard  PORT MAP(Q1(2), Result_MEM(2), CCR_Select(2), Q2(2));
	My_Mux2x1_3_level_2 : Mux2x1_standard  PORT MAP(Q1(3), Result_MEM(3), CCR_Select(3), Q2(3));

	loop1 : FOR i IN 0 TO 3 GENERATE
		fx : myDFF PORT MAP(Q2(i), Clk, Rst, Q3(i));
	END GENERATE;
     Q0 <= STD_ULOGIC_VECTOR(Q3);
	CCR_output <= Q3;
	

END ARCHITECTURE CCR_Reg_Design;