LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

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
    BEGIN
        CASE state IS
            WHEN Idle =>
                Stack_Operation_RTI <= "00";
                RTI_PC <= '0';
                MEM_ADD_MUX_RTI_Selec <= '0';
                CCR_Selector <= '0';
                PC_Disable <= '0';
                FD_Stall <= '0';
            WHEN State0 =>
                MEM_ADD_MUX_RTI_Selec <= '1';
                RTI_PC <= '0';
                CCR_Selector <= '1';
                Stack_Operation_RTI <= "01";
                PC_Disable <= '1';
                FD_Stall <= '1';
            WHEN State1 =>
                MEM_ADD_MUX_RTI_Selec <= '1';
                RTI_PC <= '1';
                CCR_Selector <= '0';
                Stack_Operation_RTI <= "01";
                PC_Disable <= '1';
                FD_Stall <= '1';
            WHEN OTHERS =>
                Stack_Operation_RTI <= "00";
                RTI_PC <= '0';
                MEM_ADD_MUX_RTI_Selec <= '0';
                CCR_Selector <= '0';
                PC_Disable <= '0';
                FD_Stall <= '0';
        END CASE;
    END PROCESS output_process;

END ARCHITECTURE;