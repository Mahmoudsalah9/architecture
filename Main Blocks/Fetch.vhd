LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Fetch IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        Data_After : IN STD_LOGIC;

        Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Fetch_Design OF Fetch IS

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
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
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

    COMPONENT Program_Counter IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
        );
    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

    SIGNAL PC_Address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Data_From_Instruction_Memory : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    Program_Counter_Instance : Program_Counter PORT MAP(Clk, Rst, '1', PC_Address);

    Instruction_Memory_Instance : Instruction_Memory PORT MAP(Clk, PC_Address, Data_From_Instruction_Memory);

    InstructionData_Decoder_Instance : InstructionData_Decoder PORT MAP(Data_From_Instruction_Memory, Data, Instruction, Data_After);

END ARCHITECTURE;