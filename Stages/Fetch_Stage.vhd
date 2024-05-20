LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Fetch_Stage IS
    PORT (

        Clk : IN STD_LOGIC;
        RESET : IN STD_LOGIC;

        --in:
        UPDATE_PC_RTI : IN STD_LOGIC;
        UPDATE_PC_INT : IN STD_LOGIC;
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
END ENTITY;

ARCHITECTURE Fetch_Stage_Design OF Fetch_Stage IS

    --------------------------------------------------------------------------  Components  --------------------------------------------------------------------------------

    COMPONENT Mux4x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Instruction_Memory IS
        PORT (
            CLK, Rst : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            M10 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            M32 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT pc_value_decoder IS
        PORT (
            jmp_destination, result_memory, M10, M32, jmp_zero_destination, PC_INC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            JMP_Z_Done, update_pc_rti, update_pc_int, reset, ret_enable, jump_enable : IN STD_LOGIC;
            address_pc_decoder_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Program_Counter IS
        PORT (
            clk : IN STD_LOGIC;
            pc_adress_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc_address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT my_nadder IS
        GENERIC (n : INTEGER := 32);
        PORT (
            a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT Data_Control IS
        PORT (
            data_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            CONTROL_BIT : OUT STD_LOGIC
        );
    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

    SIGNAL PC_INPUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_Address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Incremental_MUX_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Incremental_MUX_SEL : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL M10_WIRE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M32_WIRE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Adder_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Instruction_Wire : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Control_Bit_Wire : STD_LOGIC;
    SIGNAL JMP_ZERO_WIRE : STD_LOGIC;
    SIGNAL PC_Address_Extended : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    JMP_ZERO_WIRE <= BRANCH_ZERO AND Zero_Flag;
    Incremental_MUX_SEL(1) <= PC_Disable_RTI OR PC_Disable_INT OR PC_Disable_HDU;
    Incremental_MUX_SEL(0) <= Control_Bit_Wire;
    PC_Address_Extended(31 DOWNTO 12) <= (OTHERS => '0');
    PC_Address_Extended(11 DOWNTO 0) <= PC_Address;

    -- Instance of Mux4x1
    Incremental_MUX : Mux4x1
    GENERIC MAP(32)
    PORT MAP(
        in0 => "00000000000000000000000000000001",
        in1 => "00000000000000000000000000000010",
        in2 => "00000000000000000000000000000000",
        in3 => "00000000000000000000000000000000",
        sel => Incremental_MUX_SEL,
        MUX_Out => Incremental_MUX_OUT
    );

    -- Instance of Instruction_Memory
    Instruction_Memory_Instance : Instruction_Memory
    PORT MAP(

        CLK => Clk,
        Rst => RESET,
        address => PC_Address,
        data => Data_OUT,
        M10 => M10_WIRE,
        M32 => M32_WIRE,
        Instruction => Instruction_Wire
    );

    -- Instance of Data_Control
    Data_Control_Instance : Data_Control
    PORT MAP(

        data_IN => Instruction_Wire(15 DOWNTO 11),
        CONTROL_BIT => Control_Bit_Wire

    );

    -- Instance of pc_value_decoder
    pc_value_decoder_Instance : pc_value_decoder
    PORT MAP(

        jmp_destination => JMP_DEST,
        result_memory => Result_MEM,
        M10 => M10_WIRE,
        M32 => M32_WIRE,
        jmp_zero_destination => JMP_ZERO_DEST,
        PC_INC => Adder_OUT,
        JMP_Z_Done => JMP_ZERO_WIRE,
        update_pc_rti => UPDATE_PC_RTI,
        update_pc_int => UPDATE_PC_INT,
        reset => RESET,
        ret_enable => RET_EN,
        jump_enable => JMP_EN,
        address_pc_decoder_value => PC_INPUT

    );

    -- Instance of Program_Counter
    Program_Counter_Instance : Program_Counter
    PORT MAP(
        clk => Clk,
        pc_adress_in => PC_INPUT,
        pc_address => PC_Address
    );

    -- Instance of my_nadder
    PC_Adder : my_nadder
    GENERIC MAP(32)
    PORT MAP(

        a => PC_Address_Extended,
        b => Incremental_MUX_OUT,
        cin => '0',
        s => Adder_OUT

    );

    JMPZ_Done <= JMP_ZERO_WIRE;
    PC_Value_OUT <= Adder_OUT;
    Instruction_OUT <= Instruction_Wire;

END ARCHITECTURE;