library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity big_brain is
    Port ( 
        bb_clk : in std_logic;
        bb_rst : in std_logic;
        bb_soft_rst : in std_logic;
        bb_start : in STD_LOGIC;
        bb_count : in STD_LOGIC_VECTOR (15 downto 0);
        bb_chunk : in STD_LOGIC_VECTOR (15 downto 0);

        bb_we : out STD_LOGIC;
        bb_done : out STD_LOGIC
    );
end big_brain;

architecture structural of big_brain is
begin

    process(bb_rst, bb_clk)
        begin
        
        if bb_rst = '1' then 
            bb_we <= '0';
            bb_done <= '0';
        
        elsif (rising_edge(bb_clk)) then 
            
            if bb_soft_rst = '1' then 
                 bb_we <= '0';
                bb_done <= '0';
            
            else
            
                if (bb_count = "0000000000000000") or (bb_count = "0000000000000001")or (bb_count = "0000000000000010") or (bb_count = "0000000000000011") or (bb_count = "0000000000000100") then    
                    bb_we <= '0';
                    bb_done <= '0';
                
                else
    
                    if bb_count <= bb_chunk + 1 then
                        bb_we <= '0';
                        bb_done <= '0';
                   
                    elsif bb_count > bb_chunk +1 and bb_count <= bb_chunk + bb_chunk + bb_chunk + 1 then  
                    
                        if bb_chunk(0) = '0' then 
                            if bb_count(0) = '0' then 
                                bb_we <= '0';
                                bb_done <= '0';
                            else 
                                bb_we <= '1';
                                bb_done <= '0';
                            end if;
                        else 
                            if bb_count(0) = '0' then 
                                bb_we <= '1';
                                bb_done <= '0';
                            else
                                bb_we <= '0';
                                bb_done <= '0';
                            end if;
                        end if;
                        
                    else 
    
                        if bb_start = '1' then
                            bb_we <= '0';
                            bb_done <= '1';
                            
                        else
                            bb_done <= '0';
                            bb_we <= '0';
                        end if;
    
                    end if;
                end if;
            end if;
        end if;

    end process;

end structural;