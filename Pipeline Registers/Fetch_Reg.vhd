
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY F_D_Stage IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        instruction_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_fetch_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        instruction_fetch_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END F_D_Stage;

ARCHITECTURE Behavioral OF F_D_Stage IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            data_fetch_out <= (OTHERS => '0');
            instruction_fetch_out <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            data_fetch_out <= data_in;
            instruction_fetch_out <= instruction_in;
        END IF;
    END PROCESS;
END Behavioral;