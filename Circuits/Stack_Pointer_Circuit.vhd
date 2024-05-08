LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Stack_Pointer_Circuit IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		Stack_Operation_Controller : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Stack_Operation_RTI : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Stack_Operation_INT : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

		SP_Value_Out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE Stack_Pointer_Circuit_Design OF Stack_Pointer_Circuit IS

BEGIN

	PROCESS (Clk, Rst) IS

		VARIABLE SP_Value : STD_LOGIC_VECTOR(11 DOWNTO 0);

	BEGIN

		IF Rst = '1' THEN
			SP_Value := "111111111111";
			SP_Value_Out <= SP_Value;
		ELSIF rising_edge(clk) THEN

			IF Stack_Operation_Controller = "01" OR Stack_Operation_RTI = "01" OR Stack_Operation_INT = "01" THEN
				SP_Value := STD_LOGIC_VECTOR(unsigned(SP_Value) + 2);
				SP_Value_Out <= SP_Value;
			ELSIF Stack_Operation_Controller = "10" OR Stack_Operation_RTI = "10" OR Stack_Operation_INT = "10" THEN
				SP_Value := STD_LOGIC_VECTOR(unsigned(SP_Value) - 2);
				SP_Value_Out <= SP_Value;
			ELSE
				SP_Value_Out <= SP_Value;
			END IF;

		END IF;

	END PROCESS;

END ARCHITECTURE;