LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Mux5x1 IS
    GENERIC (n : INTEGER := 32);
    PORT (
        in0, in1, in2, in3, in4 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
    );
END ENTITY Mux5x1;

ARCHITECTURE Mux5x1_Design OF Mux5x1 IS
BEGIN
    PROCESS (sel)
    BEGIN
        CASE sel IS
            WHEN "000" =>
                MUX_Out <= in0;
            WHEN "001" =>
                MUX_Out <= in1;
            WHEN "010" =>
                MUX_Out <= in2;
            WHEN "011" =>
                MUX_Out <= in3;
            WHEN "100" =>
                MUX_Out <= in4;
            WHEN OTHERS =>
                MUX_Out <= (OTHERS => '0'); -- Default case
        END CASE;
    END PROCESS;
END ARCHITECTURE Mux5x1_Design;