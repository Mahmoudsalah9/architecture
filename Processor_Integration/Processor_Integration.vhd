LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Processor_Integration IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        INTERUPT : IN STD_LOGIC;
        In_Port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out_Port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        EXCEPTION : OUT STD_LOGIC;

    );
END ENTITY;

ARCHITECTURE Processor_Integration_Design OF Processor_Integration IS

    ------------------------------------------------------------------------------ STAGES -------------------------------------------------------------------------------------------------------------------------------------------------------------
    COMPONENT Fetch_Stage IS
        PORT (

            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            --in:
            UPDATE_PC_RTI : IN STD_LOGIC;
            UPDATE_PC_INT : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            JMP_EN : IN STD_LOGIC;
            RET_EN : IN STD_LOGIC;
            Zero_Flag : IN STD_LOGIC;
            BRANCH_ZERO : IN STD_LOGIC;
            PC_Disable_INT : IN STD_LOGIC;
            PC_Disable_RTI : IN STD_LOGIC;
            PC_Disable_HDU : IN STD_LOGIC;

            Result_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            JMP_DEST : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            JMP_ZERO_DEST : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            --out:
            JMPZ_Done : OUT STD_LOGIC;

            PC_Value_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT Decode_Stage IS
        PORT (

            --In:

            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            -- Inputs from Fetch Stage
            Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Immediate_Data_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            -- Inputs from WB Stage:
            Write_Add1_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Add2_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Data1_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Data2_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Enable1_WB : IN STD_LOGIC;
            Write_Enable2_WB : IN STD_LOGIC;

            -- Input Propagating Signals:
            PCVALUE_IN : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

            --Out:

            -- Output Control Signals:
            RTI_Begin_OUT : OUT STD_LOGIC;
            FLUSH_OUT : OUT STD_LOGIC;
            PROTECT_OUT : OUT STD_LOGIC;
            OUTPORT_Enable_OUT : OUT STD_LOGIC;
            SWAP_Enable_OUT : OUT STD_LOGIC;
            MEM_Add_Selec_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Readport2 Data,   10 SP
            WB_Selector_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
            FREE_OUT : OUT STD_LOGIC;
            JUMP_OUT : OUT STD_LOGIC;
            BRANCH_ZERO_OUT : OUT STD_LOGIC;
            WRITE_Enable_OUT : OUT STD_LOGIC;
            MEM_Write_OUT : OUT STD_LOGIC;
            MEM_Read_OUT : OUT STD_LOGIC;
            ALU_OP_OUT : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            CALL_Enable_OUT : OUT STD_LOGIC;
            INPORT_Enable_OUT : OUT STD_LOGIC;
            ALU_SRC_OUT : OUT STD_LOGIC;
            CCR_Arithmetic_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            RET_Enable_OUT : OUT STD_LOGIC;
            STACK_Operation_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 NOP on sp, 01 increment by 2, 10 decrement by 2

            -- Output Data and Address Signals:
            Write_Add1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Add2_R_Source2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Read_Port1_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Immediate_Data_Extended_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            R_Source1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

            -- OUTPUT Propagating Signals:
            PCVALUE_OUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT Execute_Stage IS
        PORT (

            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            --in:
            Branch_ZERO_IN : IN STD_LOGIC;
            Protect_IN : IN STD_LOGIC;
            Out_Enable_IN : IN STD_LOGIC;
            Swap_Enable_IN : IN STD_LOGIC;
            Memory_Add_Selec_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Back_Selector_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Free_IN : IN STD_LOGIC;
            Write_Enable_IN : IN STD_LOGIC;
            Mem_READ_IN : IN STD_LOGIC;
            Mem_Write_IN : IN STD_LOGIC;
            ALU_OP_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Call_Enable_IN : IN STD_LOGIC;
            INPUT_PORT_ENABLE_IN : IN STD_LOGIC;
            ALU_SRC_IN : IN STD_LOGIC;
            CCR_Arethmetic_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Stack_Operation_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            RET_Enable_IN : IN STD_LOGIC;

            ReadPort1_Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ReadPort2_Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            WriteAdd1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WriteAdd2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Imm_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            R_Source1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            PC_Value_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            INPUT_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            Forwarding_UNIT_MUX1_Selec1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Forwarding_UNIT_MUX1_Selec2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Forwarded_Data_ALUtoALU : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Forwarded_Data_MEMtoALU : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Forwarded_Data_SWAPALUtoALU : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Forwarded_Data_SWAPMEMtoALU : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            Stack_OP_RTI : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Stack_OP_INT : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            CCR_Select : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Result_Mem : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            --out:
            Branch_ZERO_OUT : OUT STD_LOGIC;
            Protect_OUT : OUT STD_LOGIC;
            Out_Enable_OUT : OUT STD_LOGIC;
            Swap_Enable_OUT : OUT STD_LOGIC;
            Memory_Add_Selec_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Back_Selector_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Free_OUT : OUT STD_LOGIC;
            Write_Enable_OUT : OUT STD_LOGIC;
            Mem_READ_OUT : OUT STD_LOGIC;
            Mem_Write_OUT : OUT STD_LOGIC;
            Call_Enable_OUT : OUT STD_LOGIC;
            RET_Enable_OUT : OUT STD_LOGIC;

            Final_Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_Data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WriteAdd1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WriteAdd2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Imm_Data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WriteData2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_Value_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            SP_OUT_Buffered : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            SP_OUT_Normal : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

            Zero_Flag_OUT : OUT STD_LOGIC;
            JMP_DEST : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            JMPZ_DEST : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

            Forwarded_ReadADD1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Forwarded_ReadADD2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT Memory_Stage IS
        PORT (
            CLK, RST, Protect, OutPort_Enable_in, Swap_Enable_in : IN STD_LOGIC;
            Mem_Add_selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            WB_Selector_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Free : IN STD_LOGIC;
            Write_Enable_in, Mem_Write_enable, Mem_Write_INT_FSM : IN STD_LOGIC;
            Ret_Enable_In : IN STD_LOGIC;
            Write_Data_Selector, Mux_Select_INT_FSM : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            CCR_Out : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            PC_Address_INT_OUT, Read_port2_data_in, PC_Value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Alu_result_in, SP : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            Write_Add_1_in, Write_Add_2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Immediate_data_in, Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_Add_MUX_RTI_Select, MEM_Add_MUX_INT_Select : IN STD_LOGIC;
            MEM_read_in : IN STD_LOGIC;

            Ret_Enable_Out : OUT STD_LOGIC;
            OutPort_Enable_out, Swap_Enable_out : OUT STD_LOGIC;
            WB_Selector_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Enable_out : OUT STD_LOGIC;
            Result_Mem : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Protected_To_Exception : OUT STD_LOGIC;
            Read_port2_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Alu_result_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            Write_Add_1_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Immediate_data_out, Write_Data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Add_2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) :
            MEM_read_out : OUT STD_LOGIC;
        );
    END COMPONENT;

    COMPONENT WriteBack_Stage IS
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
            SWAP_Enable_OUT : OUT STD_LOGIC

        );

    END COMPONENT;

    ------------------------------------------------------------------------------ BUFFERS ------------------------------------------------------------------------------------------------------------------------------------------------------------
    COMPONENT Fetch_Decode IS
        PORT (
            clk, Rst : IN STD_LOGIC;
            flush, stall : IN STD_LOGIC;

            -- Inputs:
            Instruction_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            PC_Value_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            -- Outputs:
            Instruction_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            PC_Value_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Decode_Execute IS

        PORT (

            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;
            FLUSH : IN STD_LOGIC;
            LoadUse_RST : IN STD_LOGIC;

            -- IN:
            PROTECT_IN : IN STD_LOGIC;
            OUTPORT_Enable_IN : IN STD_LOGIC;
            SWAP_Enable_IN : IN STD_LOGIC;
            MEM_Add_Selec_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            WB_Selector_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            FREE_IN : IN STD_LOGIC;
            JUMP_IN : IN STD_LOGIC;
            BRANCH_ZERO_IN : IN STD_LOGIC;
            WRITE_Enable_IN : IN STD_LOGIC;
            MEM_Write_IN : IN STD_LOGIC;
            MEM_Read_IN : IN STD_LOGIC;
            ALU_OP_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            CALL_Enable_IN : IN STD_LOGIC;
            INPORT_Enable_IN : IN STD_LOGIC;
            ALU_SRC_IN : IN STD_LOGIC;
            CCR_Arithmetic_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            RET_Enable_IN : IN STD_LOGIC;
            STACK_Operation_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Add1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Add2_R_Source2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Read_Port1_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Immediate_Data_Extended_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            R_Source1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            PCVALUE_IN : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

            -- OUT:
            PROTECT_OUT : OUT STD_LOGIC;
            OUTPORT_Enable_OUT : OUT STD_LOGIC;
            SWAP_Enable_OUT : OUT STD_LOGIC;
            MEM_Add_Selec_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            WB_Selector_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            FREE_OUT : OUT STD_LOGIC;
            JUMP_OUT : OUT STD_LOGIC;
            BRANCH_ZERO_OUT : OUT STD_LOGIC;
            WRITE_Enable_OUT : OUT STD_LOGIC;
            MEM_Write_OUT : OUT STD_LOGIC;
            MEM_Read_OUT : OUT STD_LOGIC;
            ALU_OP_OUT : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            CALL_Enable_OUT : OUT STD_LOGIC;
            INPORT_Enable_OUT : OUT STD_LOGIC;
            ALU_SRC_OUT : OUT STD_LOGIC;
            CCR_Arithmetic_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            RET_Enable_OUT : OUT STD_LOGIC;
            STACK_Operation_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Add1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Add2_R_Source2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Read_Port1_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Immediate_Data_Extended_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            R_Source1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            PCVALUE_OUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)

        );

    END COMPONENT;

    COMPONENT Execute_Memory IS
        PORT (
            clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            -- Inputs:
            Branch_ZERO_IN : IN STD_LOGIC;
            Protect_IN : IN STD_LOGIC;
            Out_Enable_IN : IN STD_LOGIC;
            Swap_Enable_IN : IN STD_LOGIC;
            Memory_Add_Selec_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Back_Selector_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Free_IN : IN STD_LOGIC;
            Write_Enable_IN : IN STD_LOGIC;
            Mem_READ_IN : IN STD_LOGIC;
            Mem_Write_IN : IN STD_LOGIC;
            Call_Enable_IN : IN STD_LOGIC;
            RET_Enable_IN : IN STD_LOGIC;

            Final_Result_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            WriteAdd1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WriteAdd2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Imm_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            WriteData2_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_Value_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SP_IN_Buffered : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            SP_IN_Normal : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

            Zero_Flag_IN : IN STD_LOGIC;
            JMP_DEST_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            JMPZ_DEST_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            Forwarded_ReadADD1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Forwarded_ReadADD2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            -- Outputs:
            Branch_ZERO_OUT : OUT STD_LOGIC;
            Protect_OUT : OUT STD_LOGIC;
            Out_Enable_OUT : OUT STD_LOGIC;
            Swap_Enable_OUT : OUT STD_LOGIC;
            Memory_Add_Selec_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Write_Back_Selector_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Free_OUT : OUT STD_LOGIC;
            Write_Enable_OUT : OUT STD_LOGIC;
            Mem_READ_OUT : OUT STD_LOGIC;
            Mem_Write_OUT : OUT STD_LOGIC;
            Call_Enable_OUT : OUT STD_LOGIC;
            RET_Enable_OUT : OUT STD_LOGIC;

            Final_Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Port2_Data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WriteAdd1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WriteAdd2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Imm_Data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WriteData2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_Value_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            SP_OUT_Buffered : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            SP_OUT_Normal : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

            Zero_Flag_OUT : OUT STD_LOGIC;
            JMP_DEST : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            JMPZ_DEST : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCR_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

            Forwarded_ReadADD1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Forwarded_ReadADD2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Memory_WriteBack IS
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
            MEM_read_in : IN STD_LOGIC;

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
            swap_enable_memory_Out : OUT STD_LOGIC;
            MEM_read_out : IN STD_LOGIC;

        );
    END COMPONENT;

    ------------------------------------------------------------------------------ OTHERS -------------------------------------------------------------------------------------------------------------------------------------------------------------
    COMPONENT INT_Operator IS
        PORT (

            -- IN:
            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;

            INT : IN STD_LOGIC;
            JUMP_EN : IN STD_LOGIC;
            CALL_EN : IN STD_LOGIC;
            JMP_ZERO_DONE : STD_LOGIC;
            PC_Address_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            -- OUT:
            MUX_Selec_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            PC_Address_OUT_INT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Stack_Operation_INT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            MEM_WRITE_INT : OUT STD_LOGIC;
            MEM_ADD_Selec_INT : OUT STD_LOGIC;
            UPDATE_PC_INT : OUT STD_LOGIC;
            PC_Disable : OUT STD_LOGIC;
            FD_Stall : OUT STD_LOGIC

        );
    END COMPONENT;

    COMPONENT RTI_Operator IS
        PORT (
            -- IN:
            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;
            RTI_BEGIN : IN STD_LOGIC;

            -- OUT:
            Stack_Operation_RTI : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            RTI_PC_UPDATE : OUT STD_LOGIC;
            MEM_ADD_MUX_RTI_Selec : OUT STD_LOGIC;
            CCR_Selector : OUT STD_LOGIC;
            PC_Disable : OUT STD_LOGIC;
            FD_Stall : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Hazard_DU IS
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
    END COMPONENT;

    COMPONENT Forwarding_Unit IS

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

    END COMPONENT;

    ------------------------------------------------------------------------------ signals ------------------------------------------------------------------------------------------------------------------------------------------------------------

    --Out of Fetch Stage:
    SIGNAL JMPZ_Done_Fetch : STD_LOGIC;
    SIGNAL PC_Value_Fetch : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Instruction_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --Out of Fetch/Decode Buffer:
    SIGNAL Instruction_FD : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_FD : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PC_Value_FD : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Out of Decode Stage:
    SIGNAL RTI_Begin_DECODE : STD_LOGIC;
    SIGNAL FLUSH_DECODE : STD_LOGIC;
    SIGNAL PROTECT_DECODE : STD_LOGIC;
    SIGNAL OUTPORT_Enable_DECODE : STD_LOGIC;
    SIGNAL SWAP_Enable_DECODE : STD_LOGIC;
    SIGNAL MEM_Add_Selec_DECODE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_Selector_DECODE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL FREE_DECODE : STD_LOGIC;
    SIGNAL JUMP_DECODE : STD_LOGIC;
    SIGNAL BRANCH_ZERO_DECODE : STD_LOGIC;
    SIGNAL WRITE_Enable_DECODE : STD_LOGIC;
    SIGNAL MEM_Write_DECODE : STD_LOGIC;
    SIGNAL MEM_Read_DECODE : STD_LOGIC;
    SIGNAL ALU_OP_DECODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL CALL_Enable_DECODE : STD_LOGIC;
    SIGNAL INPORT_Enable_DECODE : STD_LOGIC;
    SIGNAL ALU_SRC_DECODE : STD_LOGIC;
    SIGNAL CCR_Arithmetic_DECODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL RET_Enable_DECODE : STD_LOGIC;
    SIGNAL STACK_Operation_DECODE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Add1_DECODE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_R_Source2_DECODE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Read_Port1_DECODE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_DECODE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Immediate_Data_Extended_DECODE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL R_Source1_DECODE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PCVALUE_DECODE : STD_LOGIC_VECTOR(11 DOWNTO 0);

    --Out of Decode/Execute Buffer:
    SIGNAL PROTECT_DE : STD_LOGIC;
    SIGNAL OUTPORT_Enable_DE : STD_LOGIC;
    SIGNAL SWAP_Enable_DE : STD_LOGIC;
    SIGNAL MEM_Add_Selec_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_Selector_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL FREE_DE : STD_LOGIC;
    SIGNAL JUMP_DE : STD_LOGIC;
    SIGNAL BRANCH_ZERO_DE : STD_LOGIC;
    SIGNAL WRITE_Enable_DE : STD_LOGIC;
    SIGNAL MEM_Write_DE : STD_LOGIC;
    SIGNAL MEM_Read_DE : STD_LOGIC;
    SIGNAL ALU_OP_DE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL CALL_Enable_DE : STD_LOGIC;
    SIGNAL INPORT_Enable_DE : STD_LOGIC;
    SIGNAL ALU_SRC_DE : STD_LOGIC;
    SIGNAL CCR_Arithmetic_DE : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL RET_Enable_DE : STD_LOGIC;
    SIGNAL STACK_Operation_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Add1_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_R_Source2_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Read_Port1_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Immediate_Data_Extended_DE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL R_Source1_DE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PCVALUE_DE : STD_LOGIC_VECTOR(11 DOWNTO 0);

    --Out of Execute Stage:
    SIGNAL Branch_ZERO_EXECUTE : STD_LOGIC;
    SIGNAL Protect_EXECUTE : STD_LOGIC;
    SIGNAL Out_Enable_EXECUTE : STD_LOGIC;
    SIGNAL Swap_Enable_EXECUTE : STD_LOGIC;
    SIGNAL Memory_Add_Selec_EXECUTE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Back_Selector_EXECUTE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Free_EXECUTE : STD_LOGIC;
    SIGNAL Write_Enable_EXECUTE : STD_LOGIC;
    SIGNAL Mem_READ_EXECUTE : STD_LOGIC;
    SIGNAL Mem_Write_EXECUTE : STD_LOGIC;
    SIGNAL Call_Enable_EXECUTE : STD_LOGIC;
    SIGNAL RET_Enable_EXECUTE : STD_LOGIC;
    SIGNAL Final_Result_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_Data_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WriteAdd1_EXECUTE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WriteAdd2_EXECUTE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Imm_Data_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WriteData2_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_Value_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP_OUT_Buffered_EXECUTE : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL SP_OUT_Normal_EXECUTE : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Zero_Flag_EXECUTE : STD_LOGIC;
    SIGNAL JMP_DEST_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL JMPZ_DEST_EXECUTE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CCR_EXECUTE : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Forwarded_ReadADD1_EXECUTE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Forwarded_ReadADD2_EXECUTE : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --Out of Execute/Memory Buffer:
    SIGNAL Branch_ZERO_EM : STD_LOGIC;
    SIGNAL Protect_EM : STD_LOGIC;
    SIGNAL Out_Enable_EM : STD_LOGIC;
    SIGNAL Swap_Enable_EM : STD_LOGIC;
    SIGNAL Memory_Add_Selec_EM : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Back_Selector_EM : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Free_EM : STD_LOGIC;
    SIGNAL Write_Enable_EM : STD_LOGIC;
    SIGNAL Mem_READ_EM : STD_LOGIC;
    SIGNAL Mem_Write_EM : STD_LOGIC;
    SIGNAL Call_Enable_EM : STD_LOGIC;
    SIGNAL RET_Enable_EM : STD_LOGIC;

    SIGNAL Final_Result_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_Data_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WriteAdd1_EM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WriteAdd2_EM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Imm_Data_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WriteData2_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_Value_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP_OUT_Buffered_EM : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL SP_OUT_Normal_EM : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL Zero_Flag_EM : STD_LOGIC;
    SIGNAL JMP_DEST_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL JMPZ_DEST_EM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CCR_EM : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL Forwarded_ReadADD1_EM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Forwarded_ReadADD2_EM : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --Out of Memory Stage:
    SIGNAL Ret_Enable_MEMORY : STD_LOGIC;
    SIGNAL OutPort_Enable_MEMORY, Swap_Enable_MEMORY : STD_LOGIC;
    SIGNAL WB_Selector_MEMORY : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Enable_MEMORY : STD_LOGIC;
    SIGNAL Result_Mem_MEMORY : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Protected_To_Exception_MEMORY : STD_LOGIC;
    SIGNAL Read_port2_data_MEMORY : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Alu_result_MEMORY : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Write_Add_1_MEMORY : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Immediate_data_MEMORY, Write_Data2_MEMORY : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Add_2_MEMORY : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --Out of Memory/WriteBack Buffer:
    SIGNAL Result_Mem_MW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_Memory_MW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Result_ALU_Memory_MW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Immediate_Data_Memory_MW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Data2_MW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Add1_Memory_MW : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_Memory_MW : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB_Selector_Memory_MW : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Enable_Memory_MW : STD_LOGIC;
    SIGNAL Out_Enable_Memory_MW : STD_LOGIC;
    SIGNAL Swap_Enable_Memory_MW : STD_LOGIC;

    --Out of WriteBack Stage:
    SIGNAL Write_Back_Data1_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Back_Data2_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Output_Port_Data_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Add1_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Enable_WB : STD_LOGIC;
    SIGNAL Swap_Enable_WB : STD_LOGIC;

    --Out of Interput 
    SIGNAL MUX_Selec_INT_INTERUPT : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PC_Address_OUT_INT_INTERUPT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Stack_Operation_INT_INTERUPT : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL MEM_WRITE_INT_INTERUPT : STD_LOGIC;
    SIGNAL MEM_ADD_Selec_INT_INTERUPT : STD_LOGIC;
    SIGNAL UPDATE_PC_INT_INTERUPT : STD_LOGIC;
    SIGNAL PC_Disable_INTERUPT : STD_LOGIC;
    SIGNAL FD_Stall_INTERUPT : STD_LOGIC;

    --Out of RTI
    SIGNAL Stack_Operation_RTI_RTI : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL RTI_PC_UPDATE_RTI : STD_LOGIC;
    SIGNAL MEM_ADD_MUX_RTI_Selec_RTI : STD_LOGIC;
    SIGNAL CCR_Selector_RTI : STD_LOGIC;
    SIGNAL PC_Disable_RTI : STD_LOGIC;
    SIGNAL FD_Stall_RTI : STD_LOGIC;

    --Out of HDU
    SIGNAL STALL_Hazard : STD_LOGIC;
    SIGNAL PC_Disable_Hazard : STD_LOGIC;
    SIGNAL LoadUse_RST_Hazard : STD_LOGIC;

    --Out of FU
    SIGNAL OP1_Selec_Forwarding_Unit : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL OP2_Selec_Forwarding_Unit : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -------------------------------------------------------------------------- Port Connections ----------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN

    -- Instance of Fetch_Stage component
    Fetch_Stage_Instance : Fetch_Stage
    PORT MAP(
        Clk => OPEN,
        Rst => OPEN,
        UPDATE_PC_RTI => OPEN,
        UPDATE_PC_INT => OPEN,
        RESET => OPEN,
        JMP_EN => OPEN,
        RET_EN => OPEN,
        Zero_Flag => OPEN,
        BRANCH_ZERO => OPEN,
        PC_Disable_INT => OPEN,
        PC_Disable_RTI => OPEN,
        PC_Disable_HDU => OPEN,
        Result_MEM => OPEN,
        JMP_DEST => OPEN,
        JMP_ZERO_DEST => OPEN,
        JMPZ_Done => OPEN,
        PC_Value_OUT => OPEN,
        Instruction_OUT => OPEN,
        Data_OUT => OPEN
    );

    -- Instance of Decode_Stage component
    Decode_Stage_Instance : Decode_Stage
    PORT MAP(
        Clk => OPEN,
        Rst => OPEN,
        Instruction => OPEN,
        Immediate_Data_IN => OPEN,
        Write_Add1_WB => OPEN,
        Write_Add2_WB => OPEN,
        Write_Data1_WB => OPEN,
        Write_Data2_WB => OPEN,
        Write_Enable1_WB => OPEN,
        Write_Enable2_WB => OPEN,
        PCVALUE_IN => OPEN,
        RTI_Begin_OUT => OPEN,
        FLUSH_OUT => OPEN,
        PROTECT_OUT => OPEN,
        OUTPORT_Enable_OUT => OPEN,
        SWAP_Enable_OUT => OPEN,
        MEM_Add_Selec_OUT => OPEN,
        WB_Selector_OUT => OPEN,
        FREE_OUT => OPEN,
        JUMP_OUT => OPEN,
        BRANCH_ZERO_OUT => OPEN,
        WRITE_Enable_OUT => OPEN,
        MEM_Write_OUT => OPEN,
        MEM_Read_OUT => OPEN,
        ALU_OP_OUT => OPEN,
        CALL_Enable_OUT => OPEN,
        INPORT_Enable_OUT => OPEN,
        ALU_SRC_OUT => OPEN,
        CCR_Arithmetic_OUT => OPEN,
        RET_Enable_OUT => OPEN,
        STACK_Operation_OUT => OPEN,
        Write_Add1_OUT => OPEN,
        Write_Add2_R_Source2_OUT => OPEN,
        Read_Port1_OUT => OPEN,
        Read_Port2_OUT => OPEN,
        Immediate_Data_Extended_OUT => OPEN,
        R_Source1_OUT => OPEN,
        PCVALUE_OUT => OPEN
    );

    -- Port mapping for Execute_Stage
    Execute_Stage_Instance : Execute_Stage
    PORT MAP(
        Clk => Clk,
        Rst => Rst,
        Branch_ZERO_IN => OPEN,
        Protect_IN => OPEN,
        Out_Enable_IN => OPEN,
        Swap_Enable_IN => OPEN,
        Memory_Add_Selec_IN => OPEN,
        Write_Back_Selector_IN => OPEN,
        Free_IN => OPEN,
        Write_Enable_IN => OPEN,
        Mem_READ_IN => OPEN,
        Mem_Write_IN => OPEN,
        ALU_OP_IN => OPEN,
        Call_Enable_IN => OPEN,
        INPUT_PORT_ENABLE_IN => OPEN,
        ALU_SRC_IN => OPEN,
        CCR_Arethmetic_IN => OPEN,
        Stack_Operation_IN => OPEN,
        RET_Enable_IN => OPEN,
        ReadPort1_Data => OPEN,
        ReadPort2_Data => OPEN,
        WriteAdd1_IN => OPEN,
        WriteAdd2_IN => OPEN,
        Imm_Data_IN => OPEN,
        R_Source1_IN => OPEN,
        PC_Value_IN => OPEN,
        INPUT_PORT => OPEN,
        Forwarding_UNIT_MUX1_Selec1 => OPEN,
        Forwarding_UNIT_MUX1_Selec2 => OPEN,
        Forwarded_Data_ALUtoALU => OPEN,
        Forwarded_Data_MEMtoALU => OPEN,
        Forwarded_Data_SWAPALUtoALU => OPEN,
        Forwarded_Data_SWAPMEMtoALU => OPEN,
        Stack_OP_RTI => OPEN,
        Stack_OP_INT => OPEN,
        CCR_Select => OPEN,
        Result_Mem => OPEN,
        -- Outputs
        Branch_ZERO_OUT => OPEN,
        Protect_OUT => OPEN,
        Out_Enable_OUT => OPEN,
        Swap_Enable_OUT => OPEN,
        Memory_Add_Selec_OUT => OPEN,
        Write_Back_Selector_OUT => OPEN,
        Free_OUT => OPEN,
        Write_Enable_OUT => OPEN,
        Mem_READ_OUT => OPEN,
        Mem_Write_OUT => OPEN,
        Call_Enable_OUT => OPEN,
        RET_Enable_OUT => OPEN,
        Final_Result => OPEN,
        Read_Port2_Data_OUT => OPEN,
        WriteAdd1_OUT => OPEN,
        WriteAdd2_OUT => OPEN,
        Imm_Data_OUT => OPEN,
        WriteData2_OUT => OPEN,
        PC_Value_OUT => OPEN,
        SP_OUT_Buffered => OPEN,
        SP_OUT_Normal => OPEN,
        Zero_Flag_OUT => OPEN,
        JMP_DEST => OPEN,
        JMPZ_DEST => OPEN,
        CCR_Out => OPEN,
        Forwarded_ReadADD1 => OPEN,
        Forwarded_ReadADD2 => OPEN
    );

    U_Memory_Stage : Memory_Stage
    PORT MAP(

        CLK => OPEN,
        RST => OPEN,
        Protect => OPEN,
        OutPort_Enable_in => OPEN,
        Swap_Enable_in => OPEN,
        Mem_Add_selector => OPEN,
        WB_Selector_in => OPEN,
        Free => OPEN,
        Write_Enable_in => OPEN,
        Mem_Write_enable => OPEN,
        Mem_Write_INT_FSM => OPEN,
        Ret_Enable_In => OPEN,
        Write_Data_Selector => OPEN,
        Mux_Select_INT_FSM => OPEN,
        CCR_Out => OPEN,
        PC_Address_INT_OUT => OPEN,
        Read_port2_data_in => OPEN,
        PC_Value => OPEN,
        Alu_result_in => OPEN,
        SP => OPEN,
        Write_Add_1_in => OPEN,
        Write_Add_2_in => OPEN,
        Immediate_data_in => OPEN,
        Write_Data2_in => OPEN,
        MEM_Add_MUX_RTI_Select => OPEN,
        MEM_Add_MUX_INT_Select => OPEN,
        MEM_read_in => OPEN,
        Ret_Enable_Out => OPEN,
        OutPort_Enable_out => OPEN,
        Swap_Enable_out => OPEN,
        WB_Selector_out => OPEN,
        Write_Enable_out => OPEN,
        Result_Mem => OPEN,
        Protected_To_Exception => OPEN,
        Read_port2_data_out => OPEN,
        Alu_result_out => OPEN,
        Write_Add_1_out => OPEN,
        Immediate_data_out => OPEN,
        Write_Data2_out => OPEN,
        Write_Add_2_out => OPEN,
        MEM_read_out => OPEN

    );

    -- Instance of WriteBack_Stage component
    WriteBack_Stage_Instance : WriteBack_Stage
    PORT MAP(
        Result_ALU_IN => OPEN,
        Result_MEM_IN => OPEN,
        Read_Port2_Data_IN => OPEN,
        Immdite_Data_IN => OPEN,
        Write_Data2_IN => OPEN,
        Write_Add1_IN => OPEN,
        Write_Add2_IN => OPEN,
        OUTPORT_Enable_IN => OPEN,
        SWAP_Enable_IN => OPEN,
        WB_Selector_IN => OPEN,
        WRITE_Enable_IN => OPEN,
        Write_Back_Data1_OUT => OPEN,
        Write_Back_Data2_OUT => OPEN,
        OUTPUT_PORT_DATA => OPEN,
        Write_Add1_OUT => OPEN,
        Write_Add2_OUT => OPEN,
        WRITE_Enable_OUT => OPEN,
        SWAP_Enable_OUT => OPEN
    );

    -- Instance of Fetch_Decode component
    Fetch_Decode_Instance : Fetch_Decode
    PORT MAP(
        clk => OPEN,
        Rst => OPEN,
        flush => OPEN,
        stall => OPEN,
        Instruction_IN => OPEN,
        Data_in => OPEN,
        PC_Value_IN => OPEN,
        Instruction_OUT => OPEN,
        Data_OUT => OPEN,
        PC_Value_OUT => OPEN
    );

    -- Instance of Decode_Execute component
    Decode_Execute_Instance : Decode_Execute
    PORT MAP(
        Clk => OPEN,
        Rst => OPEN,
        FLUSH => OPEN,
        LoadUse_RST => OPEN,
        PROTECT_IN => OPEN,
        OUTPORT_Enable_IN => OPEN,
        SWAP_Enable_IN => OPEN,
        MEM_Add_Selec_IN => OPEN,
        WB_Selector_IN => OPEN,
        FREE_IN => OPEN,
        JUMP_IN => OPEN,
        BRANCH_ZERO_IN => OPEN,
        WRITE_Enable_IN => OPEN,
        MEM_Write_IN => OPEN,
        MEM_Read_IN => OPEN,
        ALU_OP_IN => OPEN,
        CALL_Enable_IN => OPEN,
        INPORT_Enable_IN => OPEN,
        ALU_SRC_IN => OPEN,
        CCR_Arithmetic_IN => OPEN,
        RET_Enable_IN => OPEN,
        STACK_Operation_IN => OPEN,
        Write_Add1_IN => OPEN,
        Write_Add2_R_Source2_IN => OPEN,
        Read_Port1_IN => OPEN,
        Read_Port2_IN => OPEN,
        Immediate_Data_Extended_IN => OPEN,
        R_Source1_IN => OPEN,
        PCVALUE_IN => OPEN,
        PROTECT_OUT => OPEN,
        OUTPORT_Enable_OUT => OPEN,
        SWAP_Enable_OUT => OPEN,
        MEM_Add_Selec_OUT => OPEN,
        WB_Selector_OUT => OPEN,
        FREE_OUT => OPEN,
        JUMP_OUT => OPEN,
        BRANCH_ZERO_OUT => OPEN,
        WRITE_Enable_OUT => OPEN,
        MEM_Write_OUT => OPEN,
        MEM_Read_OUT => OPEN,
        ALU_OP_OUT => OPEN,
        CALL_Enable_OUT => OPEN,
        INPORT_Enable_OUT => OPEN,
        ALU_SRC_OUT => OPEN,
        CCR_Arithmetic_OUT => OPEN,
        RET_Enable_OUT => OPEN,
        STACK_Operation_OUT => OPEN,
        Write_Add1_OUT => OPEN,
        Write_Add2_R_Source2_OUT => OPEN,
        Read_Port1_OUT => OPEN,
        Read_Port2_OUT => OPEN,
        Immediate_Data_Extended_OUT => OPEN,
        R_Source1_OUT => OPEN,
        PCVALUE_OUT => OPEN
    );

    -- Port mapping for Memory_Stage
    Memory_Stage_Instance : Memory_Stage
    PORT MAP(
        CLK => CLK,
        RST => RST,
        Protect => OPEN,
        OutPort_Enable_in => OPEN,
        Swap_Enable_in => OPEN,
        Mem_Add_selector => OPEN,
        WB_Selector_in => OPEN,
        Free => OPEN,
        Write_Enable_in => OPEN,
        Mem_Write_enable => OPEN,
        Mem_Write_INT_FSM => OPEN,
        Ret_Enable_In => OPEN,
        Write_Data_Selector => OPEN,
        Mux_Select_INT_FSM => OPEN,
        CCR_Out => OPEN,
        PC_Address_INT_OUT => OPEN,
        Read_port2_data_in => OPEN,
        PC_Value => OPEN,
        Alu_result_in => OPEN,
        SP => OPEN,
        Write_Add_1_in => OPEN,
        Write_Add_2_in => OPEN,
        Immediate_data_in => OPEN,
        Write_Data2_in => OPEN,
        MEM_Add_MUX_RTI_Select => OPEN,
        MEM_Add_MUX_INT_Select => OPEN,
        MEM_read_in => OPEN,
        -- Outputs
        Ret_Enable_Out => OPEN,
        OutPort_Enable_out => OPEN,
        Swap_Enable_out => OPEN,
        WB_Selector_out => OPEN,
        Write_Enable_out => OPEN,
        Result_Mem => OPEN,
        Protected_To_Exception => OPEN,
        Read_port2_data_out => OPEN,
        Alu_result_out => OPEN,
        Write_Add_1_out => OPEN,
        Immediate_data_out => OPEN,
        Write_Data2_out => OPEN,
        Write_Add_2_out => OPEN,
        MEM_read_out => OPEN
    );

    U_Memory_WriteBack : Memory_WriteBack
    PORT MAP(

        clk => OPEN,
        reset => OPEN,
        result_mem => OPEN,
        read_port2_memory => OPEN,
        Write_data_memory => OPEN,
        result_alu_memory => OPEN,
        immediate_data_memory => OPEN,
        write_add1_memory => OPEN,
        write_add2_memory => OPEN,
        write_enable_memory => OPEN,
        wb_selector_memory => OPEN,
        out_enable_memory => OPEN,
        swap_enable_memory => OPEN,
        Write_Data2_in => OPEN,
        MEM_read_in => OPEN,
        result_mem_out => OPEN,
        read_port2_memory_out => OPEN,
        result_alu_memory_out => OPEN,
        immediate_data_memory_out => OPEN,
        Write_Data2_Out => OPEN,
        write_add1_memory_out => OPEN,
        write_add2_memory_out => OPEN,
        wb_selector_memory_out => OPEN,
        write_enable_memory_Out => OPEN,
        out_enable_memory_Out => OPEN,
        swap_enable_memory_Out => OPEN,
        MEM_read_out => OPEN

    );
    -- Instance of INT_Operator component
    INT_Operator_Instance : INT_Operator
    PORT MAP(
        Clk => OPEN,
        Rst => OPEN,
        INT => OPEN,
        JUMP_EN => OPEN,
        CALL_EN => OPEN,
        JMP_ZERO_DONE => OPEN,
        PC_Address_IN => OPEN,
        Operand1 => OPEN,
        MUX_Selec_INT => OPEN,
        PC_Address_OUT_INT => OPEN,
        Stack_Operation_INT => OPEN,
        MEM_WRITE_INT => OPEN,
        MEM_ADD_Selec_INT => OPEN,
        UPDATE_PC_INT => OPEN,
        PC_Disable => OPEN,
        FD_Stall => OPEN
    );

    -- Instance of RTI_Operator component
    RTI_Operator_Instance : RTI_Operator
    PORT MAP(
        Clk => OPEN,
        Rst => OPEN,
        RTI_BEGIN => OPEN,
        Stack_Operation_RTI => OPEN,
        RTI_PC_UPDATE => OPEN,
        MEM_ADD_MUX_RTI_Selec => OPEN,
        CCR_Selector => OPEN,
        PC_Disable => OPEN,
        FD_Stall => OPEN
    );

    -- Instantiation of Hazard_DU
    Hazard_DU_Instance : Hazard_DU
    PORT MAP(
        MEM_Read => OPEN,
        Write_ADD_Execute => OPEN,
        R_Source1_Decode => OPEN,
        R_Source2_Decode => OPEN,
        STALL => OPEN,
        PC_Disable => OPEN,
        LoadUse_RST => OPEN
    );

    -- Instantiation of Forwarding_Unit
    Forwarding_Unit_Instance : Forwarding_Unit
    PORT MAP(
        Read_Add1_Execute_Stage => OPEN,
        Read_Add2_Execute_Stage => OPEN,
        Write_Add1_Memory_Stage => OPEN,
        Write_Add2_Memory_Stage => OPEN,
        Write_Add1_WB_Stage => OPEN,
        Write_Add2_WB_Stage => OPEN,
        Write_EN_Memory_Stage => OPEN,
        Swap_EN_Memory_Stage => OPEN,
        Swap_EN_WB_Stage => OPEN,
        Write_EN_WB_Stage => OPEN,
        MEM_Read_Memory_Stage => OPEN,
        MEM_Read_WB_Stage => OPEN,
        OP1_Selec => OPEN,
        OP2_Selec => OPEN
    );

END ARCHITECTURE;