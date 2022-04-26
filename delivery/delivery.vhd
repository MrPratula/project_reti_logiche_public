----------------------------------------------------------------
--
--  register_8_bit
--
----------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity register_8_bit is 
    port (
        reg8_in : in std_logic_vector(7 downto 0);
        reg8_en : in std_logic;
        reg8_rst: in std_logic;
        reg8_soft_rst: in std_logic;
        reg8_clk: in std_logic;
        
        reg8_out: out std_logic_vector(7 downto 0)
    );
end register_8_bit;

architecture structural of register_8_bit is
begin
    process(reg8_clk, reg8_rst)
    begin
        if reg8_rst = '1' then
            reg8_out <= (others => '0');

        elsif rising_edge(reg8_clk) and reg8_en = '1' then 
        
            if reg8_soft_rst = '1' then
                reg8_out <= (others => '0');
            else 
                reg8_out <= reg8_in;
                end if;
        end if;
    end process;
end structural;

----------------------------------------------------------------
--
--  check_max
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  check_min
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  activator
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  chunk_maker
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  initializer
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  counter_16_bit
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  address_requester
--
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity address_requester is
    port ( 
        req_rst : in std_logic;
        req_soft_rst : in std_logic;
        req_clk : in std_logic;
        req_count : in STD_LOGIC_VECTOR (15 downto 0);
        req_chunk : in STD_LOGIC_VECTOR (15 downto 0);
        
        req_addr : out STD_LOGIC_VECTOR (15 downto 0)
    );
end address_requester;

architecture structural of address_requester is

begin
    process(req_rst, req_clk)
    
    variable read_address : std_logic_vector(15 downto 0) := (1 => '1', others => '0');
    variable write_address : std_logic_vector(15 downto 0) := (others => '0');
    
        begin
        
        if (req_rst = '1') then 
            read_address := (1 => '1', others => '0');
            write_address := (others => '0');
            req_addr <= "0000000000000000";

        elsif rising_edge(req_clk) then 
        
            if req_soft_rst = '1' then
                read_address := (1 => '1', others => '0');
                write_address := (others => '0');
                req_addr <= "0000000000000000";
                  
            else
        
                if req_chunk = "0000000000000000" then 
                    req_addr <= req_count;
                    write_address := req_chunk +1;
                    
                elsif (req_count <= req_chunk ) then
                    req_addr <= req_count;
                    write_address := req_chunk +1;
                    
                elsif (req_count > req_chunk ) then
                    
                    if req_chunk(0) = '0' then 
                        if req_count(0) = '0' then 
                            req_addr <= read_address;
                            read_address := read_address +1;
                        else 
                            req_addr <= write_address;
                            write_address := write_address +1;
                        end if;
                    else 
                        if req_count(0) = '0' then 
                            req_addr <= write_address;
                            write_address := write_address +1;
                        else 
                            req_addr <= read_address;
                            read_address := read_address +1;
                        end if;

                    end if;

                end if;

            end if;
            
        end if;

    end process;

end structural;

----------------------------------------------------------------
--
--  max_min
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  shift_pixel
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  big_brain
--
----------------------------------------------------------------

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

----------------------------------------------------------------
--
--  mux_2_in
--
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_in is
    
    port(
    
        mux_in1 : in std_logic_vector(15 downto 0);
        mux_in2 : in std_logic_vector(15 downto 0);
        mux_sel : in std_logic;
        
        mux_out : out std_logic_vector(15 downto 0)
    );
end mux_2_in;

architecture dataflow of mux_2_in is

begin
    
    mux_out <=  mux_in1 when mux_sel = '0' else
                mux_in2;
                
end dataflow; 
    
----------------------------------------------------------------
--
--  project_reti_logiche
--
----------------------------------------------------------------

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