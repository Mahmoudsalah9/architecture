library ieee;
use ieee.std_logic_1164.all;

entity pc_value_decoder is
  port (
    jmp_destination,result_memory,M10,M32,jmp_zero_desination : in std_logic_vector(31 to 0);
    BRANCH_ZERO,zero_flag,update_pc_rti,update_pc_int,reset,ret_enable,jump_ebnable:in std_logic; 
    pc_decoder_enable : out std_logic;
    adress_pc_decoder_value : out std_logic_vector(11 downto 0)
  );
end entity pc_value_decoder;

architecture rtl of pc_value_decoder is
begin
  pc_decoder_enable<='1'when ((BRANCH_ZERO='1'and zero_flag='1') or update_pc_rti='1'  or update_pc_int='1' or reset='1' or ret_enable='1' or jump_ebnable='1') else '0';
  adress_pc_decoder_value<=jmp_destination when jump_ebnable='1' else
                           result_memory when ret_enable='1' else
                           M10 when update_pc_rti='1' else
                           M32 when update_pc_int='1' else
                           jmp_zero_desination when BRANCH_ZERO='1' and zero_flag='1' else
                           (others=>'0');
  
end architecture rtl;
