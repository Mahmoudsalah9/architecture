LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Instruction_Memory IS
	PORT (
		CLK : IN STD_LOGIC;
		we : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY Instruction_Memory;

-- make sure that the we is always zero 

ARCHITECTURE Instruction_Memory_Design OF Instruction_Memory IS

	TYPE ram_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ram : ram_type;

BEGIN
	PROCESS (CLK) IS
	BEGIN
		IF rising_edge(CLK) THEN
			IF we = '1' THEN
				ram(to_integer(unsigned(address))) <= datain;
			END IF;
		END IF;
	END PROCESS;
	dataout <= ram(to_integer(unsigned(address)));
END Instruction_Memory_Design;