LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory IS
	PORT (
		CLK, RST, Memory_Write_Enable,Free,Protect : IN STD_LOGIC;
		Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		Write_Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Read_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Protected_Data : OUT STD_LOGIC
		);
END ENTITY Memory;

ARCHITECTURE sync_Memory OF Memory IS

	TYPE ram_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(16 DOWNTO 0);
	SIGNAL ram : ram_type;
	SIGNAL Protected_Internal : STD_LOGIC;
BEGIN

	PROCESS (CLK, RST) IS
	BEGIN
		IF RST = '1' THEN
			ram <= (OTHERS => (OTHERS => '0'));
			Protected_Internal<='0';
		ELSIF rising_edge(clk) THEN
			IF Memory_Write_Enable = '1' THEN
			    IF Protect='1' THEN
				    ram(to_integer(unsigned(Address)))(16) <= '1';
				    Protected_Internal<='0';
			    ELSIF Free ='1' THEN
				    ram(to_integer(unsigned(Address))) <=(OTHERS => '0');
				    ram(to_integer(unsigned(Address)) - 1) <=  (OTHERS => '0');
				    Protected_Internal<='0';
				ELSE 
				     IF ram(to_integer(unsigned(Address)))(16)= '0' THEN
				        ram(to_integer(unsigned(Address)))(15 downto 0) <= Write_Data(31 DOWNTO 16);
				        ram(to_integer(unsigned(Address)) - 1)(15 downto 0) <= Write_Data(15 DOWNTO 0);
				        Protected_Internal<='0';
				    ELSE 
				        Protected_Internal<='1';
					END IF;
			    END IF;
		    END IF;

		END IF;

	END PROCESS;
	Protected_Data <= Protected_Internal;
	Read_Data(31 DOWNTO 16) <= ram(to_integer(unsigned(Address)))(15 downto 0);
	Read_Data(15 DOWNTO 0) <= ram(to_integer(unsigned(Address)) - 1)(15 downto 0);
END sync_Memory;