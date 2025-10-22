library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball_movement is
    Port (
        clk  : in STD_LOGIC;
        --clock100MHz : in STD_LOGIC; -- Reloj mal instanciado correccion mas adelante
        reset: in STD_LOGIC;
        game_paused: in STD_LOGIC;
        game_start : in STD_LOGIC;
        game_over : in STD_LOGIC;
        collision_left  : in STD_LOGIC;
        collision_right : in STD_LOGIC;
        collision_top   : in STD_LOGIC;
        collision_bottom: in STD_LOGIC;
        ball_x : out integer range 0 to 99; -- Debe ser Hex 4bits
        ball_y : out integer range 0 to 96; --
        ball_x_tens : out std_logic_vector(3 downto 0);-- Variables convertidas para el display 
        ball_x_units: out std_logic_vector(3 downto 0);
        ball_y_tens : out std_logic_vector(3 downto 0);
        ball_y_units: out std_logic_vector(3 downto 0);-- Variables...
        ball_moving: out STD_LOGIC;
        score_left : out STD_LOGIC; -- Señal hacia: score.vhd - code_5
        score_right: out STD_LOGIC  -- Señal hacia: score.vhd - code_6
    );
end ball_movement;

architecture Behavioral of ball_movement is
    
    signal ball_x_int : integer range 0 to 99 := 50;
    signal ball_y_int : integer range 0 to 96 := 48;
    
    -- Velocidades con más rango para mejores ángulos
    signal dx : integer range -3 to 3 := 0;
    signal dy : integer range -3 to 3 := 0;
    
--    signal movement_counter : integer range 0 to 50000 := 0;
--    constant MOVEMENT_DELAY : integer := 25000;
--    signal movement_tick : STD_LOGIC := '0';
    
    type ball_state_type is (WAITING, MOVING, SCORING, RESETTING);
    signal ball_state : ball_state_type := WAITING;
    
    signal lfsr : STD_LOGIC_VECTOR(15 downto 0) := "1010110011101001";
    signal score_timer : integer range 0 to 1000000 := 0;
    constant SCORE_DELAY : integer := 500000;

    constant ANGLE_0   : integer := 0;   -- Horizontal derecha: dx=1, dy=0
    constant ANGLE_30  : integer := 1;   -- 30°: dx=2, dy=-1
    constant ANGLE_45  : integer := 2;   -- 45°: dx=1, dy=-1
    constant ANGLE_60  : integer := 3;   -- 60°: dx=1, dy=-2
    constant ANGLE_120 : integer := 4;   -- 120°: dx=-1, dy=-2
    constant ANGLE_135 : integer := 5;   -- 135°: dx=-1, dy=-1
    constant ANGLE_150 : integer := 6;   -- 150°: dx=-2, dy=-1
    constant ANGLE_180 : integer := 7;   -- Horizontal izquierda: dx=-1, dy=0
    
    component SlowClock is
        Port ( fastClock : in STD_LOGIC;
               slowClock : inout STD_LOGIC;
               prescaler : in INTEGER RANGE 0 TO 50000000);
    end component SlowClock;

   signal ball_clock_slow : STD_LOGIC;

