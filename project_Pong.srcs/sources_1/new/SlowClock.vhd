-- Fórmula: prescaler = (CLOCK_FREQ / (2 * DESIRED_FREQ)) - 1
-- Ejemplos para 100 MHz:
-- 60 Hz:   prescaler = (100000000 / (2 * 60))     = 833,333
-- 30 Hz:   prescaler = (100000000 / (2 * 30))     = 1,666,666  
-- 10 Hz:   prescaler = (100000000 / (2 * 10))     = 5,000,000
--  1 Hz:   prescaler = (100000000 / (2 * 1))      = 50,000,000
--0.5 Hz:   prescaler = (100000000 / (2 * 0.5))    = 100,000,000
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SlowClock is
    Port (
        fastClock : in  STD_LOGIC;                     -- Reloj de entrada (100 MHz)
        slowClock : out STD_LOGIC;                     -- Señal lenta de salida
        prescaler : in  INTEGER RANGE 0 TO 50000000    -- Factor de división
    );
end SlowClock;

architecture Behavioral of SlowClock is
    signal slowClock_i : STD_LOGIC := '0'; -- inicialización obligatoria
begin
    slowClockProcess: process(fastClock)
        variable countFastCycles : INTEGER range 0 to 50000000 := 0; -- inicializada
    begin
        if rising_edge(fastClock) then
            countFastCycles := countFastCycles + 1;
            if countFastCycles >= prescaler then
                slowClock_i <= not slowClock_i;
                countFastCycles := 0;
            end if;
        end if;
    end process;

    -- salida limpia
    slowClock <= slowClock_i;
end Behavioral;
