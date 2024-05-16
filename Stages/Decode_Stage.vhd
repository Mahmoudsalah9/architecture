LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Decode_Stage IS
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
END ENTITY;

ARCHITECTURE Decode_Stage_Design OF Decode_Stage IS

    ---------------------------------------------------------------------------  Components  --------------------------------------------------------------------------------

    COMPONENT Control_Unit IS
        PORT (

            --in:
            Instruction_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

            --out:
            RTI_Begin : OUT STD_LOGIC;
            FLUSH : OUT STD_LOGIC;
            PROTECT : OUT STD_LOGIC;
            OUTPORT_Enable : OUT STD_LOGIC;
            SWAP_Enable : OUT STD_LOGIC;
            MEM_Add_Selec : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Readport2 Data,   10 SP
            WB_Selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
            FREE : OUT STD_LOGIC;
            JUMP : OUT STD_LOGIC;
            BRANCH_ZERO : OUT STD_LOGIC;
            WRITE_Enable : OUT STD_LOGIC;
            MEM_Write : OUT STD_LOGIC;
            MEM_Read : OUT STD_LOGIC;
            ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Extend_Sign : OUT STD_LOGIC;
            CALL_Enable : OUT STD_LOGIC;
            INPORT_Enable : OUT STD_LOGIC;
            ALU_SRC : OUT STD_LOGIC;
            CCR_Arithmetic : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            RET_Enable : OUT STD_LOGIC;
            STACK_Operation : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 00 NOP on sp, 01 increment by 2, 10 decrement by 2

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
            Write_Data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Write_Enable1, write_enable2 : IN STD_LOGIC

        );
    END COMPONENT;

    COMPONENT Sign_Extend IS
        PORT (
            Extend_Sign : IN STD_LOGIC;
            Data_16_bits : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data_32_bits : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------
    SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL R_Source1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL R_Source2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL Extend_Sign_Internal : STD_LOGIC;

BEGIN

    -- Instruction Break Down:
    OPCODE <= Instruction(15 DOWNTO 11);
    R_Source1 <= Instruction(10 DOWNTO 8);
    R_Source2 <= Instruction(7 DOWNTO 5);
    Write_Add <= Instruction(4 DOWNTO 2);

    -- Component Mapping:

    Controller_Instance : Control_Unit
    PORT MAP(

        Instruction_OPCODE => OPCODE,
        RTI_Begin => RTI_Begin_OUT,
        FLUSH => FLUSH_OUT,
        PROTECT => PROTECT_OUT,
        OUTPORT_Enable => OUTPORT_Enable_OUT,
        SWAP_Enable => SWAP_Enable_OUT,
        MEM_Add_Selec => MEM_Add_Selec_OUT,
        WB_Selector => WB_Selector_OUT,
        FREE => FREE_OUT,
        JUMP => JUMP_OUT,
        BRANCH_ZERO => BRANCH_ZERO_OUT,
        WRITE_Enable => WRITE_Enable_OUT,
        MEM_Write => MEM_Write_OUT,
        MEM_Read => MEM_Read_OUT,
        ALU_OP => ALU_OP_OUT,
        Extend_Sign => Extend_Sign_Internal,
        CALL_Enable => CALL_Enable_OUT,
        INPORT_Enable => INPORT_Enable_OUT,
        ALU_SRC => ALU_SRC_OUT,
        CCR_Arithmetic => CCR_Arithmetic_OUT,
        RET_Enable => RET_Enable_OUT,
        STACK_Operation => STACK_Operation_OUT

    );

    Register_File_Instance : Register_File
    PORT MAP(

        clk => Clk,
        rst => Rst,
        read_address1 => R_Source1,
        read_address2 => R_Source2,
        read_data1 => Read_Port1_OUT,
        read_data2 => Read_Port2_OUT,
        write_address1 => Write_Add1_WB,
        write_address2 => Write_Add2_WB,
        write_data1 => Write_Data1_WB,
        write_data2 => Write_Data2_WB,
        write_enable1 => Write_Enable1_WB,
        write_enable2 => Write_Enable2_WB

    );

    Sign_Extend_Instance : Sign_Extend
    PORT MAP(

        Extend_Sign => Extend_Sign_Internal,
        Data_16_bits => Immediate_Data_IN,
        Data_32_bits => Immediate_Data_Extended_OUT

    );

    -- OUTPUT Connections:
    PCVALUE_OUT <= PCVALUE_IN;
    Write_Add1_OUT <= Write_Add;
    Write_Add2_R_Source2_OUT <= R_Source2;
    R_Source1_OUT <= R_Source1;

END ARCHITECTURE;