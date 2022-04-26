library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity shift_pixel is
    Port ( 
        shift_max_pixel : in STD_LOGIC_VECTOR (7 downto 0);
        shift_min_pixel : in STD_LOGIC_VECTOR (7 downto 0);
        shift_data : in STD_LOGIC_VECTOR (7 downto 0);
        
        shift_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end shift_pixel;

architecture structural of shift_pixel is

begin

    process(shift_max_pixel, shift_min_pixel, shift_data)
    
    variable delta_value : std_logic_vector(7 downto 0);
    variable temp_pixel : unsigned(8 downto 0);
    variable shift_level : natural;
    variable temp_pixel_tmp : std_logic_vector(8 downto 0);
    variable zero : std_logic;
    
    begin
       
        zero := '0';
        delta_value := shift_max_pixel - shift_min_pixel;
       
        case to_integer(unsigned(delta_value)) is
            
			when 0 =>
				shift_level := 8;
			when 1 to 2 =>
				shift_level := 7;
			when 3 to 6 =>
				shift_level := 6;
			when 7 to 14 =>
				shift_level := 5;
			when 15 to 30 =>
				shift_level := 4;
			when 31 to 62 =>
				shift_level := 3;
			when 63 to 126 =>
				shift_level := 2;
			when 127 to 254 =>
				shift_level := 1;
			when others  =>
				shift_level := 0;
		end case;
            
        temp_pixel := zero & unsigned(shift_data - shift_min_pixel) sll shift_level;
     	temp_pixel_tmp := std_logic_vector(temp_pixel);
         
      	if temp_pixel < 255 then 
         	shift_out <= temp_pixel_tmp(7 downto 0);
      	else 
         	shift_out <= "11111111";
      	end if;
        
    end process;
    
end structural;