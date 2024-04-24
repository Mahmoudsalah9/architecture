LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Decode IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IMData_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        Write_Add1_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Enable1 : IN STD_LOGIC;
        Write_Enable2 : IN STD_LOGIC;

        ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        Write_Enable : OUT STD_LOGIC;
        Mem_Write : OUT STD_LOGIC;
        InPort_Enable : OUT STD_LOGIC;
        OutPort_Enable : OUT STD_LOGIC;
        Swap : OUT STD_LOGIC;
        Memory_Add_Selec : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Data_After : OUT STD_LOGIC;
        ALU_SRC : OUT STD_LOGIC;
        WB_Selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Extend_Sign : OUT STD_LOGIC;

        Write_Add1_EX : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_Add2_EX : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

        Read_Port1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Port2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        IMData_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END ENTITY;

ARCHITECTURE Decode_Design OF Decode IS

    COMPONENT Control_Unit IS
        PORT (

            Instruction_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Write_Enable : OUT STD_LOGIC;
            Mem_Write : OUT STD_LOGIC;
            InPort_Enable : OUT STD_LOGIC;
            OutPort_Enable : OUT STD_LOGIC;
            Swap_Enable : OUT STD_LOGIC;
            Memory_Add_Selec : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Readport2 Data,   10 SP
            Data_After : OUT STD_LOGIC;
            ALU_SRC : OUT STD_LOGIC;
            WB_Selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
            Extend_Sign : OUT STD_LOGIC;

        );
    END COMPONENT;

    COMPONENT Register_File IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_data1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_data2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_enable1, write_enable2 : IN STD_LOGIC

        );
    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

    --Control signals generation
    SIGNAL ALU_OP_Decode STD_LOGIC_VECTOR(4 DOWNTO 0); --- D/E 
    SIGNAL Write_Enable_Decode STD_LOGIC; --- D/E 
    SIGNAL Mem_Write_Decode STD_LOGIC; --- D/E 
    SIGNAL InPort_Enable_Decode STD_LOGIC; --- D/E 
    SIGNAL OutPort_Enable_Decode STD_LOGIC; --- D/E 
    SIGNAL Swap_Enable STD_LOGIC; --- D/E 
    SIGNAL Memory_Add_Selec_Decode STD_LOGIC_VECTOR(1 DOWNTO 0); --- D/E 
    SIGNAL Data_After_Decode STD_LOGIC;
    SIGNAL ALU_SRC_Decode STD_LOGIC; --- D/E 
    SIGNAL WB_Selector_Decode STD_LOGIC_VECTOR(1 DOWNTO 0) --- D/E 
    SIGNAL Extend_Sign_Decode STD_LOGIC; --- D/E 

    --Instruction Break Down
    SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL R_Source1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL R_Source2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add1_EX : STD_LOGIC_VECTOR(2 DOWNTO 0); --- D/E 
    SIGNAL Write_Add2_EX : STD_LOGIC_VECTOR(2 DOWNTO 0); --- D/E 
    SIGNAL Read_Port1 : STD_LOGIC_VECTOR(31 DOWNTO 0); --- D/E 
    SIGNAL Read_Port2 : STD_LOGIC_VECTOR(31 DOWNTO 0); --- D/E

BEGIN

    IMData_Out <= IMData_in;

    OPCODE <= Instruction(15 DOWNTO 11);
    R_Source1 <= Instruction(10 DOWNTO 8);
    R_Source2 <= Instruction(7 DOWNTO 15);
    Write_Add1 <= Instruction(4 DOWNTO 2);
    Write_Add2 <= Instruction(7 DOWNTO 15);

    Control_Unit_Instance : Control_Unit PORT MAP(OPCODE, ALU_OP_Decode, Write_Enable_Decode, Mem_Write_Decode, InPort_Enable_Decode, OutPort_Enable_Decode, Swap_Enable, Memory_Add_Selec_Decode, Data_After_Decode, ALU_SRC_Decode, WB_Selector_Decode, Extend_Sign_Decode);

    Register_File_Instance : Register_File PORT MAP(Clk, Rst, R_Source1, R_Source2, Read_Port1, Read_Port2, Write_Add1_WB, Write_Add2_WB, Write_Data1, Write_Data2, Write_Enable1, Write_Enable2);

END;