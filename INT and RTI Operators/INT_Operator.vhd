LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY INT_Operator IS
    PORT (

        -- IN:
        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        INT : IN STD_LOGIC;
        JUMP_EN : IN STD_LOGIC;
        CALL_EN : IN STD_LOGIC;
        JMP_ZERO_DONE : STD_LOGIC;
        PC_Address_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- OUT:
        MUX_Selec_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC_Address_OUT_INT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Stack_Operation_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        MEM_WRITE_INT : OUT STD_LOGIC;
        MEM_ADD_Selec_INT : OUT STD_LOGIC;
        UPDATE_PC_INT : OUT STD_LOGIC;
        PC_Disable : OUT STD_LOGIC;
        FD_Stall : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE INT_Operator_Design OF INT_Operator IS

    SIGNAL Stored_Operand1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    PROCESS (Clk, Rst)
        VARIABLE Count : INTEGER := 0;
        VARIABLE Began : STD_LOGIC := '0';
        VARIABLE Branched : STD_LOGIC := '0';
    BEGIN
        IF Rst = '1' THEN

            Stored_Operand1 <= (OTHERS => '0');
            MUX_Selec_INT <= (OTHERS => '0');
            PC_Address_OUT_INT <= (OTHERS => '0');
            Stack_Operation_INT <= (OTHERS => '0');
            MEM_WRITE_INT <= '0';
            MEM_ADD_Selec_INT <= '0';
            UPDATE_PC_INT <= '0';
            PC_Disable <= '0';
            FD_Stall <= '0';

        ELSIF rising_edge(Clk) THEN

            IF INT = '1' THEN
                Began := '1';
            ELSE
                Stored_Operand1 <= (OTHERS => '0');
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT_INT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_Selec_INT <= '0';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '0';
                FD_Stall <= '0';
            END IF;

            IF Began = '1' AND count = 0 THEN
                Stored_Operand1 <= (OTHERS => '0');
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT_INT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_Selec_INT <= '0';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '1';
                FD_Stall <= '0';

                count := count + 1;

            ELSIF Began = '1' AND count = 1 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT_INT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_Selec_INT <= '0';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';
                IF JUMP_EN = '1' OR CALL_EN = '1' OR JMP_ZERO_DONE = '1' THEN
                    Stored_Operand1 <= Operand1;
                    Branched := '1';
                END IF;

                count := count + 1;

            ELSIF Began = '1' AND count = 2 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT_INT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_Selec_INT <= '0';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';
                IF JUMP_EN = '1' OR CALL_EN = '1' OR JMP_ZERO_DONE = '1' THEN
                    Stored_Operand1 <= Operand1;
                    Branched := '1';
                END IF;

                count := count + 1;

            ELSIF Began = '1' AND count = 3 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT_INT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_Selec_INT <= '0';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';

                count := count + 1;

            ELSIF Began = '1' AND count = 4 THEN
                MUX_Selec_INT <= "01";
                Stack_Operation_INT <= "10";
                MEM_WRITE_INT <= '1';
                MEM_ADD_Selec_INT <= '1';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';
                IF Branched = '1' THEN
                    PC_Address_OUT_INT <= Stored_Operand1;
                ELSE
                    PC_Address_OUT_INT <= PC_Address_IN;
                END IF;

                count := count + 1;

            ELSIF Began = '1' AND count = 5 THEN
                PC_Address_OUT_INT <= (OTHERS => '0');
                MUX_Selec_INT <= "10";
                Stack_Operation_INT <= "10";
                MEM_WRITE_INT <= '1';
                MEM_ADD_Selec_INT <= '1';
                UPDATE_PC_INT <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';

                count := count + 1;

            ELSIF Began = '1' AND count = 6 THEN
                PC_Address_OUT_INT <= (OTHERS => '0');
                MUX_Selec_INT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_Selec_INT <= '0';
                UPDATE_PC_INT <= '1';
                PC_Disable <= '1';
                FD_Stall <= '1';

                count := 0;
                Began := '0';
                Branched := '0';

            END IF;

        END IF;

    END PROCESS;

END ARCHITECTURE;