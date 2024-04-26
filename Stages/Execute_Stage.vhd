LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Execute_Stage IS
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
        CCR_Enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

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
END ENTITY;

ARCHITECTURE Execute_Stage_Design OF Execute_Stage IS

    COMPONENT ALU IS
        GENERIC (
            N : INTEGER := 32 -- Default bit width
        );
        PORT (
            reg1_in : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            reg2_in : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            opcode_in : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- z n c o
            flag_reg_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            Write_Data_2 : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Sign_Extend IS
        PORT (
            Extend_Sign : IN STD_LOGIC;
            Data_16_bits : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data_32_bits : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Mux2x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Mux4x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT CCR_Reg IS

        PORT (
            Clk, Rst : IN STD_LOGIC;
            CCR, CCR_Enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );

    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

    SIGNAL Extended_Imm : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --ALU signals
    SIGNAL Oprand2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Flags : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    Write_Enable_out <= Write_Enable;
    Mem_Write_out <= Mem_Write;
    OutPort_Enable_out <= OutPort_Enable;
    Swap_Enable_out <= Swap_Enable;
    Memory_Add_Selec_out <= Memory_Add_Selec;
    WB_Selector_out <= WB_Selector;

    Sign_Extend_Instance : Sign_Extend PORT MAP(Extend_Sign, Immdite_Data, Extended_Imm);

    Extended_Imm_Memory <= Extended_Imm;

    Mux2x1_ALU_Source : Mux2x1 GENERIC MAP(32) PORT MAP(Read_Port2, Extended_Imm, ALU_SRC, Oprand2); -- mux for choosing oprand 2 for Alu

    ALU_Instance : ALU GENERIC MAP(32) PORT MAP(Read_Port1, Oprand2, ALU_OP, Flags, ALU_Result, ALU_Write_Data2);

    CCR_Reg_Instance : CCR_Reg PORT MAP(Clk, Rst, Flags, CCR_Enable, Flag_Output);

    Mux2x1_INPUTPORT : Mux2x1 GENERIC MAP(32) PORT MAP(ALU_Result, INPUT_PORT, InPort_Enable, Final_Result);

    Read_Port2_out <= Read_Port2;
    Write_Add1_out <= Write_Add1;
    Write_Add2_out <= Write_Add2;

END ARCHITECTURE;