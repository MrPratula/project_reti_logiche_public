library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity check_min is
    port (
        cmin_curr_min : in std_logic_vector(7 downto 0);
        cmin_data : in std_logic_vector(7 downto 0);
        cmin_count : in std_logic_vector(15 downto 0);
        cmin_chunk : in std_logic_vector(15 downto 0);
        
        cmin_en_min : out std_logic
    );
end check_min;

architecture structural of check_min is
begin
    process(cmin_curr_min, cmin_data, cmin_count, cmin_chunk)
    begin
        
        if cmin_count = 4 then
            cmin_en_min <= '1';
        
        elsif cmin_count >= 5 and cmin_count <= 4 + cmin_chunk -1 then
            
            if cmin_data < cmin_curr_min then
                cmin_en_min <= '1';
            else
                cmin_en_min <= '0';
            end if;
            
        else 
            cmin_en_min <= '0';
            
        end if;
    end process;
end structural; 