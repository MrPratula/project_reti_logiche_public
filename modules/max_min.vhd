library ieee;
use ieee.std_logic_1164.all;

entity max_min is
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
end max_min;

architecture structural of max_min is

signal s_en_max : std_logic;
signal s_max : std_logic_vector(7 downto 0);
signal s_en_min : std_logic;
signal s_min : std_logic_vector(7 downto 0);

-- registro 8 bit
component register_8_bit is
port(
        reg8_in : in std_logic_vector(7 downto 0);
        reg8_en : in std_logic;
        reg8_rst: in std_logic;
                reg8_soft_rst: in std_logic;

        reg8_clk: in std_logic;
        
        reg8_out: out std_logic_vector(7 downto 0)
    );
end component;

-- comparatore check max
component check_max is
 port (
        cmax_curr_max : in std_logic_vector(7 downto 0);
        cmax_data : in std_logic_vector(7 downto 0);
        cmax_count : in std_logic_vector(15 downto 0);
        cmax_chunk : in std_logic_vector(15 downto 0);
        
        cmax_en_max : out std_logic
    );
end component;

-- comparatore check_min
component check_min is
 port (
        cmin_curr_min : in std_logic_vector(7 downto 0);
        cmin_data : in std_logic_vector(7 downto 0);
        cmin_count : in std_logic_vector(15 downto 0);
        cmin_chunk : in std_logic_vector(15 downto 0);
        
        cmin_en_min : out std_logic
    );
end component;

begin

    r_max : register_8_bit
        port map (
            reg8_in => mm_data, 
            reg8_en => s_en_max, 
            reg8_clk => mm_clk, 
            reg8_rst => mm_rst,
            reg8_soft_rst => mm_soft_rst,

            reg8_out => s_max
        );
    
    r_min : register_8_bit
        port map (
            reg8_in => mm_data, 
            reg8_en => s_en_min, 
            reg8_clk => mm_clk, 
            reg8_rst => mm_rst,
            reg8_soft_rst => mm_soft_rst,

            reg8_out => s_min
        );
    
    c_max : check_max
        port map (
            cmax_data => mm_data,
            cmax_curr_max => s_max,
            cmax_en_max => s_en_max,
            cmax_chunk => mm_chunk,
            cmax_count => mm_count
        );
    
    c_min : check_min
        port map (
            cmin_data => mm_data,
            cmin_curr_min => s_min,
            cmin_en_min => s_en_min,
            cmin_chunk => mm_chunk,
            cmin_count => mm_count
        );
    
    mm_max <= s_max;
    mm_min <= s_min;

end structural;