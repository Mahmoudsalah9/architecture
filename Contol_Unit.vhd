LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Control_Unit IS
    PORT (

        Instruction_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        Write_Enable : OUT STD_LOGIC;
        Mem_Write : OUT STD_LOGIC;
        Mem_Read : OUT STD_LOGIC;
        InPort_Enable : OUT STD_LOGIC;
        Memory_Add_Selec : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Data_After : OUT STD_LOGIC;
        ALU_SRC : OUT STD_LOGIC;
    );
END ENTITY;

ARCHITECTURE Control_Unit_Design OF Control_Unit IS

BEGIN


END ARCHITECTURE