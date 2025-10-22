library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PongGame is
    Port (
        CLK100: in std_logic;
        ENTER : in std_logic;
        PAUSE : in std_logic;
        RST   : in std_logic; 
        DIR1  : in std_logic; 
        DIR2  : in std_logic;
        YR  : in std_logic; -- <- 
        YL  : in std_logic; -- <- 
        player_YL : out STD_LOGIC_VECTOR(15 downto 0); -- -> collision_detector
        An   : out STD_LOGIC_VECTOR(7 downto 0);
        Ka   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end PongGame;


architecture Behavioral of PongGame is
    component timer is -- 2min para finalizar
        Port (
            clk100MHz : in  STD_LOGIC; -- Reloj principal de la FPGA
            reset     : in  STD_LOGIC; -- Reset asíncrono, activo en '1'
            time_up   : out STD_LOGIC  -- Señal de fin del temporizador
        );
    end component timer;
    
    component ball_movement is
        Port (
            clk  : in STD_LOGIC;
            reset: in STD_LOGIC;
            game_paused: in STD_LOGIC;
            game_start : in STD_LOGIC;
            game_over  : in STD_LOGIC;
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
    end component ball_movement;
    
    component collision_detector is
        Port (
            clk : in STD_LOGIC;
            ball_x : in integer range 0 to 99; -- Posicion de la bola
            ball_y : in integer range 0 to 96;
            player_left_y  : in unsigned (3 downto 0);
            player_right_y : in unsigned (3 downto 0);
            collision_left  : out STD_LOGIC; -- Salidas de colisión
            collision_right : out STD_LOGIC;
            collision_top   : out STD_LOGIC;
            collision_bottom: out STD_LOGIC
        );
    end component collision_detector;
    
    component player_move_YL is
        Port (YL  : in std_logic;
              DIR : in std_logic;
              RST : in std_logic;
              CLK : in std_logic;
              player_YL : out STD_LOGIC_VECTOR(15 downto 0);
              player_YL_pos : out unsigned (3 downto 0)
        );
    end component player_move_YL;
    
    component player_move_YR is
        Port (YR  : in std_logic;
              DIR : in std_logic;
              RST : in std_logic;
              CLK : in std_logic;
              pos_YR_ten : out STD_LOGIC_VECTOR (3 downto 0);
              pos_YR_uni : out STD_LOGIC_VECTOR (3 downto 0);
              player_YR  : out unsigned (3 downto 0) --player_YR  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component player_move_YR;
    
    component score_manager is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            game_start : in STD_LOGIC;
            game_paused : in STD_LOGIC;
            game_over : in STD_LOGIC;
            score_left_in  : in STD_LOGIC; -- Señal desde: ball_movement
            score_right_in : in STD_LOGIC; -- Señal desde: ball_movement
            score_player_a : out STD_LOGIC_VECTOR(3 downto 0);
            score_player_b : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component score_manager;
    
    component display_controller is
        Port(
            clock100MHz : in std_logic;
            num1 : in STD_LOGIC_VECTOR(3 downto 0); -- entrada desde 'ball_movement.vhd' entero, convertir a Hex
            num2 : in STD_LOGIC_VECTOR(3 downto 0);
            num3 : in STD_LOGIC_VECTOR(3 downto 0);
            num4 : in STD_LOGIC_VECTOR(3 downto 0);
            num5 : in STD_LOGIC_VECTOR(3 downto 0);
            num6 : in STD_LOGIC_VECTOR(3 downto 0);
            num7 : in STD_LOGIC_VECTOR(3 downto 0);
            num8 : in STD_LOGIC_VECTOR(3 downto 0);
            An   : out STD_LOGIC_VECTOR(7 downto 0);
            Ka   : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component display_controller; 

    signal fin : STD_LOGIC;
    signal aux1,aux2,aux3,aux4,aux5,aux6,aux7,aux8 : STD_LOGIC_VECTOR (3 downto 0); -- Valores para los Display 7Seg
    
    signal aux_score_a, aux_score_b : STD_LOGIC;
    signal aux_ball_x, aux_ball_y : integer RANGE 0 to 99;
    signal aux_collision_left, aux_collision_right, aux_collision_top, aux_collision_bottom : STD_LOGIC;
    signal aux_player_left_y, aux_player_right_y : unsigned (3 downto 0);

begin
    
    Temporizador : timer port map (
        clk100MHz => CLK100,
        reset     => RST,
        time_up   => fin
    );
    
    Bola : ball_movement port map (
        clk => CLK100,
        reset => RST,
        game_paused=> PAUSE,
        game_start => ENTER,
        game_over  => fin,
        ball_x => aux_ball_x, ball_y => aux_ball_y,
        collision_left => aux_collision_left,  collision_right  => aux_collision_right, 
        collision_top  => aux_collision_top,   collision_bottom => aux_collision_bottom,
        score_left => aux_score_a, score_right => aux_score_b,
        ball_x_tens => aux1, ball_x_units => aux2, 
        ball_y_tens => aux3, ball_y_units => aux4
    );
    
    Colisiones : collision_detector port map (
        clk => CLK100,
        ball_x => aux_ball_x,
        ball_y => aux_ball_y,
        player_left_y  => aux_player_left_y,
        player_right_y => aux_player_right_y,
        collision_left => aux_collision_left, collision_right  => aux_collision_right,
        collision_top  => aux_collision_top,  collision_bottom => aux_collision_bottom
    );
    
    Jugador_A : player_move_YL port map (
        YL  => YL,
        DIR => DIR1,
        RST => RST,
        CLK => CLK100,
        player_YL => player_YL,
        player_YL_pos => aux_player_left_y
    );
    
    Jugador_B : player_move_YR port map (
        YR  => YR,
        DIR => DIR2,
        RST => RST,
        CLK => CLK100,
        pos_YR_ten => aux7, 
        pos_YR_uni => aux8,
        player_YR  => aux_player_right_y
    );
    
    Puntaje : score_manager port map (
        clk   => CLK100,
        reset => RST,
        game_start  => ENTER,
        game_paused => PAUSE,
        game_over   => fin,
        score_left_in => aux_score_a, score_right_in => aux_score_b,
        score_player_a => aux5,
        score_player_b => aux6
    );
    
    Display : display_controller port map (
        clock100MHz => CLK100,
        num1 => aux1, num2 => aux2, num3 => aux3, num4 => aux4, 
        num5 => aux5, num6 => aux6, num7 => aux7, num8 => aux8,
        An=>An, Ka=>Ka
    );

end Behavioral;
