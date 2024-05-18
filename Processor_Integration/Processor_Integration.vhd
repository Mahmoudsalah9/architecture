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
            JMP_Enable_IN : IN STD_LOGIC;
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
            JMP_Enable_OUT : OUT STD_LOGIC;
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
            Memory_Read_IN

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
            Memory_Read_OUT : OUT STD_LOGIC;

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
            STALL : IN STD_LOGIC;
            FLUSH : IN STD_LOGIC;
            LoadUse_RST : IN STD_LOGIC;

            -- IN:
            FLUSH_IN : IN STD_LOGIC;
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
            FLUSH_OUT : OUT STD_LOGIC;
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

            -- Outputs:
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
    SIGNAL FLUSH_DE : STD_LOGIC;
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
    SIGNAL JMP_Enable_EXECUTE : STD_LOGIC;
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
    SIGNAL Mem_READ_MEMORY : STD_LOGIC_VECTOR(2 DOWNTO 0);

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
    SIGNAL MEM_Read_MW : STD_LOGIC;

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
    SIGNAL CCR_Selector_RTI : STD_LOGIC_VECTOR(3 DOWNTO 0);
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
        Clk => Clk,
        Rst => Rst,
        UPDATE_PC_RTI => RTI_PC_UPDATE_RTI,
        UPDATE_PC_INT => UPDATE_PC_INT_INTERUPT,
        RESET => RESET,
        JMP_EN => JMP_Enable_EN,
        RET_EN => Ret_Enable_MEMORY,
        Zero_Flag => Zero_Flag_EXECUTE,
        BRANCH_ZERO => Branch_ZERO_EXECUTE,
        PC_Disable_INT => PC_Disable_INTERUPT,
        PC_Disable_RTI => PC_Disable_RTI,
        PC_Disable_HDU => PC_Disable_Hazard,
        Result_MEM => Result_Mem_MEMORY,
        JMP_DEST => JMP_DEST_EXECUTE,
        JMP_ZERO_DEST => JMPZ_DEST_EXECUTE,
        JMPZ_Done => JMPZ_Done_Fetch,
        PC_Value_OUT => PC_Value_Fetch,
        Instruction_OUT => Instruction_Fetch,
        Data_OUT => Data_Fetch
    );

    -- Instance of Decode_Stage component
    Decode_Stage_Instance : Decode_Stage
    PORT MAP(
        Clk => Clk,
        Rst => Rst,
        Instruction => Instruction_FD,
        Immediate_Data_IN => Data_FD,
        Write_Add1_WB => Write_Add1_WB,
        Write_Add2_WB => Write_Add2_WB,
        Write_Data1_WB => Write_Back_Data1_WB,
        Write_Data2_WB => Write_Back_Data2_WB,
        Write_Enable1_WB => Write_Enable_WB,
        Write_Enable2_WB => Swap_Enable_WB,
        PCVALUE_IN => PC_Value_FD,
        RTI_Begin_OUT => RTI_Begin_DECODE,
        FLUSH_OUT => FLUSH_DECODE,
        PROTECT_OUT => PROTECT_DECODE,
        OUTPORT_Enable_OUT => OUTPORT_Enable_DECODE,
        SWAP_Enable_OUT => SWAP_Enable_DECODE,
        MEM_Add_Selec_OUT => MEM_Add_Selec_DECODE,
        WB_Selector_OUT => WB_Selector_DECODE,
        FREE_OUT => FREE_DECODE,
        JUMP_OUT => JUMP_DECODE,
        BRANCH_ZERO_OUT => BRANCH_ZERO_DECODE,
        WRITE_Enable_OUT => WRITE_Enable_DECODE,
        MEM_Write_OUT => MEM_Write_DECODE,
        MEM_Read_OUT => MEM_Read_DECODE,
        ALU_OP_OUT => ALU_OP_DECODE,
        CALL_Enable_OUT => CALL_Enable_DECODE,
        INPORT_Enable_OUT => INPORT_Enable_DECODE,
        ALU_SRC_OUT => ALU_SRC_DECODE,
        CCR_Arithmetic_OUT => CCR_Arithmetic_DECODE,
        RET_Enable_OUT => RET_Enable_DECODE,
        STACK_Operation_OUT => STACK_Operation_DECODE,
        Write_Add1_OUT => Write_Add1_DECODE,
        Write_Add2_R_Source2_OUT => Write_Add2_R_Source2_DECODE,
        Read_Port1_OUT => Read_Port1_DECODE,
        Read_Port2_OUT => Read_Port2_DECODE,
        Immediate_Data_Extended_OUT => Immediate_Data_Extended_DECODE,
        R_Source1_OUT => R_Source1_DECODE,
        PCVALUE_OUT => PCVALUE_DECODE
    );

    -- Port mapping for Execute_Stage
    Execute_Stage_Instance : Execute_Stage
    PORT MAP(
        Clk => Clk,
        Rst => Rst,

        JMP_Enable_IN => JUMP_DE,
        Branch_ZERO_IN => BRANCH_ZERO_DE,
        Protect_IN => PROTECT_DE,
        Out_Enable_IN => OUTPORT_Enable_DE,
        Swap_Enable_IN => SWAP_Enable_DE,
        Memory_Add_Selec_IN => MEM_Add_Selec_DE,
        Write_Back_Selector_IN => WB_Selector_DE,
        Free_IN => FREE_DE,
        Write_Enable_IN => WRITE_Enable_DE,
        Mem_READ_IN => MEM_Read_DE,
        Mem_Write_IN => MEM_Write_DE,
        ALU_OP_IN => ALU_OP_DE,
        Call_Enable_IN => CALL_Enable_DE,
        INPUT_PORT_ENABLE_IN => INPORT_Enable_DE,
        ALU_SRC_IN => ALU_SRC_DE,
        CCR_Arethmetic_IN => CCR_Arithmetic_DE,
        Stack_Operation_IN => STACK_Operation_DE,
        RET_Enable_IN => RET_Enable_DE,
        ReadPort1_Data => Read_Port1_DE,
        ReadPort2_Data => Read_Port2_DE,
        WriteAdd1_IN => Write_Add1_DE,
        WriteAdd2_IN => Write_Add2_R_Source2_DE,
        Imm_Data_IN => Immediate_Data_Extended_DE,
        R_Source1_IN => R_Source1_DE,
        PC_Value_IN => PCVALUE_DE,
        INPUT_PORT => In_Port,
        Forwarding_UNIT_MUX1_Selec1 => OP1_Selec_Forwarding_Unit,
        Forwarding_UNIT_MUX1_Selec2 => OP2_Selec_Forwarding_Unit,
        Forwarded_Data_ALUtoALU => OPEN,
        Forwarded_Data_MEMtoALU => OPEN,
        Forwarded_Data_SWAPALUtoALU => OPEN,
        Forwarded_Data_SWAPMEMtoALU => OPEN,
        Stack_OP_RTI => Stack_Operation_RTI_RTI,
        Stack_OP_INT => Stack_Operation_INT_INTERUPT,
        CCR_Select => CCR_Selector_RTI,
        Result_Mem => Result_Mem_MEMORY(3 DOWNTO 0),
        -- Outputs
        JMP_Enable_OUT => JMP_Enable_EN,
        Branch_ZERO_OUT => Branch_ZERO_EXECUTE,
        Protect_OUT => Protect_EXECUTE,
        Out_Enable_OUT => Out_Enable_EXECUTE,
        Swap_Enable_OUT => Swap_Enable_EXECUTE,
        Memory_Add_Selec_OUT => Memory_Add_Selec_EXECUTE,
        Write_Back_Selector_OUT => Write_Back_Selector_EXECUTE,
        Free_OUT => Free_EXECUTE,
        Write_Enable_OUT => Write_Enable_EXECUTE,
        Mem_READ_OUT => Mem_READ_EXECUTE,
        Mem_Write_OUT => Mem_Write_EXECUTE,
        Call_Enable_OUT => Call_Enable_EXECUTE,
        RET_Enable_OUT => RET_Enable_EXECUTE,
        Final_Result => Final_Result_EXECUTE,
        Read_Port2_Data_OUT => Read_Port2_Data_EXECUTE,
        WriteAdd1_OUT => WriteAdd1_EXECUTE,
        WriteAdd2_OUT => WriteAdd2_EXECUTE,
        Imm_Data_OUT => Imm_Data_EXECUTE,
        WriteData2_OUT => WriteData2_EXECUTE,
        PC_Value_OUT => PC_Value_EXECUTE,
        SP_OUT_Buffered => SP_OUT_Buffered_EXECUTE,
        SP_OUT_Normal => SP_OUT_Normal_EXECUTE,
        Zero_Flag_OUT => Zero_Flag_EXECUTE,
        JMP_DEST => JMP_DEST_EXECUTE,
        JMPZ_DEST => JMPZ_DEST_EXECUTE,
        CCR_Out => CCR_EXECUTE,
        Forwarded_ReadADD1 => Forwarded_ReadADD1_EXECUTE,
        Forwarded_ReadADD2 => Forwarded_ReadADD2_EXECUTE
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
        clk => Clk,
        Rst => Rst,
        flush => FLUSH_DE,
        stall => STALL_Hazard,
        Instruction_IN => Instruction_Fetch,
        Data_in => Data_Fetch,
        PC_Value_IN => PC_Value_Fetch,
        Instruction_OUT => Instruction_FD,
        Data_OUT => Data_FD,
        PC_Value_OUT => PC_Value_FD
    );

    -- Instance of Decode_Execute component
    Decode_Execute_Instance : Decode_Execute
    PORT MAP(
        Clk => Clk,
        Rst => Rst,
        FLUSH => FLUSH_DE,
        FLUSH_IN => FLUSH_DECODE,
        LoadUse_RST => LoadUse_RST_Hazard,
        PROTECT_IN => PROTECT_DECODE,
        OUTPORT_Enable_IN => OUTPORT_Enable_DECODE,
        SWAP_Enable_IN => SWAP_Enable_DECODE,
        MEM_Add_Selec_IN => MEM_Add_Selec_DECODE,
        WB_Selector_IN => WB_Selector_DECODE,
        FREE_IN => FREE_DECODE,
        JUMP_IN => JUMP_DECODE,
        BRANCH_ZERO_IN => BRANCH_ZERO_DECODE,
        WRITE_Enable_IN => WRITE_Enable_DECODE,
        MEM_Write_IN => MEM_Write_DECODE,
        MEM_Read_IN => MEM_Read_DECODE,
        ALU_OP_IN => ALU_OP_DECODE,
        CALL_Enable_IN => CALL_Enable_DECODE,
        INPORT_Enable_IN => INPORT_Enable_DECODE,
        ALU_SRC_IN => ALU_SRC_DECODE,
        CCR_Arithmetic_IN => CCR_Arithmetic_DECODE,
        RET_Enable_IN => RET_Enable_DECODE,
        STACK_Operation_IN => STACK_Operation_DECODE,
        Write_Add1_IN => Write_Add1_DECODE,
        Write_Add2_R_Source2_IN => Write_Add2_R_Source2_DECODE,
        Read_Port1_IN => Read_Port1_DECODE,
        Read_Port2_IN => Read_Port2_DECODE,
        Immediate_Data_Extended_IN => Immediate_Data_Extended_DECODE,
        R_Source1_IN => R_Source1_DECODE,
        PCVALUE_IN => PCVALUE_DECODE,
        FLUSH_OUT => FLUSH_DE,
        PROTECT_OUT => PROTECT_DE,
        OUTPORT_Enable_OUT => OUTPORT_Enable_DE,
        SWAP_Enable_OUT => SWAP_Enable_DE,
        MEM_Add_Selec_OUT => MEM_Add_Selec_DE,
        WB_Selector_OUT => WB_Selector_DE,
        FREE_OUT => FREE_DE,
        JUMP_OUT => JUMP_DE,
        BRANCH_ZERO_OUT => BRANCH_ZERO_DE,
        WRITE_Enable_OUT => WRITE_Enable_DE,
        MEM_Write_OUT => MEM_Write_DE,
        MEM_Read_OUT => MEM_Read_DE,
        ALU_OP_OUT => ALU_OP_DE,
        CALL_Enable_OUT => CALL_Enable_DE,
        INPORT_Enable_OUT => INPORT_Enable_DE,
        ALU_SRC_OUT => ALU_SRC_DE,
        CCR_Arithmetic_OUT => CCR_Arithmetic_DE,
        RET_Enable_OUT => RET_Enable_DE,
        STACK_Operation_OUT => STACK_Operation_DE,
        Write_Add1_OUT => Write_Add1_DE,
        Write_Add2_R_Source2_OUT => Write_Add2_R_Source2_DE,
        Read_Port1_OUT => Read_Port1_DE,
        Read_Port2_OUT => Read_Port2_DE,
        Immediate_Data_Extended_OUT => Immediate_Data_Extended_DE,
        R_Source1_OUT => R_Source1_DE,
        PCVALUE_OUT => PCVALUE_DE
    );

    Execute_Memory_Instance : Execute_Memory
    PORT MAP(
        clk => Clk,
        Rst => Rst,
        -- Inputs:
        Protect_IN => Protect_EXECUTE,
        Out_Enable_IN => Out_Enable_EXECUTE,
        Swap_Enable_IN => Swap_Enable_EXECUTE,
        Memory_Add_Selec_IN => Memory_Add_Selec_EXECUTE,
        Write_Back_Selector_IN => Write_Back_Selector_EXECUTE,
        Free_IN => Free_EXECUTE,
        Write_Enable_IN => Write_Enable_EXECUTE,
        Mem_READ_IN => Mem_READ_EXECUTE,
        Mem_Write_IN => Mem_Write_EXECUTE,
        Call_Enable_IN => Call_Enable_EXECUTE,
        RET_Enable_IN => RET_Enable_EXECUTE,
        Final_Result_IN => Final_Result_EXECUTE,
        Read_Port2_Data_IN => Read_Port2_Data_EXECUTE,
        WriteAdd1_IN => WriteAdd1_EXECUTE,
        WriteAdd2_IN => WriteAdd2_EXECUTE,
        Imm_Data_IN => Imm_Data_EXECUTE,
        WriteData2_IN => WriteData2_EXECUTE,
        PC_Value_IN => PC_Value_EXECUTE,
        SP_IN_Buffered => SP_OUT_Buffered_EXECUTE,
        -- Outputs:
        Protect_OUT => Protect_EM,
        Out_Enable_OUT => Out_Enable_EM,
        Swap_Enable_OUT => Swap_Enable_EM,
        Memory_Add_Selec_OUT => Memory_Add_Selec_EM,
        Write_Back_Selector_OUT => Write_Back_Selector_EM,
        Free_OUT => Free_EM,
        Write_Enable_OUT => Write_Enable_EM,
        Mem_READ_OUT => Mem_READ_EM,
        Mem_Write_OUT => Mem_Write_EM,
        Call_Enable_OUT => Call_Enable_EM,
        RET_Enable_OUT => RET_Enable_EM,
        Final_Result => Final_Result_EM,
        Read_Port2_Data_OUT => Read_Port2_Data_EM,
        WriteAdd1_OUT => WriteAdd1_EM,
        WriteAdd2_OUT => WriteAdd2_EM,
        Imm_Data_OUT => Imm_Data_EM,
        WriteData2_OUT => WriteData2_EM,
        PC_Value_OUT => PC_Value_EM,
        SP_OUT_Buffered => SP_OUT_Buffered_EM
    );

    -- Port mapping for Memory_Stage
    Memory_Stage_Instance : Memory_Stage
    PORT MAP(
        CLK => CLK,
        RST => RST,
        Protect => Protect_EM,
        OutPort_Enable_in => Out_Enable_EM,
        Swap_Enable_in => Swap_Enable_EM,
        Mem_Add_selector => Memory_Add_Selec_EM,
        WB_Selector_in => Write_Back_Selector_EM,
        Free => Free_EM,
        Write_Enable_in => Write_Enable_EM,
        Mem_Write_enable => Mem_Write_EM,
        Mem_Write_INT_FSM => MEM_WRITE_INT_INTERUPT,
        Ret_Enable_In => RET_Enable_EM,
        Write_Data_Selector => Call_Enable_EM,
        Mux_Select_INT_FSM => MUX_Selec_INT_INTERUPT,
        CCR_Out => CCR_EXECUTE,
        PC_Address_INT_OUT => PC_Address_OUT_INT_INTERUPT,
        Read_port2_data_in => Read_Port2_Data_EM,
        PC_Value => PC_Value_EM,
        Alu_result_in => Final_Result_EM,
        SP => OPEN,
        Write_Add_1_in => WriteAdd1_EM,
        Write_Add_2_in => WriteAdd2_EM,
        Immediate_data_in => Imm_Data_EM,
        Write_Data2_in => WriteData2_EM,
        MEM_Add_MUX_RTI_Select => MEM_ADD_MUX_RTI_Selec_RTI,
        MEM_Add_MUX_INT_Select => MEM_ADD_Selec_INT_INTERUPT,
        MEM_read_in => Mem_READ_EM,
        -- Outputs
        Ret_Enable_Out => Ret_Enable_MEMORY,
        OutPort_Enable_out => OutPort_Enable_MEMORY,
        Swap_Enable_out => Swap_Enable_MEMORY,
        WB_Selector_out => WB_Selector_MEMORY,
        Write_Enable_out => Write_Enable_MEMORY,
        Result_Mem => Result_Mem_MEMORY,
        Protected_To_Exception => Protected_To_Exception_MEMORY,
        Read_port2_data_out => Read_port2_data_MEMORY,
        Alu_result_out => Alu_result_MEMORY,
        Write_Add_1_out => Write_Add_1_MEMORY,
        Immediate_data_out => Immediate_data_MEMORY,
        Write_Data2_out => Write_Data2_MEMORY,
        Write_Add_2_out => Write_Add_2_MEMORY,
        MEM_read_out => Mem_READ_MEMORY
    );

    U_Memory_WriteBack : Memory_WriteBack
    PORT MAP(

        clk => Clk,
        reset => Rst,
        result_mem => Result_Mem_MEMORY,
        read_port2_memory => Read_port2_data_MEMORY,
        Write_data_memory => OPEN,
        result_alu_memory => Alu_result_MEMORY,
        immediate_data_memory => Immediate_data_MEMORY,
        write_add1_memory => Write_Add_1_MEMORY,
        write_add2_memory => Write_Add_2_MEMORY,
        write_enable_memory => Write_Enable_MEMORY,
        wb_selector_memory => WB_Selector_MEMORY,
        out_enable_memory => OutPort_Enable_MEMORY,
        swap_enable_memory => Swap_Enable_MEMORY,
        Write_Data2_in => Write_Data2_MEMORY,
        MEM_read_in => Mem_READ_MEMORY,

        result_mem_out => Result_Mem_MW,
        read_port2_memory_out => Read_Port2_Memory_MW,
        result_alu_memory_out => Result_ALU_Memory_MW,
        immediate_data_memory_out => Immediate_Data_Memory_MW,
        Write_Data2_Out => Write_Data2_MW,
        write_add1_memory_out => Write_Add1_Memory_MW,
        write_add2_memory_out => Write_Add2_Memory_MW,
        wb_selector_memory_out => WB_Selector_Memory_MW,
        write_enable_memory_Out => Write_Enable_Memory_MW,
        out_enable_memory_Out => Out_Enable_Memory_MW,
        swap_enable_memory_Out => Swap_Enable_Memory_MW,
        MEM_read_out => MEM_Read_MW

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