LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Execute_Stage IS
    PORT (
        poppedflags : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        interruptselector : IN STD_LOGIC;
        selectorsource1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        selectorsource2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        forwardedEM : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        forwardedMWB : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        Clk, Rst : IN STD_LOGIC;
        BranchingSignals : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        reg1value, reg2value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- Adjusted to 5 bits
        Coutcombinational, Negcombinational, Zerocombinational : OUT STD_LOGIC; -- Removed overflowcombinational
        CoutFF, NegFF, ZeroFF : OUT STD_LOGIC; -- Removed overflowFF
        ALUout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        immediateval : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        ALUsrc : IN STD_LOGIC;
        pcsignals : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        storeforwardedvalue : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        operand1forwarded : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
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
            opcode_in : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- Adjusted to 5 bits
            flag_reg_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0); -- 3 bits for flags
            data_out : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
            Write_Data_2 : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Flagreg IS
        GENERIC (n : INTEGER := 3);
        PORT (
            Clk, Rst, en : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL ALU2op : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL couttoflag, Negtoflag, Zerotoflag : STD_LOGIC; -- Removed overflowFlag
    SIGNAL flagout : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Modified to 3 bits
    SIGNAL flagin : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Modified to 3 bits
    SIGNAL Coutcombtemp, Negcombtemp, Zerocombtemp : STD_LOGIC; -- Removed Overflowcombtemp

    SIGNAL operand1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL operand2 : STD_LOGIC_VECTOR (31 DOWNTO 0);

    SIGNAL ALUflag_out : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Added signal for ALU flag output

BEGIN

    operand1forwarded <= operand1;
    operand1 <= forwardedEM WHEN selectorsource1 = "00"
        ELSE
        forwardedMWB WHEN selectorsource1 = "01"
        ELSE
        reg1value;

    ALU2op <= forwardedEM WHEN selectorsource2 = "00"
        ELSE
        forwardedMWB WHEN selectorsource2 = "01"
        ELSE
        reg2value;

    operand2 <= ALU2op WHEN ALUsrc = '0'
        ELSE
        immediateval;

    storeforwardedvalue <= ALU2op;
    pcsignals <= "110" WHEN BranchingSignals = "110" OR (BranchingSignals = "001" AND flagout(0) = '0') OR (BranchingSignals = "010" AND flagout(2) = '0') -- don't jump
        ELSE
        "111" WHEN BranchingSignals = "111" OR (BranchingSignals = "001" AND flagout(0) = '1') OR (BranchingSignals = "010" AND flagout(2) = '1') OR BranchingSignals = "011" -- jump to operand A
        ELSE
        "100" WHEN BranchingSignals = "100" OR BranchingSignals = "101"
        ELSE
        "110";

    flagin <= poppedflags WHEN interruptselector = '1'
        ELSE
        '0' & Negcombtemp & Zerocombtemp WHEN (BranchingSignals = "010" AND flagout(2) = '0')
        ELSE
        Coutcombtemp & Negcombtemp & '0' WHEN (BranchingSignals = "001" AND flagout(0) = '0')
        ELSE
        Coutcombtemp & Negcombtemp & Zerocombtemp;

    -- Output to Controller to be forwarded to be used in the branching
    Coutcombinational <= Coutcombtemp;
    Negcombinational <= Negcombtemp;
    Zerocombinational <= Zerocombtemp;

    -- Output to the execution to ride the pipe 
    CoutFF <= flagout(2);
    NegFF <= flagout(1);
    ZeroFF <= flagout(0);

    ALU1 : ALU PORT MAP(
        reg1_in => operand1,
        reg2_in => operand2,
        opcode_in => sel,
        flag_reg_out => ALUflag_out,
        data_out => ALUout,
        Write_Data_2 => OPEN
    );

    -- Capture individual flag outputs from ALUflag_out
    Coutcombtemp <= ALUflag_out(2);
    Negcombtemp <= ALUflag_out(1);
    Zerocombtemp <= ALUflag_out(0);

    Flagreg1 : Flagreg PORT MAP(Clk, Rst, '1', flagin, flagout);

END ARCHITECTURE;