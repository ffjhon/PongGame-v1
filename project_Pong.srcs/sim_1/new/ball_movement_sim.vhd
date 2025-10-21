library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball_movement_sim is
end ball_movement_sim;

architecture Behavioral of ball_movement_sim is

    component ball_movement is
        Port (
            clk  : in STD_LOGIC;
            clock100MHz : in STD_LOGIC;
            reset: in STD_LOGIC;
            game_paused: in STD_LOGIC;
            game_start : in STD_LOGIC;
            collision_left  : in STD_LOGIC;
            collision_right : in STD_LOGIC;
            collision_top   : in STD_LOGIC;
            collision_bottom: in STD_LOGIC;
            ball_x : out integer range 0 to 99;
            ball_y : out integer range 0 to 96;
            ball_moving: out STD_LOGIC;
            score_left : out STD_LOGIC;
            score_right: out STD_LOGIC
        );
    end component;

    -- Testbench Signals
    signal clk_100MHz : STD_LOGIC := '0';
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal game_paused : STD_LOGIC := '0';
    signal game_start : STD_LOGIC := '0';
    signal collision_left : STD_LOGIC := '0';
    signal collision_right : STD_LOGIC := '0';
    signal collision_top : STD_LOGIC := '0';
    signal collision_bottom : STD_LOGIC := '0';
    signal ball_x : integer range 0 to 99;
    signal ball_y : integer range 0 to 96;
    signal ball_moving : STD_LOGIC;
    signal score_left : STD_LOGIC;
    signal score_right : STD_LOGIC;

    -- Clock period definitions
    constant CLK_100MHz_PERIOD : time := 10 ns;
    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ball_movement
        port map (
            clk => clk,
            clock100MHz => clk_100MHz,
            reset => reset,
            game_paused => game_paused,
            game_start => game_start,
            collision_left => collision_left,
            collision_right => collision_right,
            collision_top => collision_top,
            collision_bottom => collision_bottom,
            ball_x => ball_x,
            ball_y => ball_y,
            ball_moving => ball_moving,
            score_left => score_left,
            score_right => score_right
        );

    -- Clock generation
    clk_100MHz_process : process
    begin
        while true loop
            clk_100MHz <= '0';
            wait for CLK_100MHz_PERIOD/2;
            clk_100MHz <= '1';
            wait for CLK_100MHz_PERIOD/2;
        end loop;
    end process;

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Main test stimulus
    stim_proc: process
    begin
        report "=== INICIANDO SIMULACION ===";
        
        -- Reset inicial
        report "Aplicando reset...";
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 50 ns;
        
        report "Reset completado - Estado: WAITING";
        
        -- Test 1: Iniciar juego
        report "=== TEST 1: INICIANDO JUEGO ===";
        game_start <= '1';
        wait for 100 ns;
        game_start <= '0';
        
        -- Esperar primer movimiento (puede tomar hasta 16.67ms)
        wait for 20 ms;
        
        if ball_moving = '1' then
            report "Pelota en movimiento - Posicion: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
        else
            report "ERROR: Pelota no se movio" severity error;
        end if;
        
        -- Observar movimiento natural
        report "Observando movimiento por 100 ms...";
        wait for 100 ms;
        report "Posicion despues 100ms: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
        
        -- Test 2: Colision con pared superior
        report "=== TEST 2: COLISION SUPERIOR ===";
        collision_top <= '1';
        wait for 100 ns;
        collision_top <= '0';
        wait for 50 ms;  -- Esperar suficiente tiempo para ver el rebote
        report "Posicion despues colision superior: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
        
        -- Test 3: Colision con pared inferior
        report "=== TEST 3: COLISION INFERIOR ===";
        collision_bottom <= '1';
        wait for 100 ns;
        collision_bottom <= '0';
        wait for 50 ms;
        report "Posicion despues colision inferior: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
        
        -- Test 4: Colision con paleta izquierda
        report "=== TEST 4: COLISION IZQUIERDA ===";
        collision_left <= '1';
        wait for 100 ns;
        collision_left <= '0';
        wait for 50 ms;
        report "Posicion despues colision izquierda: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
        
        -- Test 5: Colision con paleta derecha
        report "=== TEST 5: COLISION DERECHA ===";
        collision_right <= '1';
        wait for 100 ns;
        collision_right <= '0';
        wait for 50 ms;
        report "Posicion despues colision derecha: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
        
        report "=== SIMULACION COMPLETADA ===";
        
        wait;
    end process;

    -- Monitoreo de movimiento
    monitor_proc: process
        variable last_x : integer := -1;
        variable last_y : integer := -1;
        variable move_count : integer := 0;
    begin
        wait until rising_edge(clk);
        
        if ball_x /= last_x or ball_y /= last_y then
            move_count := move_count + 1;
            report "Movimiento #" & integer'image(move_count) & " - Tiempo: " & time'image(now) & 
                   " - Posicion: (" & integer'image(ball_x) & ", " & integer'image(ball_y) & ")";
            last_x := ball_x;
            last_y := ball_y;
        end if;
        
        if score_left = '1' then
            report "*** GOL IZQUIERDO! *** - Tiempo: " & time'image(now);
        end if;
        
        if score_right = '1' then
            report "*** GOL DERECHO! *** - Tiempo: " & time'image(now);
        end if;
    end process;

end Behavioral;