LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
-- BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA
--BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA BYZA  
ENTITY INT_FSM IS
    PORT (

        -- IN:
        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        INT : STD_LOGIC;
        JUMP_EN : STD_LOGIC;
        CALL_EN : STD_LOGIC;

        Operand1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- OUT:
        MUX_Selec_INT_FSM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC_Address_FSM : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        Stack_Operation_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        MEM_WRITE_INT_FSM : OUT STD_LOGIC;
        Special_MUX_INT : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE INT_FSM_Design OF INT_FSM IS

    TYPE state_type IS (Idle, State0, State1, State2, State3, State4, State5, State6);
    SIGNAL state : state_type;

BEGIN

    state_process : PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
        
            state <= Idle;
            MUX_Selec_INT_FSM <= (OTHERS => '0');
            PC_Address_FSM <= (OTHERS => '0');
            Stack_Operation_INT <= (OTHERS => '0');
            MEM_WRITE_INT_FSM <= '0';
            Special_MUX_INT <= '0';

        ELSIF rising_edge(clk) THEN

            CASE state IS
                WHEN Idle =>
                    IF INT = '1' THEN
                        state <= State0;
                    ELSE
                        state <= Idle;
                    END IF;
                WHEN State0 =>
                    state <= State1;
                WHEN State1 =>
                    state <= State2;
                WHEN State2 =>
                    state <= State3;
                WHEN State3 =>
                    state <= State4;
                WHEN State4 =>
                    state <= State5;
                WHEN State5 =>
                    state <= State6;
                WHEN State6 =>
                    state <= idle;
                WHEN OTHERS =>
                    state <= Idle;
            END CASE;

        END IF;
    END PROCESS state_process;

    output_process : PROCESS (state)
    BEGIN
        CASE state IS
            WHEN State0 =>

            WHEN State1 =>

            WHEN State2 =>

            WHEN State3 =>

            WHEN State4 =>

            WHEN State5 =>

            WHEN State6 =>

            WHEN OTHERS =>
                MUX_Selec_INT_FSM <= (OTHERS => '0');
                PC_Address_FSM <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT_FSM <= '0';
                Special_MUX_INT <= '0';
        END CASE;
    END PROCESS output_process;

BEGIN
END ARCHITECTURE;