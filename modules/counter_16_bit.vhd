library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_16_bit is
    port (
        counter_clk : in std_logic;
        counter_rst : in std_logic;
        counter_soft_rst : in std_logic;
        counter_en : in std_logic;
        
        counter_count : out std_logic_vector(15 downto 0)
    );
end counter_16_bit;

architecture structural of counter_16_bit is
begin
    process(counter_rst, counter_clk)
        variable count : std_logic_vector(15 downto 0) := (others => '0');
        variable delay : std_logic_vector(1 downto 0) := "00";
    begin
        if counter_rst = '1' then
            count := (others => '0');
        elsif rising_edge(counter_clk) then
            
            if counter_soft_rst = '1' then
                count := (others => '0');
            
            else
                
                if counter_en = '1' then
                        count := count +1;
                end if;
            
            end if;
        end if;
    counter_count <= count;

    end process;
end structural;