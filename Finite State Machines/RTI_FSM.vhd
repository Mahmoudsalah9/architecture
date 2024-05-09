LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez
-- bayez

ENTITY RTI_FSM IS
    PORT (

        -- IN:
        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        RTI_BEGIN : IN STD_LOGIC;

        -- OUT:
        Stack_Operation_RTI : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RTI_PC : OUT STD_LOGIC;
        MEM_ADD_MUX_RTI_Selec : OUT STD_LOGIC;
        CCR_Selector : OUT STD_LOGIC;

        PC_Disable : OUT STD_LOGIC;
        FD_Stall : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE RTI_FSM_Design OF RTI_FSM IS

    TYPE state_type IS (Idle, State0, State1);
    SIGNAL state : state_type;

BEGIN

    state_process : PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN

            state <= Idle;
            Stack_Operation_RTI <= (OTHERS => '0');
            RTI_PC <= '0';
            MEM_ADD_MUX_RTI_Selec <= '0';
            CCR_Selector <= '0';
            PC_Disable <= '0';
            FD_Stall <= '0';

        ELSIF rising_edge(clk) THEN

            CASE state IS
                WHEN Idle =>
                    IF RTI_BEGIN = '1' THEN
                        state <= State0;
                    ELSE
                        state <= Idle;
                    END IF;
                WHEN State0 =>
                    state <= State1;
                WHEN State1 =>
                    state <= Idle;
            END CASE;

        END IF;
    END PROCESS state_process;

    output_process : PROCESS (state)

        VARIABLE Stack_Operation_RTI_V : STD_LOGIC_VECTOR(1 DOWNTO 0);
        VARIABLE RTI_PC_V : STD_LOGIC;
        VARIABLE MEM_ADD_MUX_RTI_Selec_V : STD_LOGIC;
        VARIABLE CCR_Selector_V : STD_LOGIC;
        VARIABLE PC_Disable_V : STD_LOGIC;
        VARIABLE FD_Stall_V : STD_LOGIC;

    BEGIN
        CASE state IS
            WHEN Idle =>

                Stack_Operation_RTI_V := (OTHERS => '0');
                RTI_PC_V := '0';
                MEM_ADD_MUX_RTI_Selec_V := '0';
                CCR_Selector_V := '0';
                PC_Disable_V := '0';
                FD_Stall_V := '0';

            WHEN State0 =>

                MEM_ADD_MUX_RTI_Selec_V := '1';
                RTI_PC_V := '0';
                CCR_Selector_V := '1';
                Stack_Operation_RTI_V := "01";
                PC_Disable_V := '1';
                FD_Stall_V := '1';

            WHEN State1 =>

                MEM_ADD_MUX_RTI_Selec_V := '1';
                RTI_PC_V := '1';
                CCR_Selector_V := '0';
                Stack_Operation_RTI_V := "01";
                PC_Disable_V := '1';
                FD_Stall_V := '1';

            WHEN OTHERS =>

                Stack_Operation_RTI_V := (OTHERS => '0');
                RTI_PC_V := '0';
                MEM_ADD_MUX_RTI_Selec_V := '0';
                CCR_Selector_V := '0';
                PC_Disable_V := '0';
                FD_Stall_V := '0';

        END CASE;

        -- Assign variables to signals
        Stack_Operation_RTI <= Stack_Operation_RTI_V;
        RTI_PC <= RTI_PC_V;
        MEM_ADD_MUX_RTI_Selec <= MEM_ADD_MUX_RTI_Selec_V;
        CCR_Selector <= CCR_Selector_V;
        PC_Disable <= PC_Disable_V;
        FD_Stall <= FD_Stall_V;

    END PROCESS output_process;

END ARCHITECTURE;