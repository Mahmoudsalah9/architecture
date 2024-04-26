
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch_Decode IS
    PORT (
        clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        Data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Instruction_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        Data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Instruction_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Fetch_Decode_Design OF Fetch_Decode IS

BEGIN

    PROCESS (clk, Rst)
    BEGIN
        IF Rst = '1' THEN

            Data_out <= (OTHERS => '0');
            Instruction_Out <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN

            Data_out <= Data_in;
            Instruction_Out <= Instruction_in;

        END IF;

    END PROCESS;

END ARCHITECTURE;