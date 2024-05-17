LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pc_value_decoder IS
  PORT (

    jmp_destination, result_memory, M10, M32, jmp_zero_destination, PC_INC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    JMP_Z_Done, update_pc_rti, update_pc_int, reset, ret_enable, jump_enable : IN STD_LOGIC;
    address_pc_decoder_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

  );
END ENTITY pc_value_decoder;

ARCHITECTURE rtl OF pc_value_decoder IS
BEGIN

  address_pc_decoder_value <=
    jmp_destination WHEN jump_enable = '1' ELSE
    result_memory WHEN ret_enable = '1' OR update_pc_rti = '1' ELSE
    M10 WHEN reset = '1' ELSE
    M32 WHEN update_pc_int = '1' ELSE
    jmp_zero_destination WHEN JMP_Z_Done = '1' ELSE
    PC_INC;

END ARCHITECTURE rtl;