LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CCR_Reg IS
	PORT(	Clk,Rst : IN std_logic;
		CCR : IN std_logic_vector(3 DOWNTO 0); --CCR<0>:=zero flag,CCR<1>:=negative flag,CCR<2>:=carry flag,CCR<3>:=overflow flag
		q : OUT std_logic_vector(3 DOWNTO 0));
END CCR_Reg;

ARCHITECTURE my_CCR_Reg OF CCR_Reg IS
	COMPONENT myDFF IS
	PORT( 	d,Clk,Rst : IN std_logic;
			q : OUT std_logic);
	END COMPONENT;
BEGIN
	loop1: FOR i IN 0 TO 3 GENERATE
	fx: myDFF PORT MAP(CCR(i),Clk,Rst,q(i));
END GENERATE;

END my_CCR_Reg;
