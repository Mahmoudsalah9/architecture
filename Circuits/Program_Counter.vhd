LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Program_Counter IS
    PORT (
        clk, rst, disable, datacontrol, decoder_pc_enable: IN STD_LOGIC;
        pc_decoder_value : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        pc_adress : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END Program_Counter;

ARCHITECTURE PC_arch OF Program_Counter IS
    SIGNAL counter : unsigned(11 DOWNTO 0);
BEGIN 
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            counter <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF disable = '0' THEN
                IF decoder_pc_enable = '0' THEN        
                    IF datacontrol = '0' THEN
                        counter <= counter + 1;
                    ELSIF datacontrol = '1' THEN
                        counter <= counter + 2;                        
                    END IF;
                ELSE
                    counter <= unsigned(pc_decoder_value);    
                END IF;          
            END IF;
        END IF;
    END PROCESS;

    pc_adress <= STD_LOGIC_VECTOR(counter);

END PC_arch;
