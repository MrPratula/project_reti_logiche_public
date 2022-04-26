library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity initializer is
    port (
        init_i_rst : in std_logic;
        init_i_clk : in std_logic;
        init_i_start : in std_logic;
        
        init_o_rst : out std_logic;
        init_o_start : out std_logic
    );
end initializer;

architecture structural of initializer is

    signal start_dly1 : std_logic;
    signal start_dly2 : std_logic;
    signal start_dly3 : std_logic;
    signal start_inv_dly2 : std_logic;
    signal start_inv_dly3 : std_logic;

begin

    process (init_i_clk, init_i_rst)
    begin
    
        if init_i_rst = '1' then
            
            start_dly1 <= '0';
            start_dly2 <= '0';
            start_dly3 <= '0';
            start_inv_dly2 <= '0';
            start_inv_dly3 <= '0';

        elsif rising_edge(init_i_clk) then
            
            start_dly1 <= init_i_start;
            start_dly2 <= start_dly1;
            start_dly3 <= start_dly2;
            start_inv_dly2 <= not start_dly1;
            start_inv_dly3 <=  start_inv_dly2;
        
        end if;
    end process;
        
    init_o_rst <= start_dly1 and start_inv_dly3;
    init_o_start <= start_dly3;

end structural;

architecture fsm of initializer is 
    type state is (s0, s1, s2, s3, s4);
    signal curr_state : state;
    signal next_state : state;
    
    begin
        
    process (init_i_clk, init_i_rst)
        begin
        
        if init_i_rst = '1' then 
            curr_state <= s0;
        elsif rising_edge(init_i_clk) then 
            curr_state <= next_state;
        end if;
    end process;
   
    process (curr_state, init_i_start)
        begin
        
        case curr_state is
            when s0 => init_o_start <= '0'; init_o_rst <= '0'; if init_i_start = '1' then next_state <= s1; else next_state <= s0; end if;
            when s1 => init_o_start <= '0'; init_o_rst <= '1'; if init_i_start = '1' then next_state <= s2; else next_state <= s0; end if;
            when s2 => init_o_start <= '0'; init_o_rst <= '1'; if init_i_start = '1' then next_state <= s3; else next_state <= s0; end if;
            when s3 => init_o_start <= '1'; init_o_rst <= '0'; if init_i_start = '1' then next_state <= s3; else next_state <= s4; end if;
            when s4 => init_o_start <= '1'; init_o_rst <= '0'; next_state <= s0;
        end case;
    end process;
end fsm;