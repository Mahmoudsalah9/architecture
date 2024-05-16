LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY INT_Operator IS
    PORT (

        -- IN:
        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        INT : STD_LOGIC;
        JUMP_EN : STD_LOGIC;
        CALL_EN : STD_LOGIC;
        PC_Address_IN : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        Operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- OUT:
        MUX_Selec_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC_Address_OUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        Stack_Operation_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        MEM_WRITE_INT : OUT STD_LOGIC;
        MEM_ADD_MUX_INT_Selec : OUT STD_LOGIC;
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
    BEGIN
        IF Rst = '1' THEN

            MUX_Selec_INT <= (OTHERS => '0');
            PC_Address_OUT <= (OTHERS => '0');
            Stack_Operation_INT <= (OTHERS => '0');
            MEM_WRITE_INT <= '0';
            MEM_ADD_MUX_INT_Selec <= '0';
            PC_Disable <= '0';
            FD_Stall <= '0';

        ELSIF rising_edge(Clk) THEN

            IF INT = '1' THEN
                Began := '1';
            ELSE
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_MUX_INT_Selec <= '0';
                PC_Disable <= '0';
                FD_Stall <= '0';
            END IF;

            IF Began = '1' AND count = 0 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_MUX_INT_Selec <= '0';
                PC_Disable <= '1';
                FD_Stall <= '0';

                Began := '1';
                count := count + 1;

            ELSIF Began = '1' AND count = 1 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_MUX_INT_Selec <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';
                Stored_Operand1 <= Operand1;

                Began := '1';
                count := count + 1;

            ELSIF Began = '1' AND count = 2 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_MUX_INT_Selec <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';
                Stored_Operand1 <= Operand1;

                Began := '1';
                count := count + 1;

            ELSIF Began = '1' AND count = 3 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_MUX_INT_Selec <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';

                Began := '1';
                count := count + 1;

            ELSIF Began = '1' AND count = 4 THEN
                MUX_Selec_INT <= (OTHERS => '0');
                PC_Address_OUT <= (OTHERS => '0');
                Stack_Operation_INT <= (OTHERS => '0');
                MEM_WRITE_INT <= '0';
                MEM_ADD_MUX_INT_Selec <= '0';
                PC_Disable <= '1';
                FD_Stall <= '1';

                Began := '1';
                count := count + 1;

            END IF;

        END IF;

    END PROCESS;

END ARCHITECTURE;

-- work in progreess
-- work in progreess
-- work in progreess
-- work in progreess
-- work in progreess
-- work in progreess
-- work in progreess
-- work in progreess