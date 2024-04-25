LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY WriteBack_Stage IS
    PORT (

        OutPort_Enable, Swap_Enable_in, Write_Enable_in : IN STD_LOGIC;
        Read_port2_data, Immediate_data, Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Result_Mem : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Add_1_in, Write_Add_2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_Selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Swap_Enable_out, Write_Enable_out : OUT STD_LOGIC;
        Write_Data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Add_1_out, Write_Add_2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUT_PORT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Wtite_Back_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

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

BEGIN
    Mux4x1_Write_Data : Mux4x1 GENERIC MAP(32) PORT MAP(Alu_result, Result_Mem, Immediate_data, Read_port2_data, WB_Selector, Wtite_Back_Data);

    OUT_PORT <= Read_port2_data WHEN OutPort_Enable = '1' ELSE
        x"00000000";
    Swap_Enable_out <= Swap_Enable_in;
    Write_Enable_out <= Write_Enable_in;
    Write_Data2_out <= Write_Data2_in;
    Write_Add_1_out <= Write_Add_1_in;
    Write_Add_2_out <= Write_Add_2_in;

END ARCHITECTURE;