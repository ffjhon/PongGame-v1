-- Modulo: collission_detector
-- Se encarga de detectar si hay colisiones con las paredes, jugadores o puntos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity collision_detector is
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
end collision_detector;
    

architecture Behavioral of collision_detector is
    constant PLAYER_HEIGHT : integer := 6;
    constant PLAYER_LEFT_X : integer := 1;
    constant PLAYER_RIGHT_X: integer := 95;

begin -- Behavioral
    process(clk)
    begin -- clk
        if rising_edge(clk) then -- #1
            collision_left  <= '0'; -- Reset colisiones
            collision_right <= '0';
            collision_top   <= '0';
            collision_bottom<= '0';
            
            -- Colisión con pared superior/inferior
            if    ball_y <= 1  then collision_top <= '1';
            elsif ball_y >= 95 then collision_bottom <= '1';
            end if;
            
            if ball_x = PLAYER_LEFT_X + 1 then -- Colisión con jugador izquierdo
                if ball_y >= to_integer(player_left_y) and ball_y <= to_integer(player_left_y) + PLAYER_HEIGHT then
                    collision_left <= '1';
                end if;
            end if;
            
            if ball_x = PLAYER_RIGHT_X - 1 then -- Colisión con jugador derecho
                if ball_y >= to_integer(player_right_y) and ball_y <= to_integer(player_right_y) + PLAYER_HEIGHT then
                    collision_right <= '1';
                end if;
            end if;
        end if; --#1
    end process;--clk
end Behavioral;
