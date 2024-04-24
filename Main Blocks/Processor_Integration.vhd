LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Processor_Integration IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        In_Port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out_Port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE Processor_Integration_Design OF Processor_Integration IS

    --------------------------------------------------------------------------  Components  --------------------------------------------------------------------------------

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

    COMPONENT Instruction_Memory IS
        PORT (
            CLK : IN STD_LOGIC;
            we : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT Instruction_Memory;

    COMPONENT InstructionData_Decoder IS
        PORT (

            Data_or_Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Data_After : IN STD_LOGIC
        );
    END COMPONENT;

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

    COMPONENT Control_Unit IS
        PORT (

            Instruction_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Write_Enable : OUT STD_LOGIC;
            Mem_Write : OUT STD_LOGIC;
            InPort_Enable : OUT STD_LOGIC;
            OutPort_Enable : OUT STD_LOGIC;
            Swap_Enable : OUT STD_LOGIC;
            Memory_Add_Selec : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Readport2 Data,   10 SP
            Data_After : OUT STD_LOGIC;
            ALU_SRC : OUT STD_LOGIC;
            WB_Selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
            Extend_Sign : OUT STD_LOGIC;

        );
    END COMPONENT;

    COMPONENT Memory IS
        PORT (

            CLK, RST, Memory_Write : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT CCR_Reg IS
        PORT (

            Clk, Rst : IN STD_LOGIC;
            CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --CCR<0>:=zero flag,CCR<1>:=negative flag,CCR<2>:=carry flag,CCR<3>:=overflow flag
            q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
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
            write_data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_enable1, write_enable2 : IN STD_LOGIC

        );
    END COMPONENT;

    COMPONENT Program_Counter IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

    ---------------- Fetch Stage-----------------:

    SIGNAL PC_Address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Data_From_Instruction_Memory : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Instruction_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_Fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Decode Stage:
    SIGNAL Instruction_Decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Data_Fetch_Decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Extended_Data_Decode_Execute : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);

    --Control signals generation
    SIGNAL ALU_OP_Decode STD_LOGIC_VECTOR(4 DOWNTO 0); --- D/E 
    SIGNAL Write_Enable_Decode STD_LOGIC; --- D/E 
    SIGNAL Mem_Write_Decode STD_LOGIC; --- D/E 
    SIGNAL InPort_Enable_Decode STD_LOGIC; --- D/E 
    SIGNAL OutPort_Enable_Decode STD_LOGIC; --- D/E 
    SIGNAL Swap_Enable STD_LOGIC; --- D/E 
    SIGNAL Memory_Add_Selec_Decode STD_LOGIC_VECTOR(1 DOWNTO 0); --- D/E 
    SIGNAL Data_After_Decode STD_LOGIC;
    SIGNAL ALU_SRC_Decode STD_LOGIC; --- D/E 
    SIGNAL WB_Selector_Decode STD_LOGIC_VECTOR(1 DOWNTO 0) --- D/E 
    SIGNAL Extend_Sign_Decode STD_LOGIC; --- D/E 

    SIGNAL R_Source1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL R_Source2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add1 : STD_LOGIC_VECTOR(2 DOWNTO 0); --- D/E 

    SIGNAL Write_Add2 : STD_LOGIC_VECTOR(2 DOWNTO 0); --- D/E 
    SIGNAL Read_Port1_Decode : STD_LOGIC_VECTOR(31 DOWNTO 0); --- D/E 
    SIGNAL Read_Port2_Decode : STD_LOGIC_VECTOR(31 DOWNTO 0); --- D/E 

    ---------------- Execute Stage-----------------:

    SIGNAL Immdite_Data_Execute : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Read_Port1_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Port2_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Write_Add1_Execute : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Write_Add2_Execute : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --Control signals Execute
    SIGNAL ALU_OP_Execute STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Write_Enable_Execute STD_LOGIC; --- E/M
    SIGNAL Mem_Write_Execute STD_LOGIC; --- E/M
    SIGNAL InPort_Enable_Execute STD_LOGIC;
    SIGNAL OutPort_Enable_Execute STD_LOGIC; --- E/M
    SIGNAL Swap_Execute STD_LOGIC; --- E/M
    SIGNAL Memory_Add_Selec_Execute STD_LOGIC_VECTOR(1 DOWNTO 0); --- E/M
    SIGNAL ALU_SRC_Execute STD_LOGIC;
    SIGNAL WB_Selector_Execute STD_LOGIC_VECTOR(1 DOWNTO 0) --- E/M
    SIGNAL Extend_Sign_Execute STD_LOGIC;

    --ALU signals
    SIGNAL Oprand1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Oprand2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_Result_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_Write_Data2 : STD_LOGIC_VECTOR(31 DOWNTO 0); --- E/M     
    SIGNAL Flags : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL Final_Result_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0); --- E/M

    ---------------- Memory Stage-----------------:

    ---------------- Write Back Stage-----------------:

BEGIN

    -- Fetch Stage:

    Program_Counter_Instance : Program_Counter PORT MAP(Clk, Rst, '1', PC_Address);

    Instruction_Memory_Instance : Instruction_Memory PORT MAP(Clk, PC_Address, Data_From_Instruction_Memory);

    InstructionData_Decoder_Instance : InstructionData_Decoder PORT MAP(Data_From_Instruction_Memory, Data_Fetch, Instruction_Fetch, Data_After);

    --Deocde Stage:

    OPCODE <= Instruction_Decode(15 DOWNTO 11);
    R_Source1 <= Instruction_Decode(10 DOWNTO 8);
    R_Source2 <= Instruction_Decode(7 DOWNTO 15);
    Write_Add1 <= Instruction_Decode(4 DOWNTO 2);
    Write_Add2 <= Instruction_Decode(7 DOWNTO 15);

    Control_Unit_Instance : Control_Unit PORT MAP(OPCODE, ALU_OP_Decode, Write_Enable_Decode, Mem_Write_Decode, InPort_Enable_Decode, OutPort_Enable_Decode, Swap_Enable, Memory_Add_Selec_Decode, Data_After_Decode, ALU_SRC_Decode, WB_Selector_Decode, Extend_Sign_Decode);

    Sign_Extend_Instance : Sign_Extend PORT MAP(Extend_Sign_Decode, Data_Fetch_Decode, Extended_Data_Decode_Execute);

    registerfile_Instance : registerfile PORT MAP(Clk, Rst, R_Source1, R_Source2, Read_Port1_Decode, Read_Port2_Decode, "Write Add 1", "Write Add 2", "Write data 1", "Write data 2", "write e 1", "write e 2");

    --Execute Stage:

    Mux2x1_ALU_Source : Mux2x1 GENERIC MAP(32) PORT MAP(Read_Port2_Execute, Extended_Data_Decode_Execute, ALU_SRC_Execute, Oprand2); -- mux for choosing oprand 2 for Alu

    ALU_Instance : ALU GENERIC MAP(32) PORT MAP(Read_Port1_Execute, Oprand2, ALU_OP_Execute, Flags, ALU_Result_Execute, ALU_Write_Data2);

    CCR_Reg_Instance : CCR_Reg PORT MAP(Clk, Rst, Flags, "???????");

    Mux2x1_INPUTPORT : Mux2x1 GENERIC MAP(32) PORT MAP(ALU_Result_Execute, In_Port, InPort_Enable_Execute, Final_Result_Execute);

    --Memory Stage:


END ARCHITECTURE;