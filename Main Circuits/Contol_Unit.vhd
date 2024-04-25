LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Control_Unit IS
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
        WB_Selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
        Extend_Sign : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE Control_Unit_Design OF Control_Unit IS

BEGIN

    -- ALU_Operation Signal

    ALU_OP <= "00000" WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        "00001" WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        "00010" WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        "00011" WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        "00100" WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        "00000" WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        "00000" WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        "00000" WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        "10001" WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        "01001" WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        "01010" WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        "01011" WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        "01100" WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        "01101" WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        "01010" WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        "01001" WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        "01010" WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        "01001" WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        "00000" WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        "00000" WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        "01001" WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        "01001" WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        "00000" WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        "00000" WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        "00000" WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        "00000" WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        "00000" WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        "00000" WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        "00000" WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        "00000";

    -- Write_Enable Signal

    Write_Enable <= '0' WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        '1' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '1' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '1' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '1' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '1' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '1' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '1' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '1' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '1' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '1' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '1' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '1' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '1' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '1' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '1' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '1' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '1' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

    -- Mem_Write Signal

    Mem_Write <= '0' WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '0' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '0' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '0' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '0' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '0' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '1' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '1' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '1' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';
    -- Mem InPort_Enable Signal

    InPort_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '1' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '0' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '0' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '0' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '0' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

    -- Mem Memoy_Add_Selec Signal

    Memory_Add_Selec <= "00" WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        "00" WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        "00" WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        "00" WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        "00" WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        "00" WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        "00" WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        "00" WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        "00" WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        "00" WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        "00" WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        "00" WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        "00" WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        "00" WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        "00" WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        "00" WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        "00" WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        "00" WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        "10" WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        "10" WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        "00" WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        "00" WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        "01" WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        "01" WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        "00" WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        "00" WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        "00" WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        "00" WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        "00" WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        "00";

    -- Data_After Signal

    Data_After <= '0' WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '1' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '0' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '1' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '1' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '1' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '1' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '1' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

    -- ALU_SRC Signal

    ALU_SRC <= '0' WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '0' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '0' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '1' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '1' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '0' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '1' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '1' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

    -- WB_Selector Signal

    WB_Selector <= "00" WHEN Instruction_OPCODE = "00000" -- NOP
        ELSE
        "00" WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        "00" WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        "00" WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        "00" WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        "00" WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        "00" WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        "11" WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        "00" WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        "00" WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        "00" WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        "00" WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        "00" WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        "00" WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        "00" WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        "00" WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        "00" WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        "10" WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        "00" WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        "01" WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        "01" WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        "00" WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        "00" WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        "00" WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        "00" WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        "00" WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        "00" WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        "00" WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        "00" WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        "00";

    -- OutPort_Enable Signal

    OutPort_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '1' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '0' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '0' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '0' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '0' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '0' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

    -- Swap_Enable Signal

    Swap_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '0' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '1' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '0' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '0' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '0' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

    -- Extend_Sign Signal

    Extend_Sign <= '0' WHEN Instruction_OPCODE = "00000" --NOP
        ELSE
        '0' WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        '0' WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        '0' WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        '0' WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        '0' WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        '0' WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        '0' WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        '0' WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        '0' WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        '0' WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        '0' WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        '0' WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        '0' WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        '0' WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        '0' WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        '0' WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        '0' WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        '0' WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        '1' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '1' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '0' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '0' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';

END ARCHITECTURE;