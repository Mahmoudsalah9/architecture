library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    port (
        clk, rst : in std_logic;
        read1_addr, read2_addr : in unsigned(2 downto 0);
        write1_addr, write2_addr : in unsigned(2 downto 0);
        write1_data, write2_data : in std_logic_vector(31 downto 0); 
        read1_data, read2_data : out std_logic_vector(31 downto 0); 
        enable1, enable2 : in std_logic
        enable : in std_logic
    );
end entity RegisterFile;

architecture Behavioral of Register_File is
    type register_array is array (0 to 7) of std_logic_vector(31 downto 0); 
    signal registers : register_array := (others => (others => '0')); 
begin
    process (clk, rst)
    begin
        if rst = '1' then
            registers <= (others => (others => '0')); 
        elsif rising_edge(clk) then
            if enable = '1' then
                -- Read operations
                read_data1 <= registers(to_integer(unsigned(read_address1)));
                read_data2 <= registers(to_integer(unsigned(read_address2)));
                
                -- Write operations
                if write_enable1 = '1' then
                    registers(to_integer(unsigned(write_address1))) <= write_data1;
                end if;
                
                if write_enable2 = '1' then
                    registers(to_integer(unsigned(write_address2))) <= write_data2;
                end if;
            end if;
        end if;
    end process;
end Behavioral;