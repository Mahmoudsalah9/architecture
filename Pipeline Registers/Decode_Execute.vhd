LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Decode_Execute IS

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

END ENTITY;

ARCHITECTURE Decode_Execute_Design OF Decode_Execute IS

BEGIN

    PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN

            -- Reset all outputs to '0'
            PROTECT_OUT <= '0';
            OUTPORT_Enable_OUT <= '0';
            SWAP_Enable_OUT <= '0';
            MEM_Add_Selec_OUT <= (OTHERS => '0');
            WB_Selector_OUT <= (OTHERS => '0');
            FREE_OUT <= '0';
            JUMP_OUT <= '0';
            BRANCH_ZERO_OUT <= '0';
            WRITE_Enable_OUT <= '0';
            MEM_Write_OUT <= '0';
            MEM_Read_OUT <= '0';
            ALU_OP_OUT <= (OTHERS => '0');
            CALL_Enable_OUT <= '0';
            INPORT_Enable_OUT <= '0';
            ALU_SRC_OUT <= '0';
            CCR_Arithmetic_OUT <= (OTHERS => '0');
            RET_Enable_OUT <= '0';
            STACK_Operation_OUT <= (OTHERS => '0');
            Write_Add1_OUT <= (OTHERS => '0');
            Write_Add2_R_Source2_OUT <= (OTHERS => '0');
            Read_Port1_OUT <= (OTHERS => '0');
            Read_Port2_OUT <= (OTHERS => '0');
            Immediate_Data_Extended_OUT <= (OTHERS => '0');
            R_Source1_OUT <= (OTHERS => '0');
            PCVALUE_OUT <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            IF FLUSH = '1' THEN

                PROTECT_OUT <= '0';
                OUTPORT_Enable_OUT <= '0';
                SWAP_Enable_OUT <= '0';
                MEM_Add_Selec_OUT <= (OTHERS => '0');
                WB_Selector_OUT <= (OTHERS => '0');
                FREE_OUT <= '0';
                JUMP_OUT <= '0';
                BRANCH_ZERO_OUT <= '0';
                WRITE_Enable_OUT <= '0';
                MEM_Write_OUT <= '0';
                MEM_Read_OUT <= '0';
                ALU_OP_OUT <= (OTHERS => '0');
                CALL_Enable_OUT <= '0';
                INPORT_Enable_OUT <= '0';
                ALU_SRC_OUT <= '0';
                CCR_Arithmetic_OUT <= (OTHERS => '0');
                RET_Enable_OUT <= '0';
                STACK_Operation_OUT <= (OTHERS => '0');
                Write_Add1_OUT <= (OTHERS => '0');
                Write_Add2_R_Source2_OUT <= (OTHERS => '0');
                Read_Port1_OUT <= (OTHERS => '0');
                Read_Port2_OUT <= (OTHERS => '0');
                Immediate_Data_Extended_OUT <= (OTHERS => '0');
                R_Source1_OUT <= (OTHERS => '0');
                PCVALUE_OUT <= (OTHERS => '0');

            ELSE

                PROTECT_OUT <= PROTECT_IN;
                OUTPORT_Enable_OUT <= OUTPORT_Enable_IN;
                SWAP_Enable_OUT <= SWAP_Enable_IN;
                MEM_Add_Selec_OUT <= MEM_Add_Selec_IN;
                WB_Selector_OUT <= WB_Selector_IN;
                FREE_OUT <= FREE_IN;
                JUMP_OUT <= JUMP_IN;
                BRANCH_ZERO_OUT <= BRANCH_ZERO_IN;
                WRITE_Enable_OUT <= WRITE_Enable_IN;
                MEM_Write_OUT <= MEM_Write_IN;
                MEM_Read_OUT <= MEM_Read_IN;
                ALU_OP_OUT <= ALU_OP_IN;
                CALL_Enable_OUT <= CALL_Enable_IN;
                INPORT_Enable_OUT <= INPORT_Enable_IN;
                ALU_SRC_OUT <= ALU_SRC_IN;
                CCR_Arithmetic_OUT <= CCR_Arithmetic_IN;
                RET_Enable_OUT <= RET_Enable_IN;
                STACK_Operation_OUT <= STACK_Operation_IN;
                Write_Add1_OUT <= Write_Add1_IN;
                Write_Add2_R_Source2_OUT <= Write_Add2_R_Source2_IN;
                Read_Port1_OUT <= Read_Port1_IN;
                Read_Port2_OUT <= Read_Port2_IN;
                Immediate_Data_Extended_OUT <= Immediate_Data_Extended_IN;
                R_Source1_OUT <= R_Source1_IN;
                PCVALUE_OUT <= PCVALUE_IN;

            END IF;

        END IF;

    END PROCESS;

END ARCHITECTURE;