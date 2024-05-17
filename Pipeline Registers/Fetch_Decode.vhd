LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch_Decode IS
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
END ENTITY;

ARCHITECTURE Fetch_Decode_Design OF Fetch_Decode IS

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

    -- Internal signals for storing output values
    SIGNAL Instruction_ff : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_ff : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PC_Value_ff : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ENABLE_Final : STD_LOGIC;

BEGIN

    Instruction_ff <= Instruction_IN WHEN flush = '0' ELSE
        (OTHERS => '0');
    Data_ff <= Data_in WHEN flush = '0' ELSE
        (OTHERS => '0');
    PC_Value_ff <= PC_Value_IN WHEN flush = '0' ELSE
        (OTHERS => '0');

    ENABLE_Final <= '0' WHEN stall = '1' ELSE
        '1';

    -- Instantiating flip-flops for output storage
    Inst_Instruction_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 16)
    PORT MAP(
        d => Instruction_ff,
        clk => clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Instruction_OUT
    );

    Inst_Data_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 16)
    PORT MAP(
        d => Data_ff,
        clk => clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => Data_OUT
    );

    Inst_PC_Value_OUT_FF : FLIPFLOP GENERIC MAP(DATA_WIDTH => 32)
    PORT MAP(
        d => PC_Value_ff,
        clk => clk,
        rst => Rst,
        EN => ENABLE_Final,
        q => PC_Value_OUT
    );

END ARCHITECTURE;