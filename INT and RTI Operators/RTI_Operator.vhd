LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RTI_Operator IS
    PORT (
        -- IN:
        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        RTI_BEGIN : IN STD_LOGIC;

        -- OUT:
        Stack_Operation_RTI : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RTI_PC_UPDATE : OUT STD_LOGIC;
        MEM_ADD_MUX_RTI_Selec : OUT STD_LOGIC;
        CCR_Selector : OUT STD_LOGIC;
        PC_Disable : OUT STD_LOGIC;
        FD_Stall : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE RTI_Operator_Design OF RTI_Operator IS

BEGIN
    PROCESS (Clk, Rst)
        VARIABLE Count : INTEGER := 0;
        VARIABLE Began : STD_LOGIC := '0';
    BEGIN
        IF Rst = '1' THEN

            Stack_Operation_RTI <= (OTHERS => '0');
            RTI_PC_UPDATE <= '0';
            MEM_ADD_MUX_RTI_Selec <= '0';
            CCR_Selector <= '0';
            PC_Disable <= '0';
            FD_Stall <= '0';

        ELSIF rising_edge(Clk) THEN

            IF RTI_BEGIN = '1' THEN
                Began := '1';
            ELSE
                Stack_Operation_RTI <= (OTHERS => '0');
                RTI_PC_UPDATE <= '0';
                MEM_ADD_MUX_RTI_Selec <= '0';
                CCR_Selector <= '0';
                PC_Disable <= '0';
                FD_Stall <= '0';
            END IF;

            IF Began = '1' AND count = 0 THEN
                MEM_ADD_MUX_RTI_Selec <= '1';
                RTI_PC_UPDATE <= '0';
                CCR_Selector <= '1';
                Stack_Operation_RTI <= "01";
                PC_Disable <= '1';
                FD_Stall <= '1';

                Began := '1';
                count := count + 1;

            ELSIF Began = '1' AND count = 1 THEN
                MEM_ADD_MUX_RTI_Selec <= '1';
                RTI_PC_UPDATE <= '1';
                CCR_Selector <= '0';
                Stack_Operation_RTI <= "01";
                PC_Disable <= '1';
                FD_Stall <= '1';

                Began := '0';
                count := 0;
            END IF;

        END IF;
    END PROCESS;

END ARCHITECTURE;