LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Decode_Execute IS

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

END ENTITY;

ARCHITECTURE Decode_Execute_Design OF Decode_Execute IS

    COMPONENT FLIPFLOP IS
        GENERIC (
            DATA_WIDTH : INTEGER := 32
        );
        PORT (
            d : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            clk, rst, EN : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT FLIPFLOP1BIT IS
        PORT (
            d, clk, rst, EN : IN STD_LOGIC;
            q : OUT STD_LOGIC);
    END COMPONENT;

    -- Internal signals for storing output values
    SIGNAL FLUSH_ff : STD_LOGIC;
    SIGNAL PROTECT_ff : STD_LOGIC;
    SIGNAL OUTPORT_Enable_ff : STD_LOGIC;
    SIGNAL SWAP_Enable_ff : STD_LOGIC;
    SIGNAL MEM_Add_Selec_ff : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_Selector_ff : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL FREE_ff : STD_LOGIC;
    SIGNAL JUMP_ff : STD_LOGIC;
    SIGNAL BRANCH_ZERO_ff : STD_LOGIC;
    SIGNAL WRITE_Enable_ff : STD_LOGIC;
    SIGNAL MEM_Write_ff : STD_LOGIC;
    SIGNAL MEM_Read_ff : STD_LOGIC;
    SIGNAL ALU_OP_ff : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL CALL_Enable_ff : STD_LOGIC;
    SIGNAL INPORT_Enable_ff : STD_LOGIC;
    SIGNAL ALU_SRC_ff : STD_LOGIC;
    SIGNAL CCR_Arithmetic_ff : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL RET_Enable_ff : STD_LOGIC;
    SIGNAL STACK_Operation_ff : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Write_Add1_ff : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_R_Source2_ff : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Read_Port1_ff : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_ff : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Immediate_Data_Extended_ff : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL R_Source1_ff : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PCVALUE_ff : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL ENABLE_Final : STD_LOGIC;

BEGIN

    FLUSH_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        PROTECT_IN;
    PROTECT_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        PROTECT_IN;
    OUTPORT_Enable_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        OUTPORT_Enable_IN;
    SWAP_Enable_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        SWAP_Enable_IN;
    MEM_Add_Selec_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        MEM_Add_Selec_IN;
    WB_Selector_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        WB_Selector_IN;
    FREE_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        FREE_IN;
    JUMP_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        JUMP_IN;
    BRANCH_ZERO_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        BRANCH_ZERO_IN;
    WRITE_Enable_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        WRITE_Enable_IN;
    MEM_Write_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        MEM_Write_IN;
    MEM_Read_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        MEM_Read_IN;
    ALU_OP_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        ALU_OP_IN;
    CALL_Enable_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        CALL_Enable_IN;
    INPORT_Enable_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        INPORT_Enable_IN;
    ALU_SRC_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        ALU_SRC_IN;
    CCR_Arithmetic_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        CCR_Arithmetic_IN;
    RET_Enable_ff <= '0' WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        RET_Enable_IN;
    STACK_Operation_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        STACK_Operation_IN;
    Write_Add1_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        Write_Add1_IN;
    Write_Add2_R_Source2_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        Write_Add2_R_Source2_IN;
    Read_Port1_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        Read_Port1_IN;
    Read_Port2_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        Read_Port2_IN;
    Immediate_Data_Extended_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        Immediate_Data_Extended_IN;
    R_Source1_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        R_Source1_IN;
    PCVALUE_ff <= (OTHERS => '0') WHEN FLUSH = '1' OR LoadUse_RST = '1' ELSE
        PCVALUE_IN;
    ENABLE_Final <= '0' WHEN STALL = '1' ELSE
        '1';

    -- Instantiating flip-flops for output storage
    -- FLUSH_Out
    Inst_FLUSH_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => FLUSH_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => FLUSH_OUT
    );

    -- PROTECT_OUT
    Inst_PROTECT_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => PROTECT_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => PROTECT_OUT
    );

    -- OUTPORT_Enable_OUT
    Inst_OUTPORT_Enable_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => OUTPORT_Enable_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => OUTPORT_Enable_OUT
    );

    -- SWAP_Enable_OUT
    Inst_SWAP_Enable_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => SWAP_Enable_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => SWAP_Enable_OUT
    );

    -- MEM_Add_Selec_OUT
    Inst_MEM_Add_Selec_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 2)
    PORT MAP(
        d => MEM_Add_Selec_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => MEM_Add_Selec_OUT
    );

    -- WB_Selector_OUT
    Inst_WB_Selector_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 2)
    PORT MAP(
        d => WB_Selector_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => WB_Selector_OUT
    );

    -- FREE_OUT
    Inst_FREE_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => FREE_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => FREE_OUT
    );

    -- JUMP_OUT
    Inst_JUMP_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => JUMP_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => JUMP_OUT
    );

    -- BRANCH_ZERO_OUT
    Inst_BRANCH_ZERO_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => BRANCH_ZERO_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => BRANCH_ZERO_OUT
    );

    -- WRITE_Enable_OUT
    Inst_WRITE_Enable_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => WRITE_Enable_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => WRITE_Enable_OUT
    );

    -- MEM_Write_OUT
    Inst_MEM_Write_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => MEM_Write_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => MEM_Write_OUT
    );

    -- MEM_Read_OUT
    Inst_MEM_Read_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => MEM_Read_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => MEM_Read_OUT
    );

    -- ALU_OP_OUT
    Inst_ALU_OP_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 5)
    PORT MAP(
        d => ALU_OP_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => ALU_OP_OUT
    );

    -- CALL_Enable_OUT
    Inst_CALL_Enable_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => CALL_Enable_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => CALL_Enable_OUT
    );

    -- INPORT_Enable_OUT
    Inst_INPORT_Enable_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => INPORT_Enable_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => INPORT_Enable_OUT
    );

    -- ALU_SRC_OUT
    Inst_ALU_SRC_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => ALU_SRC_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => ALU_SRC_OUT
    );

    -- CCR_Arithmetic_OUT
    Inst_CCR_Arithmetic_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 4)
    PORT MAP(
        d => CCR_Arithmetic_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => CCR_Arithmetic_OUT
    );

    -- RET_Enable_OUT
    Inst_RET_Enable_OUT_FF : FLIPFLOP1BIT
    PORT MAP(
        d => RET_Enable_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => RET_Enable_OUT
    );

    -- STACK_Operation_OUT
    Inst_STACK_Operation_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 2)
    PORT MAP(
        d => STACK_Operation_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => STACK_Operation_OUT
    );

    -- Write_Add1_OUT
    Inst_Write_Add1_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 3)
    PORT MAP(
        d => Write_Add1_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Write_Add1_OUT
    );

    -- Write_Add2_R_Source2_OUT
    Inst_Write_Add2_R_Source2_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 3)
    PORT MAP(
        d => Write_Add2_R_Source2_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Write_Add2_R_Source2_OUT
    );

    -- Read_Port1_OUT
    Inst_Read_Port1_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 32)
    PORT MAP(
        d => Read_Port1_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Read_Port1_OUT
    );

    -- Read_Port2_OUT
    Inst_Read_Port2_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 32)
    PORT MAP(
        d => Read_Port2_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Read_Port2_OUT
    );

    -- Immediate_Data_Extended_OUT
    Inst_Immediate_Data_Extended_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 32)
    PORT MAP(
        d => Immediate_Data_Extended_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Immediate_Data_Extended_OUT
    );

    -- R_Source1_OUT
    Inst_R_Source1_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 3)
    PORT MAP(
        d => R_Source1_ff,
        clk => Clk,
        rst =>
        Rst,
        EN => ENABLE_Final,
        q => R_Source1_OUT
    );

    -- PCVALUE_OUT
    Inst_PCVALUE_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 12)
    PORT MAP(
        d => PCVALUE_ff,
        clk => Clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => PCVALUE_OUT
    );

    -- Repeat instantiation for other output signals...

END ARCHITECTURE;