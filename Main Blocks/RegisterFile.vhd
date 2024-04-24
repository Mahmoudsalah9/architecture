library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerfile is
    port (
        clk, rst: in std_logic;
        wrten1, wrten2: in std_logic;  -- Two write enables
        writeport1, writeport2: in std_logic_vector(31 downto 0);
        readport1, readport2: out std_logic_vector(31 downto 0);
        WriteAdd1, WriteAdd2: in std_logic_vector(31 downto 0);
        ReadAdd1, ReadAdd2: in std_logic_vector(31 downto 0)
    );
end registerfile;

architecture filearc of registerfile is
    component my_DFF is
        generic (
            n: integer := 32
        );
        port (
            Clk, Rst, En: in std_logic;
            D: in std_logic_vector(n-1 downto 0);
            Q: out std_logic_vector(n-1 downto 0)
        );
    end component;

    signal enabletemp1, enabletemp2: std_logic_vector(7 downto 0);
    type regout_type is array(0 to 7) of std_logic_vector(31 downto 0);
    signal regout: regout_type;
    signal notclk: std_logic;
begin
    notclk <= not clk;

    loop1: for i in 0 to 7 generate
        fx1: my_DFF port map (
            notclk,
            rst,
            enabletemp1(i),
            writeport1,
            regout(i)
        );

        fx2: my_DFF port map (
            notclk,
            rst,
            enabletemp2(i),
            writeport2,
            regout(i)
        );
    end generate loop1;

   process(WriteAdd1, WriteAdd2, wrten1, wrten2, rst)
begin
    if rst = '1' then
        enabletemp1 <= (others => '0');
        enabletemp2 <= (others => '0');
    elsif wrten1 = '1' then
        case WriteAdd1 is
            when "00000000000000000000000000000000" =>
                enabletemp1 <= "00000001";
            when "00000000000000000000000000000001" =>
                enabletemp1 <= "00000010";
            when "00000000000000000000000000000010" =>
                enabletemp1 <= "00000100";
            when "00000000000000000000000000000011" =>
                enabletemp1 <= "00001000";
            when "00000000000000000000000000000100" =>
                enabletemp1 <= "00010000";
            when "00000000000000000000000000000101" =>
                enabletemp1 <= "00100000";
            when "00000000000000000000000000000110" =>
                enabletemp1 <= "01000000";
            when others =>
                enabletemp1 <= "10000000";
        end case;
    elsif wrten2 = '1' then
        case WriteAdd2 is
            when "00000000000000000000000000000000" =>
                enabletemp2 <= "00000001";
            when "00000000000000000000000000000001" =>
                enabletemp2 <= "00000010";
            when "00000000000000000000000000000010" =>
                enabletemp2 <= "00000100";
            when "00000000000000000000000000000011" =>
                enabletemp2 <= "00001000";
            when "00000000000000000000000000000100" =>
                enabletemp2 <= "00010000";
            when "00000000000000000000000000000101" =>
                enabletemp2 <= "00100000";
            when "00000000000000000000000000000110" =>
                enabletemp2 <= "01000000";
            when others =>
                enabletemp2 <= "10000000";
        end case;
    else
        enabletemp1 <= (others => '0');
        enabletemp2 <= (others => '0');
    end if;
end process;

    readport1 <= regout(to_integer(unsigned(ReadAdd1)));
    readport2 <= regout(to_integer(unsigned(ReadAdd2)));
end filearc;