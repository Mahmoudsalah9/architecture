LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Program_Counter IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END Program_Counter;

ARCHITECTURE PC_arch OF Program_Counter IS
    SIGNAL counter : unsigned(11 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            counter <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                counter <= counter + 1;
            END IF;
        END IF;
    END PROCESS;

    address <= STD_LOGIC_VECTOR(counter);

END PC_arch;