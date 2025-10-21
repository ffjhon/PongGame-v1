library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity player_move_sim is
--  Port ( );
end player_move_sim;

architecture Behavioral of player_move_sim is
component player_move is
    Port (YR  : in std_logic;
          DIR : in std_logic;
          RST : in std_logic;
          CLK : in std_logic;
          Z  : out std_logic
          );
end component player_move;

signal YR  : std_logic;
signal DIR : std_logic;
signal RST : std_logic;
signal CLK : std_logic := '0';
signal Z   : std_logic := '1';

begin
insyr: player_move port map(YR,DIR,RST,CLK,Z);

pclk: process
    begin
        wait for 5 ns;
        CLK <= not CLK;
end process;

pest: process
    begin
        RST <='0';
        YR <='1';
        DIR<='1';
        wait for 200ns;
        DIR<='0';
    wait;
end process;

end Behavioral;