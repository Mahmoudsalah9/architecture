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
            Mem_Read : OUT STD_LOGIC;
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

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

    SIGNAL

BEGIN
END ARCHITECTURE;