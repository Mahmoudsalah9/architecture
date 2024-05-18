
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory_WriteBack IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        result_mem : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        read_port2_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        result_alu_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate_data_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_add1_memory : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_add2_memory : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_enable_memory : IN STD_LOGIC;
        wb_selector_memory : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        out_enable_memory : IN STD_LOGIC;
        swap_enable_memory : IN STD_LOGIC;
        Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_read_in : IN STD_LOGIC;

        result_mem_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        read_port2_memory_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        result_alu_memory_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate_data_memory_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Data2_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_add1_memory_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_add2_memory_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        wb_selector_memory_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        write_enable_memory_Out : OUT STD_LOGIC;
        out_enable_memory_Out : OUT STD_LOGIC;
        swap_enable_memory_Out : OUT STD_LOGIC;
        MEM_read_out : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE Memory_WriteBack_Design OF Memory_WriteBack IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            result_mem_out <= (OTHERS => '0');
            read_port2_memory_out <= (OTHERS => '0');
            result_alu_memory_out <= (OTHERS => '0');
            immediate_data_memory_out <= (OTHERS => '0');
            write_add1_memory_out <= (OTHERS => '0');
            write_add2_memory_out <= (OTHERS => '0');
            wb_selector_memory_out <= (OTHERS => '0');
            Write_Data2_Out <= (OTHERS => '0');
            write_enable_memory_Out <= '0';
            out_enable_memory_Out <= '0';
            swap_enable_memory_Out <= '0';

        ELSIF rising_edge(clk) THEN
            result_mem_out <= result_mem;
            read_port2_memory_out <= read_port2_memory;
            result_alu_memory_out <= result_alu_memory;
            immediate_data_memory_out <= immediate_data_memory;
            write_add1_memory_out <= write_add1_memory;
            write_add2_memory_out <= write_add2_memory;
            wb_selector_memory_out <= wb_selector_memory;
            write_enable_memory_Out <= write_enable_memory;
            out_enable_memory_Out <= out_enable_memory;
            swap_enable_memory_Out <= swap_enable_memory;
            Write_Data2_Out <= Write_Data2_In;
            MEM_read_out<=MEM_read_in;

        END IF;
    END PROCESS;
END ARCHITECTURE;