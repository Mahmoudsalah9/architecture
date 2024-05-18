LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Execute_Stage IS
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
        Forwarded_ReadADD2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        OP1_to_INT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE Execute_Stage_Design OF Execute_Stage IS

    COMPONENT ALU IS
        GENERIC (
            N : INTEGER := 32 -- Default bit width
        );
        PORT (
            reg1_in : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            reg2_in : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            opcode_in : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
            flag_reg_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            Write_Data_2 : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Stack_Pointer_Circuit IS
        PORT (
            Clk : IN STD_LOGIC;
            Rst : IN STD_LOGIC;
            Stack_Operation_Controller : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Stack_Operation_RTI : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Stack_Operation_INT : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

            SP_Value_Out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT CCR_Reg IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            CCR_input_from_alu, Result_MEM, CCR_Arithmetic, CCR_Select : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            CCR_output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT CCR_Reg;

    COMPONENT Mux5x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3, in4 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT Mux5x1;

    COMPONENT Mux2x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Forward_MUX_OUTPUT1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Forward_MUX_OUTPUT2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_Oprand2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_RESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP_Wire : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Flags_Wire_FromALU : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Flags_Wire_IntoCCR : STD_LOGIC_VECTOR(3 DOWNTO 0);
    Signal CCR_O_WIRE : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- Instantiate ALU
    ALU_inst : ALU
    GENERIC MAP(
        N => 32 -- Default bit width
    )
    PORT MAP(
        reg1_in => Forward_MUX_OUTPUT1,
        reg2_in => ALU_Oprand2,
        opcode_in => ALU_OP_IN,
        flag_reg_out => Flags_Wire_FromALU,
        data_out => ALU_RESULT,
        Write_Data_2 => WriteData2_OUT
    );

    -- Instantiate Stack_Pointer_Circuit
    Stack_Pointer_Circuit_inst : Stack_Pointer_Circuit
    PORT MAP(
        Clk => Clk,
        Rst => Rst,
        Stack_Operation_Controller => Stack_Operation_IN,
        Stack_Operation_RTI => Stack_OP_RTI,
        Stack_Operation_INT => Stack_OP_INT,
        SP_Value_Out => SP_Wire
    );

    -- Instantiate CCR_Reg
    CCR_Reg_inst : CCR_Reg
    PORT MAP(
        Clk => Clk,
        Rst => Rst,
        CCR_input_from_alu => Flags_Wire_IntoCCR,
        Result_MEM => Result_Mem,
        CCR_Arithmetic => CCR_Arethmetic_IN,
        CCR_Select => CCR_Select,
        CCR_output => CCR_O_WIRE
    );

    -- Instantiate two Mux5x1
    Mux5x1_1_inst : Mux5x1
    GENERIC MAP(
        n => 32
    )
    PORT MAP(
        in0 => ReadPort1_Data,
        in1 => Forwarded_Data_MEMtoALU,
        in2 => Forwarded_Data_SWAPALUtoALU,
        in3 => Forwarded_Data_ALUtoALU,
        in4 => Forwarded_Data_SWAPMEMtoALU,
        sel => Forwarding_UNIT_MUX1_Selec1,
        MUX_Out => Forward_MUX_OUTPUT1
    );
    Mux5x1_2_inst : Mux5x1
    GENERIC MAP(
        n => 32
    )
    PORT MAP(
        in0 => ReadPort2_Data,
        in1 => Forwarded_Data_MEMtoALU,
        in2 => Forwarded_Data_SWAPALUtoALU,
        in3 => Forwarded_Data_ALUtoALU,
        in4 => Forwarded_Data_SWAPMEMtoALU,
        sel => Forwarding_UNIT_MUX1_Selec2,
        MUX_Out => Forward_MUX_OUTPUT2
    );

    -- Instantiate Mux2x1
    Mux2x1_inst_1 : Mux2x1
    GENERIC MAP(
        n => 32
    )
    PORT MAP(
        in0 => Forward_MUX_OUTPUT2,
        in1 => Imm_Data_IN,
        sel => ALU_SRC_IN,
        MUX_Out => ALU_Oprand2
    );

    Mux2x1_inst_2 : Mux2x1
    GENERIC MAP(
        n => 32
    )
    PORT MAP(
        in0 => ALU_RESULT,
        in1 => INPUT_PORT,
        sel => INPUT_PORT_ENABLE_IN,
        MUX_Out => Final_Result
    );

    Flags_Wire_IntoCCR(3 DOWNTO 1) <= Flags_Wire_FromALU(3 DOWNTO 1);
    Flags_Wire_IntoCCR(0) <= Flags_Wire_FromALU(0) AND (NOT Branch_ZERO_IN);

    SP_OUT_Buffered <= SP_Wire;
    SP_OUT_Normal <= SP_Wire;

    Branch_ZERO_OUT <= Branch_ZERO_In;
    Protect_OUT <= Protect_In;
    Out_Enable_OUT <= Out_Enable_IN;
    Swap_Enable_OUT <= Swap_Enable_IN;
    Memory_Add_Selec_OUT <= Memory_Add_Selec_In;
    Write_Back_Selector_OUT <= Write_Back_Selector_IN;
    Free_OUT <= Free_IN;
    Write_Enable_OUT <= Write_Enable_IN;
    Mem_READ_OUT <= Mem_READ_IN;
    Mem_Write_OUT <= Mem_Write_IN;
    Call_Enable_OUT <= Call_Enable_IN;
    RET_Enable_OUT <= RET_Enable_IN;
    WriteAdd1_OUT <= WriteAdd1_IN;
    Imm_Data_OUT <= Imm_Data_IN;
    WriteAdd2_OUT <= WriteAdd2_IN;
    PC_Value_OUT <= PC_Value_In;

    Forwarded_ReadADD1 <= R_Source1_IN;
    Forwarded_ReadADD2 <= WriteAdd2_IN;

    JMP_DEST <= Forward_MUX_OUTPUT1;
    JMPZ_DEST <= Forward_MUX_OUTPUT1;

    CCR_Out <= CCR_O_WIRE;
    Zero_Flag_OUT <= CCR_O_WIRE(0); 
    OP1_to_INT<=Forward_MUX_OUTPUT1;

END ARCHITECTURE;