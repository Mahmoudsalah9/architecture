LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Processor_Integration IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        In_Port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out_Port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE Processor_Integration_Design OF Processor_Integration IS

    COMPONENT Fetch_Stage IS
        PORT (
            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            Data_After : IN STD_LOGIC;

            Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Fetch_Decode IS
        PORT (
            clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            Data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Instruction_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            Data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Instruction_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Decode_Stage IS
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
            Swap_Enable : OUT STD_LOGIC;
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
            CCR_Enable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Decode_Execute IS
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
    END COMPONENT;

    COMPONENT Execute_Stage IS
        PORT (

            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;
            INPUT_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            --Buses In:
            Immdite_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Read_Port1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Add1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Add2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            --Control Signals In:
            ALU_OP : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Write_Enable : IN STD_LOGIC;
            Mem_Write : IN STD_LOGIC;
            InPort_Enable : IN STD_LOGIC;
            OutPort_Enable : IN STD_LOGIC;
            Swap_Enable : IN STD_LOGIC;
            Memory_Add_Selec : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALU_SRC : IN STD_LOGIC;
            WB_Selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Extend_Sign : IN STD_LOGIC;
            CCR_Enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            --Control Signals Out:
            Write_Enable_out : OUT STD_LOGIC;
            Mem_Write_out : OUT STD_LOGIC;
            OutPort_Enable_out : OUT STD_LOGIC;
            Swap_Enable_out : OUT STD_LOGIC;
            Memory_Add_Selec_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            WB_Selector_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

            --Buses Out:
            Extended_Imm_Memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Final_Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Add1_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Add2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            ALU_Write_Data2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Flag_Output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

        );
    END COMPONENT;

    -------------------------------------------------------------------------------signals----------------------------------------------------------------------------------------------------------------------------------------------------------

    --Out of Fetch Stage:
    SIGNAL Instruction_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --Out of Fetch/Decode:
    SIGNAL Data_FD : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Instruction_FD : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --Out of Decode Stage:
    SIGNAL ALU_OP_Decode : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Write_Enable_Decode : STD_LOGIC;
    SIGNAL Mem_Write_Decode : STD_LOGIC;
    SIGNAL InPort_Enable_Decode : STD_LOGIC;
    SIGNAL OutPort_Enable_Decode : STD_LOGIC;
    SIGNAL Swap_Enable_Decode : STD_LOGIC;
    SIGNAL Memory_Add_Selec_Decode : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Data_After_Decode : STD_LOGIC;
    SIGNAL ALU_SRC_Decode : STD_LOGIC;
    SIGNAL WB_Selector_Decode : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Extend_Sign_Decode : STD_LOGIC;
    SIGNAL Write_Add1_Decode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_Decode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Read_Port1_Decode : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_Decode : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IMData_out_Decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL CCR_Enable_Decode : STD_LOGIC_VECTOR(3 DOWNTO 0);

    --Out of Decode/Execute Stage:
    SIGNAL ALU_OP_DE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Write_Enable_DE : STD_LOGIC;
    SIGNAL Mem_Write_DE : STD_LOGIC;
    SIGNAL InPort_Enable_DE : STD_LOGIC;
    SIGNAL OutPort_Enable_DE : STD_LOGIC;
    SIGNAL Swap_Enable_DE : STD_LOGIC;
    SIGNAL Memory_Add_Selec_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL ALU_SRC_DE : STD_LOGIC;
    SIGNAL WB_Selector_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Extend_Sign_DE : STD_LOGIC;
    SIGNAL Write_Add1_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Read_Port1_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IMData_DE : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL CCR_Enable_DE : STD_LOGIC_VECTOR(3 DOWNTO 0);

    --Out of Execute Stage:
    SIGNAL Write_Enable_Execute : STD_LOGIC;
    SIGNAL Mem_Write_Execute : STD_LOGIC;
    SIGNAL OutPort_Enable_Execute : STD_LOGIC;
    SIGNAL Swap_Enable_Execute : STD_LOGIC;
    SIGNAL Memory_Add_Selec_Execute : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_Selector_Execute : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Extended_Imm_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Final_Result_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Add1_Execute : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_Execute : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ALU_Write_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Flag_Output_Execute : STD_LOGIC_VECTOR(3 DOWNTO 0);

    --Out of WriteBack Reg:
    SIGNAL Write_Add1_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Data1_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Data2_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Enable_WB : STD_LOGIC;
    SIGNAL Swap_Enable_WB : STD_LOGIC;

BEGIN

    Fetch_Stage_Instance : Fetch_Stage PORT MAP(Clk, Rst, Data_After_Decode, Instruction_Fetch, Data_Fetch);

    Fetch_Decode_Instance : Fetch_Decode PORT MAP(Clk, Rst, Data_Fetch, Instruction_Fetch, Data_FD, Instruction_FD);

    Decode_stage_Instance : Decode_Stage PORT MAP(
        Clk, Rst, Instruction_FD, Data_FD, Write_Add1_WB, Write_Add2_WB, Write_Data1_WB, Write_Data2_WB, Write_Enable_WB,
        Swap_Enable_WB, ALU_OP_Decode, Write_Enable_Decode, Mem_Write_Decode, InPort_Enable_Decode, OutPort_Enable_Decode, Swap_Enable_Decode,
        Memory_Add_Selec_Decode, Data_After_Decode, ALU_SRC_Decode, WB_Selector_Decode, Extend_Sign_Decode, Write_Add1_Decode, Write_Add2_Decode,
        Read_Port1_Decode, Read_Port2_Decode, IMData_out_Decode, CCR_Enable_Decode
    );

    Decode_Execute_Instance : Decode_Execute PORT MAP(
        Clk, Rst, ALU_OP_Decode, Write_Enable_Decode, Mem_Write_Decode, InPort_Enable_Decode, OutPort_Enable_Decode,
        Swap_Enable_Decode, Memory_Add_Selec_Decode, ALU_SRC_Decode, WB_Selector_Decode, Extend_Sign_Decode, Write_Add1_Decode, Write_Add2_Decode,
        Read_Port1_Decode, Read_Port2_Decode, IMData_out_Decode, CCR_Enable_Decode, ALU_OP_DE, Write_Enable_DE, Mem_Write_DE, InPort_Enable_DE,
        OutPort_Enable_DE, Swap_Enable_DE, Memory_Add_Selec_DE, ALU_SRC_DE, WB_Selector_DE, Extend_Sign_DE, Write_Add1_DE, Write_Add2_DE, Read_Port1_DE, Read_Port2_DE,
        IMData_DE, CCR_Enable_DE
    );

    Execute_Stage_Instance : Execute_Stage PORT MAP(
        Clk, Rst, In_Port, IMData_DE, Read_Port1_DE, Read_Port2_DE, Write_Add1_DE, Write_Add2_DE, ALU_OP_DE,
        Write_Enable_DE, Mem_Write_DE, InPort_Enable_DE, OutPort_Enable_DE, Swap_Enable_DE, Memory_Add_Selec_DE, ALU_SRC_DE, WB_Selector_DE, Extend_Sign_DE,
        CCR_Enable_DE, Write_Enable_Execute, Mem_Write_Execute, OutPort_Enable_Execute, Swap_Enable_Execute, Memory_Add_Selec_Execute, WB_Selector_Execute, Extended_Imm_Execute,
        Final_Result_Execute, Read_Port2_Execute, Write_Add1_Execute, Write_Add2_Execute, ALU_Write_Execute, Flag_Output_Execute
    );

END ARCHITECTURE;