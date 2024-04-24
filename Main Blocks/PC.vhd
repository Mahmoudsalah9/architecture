
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC IS
    PORT (
        instmem0            : IN std_logic_vector(15 DOWNTO 0);
        instmem1            : IN std_logic_vector(15 DOWNTO 0);
        interrupt           : IN std_logic;
        stall               : IN std_logic;
        pcsignals           : IN std_logic_vector(2 DOWNTO 0);
        pcsignalswriteback  : IN std_logic_vector(2 DOWNTO 0);
        clk                 : IN std_logic;
        registerOneValue    : IN std_logic_vector(31 DOWNTO 0);
        memvalue            : IN std_logic_vector(31 DOWNTO 0);
        e, rst, branchingSel, imSel : IN std_logic;
        dataout             : OUT std_logic_vector(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_pc OF PC IS
    SIGNAL s             : std_logic_vector(31 DOWNTO 0);
    SIGNAL sReg          : std_logic_vector(31 DOWNTO 0);
    SIGNAL adder         : std_logic_vector(31 DOWNTO 0);
    SIGNAL rti_ret       : std_logic_vector(31 DOWNTO 0);
    SIGNAL pcsignalsfinal: std_logic_vector(2 DOWNTO 0);
BEGIN
    rti_ret <= (others => '0') WHEN rst = '1' ELSE ('0' & memvalue(12 DOWNTO 0));
    pcsignalsfinal <= pcsignals WHEN rst = '0' ELSE "110";

    PROCESS(clk, rst)
    BEGIN
        IF rising_edge(clk) AND e = '1' THEN
            IF rst = '1' THEN
                sReg <= instmem0;
            ELSIF interrupt = '1' THEN
                sReg <= instmem1;
            ELSIF pcsignalsfinal = "111" AND stall = '0' AND rst = '0' THEN
                sReg <= registerOneValue;
            ELSIF pcsignalswriteback = "100" AND stall = '0' THEN
                sReg <= rti_ret;
            ELSIF stall = '0' THEN
                sReg <= adder;
            END IF;
        ELSE
            sReg <= sReg;
        END IF;
    END PROCESS;

    -- mux to pc reg
    dataout <= sReg;

    -- mux to adder
    adder <= std_logic_vector(unsigned(sReg) + "0000000000000001") WHEN imSel = '0' ELSE
             std_logic_vector(unsigned(sReg) + "0000000000000010"); -- plus one or plus two

END ARCHITECTURE;