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

    COMPONENT Fetch IS
        PORT (

            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;
            Data_After : IN STD_LOGIC;

            Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT F_D_Stage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            instruction_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            data_fetch_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            instruction_fetch_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT Decode IS
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
            CCR_Enable : OUT STD_LOGIC

        );
    END COMPONENT;

    COMPONENT D_E_Stage IS
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
            Mem_Read : IN STD_LOGIC;
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

            Memory_Add_Select_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            WB_Select_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

            Mem_Write_Out : OUT STD_LOGIC;
            Mem_Read_Out : OUT STD_LOGIC;
            ALU_Op_Out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

            ALU_Src_Out : OUT STD_LOGIC;
            Extend_Sign_Out : OUT STD_LOGIC;
            CCR_Arithmetic_Out : OUT STD_LOGIC
        );
    END COMPONENT D_E_Stage;

    COMPONENT Execute IS
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

    COMPONENT E_M_Stage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            alu_result_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_port2_data_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_add_execute : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            immediate_data_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Data2_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            mem_write_execute : IN STD_LOGIC;
            write_enable_execute : IN STD_LOGIC;
            OutPort_Enable : IN STD_LOGIC;
            wb_selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            memory_add_select_execute : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            swap_enable_execute : IN STD_LOGIC;

            read_port2_memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            result_alu_memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            immediate_data_memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Data2_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_add_memory : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_selector_memory : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            memory_add_select_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            OutPort_Enable_out : OUT STD_LOGIC;
            mem_write_out : OUT STD_LOGIC;
            write_enable_out : OUT STD_LOGIC;
            swap_enable_Out : OUT STD_LOGIC

        );
    END COMPONENT;

    COMPONENT memory_stage IS
        PORT (
            CLK, RST : IN STD_LOGIC;
            OutPort_Enable_in, Swap_Enable_in, Write_Enable_in, Mem_Write_enable : IN STD_LOGIC;
            Read_port2_data_in, Immediate_data_in, Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Alu_result_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            Write_Add_1_in, Write_Add_2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_Selector_in, Mem_Add_selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

            OutPort_Enable_out, Swap_Enable_out, Write_Enable_out : OUT STD_LOGIC;
            Read_port2_data_out, Immediate_data_out, Write_Data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Alu_result_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            Write_Add_1_out, Write_Add_2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_Selector_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Result_Mem : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT WB_Stage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            result_mem : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_port2_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            result_alu_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            immediate_data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_add1_memory : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_add2_memory : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_enable_memory : IN STD_LOGIC;
            wb_selector_memory : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            out_enable_memory : IN STD_LOGIC;
            swap_enable_memory : IN STD_LOGIC;
            Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            result_mem_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_port2_memory_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            result_alu_memory_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            immediate_data_memory_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Data2_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_add1_memory_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_add2_memory_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_selector_memory_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            write_enable_memory_Out : OUT STD_LOGIC;
            out_enable_memory_Out : OUT STD_LOGIC;
            swap_enable_memory_Out : OUT STD_LOGIC

        );
    END COMPONENT;

    COMPONENT Write_Back IS
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
    END COMPONENT;

    --signals---

    --Out of Fetch Stage:
    SIGNAL Instruction_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --Out of Fetch/Decode:
    SIGNAL data_fetch_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instruction_fetch_out : STD_LOGIC_VECTOR(15 DOWNTO 0)

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
    SIGNAL CCR_Enable_Decode : STD_LOGIC;

    --Out of Decode/Execute:
    SIGNAL ReadPort1_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ReadPort2_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Add1_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL IMData_DE : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Memory_Add_Select_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_Select_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Mem_Write_DE : STD_LOGIC;
    SIGNAL ALU_Op_DE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL ALU_Src_DE : STD_LOGIC;
    SIGNAL Extend_Sign_DE : STD_LOGIC;
    SIGNAL CCR_Arithmetic_DE : STD_LOGIC;
    SIGNAL Out_Enable_DE : STD_LOGIC;
    SIGNAL Swap_Enable_DE : STD_LOGIC;
    SIGNAL Write_Enable_DE : STD_LOGIC;
    SIGNAL In_Enable_DE : STD_LOGIC;

    --Out of Execute:
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
    SIGNAL ALU_Write_Data2_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Flag_Output_Execute : STD_LOGIC_VECTOR(3 DOWNTO 0)

    --Out of Execute/Memory
    SIGNAL read_port2_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result_alu_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL immediate_data_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Data2_Out_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_add_EM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL wb_selector_EM : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL memory_add_select_EM : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL OutPort_Enable_EM : STD_LOGIC;
    SIGNAL mem_write_EM : STD_LOGIC;
    SIGNAL write_enable_EM : STD_LOGIC;
    SIGNAL swap_enable_EM : STD_LOGIC;

    --Out of WriteBack Reg:
    SIGNAL Write_Add1_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Data1_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Data2_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Enable1_WB : STD_LOGIC;
    SIGNAL Write_Enable2_WB : STD_LOGIC;
