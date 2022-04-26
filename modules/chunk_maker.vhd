library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity chunk_maker is
    Port ( 
        chunk_start : in STD_LOGIC;
        chunk_clk : in STD_LOGIC;
        chunk_rst : in STD_LOGIC;
        chunk_soft_rst : in STD_LOGIC;
        chunk_data : in std_logic_vector (7 downto 0);
        
        chunk_done : out STD_LOGIC;
        chunk_chunk : out STD_LOGIC_VECTOR (15 downto 0);
        chunk_address : out std_logic_vector (15 downto 0)
    );
end chunk_maker;

architecture structural of chunk_maker is

signal s_mem0 : std_logic_vector(7 downto 0);
signal s_chunk: std_logic_vector (15 downto 0);
signal s_counter : std_logic_vector(2 downto 0);

begin

    process(chunk_clk, chunk_rst)
        
        begin
        
        if chunk_rst = '1' then 
            
            s_mem0 <= (others => '0');
            s_chunk <= (others => '0');
            s_counter <= "000";
            
            chunk_done <= '0';
            chunk_chunk <= (others => '0');
            chunk_address <= (others => '0');
        
        elsif rising_edge(chunk_clk) then
        
           if chunk_soft_rst = '1' then 
           
                s_mem0 <= (others => '0');
                s_chunk <= (others => '0');
                s_counter <= "000";
            
                chunk_done <= '0';
                chunk_chunk <= (others => '0');
                chunk_address <= (others => '0');
           
           else 
                
                if chunk_start = '1' then 
                    
                    if s_counter = "000" then 
                        
                        s_counter <= s_counter +1;          -- incremento counter
                        chunk_address <= (others => '0');   -- richiedo byte 0
                    
                    elsif s_counter = "001" then
                    
                        s_mem0 <= chunk_data;               -- salvo contenuto byte 0
                        s_counter <= s_counter +1;          -- incremento counter
                        
                        chunk_address <= std_logic_vector(to_unsigned(1, 16));  -- richiedo byte 1
                    
                    elsif s_counter = "010" then 
                        
                        s_counter <= s_counter +1;              -- incremento il counter
                        
                    elsif s_counter = "011" then 
                    
                        s_counter <= s_counter +1;              -- incremento il counter
                        s_chunk <= s_mem0 * chunk_data;         -- salvo il chunk
                    
                    else 
                        s_counter <= s_counter;
                        chunk_done <= '1';          -- alzo il done
                        
                    end if;
                    
                    chunk_chunk <= s_chunk;         -- assegno l'uscita del chunk sempre
                
                end if;
            end if;
        end if;
    end process;
end structural;