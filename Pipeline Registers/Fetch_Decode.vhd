LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch_Decode IS
    PORT (
        clk, Rst : IN STD_LOGIC;
        flush, stall : IN STD_LOGIC;

        -- Inputs:
        Instruction_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Value_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Outputs:
        Instruction_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Data_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Value_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Fetch_Decode_Design OF Fetch_Decode IS

BEGIN

    PROCESS (clk, Rst)
    BEGIN
        IF Rst = '1' THEN

            Instruction_OUT <= (OTHERS => '0');
            Data_OUT <= (OTHERS => '0');
            PC_Value_OUT <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            IF flush = '1' OR stall = '1' THEN

                Instruction_OUT <= (OTHERS => '0');
                Data_OUT <= (OTHERS => '0');
                PC_Value_OUT <= (OTHERS => '0');

            ELSE 

                Instruction_OUT <= Instruction_IN;
                Data_OUT <= Data_in;
                PC_Value_OUT <= PC_Value_IN; 

            END IF;

        END IF;
    END PROCESS;

END ARCHITECTURE;