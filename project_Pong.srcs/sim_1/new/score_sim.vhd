library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity score_manager_sim is
-- Testbench no tiene puertos
end score_manager_sim;

architecture Behavioral of score_manager_sim is
    component score_manager
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            game_start : in STD_LOGIC;
            game_paused : in STD_LOGIC;
            game_over : in STD_LOGIC;
            score_left_in : in STD_LOGIC;
            score_right_in : in STD_LOGIC;
            score_player_a : out STD_LOGIC_VECTOR(3 downto 0);
            score_player_b : out STD_LOGIC_VECTOR(3 downto 0);
            display_score_a : out STD_LOGIC_VECTOR(6 downto 0);
            display_score_b : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    signal clk : STD_LOGIC := '0';     -- Señales de entrada
    signal reset : STD_LOGIC := '1';
    signal game_start : STD_LOGIC := '0';
    signal game_paused : STD_LOGIC := '0'; 
    signal game_over : STD_LOGIC := '0';
    signal score_left_in : STD_LOGIC := '0';
    signal score_right_in : STD_LOGIC := '0';
    signal score_player_a : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal score_player_b : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal display_score_a : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    signal display_score_b : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz -- Constante para el período del reloj
    
begin
    uut: score_manager -- Instanciación del DUT (Device Under Test)
        port map (
            clk => clk,
            reset => reset,
            game_start => game_start,
            game_paused => game_paused,
            game_over => game_over,
            score_left_in => score_left_in,
            score_right_in => score_right_in,
            score_player_a => score_player_a,
            score_player_b => score_player_b,
            display_score_a => display_score_a,
            display_score_b => display_score_b
        );
    
    -- Generación del reloj
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Proceso de estímulo
    stim_proc : process
    begin
        -- Inicialización
        report "Iniciando testbench...";
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 20 ns;
        
        -- Test 1: Inicio del juego
        report "Test 1: Inicio del juego";
        game_start <= '1';
        wait for 50 ns;
        
        -- Test 2: Jugador A anota 3 puntos
        report "Test 2: Jugador A anota 3 puntos";
        for i in 1 to 3 loop
            score_left_in <= '1';
            wait for 20 ns;
            score_left_in <= '0';
            wait for 100 ns; -- Esperar entre anotaciones
        end loop;
        
        -- Verificar puntaje
        wait for 50 ns;
        assert score_player_a = "0011" 
            report "Error: Puntaje A debería ser 3" severity error;
        
        -- Test 3: Jugador B anota 2 puntos
        report "Test 3: Jugador B anota 2 puntos";
        for i in 1 to 2 loop
            score_right_in <= '1';
            wait for 20 ns;
            score_right_in <= '0';
            wait for 100 ns;
        end loop;
        
        score_right_in <= '1'; wait for 20ns;
        score_right_in <= '0'; wait for 20ns;
        
        -- Otros 7 puntos para el player 1 (L)
        report "Test 4A: Jugador A anota 3 puntos";
        for i in 1 to 7 loop
            score_left_in <= '1';
            wait for 20 ns;
            score_left_in <= '0';
            wait for 100 ns; -- Esperar entre anotaciones
        end loop;
        
        -- Verificar puntaje -------------------------------------------------------------------------
        wait for 50 ns;
        assert score_player_b = "0010" 
            report "Error: Puntaje B debería ser 2" severity error;
        
        -- Test 4: Juego en pausa - no debería contar puntos
        report "Test 4: Pausa - no contar puntos";
        game_paused <= '1';
        wait for 20 ns;
        score_left_in <= '1';
        wait for 20 ns;
        score_left_in <= '0';
        wait for 100 ns;
        game_paused <= '0';
        
        -- Verificar que no cambió el puntaje
        assert score_player_a = "0011" 
            report "Error: Puntaje A no debería cambiar en pausa" severity error;
        
        -- Test 5: Anotaciones rápidas (debounce test)
        report "Test 5: Test de debounce";
        for i in 1 to 5 loop
            score_right_in <= '1';
            wait for 5 ns;  -- Pulso muy corto
            score_right_in <= '0';
            wait for 5 ns;
        end loop;
        wait for 200 ns;    -- Esperar que procese solo una anotación
        
        -- Test 6: Llegar a puntaje máximo (15)
        report "Test 6: Llegar a puntaje máximo";
        for i in 1 to 12 loop  -- Ya tenemos 2, necesitamos 13 más para llegar a 15
            score_right_in <= '1';
            wait for 20 ns;
            score_right_in <= '0';
            wait for 100 ns;
        end loop;
        
        -- Verificar puntaje máximo
        wait for 50 ns;
        assert score_player_b = "1111" 
            report "Error: Puntaje B debería ser 15 (F)" severity error;
        
        -- Test 7: Intentar sobrepasar el máximo
        report "Test 7: Intentar sobrepasar puntaje máximo";
        score_right_in <= '1';
        wait for 20 ns;
        score_right_in <= '0';
        wait for 100 ns;
        
        -- Verificar que se mantiene en 15
        assert score_player_b = "1111" 
            report "Error: Puntaje B no debería pasar de 15" severity error;
        
        -- Test 8: Game over - mantener puntaje
        report "Test 8: Game over - mantener puntaje final";
        game_over <= '1';
        wait for 50 ns;
        
        -- Intentar anotar durante game over
        score_left_in <= '1';
        wait for 20 ns;
        score_left_in <= '0';
        wait for 100 ns;
        
        -- Verificar que no cambia
        assert score_player_a = "0011" 
            report "Error: Puntaje no debería cambiar en game over" severity error;
        
        -- Test 9: Reset
        report "Test 9: Reset del juego";
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        wait for 50 ns;
        
        -- Verificar reset
        assert score_player_a = "0000" and score_player_b = "0000"
            report "Error: Reset no funcionó correctamente" severity error;
        
        -- Finalizar simulación
        report "Simulación completada exitosamente!";
        wait for 100 ns;
        
        -- Fin de la simulación
        assert false report "Fin de la simulación" severity note;
        wait;
    end process;
    
    -- Proceso de monitoreo para displays
    monitor_proc : process
        variable display_a_val : integer;
        variable display_b_val : integer;
    begin
        wait for 10 ns; -- Esperar inicialización
        
        while true loop
            wait until rising_edge(clk);
            
            -- Decodificar display A
            case display_score_a is
                when "1000000" => display_a_val := 0;
                when "1111001" => display_a_val := 1;
                when "0100100" => display_a_val := 2;
                when "0110000" => display_a_val := 3;
                when "0011001" => display_a_val := 4;
                when "0010010" => display_a_val := 5;
                when "0000010" => display_a_val := 6;
                when "1111000" => display_a_val := 7;
                when "0000000" => display_a_val := 8;
                when "0010000" => display_a_val := 9;
                when "0001000" => display_a_val := 10; -- A
                when "0000011" => display_a_val := 11; -- b
                when "1000110" => display_a_val := 12; -- C
                when "0100001" => display_a_val := 13; -- d
                when "0000110" => display_a_val := 14; -- E
                when "0001110" => display_a_val := 15; -- F
                when others => display_a_val := -1;
            end case;
            
            -- Decodificar display B
            case display_score_b is
                when "1000000" => display_b_val := 0;
                when "1111001" => display_b_val := 1;
                when "0100100" => display_b_val := 2;
                when "0110000" => display_b_val := 3;
                when "0011001" => display_b_val := 4;
                when "0010010" => display_b_val := 5;
                when "0000010" => display_b_val := 6;
                when "1111000" => display_b_val := 7;
                when "0000000" => display_b_val := 8;
                when "0010000" => display_b_val := 9;
                when "0001000" => display_b_val := 10;
                when "0000011" => display_b_val := 11;
                when "1000110" => display_b_val := 12;
                when "0100001" => display_b_val := 13;
                when "0000110" => display_b_val := 14;
                when "0001110" => display_b_val := 15;
                when others => display_b_val := -1;
            end case;
            
            -- Reportar cambios en displays
            if display_a_val /= to_integer(unsigned(score_player_a)) then
                report "Display A muestra: " & integer'image(display_a_val) & 
                       " pero score es: " & integer'image(to_integer(unsigned(score_player_a)));
            end if;
            
            if display_b_val /= to_integer(unsigned(score_player_b)) then
                report "Display B muestra: " & integer'image(display_b_val) & 
                       " pero score es: " & integer'image(to_integer(unsigned(score_player_b)));
            end if;
        end loop;
    end process;

end Behavioral;