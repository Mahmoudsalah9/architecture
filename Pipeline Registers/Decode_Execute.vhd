LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Decode_Execute IS

    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        ALU_OP_In : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Write_Enable_In : IN STD_LOGIC;
        Mem_Write_In : IN STD_LOGIC;
        InPort_Enable_In : IN STD_LOGIC;
        OutPort_Enable_In : IN STD_LOGIC;
        Swap_Enable_In : IN STD_LOGIC;
        Memory_Add_Selec_In : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALU_SRC_In : IN STD_LOGIC;
        WB_Selector_In : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Extend_Sign_In : IN STD_LOGIC;
        Write_Add1_EX_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_EX_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Read_Port1_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Port2_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMData_In : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        CCR_Enable_In : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        ALU_OP_Out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        Write_Enable_Out : OUT STD_LOGIC;
        Mem_Write_Out : OUT STD_LOGIC;
        InPort_Enable_Out : OUT STD_LOGIC;
        OutPort_Enable_Out : OUT STD_LOGIC;
        Swap_Enable_Out : OUT STD_LOGIC;
        Memory_Add_Selec_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALU_SRC_Out : OUT STD_LOGIC;
        WB_Selector_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Extend_Sign_Out : OUT STD_LOGIC;
        Write_Add1_EX_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_EX_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Read_Port1_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Port2_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMData_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        CCR_Enable_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END ENTITY;

ARCHITECTURE Decode_Execute_Design OF Decode_Execute IS

BEGIN

    PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN

            ALU_OP_Out <= (OTHERS => '0');
            Write_Enable_Out <= '0';
            Mem_Write_Out <= '0';
            InPort_Enable_Out <= '0';
            OutPort_Enable_Out <= '0';
            Swap_Enable_Out <= '0';
            Memory_Add_Selec_Out <= (OTHERS => '0');
            ALU_SRC_Out <= '0';
            WB_Selector_Out <= (OTHERS => '0');
            Extend_Sign_Out <= '0';
            Write_Add1_EX_Out <= (OTHERS => '0');
            Write_Add2_EX_Out <= (OTHERS => '0');
            Read_Port1_Out <= (OTHERS => '0');
            Read_Port2_Out <= (OTHERS => '0');
            IMData_Out <= (OTHERS => '0');
            CCR_Enable_Out <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN

            Read_Port1_Out <= Read_Port1_In;
            Read_Port2_Out <= Read_Port2_In;
            Write_Add1_EX_Out <= Write_Add1_EX_In;
            Write_Add2_EX_Out <= Write_Add2_EX_In;
            Memory_Add_Selec_Out <= Memory_Add_Selec_In;
            WB_Selector_Out <= WB_Selector_In;
            Mem_Write_Out <= Mem_Write_In;
            ALU_OP_Out <= ALU_OP_In;
            ALU_SRC_Out <= ALU_SRC_In;
            Extend_Sign_Out <= Extend_Sign_In;
            CCR_Enable_Out <= CCR_Enable_In;
            IMData_Out <= IMData_In;
            OutPort_Enable_Out <= OutPort_Enable_In;
            InPort_Enable_Out <= InPort_Enable_In;
            Write_Enable_Out <= Write_Enable_In;
            Swap_Enable_Out <= Swap_Enable_In;

        END IF;

    END PROCESS;

END ARCHITECTURE;