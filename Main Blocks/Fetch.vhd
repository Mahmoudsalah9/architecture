LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Fetch IS
    PORT (

        Clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;
        In_Port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out_Port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;