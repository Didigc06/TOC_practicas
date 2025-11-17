----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/17/2025 09:59:41 PM
-- Design Name: 
-- Module Name: tragaperrasASM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tragaperrasASM is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           inicio : in STD_LOGIC;
           fin : in STD_LOGIC;
           opCodeleds : out STD_LOGIC_VECTOR (2 downto 0);
           ruleta01 : out STD_LOGIC_VECTOR (3 downto 0);
           ruleta02 : out STD_LOGIC_VECTOR (3 downto 0));
end tragaperrasASM;

architecture Behavioral of tragaperrasASM is

begin


end Behavioral;
