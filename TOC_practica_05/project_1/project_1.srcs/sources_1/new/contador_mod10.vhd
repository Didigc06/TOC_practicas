----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2025 13:39:10
-- Design Name: 
-- Module Name: contador_mod10 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador_mod10 is
    Port ( 
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           salida : out STD_LOGIC_VECTOR (3 downto 0)
    );
end contador_mod10;

architecture Behavioral of contador_mod10 is
    signal count_val : unsigned(3 downto 0) := (others => '0');
    
begin

    process(rst, clk)
    begin
        if (rst = '1') then
            count_val <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                if (count_val = 9) then
                    count_val <= (others => '0');
                else
                    count_val <= count_val + 1;
                end if;
            end if;
        end if;
    end process;
    
    salida <= STD_LOGIC_VECTOR(count_val);

end Behavioral;
