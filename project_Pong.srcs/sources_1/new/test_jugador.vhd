library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_jugador is
 --PRIMER JUGADOR DISPLAY
      Port (YR  : in std_logic;
      DIR : in std_logic;
      RST : in std_logic;
      CLK100 : in std_logic;
--      pos_YR_ten : out std_logic_vector(3 downto 0);
--      pos_YR_uni : out std_logic_vector (3 downto 0);
      An   : out STD_LOGIC_VECTOR(7 downto 0);
      Ka   : out STD_LOGIC_VECTOR(7 downto 0);
      
     --SEGUNDO JUGADOR LEDS  CON EL MISMO CLK100
      YL   : in std_logic;  
      DIR2 : in std_logic;
 --RST : in std_logic;
 --     CLK : in std_logic;
      player_YL : out STD_LOGIC_VECTOR(15 downto 0) -- -> collision_detector
     );
end test_jugador;



architecture Behavioral of test_jugador is

    component player_move_YR is
        Port (YR  : in std_logic;
              DIR : in std_logic;
              RST : in std_logic;
              CLK : in std_logic;
              pos_YR_ten : out STD_LOGIC_VECTOR (3 downto 0);
              pos_YR_uni : out STD_LOGIC_VECTOR (3 downto 0);
              player_YR  : out STD_LOGIC_VECTOR (3 downto 0)
           );
    end component player_move_YR;
    
    component player_move_YL is
        Port (YL  : in std_logic;
            DIR : in std_logic;
            RST : in std_logic;
            CLK : in std_logic;
            player_YL : out STD_LOGIC_VECTOR(15 downto 0)); -- -> collision_detector
    end component player_move_YL;

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

    signal aux1,aux2,aux3 : STD_LOGIC_VECTOR (3 downto 0); 
    signal reloj : STD_LOGIC;
    
begin
    
    jugador_YR : player_move_YR port map(
        YR  => YR,
        DIR => DIR,
        RST => RST,
        CLK => CLK100,
        pos_YR_ten => aux1, 
        pos_YR_uni => aux2,
        player_YR  => aux3
    );
    
    jugador_YL : player_move_YL port map(
        YL   => YL,
        DIR  => DIR2,
        RST  => RST,
        CLK  => CLK100,
        player_YL => player_YL 
        
    );
    
    display : display_controller port map (
        clock100MHz => CLK100,
        num1 => aux1,
        num2 => aux2,
        num3 => aux3,
        num4 =>"0000", num5=>"0000", num6=>"0000", num7=>"0000", num8=>"0000",
        An=>An, Ka=>Ka
    );

end Behavioral;
