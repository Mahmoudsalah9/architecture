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

    ------------------------------------------------------------------------------ signals ------------------------------------------------------------------------------------------------------------------------------------------------------------

    --Out of Fetch Stage:

    --Out of Fetch/Decode Buffer:

    --Out of Decode Stage:

    --Out of Decode/Execute Buffer:

    --Out of Execute Stage:

    --Out of Execute/Memory Buffer:

    --Out of Memory Stage:

    --Out of Memory/WriteBack Buffer:

    --Out of WriteBack Stage:

    ---------------------------------------------------------------------------- Connections ----------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN

END ARCHITECTURE;