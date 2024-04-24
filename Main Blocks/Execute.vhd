LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Execute IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
    );
END ENTITY;

ARCHITECTURE Execute_Design OF Execute IS

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
            CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --CCR<0>:=zero flag,CCR<1>:=negative flag,CCR<2>:=carry flag,CCR<3>:=overflow flag
            q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    ----------------------------------------------------------------------------  Signals  -------------------------------------------------------------------------------

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

BEGIN
END;