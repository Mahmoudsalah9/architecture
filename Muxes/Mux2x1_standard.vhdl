LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
Entity Mux2x1_standard IS
		PORT (
		in0, in1 : IN STD_LOGIC;
		sel : IN STD_LOGIC;
		MUX_Out : OUT STD_LOGIC
	);
	END Entity;
    ARCHITECTURE Mux2x1_Design OF Mux2x1_standard IS
BEGIN

	MUX_Out <= in0 WHEN sel = '0'
		ELSE
		in1 WHEN sel = '1';

END ARCHITECTURE;