LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Sign_Extend IS
    PORT (
        Extend_Sign : IN STD_LOGIC;
        Data_16_bits : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Data_32_bits : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Sign_Extend_Design OF Sign_Extend IS

    SIGNAL Sign_Bit : STD_LOGIC;

BEGIN

    Sign_Bit <= Data_16_bits(15);

    Data_32_bits(15 DOWNTO 0) <= Data_16_bits;
    Data_32_bits(31 DOWNTO 16) <= x"0000" WHEN Extend_Sign = '0' ELSE
    (OTHERS => Sign_Bit) WHEN Extend_Sign = '1';

END ARCHITECTURE;