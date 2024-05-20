LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Program_Counter IS
    PORT (
        clk : IN STD_LOGIC;
        pc_adress_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc_address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END Program_Counter;

ARCHITECTURE PC_arch OF Program_Counter IS

BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            pc_address <= pc_adress_in(11 DOWNTO 0);
        END IF;
    END PROCESS;

END ARCHITECTURE;