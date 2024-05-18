LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY WriteBack_Stage IS
    PORT (

        ------ IN:

        -- Data:
        Result_ALU_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Result_MEM_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Port2_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Immdite_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Data2_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- Address:
        Write_Add1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Control:
        OUTPORT_Enable_IN : IN STD_LOGIC;
        SWAP_Enable_IN : IN STD_LOGIC;
        WB_Selector_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
        WRITE_Enable_IN : IN STD_LOGIC;
        Memory_Read_IN : IN STD_LOGIC;

        ------ OUT:

        -- Data:
        Write_Back_Data1_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Back_Data2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        OUTPUT_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- Address:
        Write_Add1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Control:
        WRITE_Enable_OUT : OUT STD_LOGIC;
        SWAP_Enable_OUT : OUT STD_LOGIC;
        Memory_Read_OUT : OUT STD_LOGIC;

    );

END ENTITY;

ARCHITECTURE WriteBack_Stage_Design OF WriteBack_Stage IS

    COMPONENT Mux4x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Mux2x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    Mux4x1_Write_Data1 : Mux4x1 GENERIC MAP(
        32) PORT MAP(
        in0 => Result_ALU_IN,
        in1 => Result_MEM_IN,
        in2 => Immdite_Data_IN,
        in3 => Read_Port2_Data_IN,
        sel => WB_Selector_IN,
        MUX_Out => Write_Back_Data1_OUT
    );

    Mux2x1_OUTPUT_PORT : Mux2x1 GENERIC MAP(
        32) PORT MAP(

        in0 => "00000000000000000000000000000000",
        in1 => Read_Port2_Data_IN,
        sel => OUTPORT_Enable_IN,
        MUX_Out => OUTPUT_PORT_DATA

    );

    Write_Back_Data2_OUT <= Write_Data2_IN;
    Write_Add1_OUT <= Write_Add1_IN;
    Write_Add2_OUT <= Write_Add2_IN;
    WRITE_Enable_OUT <= WRITE_Enable_IN;
    SWAP_Enable_OUT <= SWAP_Enable_IN;
    Memory_Read_OUT <= Memory_Read_IN;

END ARCHITECTURE;