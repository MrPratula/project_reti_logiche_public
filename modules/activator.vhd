library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity activator is
    port (
        act_done_chunk : in std_logic;
        act_start : in std_logic;
        act_clk : in std_logic;
        act_rst : in std_logic;
        act_soft_rst : in std_logic;

        act_start_init : out std_logic;
        act_start_chunk : out std_logic;
        act_mux_sel : out std_logic
    );
end activator;

architecture structural of activator is

begin

    process(act_clk, act_rst)
    begin
        
        if act_rst = '1' then 
            
            act_start_init <= '0';
            act_start_chunk <= '0';
            act_mux_sel <= '0';
        
        else 
            
            if rising_edge(act_clk) then 
                    
                if act_soft_rst = '1' then 
                
                    act_start_init <= '0';
                    act_start_chunk <= '0';
                    act_mux_sel <= '0';
                
                else 
                                
                    if act_start = '0' and act_done_chunk = '0' then 
                        
                        act_start_init <= '0';
                        act_start_chunk <= '0';
                        act_mux_sel <= '0';
                    
                    elsif act_start = '1' and act_done_chunk = '0' then 
            
                        act_start_init <= '0';
                        act_start_chunk <= '1';
                        act_mux_sel <= '0';
                        
                    elsif act_start = '1' and act_done_chunk = '1' then 
            
                        act_start_init <= '1';
                        act_start_chunk <= '0';
                        act_mux_sel <= '1';
            
                    else 
                    
                        act_start_init <= '0';
                        act_start_chunk <= '0';
                        act_mux_sel <= '0';
                    
                    end if;
                end if;
            end if;
        end if;
        
    end process;
end structural;
