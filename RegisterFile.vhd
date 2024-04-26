LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Register_File IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_data1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        read_data2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_enable1, write_enable2 : IN STD_LOGIC

    );
END Register_File;

ARCHITECTURE Behavioral OF Register_File IS
    TYPE register_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL registers : register_array := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            registers <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN

            IF write_enable1 = '1' THEN
                registers(to_integer(unsigned(write_address1))) <= write_data1;
            END IF;

            IF write_enable2 = '1' THEN
                registers(to_integer(unsigned(write_address2))) <= write_data2;
            END IF;
        END IF;

    END PROCESS;
    read_data1 <= registers(to_integer(unsigned(read_address1)));
    read_data2 <= registers(to_integer(unsigned(read_address2)));

END Behavioral;