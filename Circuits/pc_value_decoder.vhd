LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pc_value_decoder IS
  PORT (
    jmp_destination, result_memory, M10, M32, jmp_zero_desination : IN STD_LOGIC_VECTOR(31 TO 0);
    BRANCH_ZERO, zero_flag, update_pc_rti, update_pc_int, reset, ret_enable, jump_ebnable : IN STD_LOGIC;
    pc_decoder_enable : OUT STD_LOGIC;
    adress_pc_decoder_value : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END ENTITY pc_value_decoder;

ARCHITECTURE rtl OF pc_value_decoder IS
BEGIN
  pc_decoder_enable <= '1'WHEN ((BRANCH_ZERO = '1'AND zero_flag = '1') OR update_pc_rti = '1' OR update_pc_int = '1' OR reset = '1' OR ret_enable = '1' OR jump_ebnable = '1') ELSE
    '0';

  adress_pc_decoder_value <= jmp_destination WHEN jump_ebnable = '1' ELSE
    result_memory WHEN ret_enable = '1' ELSE
    result_memory WHEN update_pc_rti = '1' ELSE
    M10 WHEN reset = '1' ELSE
    M32 WHEN update_pc_int = '1' ELSE
    jmp_zero_desination WHEN BRANCH_ZERO = '1' AND zero_flag = '1' ELSE
    (OTHERS => '0');

END ARCHITECTURE rtl;