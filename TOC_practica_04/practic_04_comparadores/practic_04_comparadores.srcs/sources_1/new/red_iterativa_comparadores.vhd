----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2025 05:59:16 PM
-- Design Name: 
-- Module Name: red_iterativa_comparadores - Behavioral
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

entity red_iterativa_comparadores is
    generic (
        num_bits    : natural := 4;
        num_entradas : natural := 4
    );
    port(
        X : in  std_logic_vector (num_entradas*num_bits-1 downto 0);
        S : out std_logic_vector (num_bits-1 downto 0)
    );
end red_iterativa_comparadores;

architecture Behavioral of red_iterativa_comparadores is
    
    component comparador is
        generic ( n : natural := 4 );
        port (
            A : in  std_logic_vector(n-1 downto 0);
            B : in  std_logic_vector(n-1 downto 0);
            S : out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    type array_bits is array (0 to num_entradas-1) 
        of std_logic_vector(num_bits-1 downto 0);
    signal C : array_bits;

begin
    C(0) <= X(num_bits-1 downto 0);
    
    gen_iterativa : for i in 1 to num_entradas-1 generate
    begin
        comparador_i : comparador
            generic map (
                n => num_bits
            )
            port map (
                A => C(i-1),  -- El máximo encontrado hasta la etapa anterior
                B => X((i+1)*num_bits-1 downto i*num_bits), -- El número de entrada actual (Xi)
                S => C(i)     -- La salida es el nuevo máximo
            );
    end generate gen_iterativa;
    
    S <= C(num_entradas-1);

end Behavioral;
