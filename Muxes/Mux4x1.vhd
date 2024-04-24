LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Mux2x1 IS
    GENERIC (n : INTEGER := 32);
    PORT (
        in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE when_else_mux OF mux_gesneric IS
BEGIN

    MUX_Out <= in0 WHEN sel = "00"
        ELSE
        in1 WHEN sel = "01"
        ELSE
        in2 WHEN sel = "10"
        ELSE
        in3 WHEN sel = "11";

END ARCHITECTURE;