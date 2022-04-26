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