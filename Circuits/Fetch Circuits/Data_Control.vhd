LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Data_Control IS
  PORT (
    data_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    CONTROL_BIT : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE Data_Control_Design OF Data_Control IS
BEGIN

  CONTROL_BIT <= '1' WHEN data_IN = "10001" ELSE
    '1' WHEN data_IN = "10100"ELSE
    '1' WHEN data_IN = "10101" ELSE
    '0';

END ARCHITECTURE;