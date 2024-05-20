LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Instruction_Memory IS
    PORT (
        CLK, Rst : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        M10 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        M32 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Instruction_Memory;

ARCHITECTURE Instruction_Memory_Design OF Instruction_Memory IS
    TYPE ram_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;
BEGIN
    PROCESS (CLK, Rst) IS
    BEGIN
        IF Rst = '1' THEN
            M10 <= ram(1) & ram(0);
            M32 <= ram(3) & ram(2);
        ELSIF rising_edge(CLK) THEN
            Instruction <= ram(to_integer(unsigned(address)));
            data <= ram(to_integer(unsigned(address)) + 1);
        END IF;
    END PROCESS;
END ARCHITECTURE Instruction_Memory_Design;