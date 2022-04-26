library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity check_max is
    port (
        cmax_curr_max : in std_logic_vector(7 downto 0);
        cmax_data : in std_logic_vector(7 downto 0);
        cmax_count : in std_logic_vector(15 downto 0);
        cmax_chunk : in std_logic_vector(15 downto 0);
        
        cmax_en_max : out std_logic
    );
end check_max;

architecture structural of check_max is
begin
    process(cmax_curr_max, cmax_data, cmax_count, cmax_chunk)
    begin
        
        if cmax_count = 4 then
            cmax_en_max <= '1';
        
        elsif cmax_count >= 5 and cmax_count <= 4 + cmax_chunk -1 then
        
                if cmax_data > cmax_curr_max then
                    cmax_en_max <= '1';
                else
                    cmax_en_max <= '0';
                end if;
                
            else 
                cmax_en_max <= '0';
            end if;
    end process;
end structural; 