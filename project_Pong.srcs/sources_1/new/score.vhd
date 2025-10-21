library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity score_manager is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        game_start : in STD_LOGIC;
        game_paused : in STD_LOGIC;
        game_over : in STD_LOGIC;
        score_left_in  : in STD_LOGIC; -- Señal desde: ball_movement
        score_right_in : in STD_LOGIC; -- Señal desde: ball_movement
        score_player_a : out STD_LOGIC_VECTOR(3 downto 0);
        score_player_b : out STD_LOGIC_VECTOR(3 downto 0);
        display_score_a: out STD_LOGIC_VECTOR(6 downto 0); -- NO SE USARA
        display_score_b: out STD_LOGIC_VECTOR(6 downto 0)  -- NO SE USARA
    );
end score_manager;

architecture Behavioral of score_manager is
    signal score_a_int : unsigned(3 downto 0) := "0000";
    signal score_b_int : unsigned(3 downto 0) := "0000";
    signal last_left, last_right : STD_LOGIC := '0';
begin

    score_player_a <= STD_LOGIC_VECTOR(score_a_int);
    score_player_b <= STD_LOGIC_VECTOR(score_b_int);

    process(clk, reset)
    begin
        if reset = '1' then
            score_a_int <= "0000";
            score_b_int <= "0000";
            last_left <= '0';
            last_right <= '0';
        elsif rising_edge(clk) then
            if game_start = '1' and game_paused = '0' and game_over = '0' then
                -- Detectar flanco de subida en score_left_in
                if last_left = '0' and score_left_in = '1' and score_a_int < 15 then
                    score_a_int <= score_a_int + 1; -- Cada anotacion son 3 puntos (+3)
                end if;
                
                -- Detectar flanco de subida en score_right_in  
                if last_right = '0' and score_right_in = '1' and score_b_int < 15 then
                    score_b_int <= score_b_int + 1; -- Cada anotacion son 3 puntos (+3)
                end if;
                
                last_left  <= score_left_in;
                last_right <= score_right_in;
            end if;
        end if;
    end process;
end Behavioral;