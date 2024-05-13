LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch_Decode IS
    PORT (
        clk, Rst : IN STD_LOGIC;
        flush, stall : IN STD_LOGIC;
        Data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        increment_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instruction_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        increment_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Data_out, Instruction_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Fetch_Decode_Design OF Fetch_Decode IS
BEGIN

    PROCESS (clk, Rst)
        -- Variable declarations inside the process
        variable Data_in_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
        variable increment_in_temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
        variable Instruction_in_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF Rst = '1' THEN
            -- Reset all outputs and clear variables
            Data_out <= (OTHERS => '0');
            Instruction_Out <= (OTHERS => '0');
            increment_out <= (OTHERS => '0');
            Data_in_temp := (OTHERS => '0');
            increment_in_temp := (OTHERS => '0');
            Instruction_in_temp := (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF flush = '1' THEN
                -- On flush, reset all outputs and clear variables
                increment_out <= (OTHERS => '0');
                Data_out <= (OTHERS => '0');
                Instruction_Out <= (OTHERS => '0');
                Data_in_temp := (OTHERS => '0');
                increment_in_temp := (OTHERS => '0');
                Instruction_in_temp := (OTHERS => '0');
            ELSIF stall = '1' THEN
                -- On stall, zero the outputs but retain the last data in variables
                increment_out <= (OTHERS => '0');
                Data_out <= (OTHERS => '0');
                Instruction_Out <= (OTHERS => '0');
            ELSE
                -- Normal operation, show data from variables
                increment_out <= increment_in_temp;
                Data_out <= Data_in_temp;
                Instruction_Out <= Instruction_in_temp;

                -- Update variables with current inputs
                Data_in_temp := Data_in;
                increment_in_temp := increment_in;
                Instruction_in_temp := Instruction_in;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;
