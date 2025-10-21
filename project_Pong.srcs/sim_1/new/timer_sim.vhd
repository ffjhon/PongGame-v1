library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_sim is
end    timer_sim;

architecture sim of timer_sim is

    -- Señales internas
    signal clk100MHz   : std_logic := '0';
    signal reset       : std_logic := '0';
    signal time_up_sig : std_logic := '1';
    signal sec_count_sig : integer range 0 to 120 := 0;

    -- Constantes de simulacion
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    clk_process : process
    begin
        clk100MHz <= '0';
        wait for CLK_PERIOD / 2;
        clk100MHz <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    uut : entity work.timer
        port map (
            clk100MHz => clk100MHz,
            reset     => reset,
            time_up   => time_up_sig,
            sec_count => sec_count_sig
        );


    stim_proc : process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        
        --sec_count_sig <= 100; wait for 20ns;

        report "Inicio de simulacion" severity note;

        wait for 200 ms; -- tiempo simulado suficiente

        -- Fin de simulacion
        assert false report "Fin de simulacion" severity failure;
    end process;

end sim;
