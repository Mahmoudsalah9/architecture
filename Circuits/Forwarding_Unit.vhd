LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Forwarding_Unit IS

    PORT (

        --in:
        Read_Add1_Execute
        Read_Add2_Execute
        Write_Add1_Memory
        Write_Add2_Memory
        Write_Add1_WB

        Write_EN_Memory
        Swap_EN_Memory
        Write_EN_WB

        --out:
        OP1_Selec
        OP2_Selec
    );

END ENTITY;

ARCHITECTURE Forwarding_Unit_Design OF Forwarding_Unit IS
BEGIN

    

END ARCHITECTURE;