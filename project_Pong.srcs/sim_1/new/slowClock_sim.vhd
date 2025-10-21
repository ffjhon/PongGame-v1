library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SlowClock is
    Port ( 
        fastClock : in STD_LOGIC;
        slowClock : inout STD_LOGIC;
        prescaler : in INTEGER RANGE 0 TO 50000000
    );
end SlowClock;

architecture Behavioral of SlowClock is
    signal counter : integer range 0 to 50000000 := 0;
    signal slow_signal : STD_LOGIC := '0';
begin
    process(fastClock)
    begin
        if rising_edge(fastClock) then
            -- Para simulacion: usar prescaler reducido
            -- Para sintesis: usar el prescaler normal
            if counter >= 1000 then  -- ¡RÁPIDO para simulación!
                slow_signal <= not slow_signal;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    slowClock <= slow_signal;
end Behavioral;