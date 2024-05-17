LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Execute_Memory IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        LoadUse_RST : IN STD_LOGIC;

        alu_result_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        read_port2_data_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_add_execute : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        immediate_data_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Data2_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_write_execute : IN STD_LOGIC;
        write_enable_execute : IN STD_LOGIC;
        OutPort_Enable : IN STD_LOGIC;
        wb_selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        memory_add_select_execute : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        swap_enable_execute : IN STD_LOGIC;

        read_port2_memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        result_alu_memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate_data_memory : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Data2_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_add_memory : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        wb_selector_memory : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        memory_add_select_Out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        OutPort_Enable_out : OUT STD_LOGIC;
        mem_write_out : OUT STD_LOGIC;
        write_enable_out : OUT STD_LOGIC;
        swap_enable_Out : OUT STD_LOGIC

    );

END ENTITY;

ARCHITECTURE Execute_Memory_Design OF Execute_Memory IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            read_port2_memory <= (OTHERS => '0');
            result_alu_memory <= (OTHERS => '0');
            immediate_data_memory <= (OTHERS => '0');
            write_add_memory <= (OTHERS => '0');
            OutPort_Enable_out <= '0';
            wb_selector_memory <= (OTHERS => '0');
            mem_write_out <= '0';
            write_enable_out <= '0';
            swap_enable_Out <= '0';
            memory_add_select_Out <= (OTHERS => '0');
            Write_Data2_Out <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
        
            IF LoadUse_RST = '1' THEN
                read_port2_memory <= (OTHERS => '0');
                result_alu_memory <= (OTHERS => '0');
                immediate_data_memory <= (OTHERS => '0');
                write_add_memory <= (OTHERS => '0');
                OutPort_Enable_out <= '0';
                wb_selector_memory <= (OTHERS => '0');
                mem_write_out <= '0';
                write_enable_out <= '0';
                swap_enable_Out <= '0';
                memory_add_select_Out <= (OTHERS => '0');
                Write_Data2_Out <= (OTHERS => '0');
            ELSE
                read_port2_memory <= read_port2_data_execute;
                result_alu_memory <= alu_result_execute;
                immediate_data_memory <= immediate_data_execute;
                write_add_memory <= write_add_execute;
                OutPort_Enable_out <= OutPort_Enable;
                wb_selector_memory <= wb_selector;
                mem_write_out <= mem_write_execute;
                write_enable_out <= write_enable_execute;
                memory_add_select_Out <= memory_add_select_execute;
                swap_enable_Out <= swap_enable_execute;
                Write_Data2_Out <= Write_Data2_In;
            END IF;

        END IF;
    END PROCESS;
END ARCHITECTURE;