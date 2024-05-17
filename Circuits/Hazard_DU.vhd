LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Hazard_DU IS
    PORT (

        --in:
        MEM_Read : IN STD_LOGIC;
        Write_ADD_Execute : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        R_Source1_Decode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        R_Source2_Decode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        --out:
        STALL : OUT STD_LOGIC;
        PC_Disable : OUT STD_LOGIC;
        LoadUse_RST : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE Hazard_DU_dESIGN OF Hazard_DU IS
BEGIN

    stall <= '1' WHEN (MEM_Read = '1' AND (Write_ADD_Execute = R_Source1_Decode OR Write_ADD_Execute = R_Source2_Decode)) ELSE
        '0';
    PC_Disable <= '1' WHEN (MEM_Read = '1' AND (Write_ADD_Execute = R_Source1_Decode OR Write_ADD_Execute = R_Source2_Decode)) ELSE
        '0';
    LoadUse_RST <= '1' WHEN (MEM_Read = '1' AND (Write_ADD_Execute = R_Source1_Decode OR Write_ADD_Execute = R_Source2_Decode)) ELSE
        '0';

END ARCHITECTURE;   