LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Decode_Execute IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        ReadPort1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ReadPort2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Add_Decode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IMData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Out_Enable : IN STD_LOGIC;
        Swap_Enable : IN STD_LOGIC;
        Memory_Add_Select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        WB_Select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Write_Enable : IN STD_LOGIC;
        Mem_Write : IN STD_LOGIC;
        ALU_Op : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        In_Enable : IN STD_LOGIC;
        ALU_Src : IN STD_LOGIC;
        Extend_Sign : IN STD_LOGIC;
        CCR_Arithmetic : IN STD_LOGIC;

        ReadPort1_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ReadPort2_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Add_Decode_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IMData_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Out_Enable_Out : OUT STD_LOGIC;
        Swap_Enable_Out : OUT STD_LOGIC;
        Memory_Add_Select_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        WB_Select_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Write_Enable_Out : OUT STD_LOGIC;
        In_Enable_out : OUT STD_LOGIC;
        Mem_Write_Out : OUT STD_LOGIC;
        ALU_Op_Out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

        ALU_Src_Out : OUT STD_LOGIC;
        Extend_Sign_Out : OUT STD_LOGIC;
        CCR_Arithmetic_Out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE Decode_Execute_Design OF Decode_Execute IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN

            ReadPort1_Out <= (OTHERS => '0');
            ReadPort2_Out <= (OTHERS => '0');
            Write_Add_Decode_Out <= (OTHERS => '0');
            Write_Add2_Out <= (OTHERS => '0');
            Memory_Add_Select_Out <= (OTHERS => '0');
            WB_Select_Out <= (OTHERS => '0');
            Mem_Write_Out <= '0';
            ALU_Op_Out <= (OTHERS => '0');
            ALU_Src_Out <= '0';
            Extend_Sign_Out <= '0';
            CCR_Arithmetic_Out <= '0';
            Write_Enable_Out <= '0';
            Out_Enable_Out <= '0';
            In_Enable_out <= '0';
            Swap_Enable_Out <= '0';
            IMData_Out <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            ReadPort1_Out <= ReadPort1;
            ReadPort2_Out <= ReadPort2;
            Write_Add_Decode_Out <= Write_Add_Decode;
            Write_Add2_Out <= Write_Add2;
            Memory_Add_Select_Out <= Memory_Add_Select;
            WB_Select_Out <= WB_Select;
            Mem_Write_Out <= Mem_Write;
            ALU_Op_Out <= ALU_Op;
            ALU_Src_Out <= ALU_Src;
            Extend_Sign_Out <= Extend_Sign;
            CCR_Arithmetic_Out <= CCR_Arithmetic;
            IMData_Out <= IMData;
            Out_Enable_Out <= Out_Enable;
            In_Enable_out <= In_Enable;
            Write_Enable_Out <= Write_Enable;
            Swap_Enable_Out <= Swap_Enable;
        END IF;
    END PROCESS;
END ARCHITECTURE;