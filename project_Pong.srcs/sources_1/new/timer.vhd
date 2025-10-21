-- Módulo: timer
-- Función: Cuenta 2 minutos (120 segundos) usando un reloj dividido (1 Hz)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port (
        clk100MHz : in  STD_LOGIC;         -- Reloj principal de la FPGA
        reset     : in  STD_LOGIC;         -- Reset asíncrono, activo en '1'
        time_up   : out STD_LOGIC;         -- Señal de fin del temporizador
        sec_count : out INTEGER range 0 to 120  -- Segundos transcurridos (0-120)
    );
end timer;


architecture Behavioral of timer is
    
    signal slowClk   : STD_LOGIC := '0';            -- Señal interna del reloj lento (1 Hz)
    signal count_sec : INTEGER range 0 to 120 :=0; -- Contador interno de segundos

begin

    SlowClock_inst : entity work.SlowClock -- Instancia 
        port map (
            fastClock => clk100MHz,
            slowClock => slowClk,
            prescaler => 1--50000000    -- Divide 100 MHz -> 1 Hz
        );

    process(slowClk, reset)
    begin
        if reset = '1' then
            count_sec <= 0;
            time_up <= '0';
        elsif rising_edge(slowClk) then
            if count_sec < 120 then
                count_sec <= count_sec + 1;
                time_up <= '0';
            else
                count_sec <= 120;
                time_up <= '1';  -- Señal de fin (2 minutos)
            end if;
        end if;
    end process;

    sec_count <= count_sec; -- Salida del contador para depuración o visualización
    
end Behavioral;
