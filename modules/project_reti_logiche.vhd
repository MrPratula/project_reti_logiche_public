library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port ( 
        i_start : in STD_LOGIC;
        i_data : in STD_LOGIC_VECTOR (7 downto 0);
        i_clk : in STD_LOGIC;
        i_rst : in STD_LOGIC;
        
        o_address : out STD_LOGIC_VECTOR (15 downto 0);
        o_data : out STD_LOGIC_VECTOR (7 downto 0);
        o_en : out STD_LOGIC;
        o_we : out STD_LOGIC;
        o_done : out STD_LOGIC
    );

end project_reti_logiche;

architecture structural of project_reti_logiche is

signal s_count : std_logic_vector(15 downto 0);
signal s_chunk : STD_LOGIC_VECTOR (15 downto 0);
signal s_max :  std_logic_vector(7 downto 0);
signal s_min :  std_logic_vector(7 downto 0);
signal s_shift_en :  std_logic;
signal s_soft_rst : std_logic;
signal s_start : std_logic;

signal s_done : std_logic;
signal s_counter_en : std_logic;

signal s_mux1 : STD_LOGIC_VECTOR (15 downto 0);
signal s_mux2 : STD_LOGIC_VECTOR (15 downto 0);
signal s_mux_sel : std_logic;

signal s_start_init : std_logic;
signal s_start_chunk : std_logic;

signal s_chunk_done : std_logic;
signal s_dirty_rst: std_logic;

component activator is
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
    end component;

component initializer is
    port (
        init_i_rst : in std_logic;
        init_i_clk : in std_logic;
        init_i_start : in std_logic;
        
        init_o_rst : out std_logic;
        init_o_start : out std_logic
    );
    end component;

component chunk_maker is
    port (
        chunk_start : in STD_LOGIC;
        chunk_clk : in STD_LOGIC;
        chunk_rst : in STD_LOGIC;
        chunk_soft_rst : in STD_LOGIC;
        chunk_data : in std_logic_vector (7 downto 0);
        
        chunk_done : out STD_LOGIC;
        chunk_chunk : out STD_LOGIC_VECTOR (15 downto 0);
        chunk_address : out std_logic_vector (15 downto 0)
    );
    end component;

component counter_16_bit is
    port(
        counter_clk : in std_logic;
        counter_rst : in std_logic;
        counter_soft_rst : in std_logic;
        counter_en : in std_logic;
        
        counter_count : out std_logic_vector(15 downto 0)
    );
end component;

component address_requester is
    port (
        req_rst : in std_logic;
        req_soft_rst : in std_logic;
        req_clk : in std_logic;
        req_count : in STD_LOGIC_VECTOR (15 downto 0);
        req_chunk : in STD_LOGIC_VECTOR (15 downto 0);
        
        req_addr : out STD_LOGIC_VECTOR (15 downto 0)
    );
end component;
    
component max_min is
    port(
        mm_data : in std_logic_vector(7 downto 0);
        mm_clk : in std_logic;
        mm_rst : in std_logic;
        mm_soft_rst : in std_logic;
        mm_count : in STD_LOGIC_VECTOR (15 downto 0);
        mm_chunk : in STD_LOGIC_VECTOR (15 downto 0);
        
        mm_max: out std_logic_vector(7 downto 0);
        mm_min: out std_logic_vector(7 downto 0)
    );
end component;

component shift_pixel is
    Port ( 
        shift_max_pixel : in STD_LOGIC_VECTOR (7 downto 0);
        shift_min_pixel : in STD_LOGIC_VECTOR (7 downto 0);
        shift_data : in STD_LOGIC_VECTOR (7 downto 0);
        
        shift_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end component;

component big_brain is
    port (
        bb_clk : in std_logic;
        bb_start : in STD_LOGIC;
        bb_rst : in STD_LOGIC;
        bb_soft_rst : in STD_LOGIC;
        bb_count : in STD_LOGIC_VECTOR (15 downto 0);
        bb_chunk : in STD_LOGIC_VECTOR (15 downto 0);

        bb_we : out STD_LOGIC;
        bb_done : out STD_LOGIC
    );
end component;

component mux_2_in is
    port(
        mux_in1 : in std_logic_vector(15 downto 0);
        mux_in2 : in std_logic_vector(15 downto 0);
        mux_sel : in std_logic;
        
        mux_out : out std_logic_vector(15 downto 0)
    );
end component;






begin
    
    
    act : activator 
        port map (
            act_done_chunk => s_chunk_done,
            act_start => i_start,
            act_rst => i_rst,
            act_soft_rst => s_done,
            act_clk => i_clk,
            
            act_start_init => s_start_init,
            act_start_chunk => s_start_chunk,
            act_mux_sel => s_mux_sel
        );
            
    chunk_calculator : chunk_maker
        port map (
            chunk_start =>  s_start_chunk,
            chunk_clk =>    i_clk,
            chunk_rst =>    i_rst,
            chunk_soft_rst => s_done,
            chunk_data =>   i_data,
            
            chunk_done =>   s_chunk_done,
            chunk_chunk =>  s_chunk,
            chunk_address => s_mux1
        );        

    init : 
        entity work.initializer (fsm)
        port map(
            init_i_clk => i_clk,
            init_i_rst => i_rst,
            init_i_start => s_start_init,
            
            init_o_rst => s_soft_rst,
            init_o_start => s_start
        );
    s_counter_en <= s_start and not s_done;

    counter : counter_16_bit
        port map(
            counter_clk => i_clk,
            counter_rst => i_rst,
            counter_soft_rst => s_done,
            counter_en => s_counter_en,
            counter_count => s_count
        );
    
    requester: address_requester
        port map(
            req_rst => i_rst,
            req_soft_rst => s_soft_rst,
            req_clk => i_clk,
            req_count => s_count,
            req_chunk => s_chunk,
            req_addr => s_mux2 
        );
    
    edges : max_min
        port map (
            mm_data => i_data,
            mm_clk => i_clk,
            mm_rst => i_rst,
            mm_soft_rst => s_soft_rst,
            mm_count => s_count,
            mm_chunk => s_chunk,
            mm_max => s_max,
            mm_min => s_min
        );
        
    shifter : shift_pixel
        port map (
            shift_data => i_data,
            shift_max_pixel => s_max,
            shift_min_pixel => s_min,
            shift_out => o_data
        );
        
    brian : big_brain
        port map(
            bb_start => s_start,
            bb_clk => i_clk,
            bb_rst => i_rst,
            bb_soft_rst => s_soft_rst,
            bb_count => s_count,
            bb_chunk => s_chunk,
            bb_we => o_we,
            bb_done => s_done            
        );
        
    mux : mux_2_in
        port map(
            mux_in1 => s_mux1,
            mux_in2 => s_mux2,
            mux_sel => s_mux_sel,
            
            mux_out => o_address
        );
        
    o_en <= '1';
    o_done <= s_done;
    
end structural;
