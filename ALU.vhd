library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is 
    generic (
        N : INTEGER := 32  -- Default bit width
    );
    port (
        reg1_in : in std_logic_vector (N-1 downto 0);
        reg2_in : in std_logic_vector (N-1 downto 0);
        opcode_in : in std_logic_vector (4 downto 0);
        carryflag_out: out std_logic;
        data_out : out std_logic_vector (N-1 downto 0);
        zero_out : out std_logic
    );
end entity;

architecture myModel of ALU is
    component my_nadder IS
        generic (n: integer := 32);
        port (
            a, b : IN  std_logic_vector(N-1 DOWNTO 0);
            cin : in std_logic;
            s : out std_logic_vector(N-1 DOWNTO 0);
            cout : OUT std_logic
        );
    END component;

    signal not_out, neg_out, inc_out, dec_out, add_out, sub_out, and_out, or_out, xor_out, cmp_out: std_logic_vector(N-1 downto 0);
    signal cnot_out, cneg_out, cinc_out, cdec_out, cadd_out, csub_out, cand_out, cor_out, cxor_out, ccmp_out: std_logic;
    signal zeronot_out, zeroneg_out, zeroinc_out, zerodec_out, zeroadd_out, zerosub_out, zeroand_out, zeroor_out, zeroxor_out, zerocmp_out: std_logic;
    signal notreg1_in, notreg2_in: std_logic_vector(N-1 downto 0);
    signal notcin: std_logic;
    signal zerocout : std_logic;
    signal zerodataout : std_logic_vector(N-1 downto 0);

begin
    notreg1_in <= NOT reg1_in;
    notreg2_in <= NOT reg2_in;

    inc_comp: my_nadder generic map(N) port map(reg1_in, (others => '0'), '1', inc_out, cinc_out);
    dec_comp: my_nadder generic map(N) port map(reg1_in, (others => '1'), '0', dec_out, cdec_out);
    add_comp: my_nadder generic map(N) port map(reg1_in, reg2_in, '0', add_out, cadd_out);
    sub_comp: my_nadder generic map(N) port map(reg1_in, notreg2_in, '0', sub_out, csub_out);
    neg_comp: my_nadder generic map(N) port map(notreg1_in, (others => '0'), '1', neg_out, cneg_out);

    -- Data output conditional assignment
    data_out <= not reg1_in when opcode_in = "00001" else
                neg_out when opcode_in = "00010" else
                inc_out when opcode_in = "00011" else
                dec_out when opcode_in = "00100" else
                add_out when opcode_in = "01001" else
                sub_out when opcode_in = "01010" else
                reg1_in and reg2_in when opcode_in = "01011" else
                reg1_in or reg2_in when opcode_in = "01100" else
                reg1_in xor reg2_in when opcode_in = "01101" else
                sub_out when opcode_in = "01110" else
                add_out when opcode_in = "01111" else
                sub_out when opcode_in = "10000" else 
                x"00000000";
                

    -- Conditional signal assignment for Carry Flag
    carryflag_out <= 
        cinc_out when opcode_in = "00011" else
        cadd_out when opcode_in = "01001" else
        cadd_out when opcode_in = "01111" else
        csub_out when opcode_in = "01010" else
        csub_out when opcode_in = "01110" else
        csub_out when opcode_in = "10000" else
        '0';

        zerodataout <= not reg1_in when opcode_in = "00001" else
        neg_out when opcode_in = "00010" else
        inc_out when opcode_in = "00011" else
        dec_out when opcode_in = "00100" else
        add_out when opcode_in = "01001" else
        sub_out when opcode_in = "01010" else
        reg1_in and reg2_in when opcode_in = "01011" else
        reg1_in or reg2_in when opcode_in = "01100" else
        reg1_in xor reg2_in when opcode_in = "01101" else
        sub_out when opcode_in = "01110" else
        add_out when opcode_in = "01111" else
        sub_out when opcode_in = "10000" else 
        x"00000000";  


        zerocout <= 
        cinc_out when opcode_in = "00011" else
        cadd_out when opcode_in = "01001" else
        cadd_out when opcode_in = "01111" else
        csub_out when opcode_in = "01010" else
        csub_out when opcode_in = "01110" else
        csub_out when opcode_in = "10000" else
        '0';
    -- Zero flag logic
    zero_out <= '1' when zerodataout = x"00000000"    and zerocout = '0' else '0';
  end architecture;
