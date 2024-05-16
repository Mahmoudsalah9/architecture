LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Control_Unit IS
    PORT (

        --in:
        Instruction_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

        --out:
        RTI_Begin : OUT STD_LOGIC;
        FLUSH : OUT STD_LOGIC;
        PROTECT : OUT STD_LOGIC;
        OUTPORT_Enable : OUT STD_LOGIC;
        SWAP_Enable : OUT STD_LOGIC;
        MEM_Add_Selec : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Readport2 Data,   10 SP
        WB_Selector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 00 ALU Result,  01 Mem Result,   10 Imm Data, 11 Readport2 Data
        FREE : OUT STD_LOGIC;
        JUMP : OUT STD_LOGIC;
        BRANCH_ZERO : OUT STD_LOGIC;
        WRITE_Enable : OUT STD_LOGIC;
        MEM_Write : OUT STD_LOGIC;
        MEM_Read : OUT STD_LOGIC;
        ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        Extend_Sign : OUT STD_LOGIC;
        CALL_Enable : OUT STD_LOGIC;
        INPORT_Enable : OUT STD_LOGIC;
        ALU_SRC : OUT STD_LOGIC;
        CCR_Arithmetic : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        RET_Enable : OUT STD_LOGIC;
        STACK_Operation : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 00 NOP on sp, 01 increment by 2, 10 decrement by 2

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
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT ----------------------------
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
        '1' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '1' WHEN Instruction_OPCODE = "10111" -- FREE
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

    -- MEM_Add_Selec Signal

    MEM_Add_Selec <= "00" WHEN Instruction_OPCODE = "00000" -- NOP
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

    -- OUTPORT_Enable Signal

    OUTPORT_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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

    -- SWAP_Enable Signal

    SWAP_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
    --CCR_Arithmetic Signal

    CCR_Arithmetic <= "0000" WHEN Instruction_OPCODE = "00000" --NOP

        ELSE
        "0011" WHEN Instruction_OPCODE = "00001" -- NOT
        ELSE
        "0011" WHEN Instruction_OPCODE = "00010" -- NEG
        ELSE
        "1111" WHEN Instruction_OPCODE = "00011" -- INC
        ELSE
        "0111" WHEN Instruction_OPCODE = "00100" -- DEC
        ELSE
        "0000" WHEN Instruction_OPCODE = "00100" -- OUT
        ELSE
        "0000" WHEN Instruction_OPCODE = "00110" -- IN
        ELSE
        "0000" WHEN Instruction_OPCODE = "00111" -- MOV
        ELSE
        "0000" WHEN Instruction_OPCODE = "01000" -- SWAP
        ELSE
        "1111" WHEN Instruction_OPCODE = "01001" -- ADD
        ELSE
        "1111" WHEN Instruction_OPCODE = "01010" -- SUB
        ELSE
        "0011" WHEN Instruction_OPCODE = "01011" -- AND
        ELSE
        "0011" WHEN Instruction_OPCODE = "01100" -- OR
        ELSE
        "0011" WHEN Instruction_OPCODE = "01101" -- XOR
        ELSE
        "0011" WHEN Instruction_OPCODE = "01110" -- CMP
        ELSE
        "1111" WHEN Instruction_OPCODE = "01111" -- ADDI
        ELSE
        "1111" WHEN Instruction_OPCODE = "10000" -- SUBI
        ELSE
        "0000" WHEN Instruction_OPCODE = "10001" -- LDM
        ELSE
        "0000" WHEN Instruction_OPCODE = "10010" -- PUSH
        ELSE
        "0000" WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        "0000" WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        "0000" WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        "0000" WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        "0000" WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        "0001" WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        "0000" WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        "0000" WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        "0000" WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        "1111" WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        "0000";
    -- RTI_Begin Signal

    RTI_Begin <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '1' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';
    -- FLUSH Signal

    FLUSH <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '1' WHEN Instruction_OPCODE = "11000" -- JZ
        ELSE
        '1' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';
    -- PROTECT Signal

    PROTECT <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '1' WHEN Instruction_OPCODE = "10110" -- PROTECT
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
    -- BRANCH_ZERO Signal

    BRANCH_ZERO <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '0' WHEN Instruction_OPCODE = "10111" -- FREE
        ELSE
        '1' WHEN Instruction_OPCODE = "11000" -- JZ
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
    -- JUMP Signal

    JUMP <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '1' WHEN Instruction_OPCODE = "11001" -- JMP
        ELSE
        '0' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';
    -- MEM_Read Signal

    MEM_Read <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
    -- RET_Enable Signal

    RET_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '1' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';
    -- FREE Signal

    FREE <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '0' WHEN Instruction_OPCODE = "10100" -- LDD
        ELSE
        '0' WHEN Instruction_OPCODE = "10101" -- STD
        ELSE
        '0' WHEN Instruction_OPCODE = "10110" -- PROTECT
        ELSE
        '1' WHEN Instruction_OPCODE = "10111" -- FREE
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
    -- CALL_Enable Signal

    CALL_Enable <= '0' WHEN Instruction_OPCODE = "00000" --NOP
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
        '1' WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        '0' WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        '0' WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        '0';
    -- STACK_Operation Signal

    STACK_Operation <= "00" WHEN Instruction_OPCODE = "00000" -- NOP
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
        "01" WHEN Instruction_OPCODE = "10011" -- POP
        ELSE
        "00" WHEN Instruction_OPCODE = "10100" -- LDD
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
        "10" WHEN Instruction_OPCODE = "11010" -- CALL
        ELSE
        "01" WHEN Instruction_OPCODE = "11011" -- RET
        ELSE
        "00" WHEN Instruction_OPCODE = "11100" -- RTI
        ELSE
        "00";
END ARCHITECTURE;