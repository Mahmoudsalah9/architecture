LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory IS
	PORT (
		CLK, RST, Memory_Write : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY Memory;

ARCHITECTURE sync_Memory OF Memory IS

	TYPE ram_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ram : ram_type;
BEGIN

	PROCESS (CLK, RST) IS
	BEGIN
		IF RST = '1' THEN
			ram <= (OTHERS => (OTHERS => '0'));
		ELSIF rising_edge(clk) THEN
			IF Memory_Write = '1' THEN
				ram(to_integer(unsigned(address))) <= datain(31 DOWNTO 16);
				ram(to_integer(unsigned(address)) - 1) <= datain(15 DOWNTO 0);
			END IF;

		END IF;

	END PROCESS;
	dataout(31 DOWNTO 16) <= ram(to_integer(unsigned(address)));
	dataout(15 DOWNTO 0) <= ram(to_integer(unsigned(address)) - 1);
END sync_Memory;