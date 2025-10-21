-- Simulacion simple del modulo collision_detector
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity collision_detector_sim is
end collision_detector_sim;

architecture sim of collision_detector_sim is

    -- Component under test
    component collision_detector
        Port (
            clk : in STD_LOGIC;
            ball_x : in integer range 0 to 99;
            ball_y : in integer range 0 to 96;
            player_left_y  : in unsigned (3 downto 0);
            player_right_y : in unsigned (3 downto 0);
            collision_left  : out STD_LOGIC;
            collision_right : out STD_LOGIC;
            collision_top   : out STD_LOGIC;
            collision_bottom: out STD_LOGIC
        );
    end component;

    -- Señales para conectar el DUT
    signal clk             : STD_LOGIC := '0';
    signal ball_x          : integer range 0 to 99 := 50;
    signal ball_y          : integer range 0 to 96 := 48;
    signal player_left_y   : unsigned (3 downto 0) := "0100";  -- posicion 4
    signal player_right_y  : unsigned (3 downto 0) := "1000";  -- posicion 8
    signal collision_left  : STD_LOGIC;
    signal collision_right : STD_LOGIC;
    signal collision_top   : STD_LOGIC;
    signal collision_bottom: STD_LOGIC;

begin

    -- Instancia del modulo
    DUT: collision_detector
        port map (
            clk => clk,
            ball_x => ball_x,
            ball_y => ball_y,
            player_left_y => player_left_y,
            player_right_y => player_right_y,
            collision_left => collision_left,
            collision_right => collision_right,
            collision_top => collision_top,
            collision_bottom => collision_bottom
        );

    -- Generador de reloj (periodo 10 ns)
    clock_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Estimulos de prueba
    stimulus_process : process
    begin
        -- Espera inicial
        wait for 20 ns;

        -- Colision superior
        ball_y <= 0;
        wait for 10 ns;

        -- Colision inferior
        ball_y <= 96;
        wait for 10 ns;

        -- Sin colision
        ball_x <= 50;
        ball_y <= 50;
        wait for 10 ns;

        -- Colision con jugador izquierdo
        ball_x <= 2;  -- PLAYER_LEFT_X + 1 = 2
        ball_y <= 6;  -- dentro del rango del jugador (4 a 10)
        wait for 10 ns;

        -- Colision con jugador derecho
        ball_x <= 94; -- PLAYER_RIGHT_X - 1 = 94
        ball_y <= 9;  -- dentro del rango del jugador (8 a 14)
        wait for 10 ns;

        -- Fin de la simulacion
        wait for 20 ns;
        assert false report "Fin de simulacion" severity failure; -- "severity" puede ser: note, warning, error, failure
    end process;

end sim;
