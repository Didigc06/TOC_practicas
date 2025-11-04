----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2025 06:41:53 PM
-- Design Name: 
-- Module Name: cerrojo - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cerrojo is
  Port (
    rst : IN  std_logic;
    clk	: IN  std_logic;
    boton : IN  std_logic;
    clave : IN  std_logic_vector (7 DOWNTO 0);
    bloqueado : OUT std_logic_vector (15 DOWNTO 0);
    display : OUT std_logic_vector (6 DOWNTO 0);
    s_display : OUT std_logic_vector (3 DOWNTO 0)
  );
end cerrojo;

architecture Behavioral of cerrojo is
    COMPONENT debouncer
    port (
    rst: IN std_logic;
    clk: IN std_logic;
    x: IN std_logic;
    xDeb: OUT std_logic;
    xDebFallingEdge: OUT std_logic;
    xDebRisingEdge: OUT std_logic
    );
    END COMPONENT;
    COMPONENT conv_7seg
    port (
    x : in  STD_LOGIC_VECTOR (3 downto 0);
    display : out  STD_LOGIC_VECTOR (6 downto 0)
    );
    END COMPONENT;
    
    signal boton_deb, boton_rise : std_logic;
    signal clave_guardada : std_logic_vector(7 downto 0) := (others => '0');
    signal intentos_reg : std_logic_vector(1 downto 0) := "11";  
    signal bloqueado_reg : std_logic := '0';
    signal clave_almacenada : std_logic := '0';
    signal eq : std_logic;
    signal intentos4bits : std_logic_vector(3 downto 0);
    
begin
debouncer_map: debouncer
    port map (
        rst => rst,
        clk => clk,
        x => boton,
        xDeb => boton_deb,
        xDebFallingEdge => open,
        xDebRisingEdge => boton_rise
    );
    eq <= '1' when clave = clave_guardada else '0';
     process(clk, rst)
    begin
        if rst = '1' then
            clave_guardada <= (others => '0');
            clave_almacenada <= '0';
            intentos_reg <= "11";  -- 3 intentos
            bloqueado_reg <= '0';
        elsif rising_edge(clk) then
            if boton_rise = '1' then
                if clave_almacenada = '0' then
                    -- Primer botón: guardar clave
                    clave_guardada   <= clave;
                    clave_almacenada <= '1';
                elsif bloqueado_reg = '0' then
                    if clave_guardada = clave then
                        -- Clave correcta
                        bloqueado_reg <= '0';
                        intentos_reg  <= "11";  -- restablece intentos
                    else
                        -- Clave incorrecta
                        if intentos_reg = "11" then
                            intentos_reg <= "10";
                        elsif intentos_reg = "10" then
                            intentos_reg <= "01";
                        else 
                            intentos_reg <= "00";
                            bloqueado_reg <= '1';  -- bloqueo permanente

                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    
end Behavioral;
