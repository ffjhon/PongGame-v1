library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_HexTo7Seg is
    Port ( code : in STD_LOGIC_VECTOR (3 downto 0);
           cathodes : out STD_LOGIC_VECTOR (7 downto 0)
    );
end display_HexTo7Seg;

architecture Behavioral of display_HexTo7Seg is
begin
    cathodes <= 
        "00000011" when code = "0000" else -- 0
        "10011111" when code = "0001" else -- 1
        "00100101" when code = "0010" else -- 2
        "00001101" when code = "0011" else -- 3
        "10011001" when code = "0100" else -- 4
        "01001001" when code = "0101" else -- 5
        "01000001" when code = "0110" else -- 6
        "00011111" when code = "0111" else -- 7
        "00000001" when code = "1000" else -- 8
        "00001001" when code = "1001" else -- 9
        "00010001" when code = "1010" else -- A
        "11000001" when code = "1011" else -- b
        "01100011" when code = "1100" else -- C
        "10000101" when code = "1101" else -- d
        "01100001" when code = "1110" else -- E
        "01110001" when code = "1111" else -- F
        "11111110";                        -- default (apagado)
end Behavioral;

