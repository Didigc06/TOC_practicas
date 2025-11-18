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
use IEEE.NUMERIC_STD.ALL;

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
    component divisor
        port (
            rst: in STD_LOGIC;
            clk: in STD_LOGIC; -- reloj de entrada de la entity superior
            cuenta_medio_segundo: out STD_LOGIC;
            cuenta_display1: out STD_LOGIC;
            cuenta_display2: out STD_LOGIC
        );
    end component;
    
    component contador_mod10
        port ( 
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           salida : out STD_LOGIC_VECTOR (3 downto 0)
        );
     end component;
     
    type states is (estado_reset, estado_contando, estado_resultado);
    signal estado_actual, estado_siguiente : states;
    
    signal clk_50ms, clk_fast1, clk_fast2 : STD_LOGIC;
    
    signal en_cont1, en_cont2 : STD_LOGIC;
    
    signal ruleta01_i, ruleta02_i : STD_LOGIC_VECTOR (3 downto 0);
    
    signal timer_5s_count : unsigned(3 downto 0) := (others => '0');
    signal timer_5s_en : STD_LOGIC;
    signal timer_5s_end : STD_LOGIC;
    
    signal ruletas_match : STD_LOGIC;
begin

    divisor_i: divisor
        port map (
            rst                  => rst,
            clk                  => clk,
            cuenta_medio_segundo => clk_50ms,
            cuenta_display1      => clk_fast1,
            cuenta_display2      => clk_fast2
        );

    contador1_i: contador_mod10
        port map (
            rst    => rst,
            clk    => clk_fast1,
            enable => en_cont1,
            salida => ruleta01_i
        );
        
    contador2_i: contador_mod10
        port map (
            rst    => rst,
            clk    => clk_fast2,
            enable => en_cont2,
            salida => ruleta02_i
        );
    
    ruleta01 <= ruleta01_i;
    ruleta02 <= ruleta02_i;
    ruletas_match <= '1' when (ruleta01_i = ruleta02_i) else '0';
    
    opCodeleds <= "100" when estado_actual = estado_reset else
              "000" when estado_actual = estado_contando else
              "010" when (estado_actual = estado_resultado and ruletas_match = '1') else
              "011" when (estado_actual = estado_resultado and ruletas_match = '0') else
              "000";
                      
    en_cont1 <= '1' when estado_actual = estado_contando else '0';
    en_cont2 <= '1' when estado_actual = estado_contando else '0';
    
    timer_5s_en <= '1' when estado_actual = estado_resultado else '0';
    
    process(rst, clk)
    begin
        if (rst = '1') then
            timer_5s_count <= (others => '0');
        elsif (rising_edge(clk)) then
            if (timer_5s_en = '1' and clk_50ms = '1') then
                if (timer_5s_count = 9) then
                    timer_5s_count <= (others => '0');
                else
                    timer_5s_count <= timer_5s_count + 1;
                end if;
            elsif (timer_5s_en = '0') then
                timer_5s_count <= (others => '0');
            end if;
        end if;
    end process;
    
    timer_5s_end <= '1' when (timer_5s_count = 9 and timer_5s_en = '1' and clk_50ms = '1') else '0';
    
    -- Registro de Estado (Secuencial)
    process(rst, clk)
    begin
        if (rst = '1') then
            estado_actual <= estado_reset;
        elsif (rising_edge(clk)) then
            estado_actual <= estado_siguiente;
        end if;
    end process;

    -- Lógica de Transición de Estados (Combinacional)
    process(estado_actual, inicio, fin, timer_5s_end)
    begin
        estado_siguiente <= estado_actual;

        case estado_actual is
            
            when estado_reset =>
                if (inicio = '1') then
                    estado_siguiente <= estado_contando;
                end if;

            when estado_contando =>
                if (fin = '1') then
                    estado_siguiente <= estado_resultado;
                end if;
            
            when estado_resultado =>
                if (timer_5s_end = '1') then
                    estado_siguiente <= estado_reset;
                end if;
                
            when others =>
                estado_siguiente <= estado_reset;
                
        end case;
    end process;

end Behavioral;
