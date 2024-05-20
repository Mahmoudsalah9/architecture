LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALU IS
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
END ENTITY;

ARCHITECTURE myModel OF ALU IS
    COMPONENT my_nadder IS
        GENERIC (n : INTEGER := 32);
        PORT (
            a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL not_out, neg_out, inc_out, dec_out, add_out, sub_out, and_out, or_out, xor_out, cmp_out : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL cnot_out, cneg_out, cinc_out, cdec_out, cadd_out, csub_out, cand_out, cor_out, cxor_out, ccmp_out : STD_LOGIC;
    SIGNAL zeronot_out, zeroneg_out, zeroinc_out, zerodec_out, zeroadd_out, zerosub_out, zeroand_out, zeroor_out, zeroxor_out, zerocmp_out : STD_LOGIC;
    SIGNAL notreg1_in, notreg2_in, Temp : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL notcin : STD_LOGIC;
    SIGNAL signal_cout : STD_LOGIC;
    SIGNAL signal_dataout : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL zero_flag_out, neg_flag_out, carry_flag_out, overflow_flag_out : STD_LOGIC;

BEGIN
    notreg1_in <= NOT reg1_in;
    notreg2_in <= NOT reg2_in;

    inc_comp : my_nadder GENERIC MAP(N) PORT MAP(reg1_in, (OTHERS => '0'), '1', inc_out, cinc_out);
    dec_comp : my_nadder GENERIC MAP(N) PORT MAP(reg1_in, (OTHERS => '1'), '0', dec_out, cdec_out);
    w : my_nadder GENERIC MAP(N) PORT MAP(reg1_in, reg2_in, '0', add_out, cadd_out);
    sub_comp : my_nadder GENERIC MAP(N) PORT MAP(reg1_in, notreg2_in, '1', sub_out, csub_out);
    neg_comp : my_nadder GENERIC MAP(N) PORT MAP(notreg1_in, (OTHERS => '0'), '1', neg_out, cneg_out);

    Temp <= reg1_in;

    -- Data output conditional assignment
    data_out <= NOT reg1_in WHEN opcode_in = "00001" ELSE
        neg_out WHEN opcode_in = "00010" ELSE
        inc_out WHEN opcode_in = "00011" ELSE
        dec_out WHEN opcode_in = "00100" ELSE
        add_out WHEN opcode_in = "01001" ELSE
        sub_out WHEN opcode_in = "01010" ELSE
        reg1_in AND reg2_in WHEN opcode_in = "01011" ELSE
        reg1_in OR reg2_in WHEN opcode_in = "01100" ELSE
        reg1_in XOR reg2_in WHEN opcode_in = "01101" ELSE
        sub_out WHEN opcode_in = "01110" ELSE
        add_out WHEN opcode_in = "01111" ELSE
        sub_out WHEN opcode_in = "10000" ELSE
        reg2_in WHEN opcode_in = "10001" ELSE
        reg1_in WHEN opcode_in = "00000" ELSE
        x"00000000";

    Write_Data_2 <= Temp WHEN opcode_in = "10001" ELSE
        x"00000000";
    -- Data output conditional assignment
    signal_dataout <= NOT reg1_in WHEN opcode_in = "00001" ELSE
        neg_out WHEN opcode_in = "00010" ELSE
        inc_out WHEN opcode_in = "00011" ELSE
        dec_out WHEN opcode_in = "00100" ELSE
        add_out WHEN opcode_in = "01001" ELSE
        sub_out WHEN opcode_in = "01010" ELSE
        reg1_in AND reg2_in WHEN opcode_in = "01011" ELSE
        reg1_in OR reg2_in WHEN opcode_in = "01100" ELSE
        reg1_in XOR reg2_in WHEN opcode_in = "01101" ELSE
        sub_out WHEN opcode_in = "01110" ELSE
        add_out WHEN opcode_in = "01111" ELSE
        sub_out WHEN opcode_in = "10000" ELSE
        reg2_in WHEN opcode_in = "10001" ELSE
        x"00000000";

    -- Conditional signal assignment for Carry Flag
    carry_flag_out <=
        cinc_out WHEN opcode_in = "00011" ELSE
        cadd_out WHEN opcode_in = "01001" ELSE
        cadd_out WHEN opcode_in = "01111" ELSE
        '1' WHEN ((opcode_in = "01010" OR opcode_in = "10000") AND reg1_in(n - 1) = '0' AND reg2_in(n - 1) = '0' AND signal_dataout(n - 1) = '1') OR ((opcode_in = "01010" OR opcode_in = "10000") AND reg1_in(n - 1) = '1' AND reg2_in(n - 1) = '1' AND signal_dataout(n - 1) = '0')
        ELSE
        '0';
    -- Overflow flag logic for addition
    -- Overflow flag logic

    -- Zero flag logic
    zero_flag_out <= '1' WHEN signal_dataout = x"00000000" ELSE
        '0';
    neg_flag_out <= '1' WHEN signal_dataout(N - 1) = '1' ELSE
        '0';
    -- Overflow flag logic
    overflow_flag_out <= '1' WHEN (
        -- Check if opcode is ADD or ADDI
        -- If true, check overflow conditions for addition
        ((opcode_in = "01001" OR opcode_in = "01111") AND
        -- Check if both operands are positive and the result is negative
        ((reg1_in(N - 1) = '0' AND reg2_in(N - 1) = '0' AND add_out(N - 1) = '1') OR
        -- Check if both operands are negative and the result is positive
        (reg1_in(N - 1) = '1' AND reg2_in(N - 1) = '1' AND add_out(N - 1) = '0'))) OR
        -- Check if opcode is SUB or SUBI
        -- If true, check overflow conditions for subtraction
        ((opcode_in = "01010" OR opcode_in = "10000") AND
        -- Check if the first operand is positive, the second operand is negative, and the result is negative
        ((reg1_in(N - 1) = '0' AND reg2_in(N - 1) = '1' AND sub_out(N - 1) = '1') OR
        -- Check if the first operand is negative, the second operand is positive, and the result is positive
        (reg1_in(N - 1) = '1' AND reg2_in(N - 1) = '0' AND sub_out(N - 1) = '0')))
        ) ELSE
        '0';

    flag_reg_out(3) <= overflow_flag_out;
    flag_reg_out(2) <= carry_flag_out;--i want to check for the condition for the subtract for the carry 
    flag_reg_out(1) <= neg_flag_out;
    flag_reg_out(0) <= zero_flag_out;

END ARCHITECTURE;