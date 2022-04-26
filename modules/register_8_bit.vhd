-- registro 8 bit sincrono che scrive solo se en=1 con reset asincrono

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
