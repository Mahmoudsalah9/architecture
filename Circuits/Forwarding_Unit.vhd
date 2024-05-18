LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Forwarding_Unit IS

    PORT (-- 011 ALU to ALU 010 Swap 001 mem to alu 000 3ade 100

        --in:
        Read_Add1_Execute_Stage : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Read_Add2_Execute_Stage : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add1_Memory_Stage : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_Memory_Stage : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add1_WB_Stage : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_WB_Stage : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        Write_EN_Memory_Stage : IN STD_LOGIC;
        Swap_EN_Memory_Stage : IN STD_LOGIC;
        Swap_EN_WB_Stage : IN STD_LOGIC;
        Write_EN_WB_Stage : IN STD_LOGIC;
        MEM_Read_Memory_Stage : IN STD_LOGIC;
        MEM_Read_WB_Stage : IN STD_LOGIC;

        --out:
        OP1_Selec : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        OP2_Selec : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE Forwarding_Unit_Design OF Forwarding_Unit IS

BEGIN

    OP1_Selec <= "011" WHEN (Write_EN_Memory_Stage = '1'AND MEM_Read_Memory_Stage = '0' AND Swap_EN_Memory_Stage = '0' AND Write_Add1_Memory_Stage = Read_Add1_Execute_Stage) ELSE
        "001" WHEN (Write_EN_WB_Stage = '1' AND MEM_Read_WB_Stage = '0' AND Swap_EN_WB_Stage = '0' AND Read_Add1_Execute_Stage = Write_Add1_WB_Stage) ELSE
        "010" WHEN (Write_EN_Memory_Stage = '1' AND Swap_EN_Memory_Stage = '1' AND Read_Add1_Execute_Stage = Write_Add2_Memory_Stage) ELSE
        "100" WHEN (Write_EN_WB_Stage = '1' AND Swap_EN_WB_Stage = '1' AND Read_Add1_Execute_Stage = Write_Add2_WB_Stage) ELSE
        "000";

    OP2_Selec <= "011" WHEN (Write_EN_Memory_Stage = '1'AND MEM_Read_Memory_Stage = '0' AND Swap_EN_Memory_Stage = '0' AND Write_Add1_Memory_Stage = Read_Add2_Execute_Stage) ELSE
        "001" WHEN (Write_EN_WB_Stage = '1' AND MEM_Read_WB_Stage = '0' AND Swap_EN_WB_Stage = '0' AND Read_Add2_Execute_Stage = Write_Add1_WB_Stage) ELSE
        "010" WHEN (Write_EN_Memory_Stage = '1' AND Swap_EN_Memory_Stage = '1' AND Read_Add2_Execute_Stage = Write_Add2_Memory_Stage) ELSE
        "100" WHEN (Write_EN_WB_Stage = '1' AND Swap_EN_WB_Stage = '1' AND Read_Add2_Execute_Stage = Write_Add2_WB_Stage) ELSE
        "000";

END ARCHITECTURE;