BEGIN

    Fetch_Stage_Instance : Fetch PORT MAP(Clk, Rst, Data_After_Decode, Instruction_Fetch, Data_Fetch);

    Fetch_Decode_Instance : F_D_Stage PORT MAP(Clk, Rst, Data_Fetch, Instruction_Fetch, data_fetch_out, instruction_fetch_out);

    Decode_Stage_Instance : Decode PORT MAP(
        Clk, Rst, instruction_fetch_out, data_fetch_out, Write_Add1_WB, Write_Add2_WB, Write_Data1_WB, Write_Data2_W, Write_Enable1_WB, Write_Enable2_WB
        ALU_OP_Decode, Write_Enable_Decode, Mem_Write_Decode, InPort_Enable_Decode, OutPort_Enable_Decode, Swap_Enable_Decode, Memory_Add_Selec_Decode, Data_After_Decode,
        ALU_SRC_Decode, WB_Selector_Decode, WB_Selector_Decode, Extend_Sign_Decode, Write_Add1_Decode, Write_Add2_Decode, Read_Port1_Decode, Read_Port2_Decode,
        IMData_out_Decode, CCR_Enable_Decode);

    Decode_Execute_Instance : D_E_Stage PORT MAP(
        Clk, Rst, Read_Port1_Decode, Read_Port2_Decode, Write_Add1_Decode, Write_Add2_Decode, IMData_out_Decode, OutPort_Enable_Decode, Swap_Enable_Decode,
        Memory_Add_Selec_Decode, WB_Selector_Decode, Write_Enable_Decode, Mem_Write_Decode, ALU_OP_Decode, InPort_Enable_Decode, ALU_SRC_Decode, Extend_Sign_Decode, CCR_Enable_Decode,
        ReadPort1_DE, ReadPort2_DE, Write_Add1_DE, Write_Add2_DE, IMData_DE, Out_Enable_DE, Swap_Enable_DE, Memory_Add_Select_DE, WB_Select_DE, Write_Enable_DE, In_Enable_DE, Mem_Write_DE, ALU_Op_DE, ALU_Src_DE, Extend_Sign_DE, CCR_Arithmetic_DE);

    Execute_Stage_Instance : Execute PORT MAP(
        Clk, Rst, In_Port, IMData_DE, ReadPort1_DE, ReadPort2_DE, Write_Add1_DE, Write_Add2_DE, ALU_Op_DE, Write_Enable_DE, Mem_Write_DE,
        In_Enable_DE, Out_Enable_DE, Swap_Enable_DE, Memory_Add_Select_DE, WB_Select_DE, Extend_Sign_DE, Write_Enable_Execute, Mem_Write_Execute, OutPort_Enable_Execute,
        Swap_Enable_Execute, Memory_Add_Selec_Execute, WB_Selector_Execute, Extended_Imm_Execute, Final_Result_Execute, Read_Port2_Execute, Write_Add1_Execute, Write_Add2_Execute,
        ALU_Write_Data2_Execute, Flag_Output_Execute);

    Execute_Memory_Instance : E_M_Stage PORT MAP(
        Clk, Rst, Final_Result_Execute, Read_Port2_Execute, Write_Add1_Execute, Extended_Imm_Execute, ALU_Write_Data2_Execute,
        Mem_Write_Execute, Write_Enable_Execute, OutPort_Enable_Execute, WB_Selector_Execute, Memory_Add_Selec_Execute, Swap_Enable_Execute,
        read_port2_EM, result_alu_EM, immediate_data_EM, Write_Data2_Out_EM, write_add_EM, wb_selector_EM, memory_add_select_EM, OutPort_Enable_EM,
        mem_write_EM, write_enable_EM, swap_enable_EM);

    Memory_Stage_Instance : memory_stage PORT MAP(Clk,Rst,OutPort_Enable_EM,swap_enable_EM,write_enable_EM,mem_write_EM,read_port2_EM,
    immediate_data_EM,Write_Data2_Out_EM,result_alu_EM,write_add_EM,);

END ARCHITECTURE;