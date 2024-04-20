
 -- make sure that the we is always zero 
 LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.numeric_std.all;
 
 ENTITY instruction_pointer IS
	 PORT(
		 clk : IN std_logic;
		 we  : IN std_logic;
		 address : IN  std_logic_vector(11 DOWNTO 0);
		 datain  : IN  std_logic_vector(15 DOWNTO 0);
		 dataout : OUT std_logic_vector(15 DOWNTO 0));
 END ENTITY instruction_pointer;
	-- make sure that the we is always zero 
 
 ARCHITECTURE syncrama OF instruction_pointer IS
 
	 TYPE ram_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
	 SIGNAL ram : ram_type ;
	 
	 BEGIN
		 PROCESS(clk) IS
			 BEGIN
				 IF rising_edge(clk) THEN  
					 IF we = '1' THEN
						 ram(to_integer(unsigned(address))) <= datain;
					 END IF;
				 END IF;
		 END PROCESS;
		 dataout <= ram(to_integer(unsigned(address)));
 END syncrama;
 