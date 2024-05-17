LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY FLIPFLOP IS
	GENERIC (
		DATA_WIDTH : INTEGER := 32
	);
	PORT (
		d : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		clk, rst, EN : IN STD_LOGIC;
		q : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
	);
END FLIPFLOP;

ARCHITECTURE FLIPFLOP_Design OF FLIPFLOP IS
	SIGNAL q_internal : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			q_internal <= (OTHERS => '0');
		ELSIF clk'event AND clk = '1' THEN
			IF EN = '1' THEN
				q_internal <= d;
			END IF;
		END IF;
	END PROCESS;

	-- Output assignment
	q <= q_internal;
END ARCHITECTURE;