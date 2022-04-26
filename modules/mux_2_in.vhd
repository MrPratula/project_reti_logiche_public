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
    
    
       
    
