library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_7SegSequence is
    Port(
        clockDisplay : in STD_LOGIC;
        code_1 : in STD_LOGIC_VECTOR (3 downto 0);
        code_2 : in STD_LOGIC_VECTOR (3 downto 0);
        code_3 : in STD_LOGIC_VECTOR (3 downto 0);
        code_4 : in STD_LOGIC_VECTOR (3 downto 0);
        code_5 : in STD_LOGIC_VECTOR (3 downto 0);
        code_6 : in STD_LOGIC_VECTOR (3 downto 0);
        code_7 : in STD_LOGIC_VECTOR (3 downto 0);
        code_8 : in STD_LOGIC_VECTOR (3 downto 0);
        codeOut: out STD_LOGIC_VECTOR (3 downto 0);
        anodes : out STD_LOGIC_VECTOR (7 downto 0)
    );
end display_7SegSequence;

architecture Behavioral of display_7SegSequence is
begin
    
    DisplaySequence : process(clockDisplay)
    variable numDisplay : INTEGER range 1 TO 8;
    
    begin
        if rising_edge(clockDisplay) then
            if(numDisplay = 1)        then anodes <= "11111110"; codeOut <= code_1;
                elsif(numDisplay = 2) then anodes <= "11111101"; codeOut <= code_2;
                elsif(numDisplay = 3) then anodes <= "11111011"; codeOut <= code_3;
                elsif(numDisplay = 4) then anodes <= "11110111"; codeOut <= code_4;
                elsif(numDisplay = 5) then anodes <= "11101111"; codeOut <= code_5;
                elsif(numDisplay = 6) then anodes <= "11011111"; codeOut <= code_6;
                elsif(numDisplay = 7) then anodes <= "10111111"; codeOut <= code_7;
                elsif(numDisplay = 8) then anodes <= "01111111"; codeOut <= code_8;
                else anodes <= "11111111"; codeOut <= code_1;
            end if;--numDisplay
            numDisplay := numDisplay + 1;
            if(numDisplay > 8) then numDisplay := 1; end if;
        end if; --clockDisplay 
    end process DisplaySequence;
end Behavioral;