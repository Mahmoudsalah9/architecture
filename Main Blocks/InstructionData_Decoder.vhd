LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY InstructionData_Decoder IS
    PORT (

        Data_or_Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Data_After : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE InstructionData_Decoder_Design OF InstructionData_Decoder IS
BEGIN

    Instruction <= Data_or_Instruction WHEN Data_After = '0' ELSE
        x"0000";
    Data <= Data_or_Instruction WHEN Data_After = '1' ELSE
        x"0000";

END ARCHITECTURE;