begin
    ball_clock: SlowClock -- Instanciar el slowClock para la bola
        port map(
        fastClock => clk,
        slowClock => ball_clock_slow ,
        prescaler => 833333  -- Para 60 Hz
    );
    
    ball_x <= ball_x_int;
    ball_y <= ball_y_int;
    ball_moving <= '1' when ball_state = MOVING else '0';

    -- Generador de números pseudoaleatorios
    process(clk)
    begin
        if rising_edge(clk) then
            lfsr <= lfsr(14 downto 0) & (lfsr(15) xor lfsr(14) xor lfsr(12) xor lfsr(3));
        end if;
    end process;
    
    -- Proceso para convertir las unidades de la posicion de la bola y generar la salida para el 'display_controller'
    process(ball_x_int, ball_y_int)
    begin
        ball_x_tens  <= std_logic_vector(to_unsigned( ball_x_int/10, 	 4 ));
        ball_x_units <= std_logic_vector(to_unsigned( ball_x_int mod 10, 4 ));
        ball_y_tens  <= std_logic_vector(to_unsigned( ball_y_int/10, 	 4 ));
        ball_y_units <= std_logic_vector(to_unsigned( ball_y_int mod 10, 4 ));
    end process;

    -- Máquina de estados principal CORREGIDA
    process(clk, reset)
        variable new_x, new_y : integer;
        variable rand_idx : integer;
    begin
        if reset = '1' then
            ball_state <= WAITING;
            ball_x_int <= 50;
            ball_y_int <= 48;
            dx <= 0;
            dy <= 0;
            score_left  <= '0';
            score_right <= '0';
            score_timer <= 0;
            
        elsif rising_edge(clk) then
            score_left <= '0';
            score_right <= '0';
            
            case ball_state is
                
                when WAITING =>
                    if game_start = '1' then
                        ball_state <= MOVING;
                        -- Inicializar con ángulo aleatorio (INCLUYendo horizontales)
                        rand_idx := to_integer(unsigned(lfsr(2 downto 0))) mod 8;
                        case rand_idx is
                            when ANGLE_0 =>   dx <= 1;  dy <= 0;   -- 0° horizontal derecha
                            when ANGLE_30 =>  dx <= 2;  dy <= -1;  -- 30°
                            when ANGLE_45 =>  dx <= 1;  dy <= -1;  -- 45°
                            when ANGLE_60 =>  dx <= 1;  dy <= -2;  -- 60°
                            when ANGLE_120 => dx <= -1; dy <= -2;  -- 120°
                            when ANGLE_135 => dx <= -1; dy <= -1;  -- 135°
                            when ANGLE_150 => dx <= -2; dy <= -1;  -- 150°
                            when ANGLE_180 => dx <= -1; dy <= 0;   -- 180° horizontal izquierda
                            when others =>    dx <= 1;  dy <= 0;   -- Default
                        end case;
                        ball_x_int <= 40 + to_integer(unsigned(lfsr(6 downto 0))) mod 20;
                        ball_y_int <= 38 + to_integer(unsigned(lfsr(6 downto 0))) mod 20;
                    end if;
                
                when MOVING =>
                    if game_paused = '1' then
                        null;
                    elsif ball_clock_slow = '1' then
                        new_x := ball_x_int + dx;
                        new_y := ball_y_int + dy;
                        
                        -- Manejar colisiones con paredes superior/inferior 
                        -- (LOS MOVIMIENTOS HORIZONTALES PUROS NO CAMBIAN)
                        if collision_top = '1' or collision_bottom = '1' then
                            -- SOLO los ángulos con componente vertical cambian
                            -- Los horizontales puros (dy=0) se mantienen igual
                            if dy /= 0 then
                                dy <= -dy; -- Invertir componente vertical para rebote
                            end if;
                            
                            -- Corregir posición
                            if collision_top = '1' then
                                new_y := 1;
                            else
                                new_y := 95;
                            end if;
                        end if;
                        
                        -- Manejar colisiones con jugadores (rebotes aleatorios)
                        if collision_left = '1' then
                           -- Rebote del jugador izquierdo: ángulo aleatorio hacia derecha
                            -- TODOS los ángulos menos 90° vertical (dy = -1, dx = 0)
                            rand_idx := to_integer(unsigned(lfsr(2 downto 0))) mod 7; -- 7 ángulos posibles
                            case rand_idx is
                                when 0 => dx <= 1;  dy <= 0;   -- 0° horizontal derecha
                                when 1 => dx <= 2;  dy <= -1;  -- 30° 
                                when 2 => dx <= 1;  dy <= -1;  -- 45°
                                when 3 => dx <= 1;  dy <= -2;  -- 60°
                                when 4 => dx <= 1;  dy <= 1;   -- 45° abajo (complementario de 45° arriba)
                                when 5 => dx <= 2;  dy <= 1;   -- 30° abajo (complementario de 30° arriba)
                                when 6 => dx <= 1;  dy <= 2;   -- 60° abajo (complementario de 60° arriba)
                                when others => dx <= 1; dy <= 0;
                            end case;
                            
                        elsif collision_right = '1' then
                            -- Rebote del jugador derecho: ángulo aleatorio hacia izquierda  
                            -- TODOS los ángulos menos 90° vertical (dy = -1, dx = 0)
                            rand_idx := to_integer(unsigned(lfsr(2 downto 0))) mod 7; -- 7 ángulos posibles
                            case rand_idx is
                                when 0 => dx <= -1; dy <= 0;   -- 180° horizontal izquierda
                                when 1 => dx <= -2; dy <= -1;  -- 150°
                                when 2 => dx <= -1; dy <= -1;  -- 135°
                                when 3 => dx <= -1; dy <= -2;  -- 120°
                                when 4 => dx <= -1; dy <= 1;   -- 135° abajo (complementario de 135° arriba)
                                when 5 => dx <= -2; dy <= 1;   -- 150° abajo (complementario de 150° arriba)
                                when 6 => dx <= -1; dy <= 2;   -- 120° abajo (complementario de 120° arriba)
                                when others => dx <= -1; dy <= 0;
                            end case;
                        end if;
                        
                        -- Detectar goles (cuando la bola pasa a los jugadores)
                        if new_x <= 0 then
                            score_right <= '1';
                            ball_state <= SCORING;
                            score_timer <= 0;
                        elsif new_x >= 99 then
                            score_left <= '1';
                            ball_state <= SCORING;
                            score_timer <= 0;
                        else
                            ball_x_int <= new_x;
                            ball_y_int <= new_y;
                        end if;
                    end if;
                
                when SCORING =>
                    if score_timer >= SCORE_DELAY then -- Resetear posición de la bola
                        ball_x_int <= 40 + to_integer(unsigned(lfsr(6 downto 0))) mod 20;
                        ball_y_int <= 38 + to_integer(unsigned(lfsr(6 downto 0))) mod 20;
                        -- Reiniciar con ángulo aleatorio (INCLUYENDO horizontales)
                        rand_idx := to_integer(unsigned(lfsr(2 downto 0))) mod 8;
                        case rand_idx is
                            when ANGLE_0 =>   dx <= 1;  dy <= 0;
                            when ANGLE_30 =>  dx <= 2;  dy <= -1;
                            when ANGLE_45 =>  dx <= 1;  dy <= -1;
                            when ANGLE_60 =>  dx <= 1;  dy <= -2;
                            when ANGLE_120 => dx <= -1; dy <= -2;
                            when ANGLE_135 => dx <= -1; dy <= -1;
                            when ANGLE_150 => dx <= -2; dy <= -1;
                            when ANGLE_180 => dx <= -1; dy <= 0;
                            when others =>    dx <= 1;  dy <= 0;
                        end case;
                        ball_state <= MOVING;
                    else
                        score_timer <= score_timer + 1;
                    end if;
                    
                when RESETTING =>
                    null;
                    
            end case;
        end if;
    end process;

end Behavioral;