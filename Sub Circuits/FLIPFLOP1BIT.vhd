LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY FLIPFLOP1BIT IS
    PORT (
        d, clk, rst, EN : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE FLIPFLOP1BIT_Design OF FLIPFLOP1BIT IS
    SIGNAL q_internal : STD_LOGIC;
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            q_internal <= '0';
        ELSIF clk'event AND clk = '1' THEN
            IF EN = '1' THEN
                q_internal <= d;
            END IF;
        END IF;
    END PROCESS;

    -- Output assignment
    q <= q_internal;
END ARCHITECTURE;