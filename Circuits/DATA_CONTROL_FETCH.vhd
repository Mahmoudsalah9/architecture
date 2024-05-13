library ieee;
use ieee.std_logic_1164.all;

entity DATA_CONTROL_FETCH is
  port (
    data_IN : IN std_logic_vector(4 downto 0);
    CONTROL_BIT : OUT std_logic 
  );
end entity DATA_CONTROL_FETCH;

architecture Behavioral of DATA_CONTROL_FETCH is
begin
  PROCESS(data_IN)  -- Sensitivity list includes data_IN
  BEGIN
    -- Compare data_IN with the specified values
    if (data_IN = "10001" or data_IN = "10100" or data_IN = "10101") then
      CONTROL_BIT <= '1';
    else
      CONTROL_BIT <= '0';
    end if;
  END PROCESS;
end architecture Behavioral;
