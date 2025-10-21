library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_controller is
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
end display_controller; 

architecture Behavioral of display_controller is
    
    component SlowClock is
        Port ( fastClock : in STD_LOGIC;
               slowClock : inout STD_LOGIC;
               prescaler : in INTEGER RANGE 0 TO 50000000);
    end component SlowClock;
    
    component display_HexTo7Seg is
        Port ( code : in STD_LOGIC_VECTOR (3 downto 0);
               cathodes : out STD_LOGIC_VECTOR (7 downto 0));
    end component display_HexTo7Seg;
    
    component display_7SegSequence is
        Port(
            clockDisplay : in STD_LOGIC;
            code_1 : in STD_LOGIC_VECTOR (3 downto 0); -- ball_x_ten (dec)
            code_2 : in STD_LOGIC_VECTOR (3 downto 0); -- ball_x_uni (dec)
            code_3 : in STD_LOGIC_VECTOR (3 downto 0); -- ball_y_ten (dec)
            code_4 : in STD_LOGIC_VECTOR (3 downto 0); -- ball_y_uni (dec)
            code_5 : in STD_LOGIC_VECTOR (3 downto 0); -- score_a, (hex)
            code_6 : in STD_LOGIC_VECTOR (3 downto 0); -- score_b, (hex)
            code_7 : in STD_LOGIC_VECTOR (3 downto 0); -- pos_playerB_ten (dec)
            code_8 : in STD_LOGIC_VECTOR (3 downto 0); -- pos_playerB_uni (dec)
            codeOut: out STD_LOGIC_VECTOR (3 downto 0);-- 
            anodes : out STD_LOGIC_VECTOR (7 downto 0) -- 
        );
    end component display_7SegSequence;
    
    signal reloj: STD_LOGIC;
    signal code : STD_LOGIC_VECTOR(3 downto 0);
    -- signal : num1_tens 

begin
    
    -- Codigo para convertir los numeros
    -- 
    
    clock : SlowClock port map (fastClock => clock100MHz, slowClock => reloj, prescaler => 500000);
    sequence7Sseg : display_7SegSequence port map (
        clockDisplay => reloj, 
        code_1 => num1, code_2 => num2, code_3 => num3, code_4 => num4,
        code_5 => num5, code_6 => num6, code_7 => num7, code_8 => num8,
        codeOut => code,
        anodes => An
    );
    HexTo7Seg : display_HexTo7Seg port map (code => code, cathodes => Ka);

end Behavioral;