library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity InstructionFetch is
    port (
        clk : in std_logic;
        reset : in std_logic;
        instruction_ready : out std_logic;
        decoded_instruction : out std_logic_vector(15 downto 0)
    );
end entity InstructionFetch;

architecture Behavioral of InstructionFetch is
    signal instruction_fetch : std_logic_vector(15 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            instruction_ready <= '0';
            decoded_instruction <= (others => '0');
        elsif rising_edge(clk) then
            instruction_fetch <= Instruction_Fetch;
            instruction_ready <= '1';
            decoded_instruction <= instruction_fetch;
        end if;
    end process;
end architecture Behavioral;