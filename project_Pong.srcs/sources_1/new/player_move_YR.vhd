library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity player_move_YR is
    Port (YR  : in std_logic;
          DIR : in std_logic;
          RST : in std_logic;
          CLK : in std_logic;
          pos_YR_ten : out std_logic_vector(3 downto 0);
          pos_YR_uni : out std_logic_vector (3 downto 0);
          player_YR : out STD_LOGIC_VECTOR(3 downto 0)
           );
end player_move_YR;

architecture Behavioral of player_move_YR is
   type state_type is (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15);
   signal state, next_state : state_type;
   --Declare internal signals for all outputs of the state-machine
   signal player_YR_i : std_logic_vector(3 downto 0);  -- example output signal
   --other outputs
   
   component SlowClock is
        Port ( fastClock : in STD_LOGIC;
               slowClock : inout STD_LOGIC;
               prescaler : in INTEGER RANGE 0 TO 50000000);
    end component SlowClock;
    
    signal reloj: STD_LOGIC;
begin

    clock : SlowClock port map (fastClock => CLK, slowClock => reloj, prescaler => 7500000);
    
--Insert the following in the architecture after the begin keyword
   SYNC_PROC: process (reloj)
   begin
      if (reloj'event and reloj = '1') then
         if (RST = '1') then
            state <= P0;
            player_YR <= "0000";
         else
            state <= next_state;
            player_YR <=player_YR_i;
         -- assign other outputs to internal signals
         end if;
      end if;
   end process;

   --MOORE State-Machine - Outputs based on state only
  OUTPUT_DECODE: process (state)
  begin
     --SALIDA HEXADECIMAL DISPLAY JUGADOR DERECHO YR
     if state = P0     then player_YR_i <= "0000";    pos_YR_ten <= "0000"; pos_YR_uni <= "0000";
     elsif state = P1  then player_YR_i <= "0001";    pos_YR_ten <= "0000"; pos_YR_uni <= "0001";
     elsif state = P2  then player_YR_i <= "0010";    pos_YR_ten <= "0000"; pos_YR_uni <= "0010";
     elsif state = P3  then player_YR_i <= "0011";    pos_YR_ten <= "0000"; pos_YR_uni <= "0011";
     elsif state = P4  then player_YR_i <= "0100";    pos_YR_ten <= "0000"; pos_YR_uni <= "0100";
     elsif state = P5  then player_YR_i <= "0101";    pos_YR_ten <= "0000"; pos_YR_uni <= "0101";
     elsif state = P6  then player_YR_i <= "0110";    pos_YR_ten <= "0000"; pos_YR_uni <= "0110";
     elsif state = P7  then player_YR_i <= "0111";    pos_YR_ten <= "0000"; pos_YR_uni <= "0111";
     elsif state = P8  then player_YR_i <= "1000";    pos_YR_ten <= "0000"; pos_YR_uni <= "1000";
     elsif state = P9  then player_YR_i <= "1001";    pos_YR_ten <= "0001"; pos_YR_uni <= "0000";
     elsif state = P10 then player_YR_i <= "1010";    pos_YR_ten <= "0001"; pos_YR_uni <= "0001";
     elsif state = P11 then player_YR_i <= "1011";    pos_YR_ten <= "0001"; pos_YR_uni <= "0010";
     elsif state = P12 then player_YR_i <= "1100";    pos_YR_ten <= "0001"; pos_YR_uni <= "0011";
     elsif state = P13 then player_YR_i <= "1101";    pos_YR_ten <= "0001"; pos_YR_uni <= "0100";
     elsif state = P14 then player_YR_i <= "1110";    pos_YR_ten <= "0001"; pos_YR_uni <= "0101";
     elsif state = P15 then player_YR_i <= "1111";    pos_YR_ten <= "0001"; pos_YR_uni <= "0110";
         
     
     end if;
     
   end process;

   NEXT_STATE_DECODE: process (state, YR, DIR)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when P0 =>
            if YR = '1'and DIR = '0' then
               next_state <= P0;
               elsif YR = '1'and DIR = '1' then
               next_state <= P1;
            end if;
         when P1 =>
            if YR = '1'and DIR = '0' then
               next_state <= P0;
               elsif YR = '1'and DIR = '1' then
               next_state <= P2;
            end if;
         when P2 =>
            if YR = '1'and DIR = '0' then
               next_state <= P1;
               elsif YR = '1'and DIR = '1' then
               next_state <= P3;
            end if;
         when P3 =>
            if YR = '1'and DIR = '0' then
               next_state <= P2;
               elsif YR = '1'and DIR = '1' then
               next_state <= P4;
            end if;
         when P4 =>
            if YR = '1'and DIR = '0' then
               next_state <= P3;
               elsif YR = '1'and DIR = '1' then
               next_state <= P5;
            end if;
         when P5 =>
            if YR = '1'and DIR = '0' then
               next_state <= P4;
               elsif YR = '1'and DIR = '1' then
               next_state <= P6;
            end if;
         when P6 =>
            if YR = '1'and DIR = '0' then
               next_state <= P5;
               elsif YR = '1'and DIR = '1' then
               next_state <= P7;
            end if;
         when P7 =>
            if YR = '1'and DIR = '0' then
               next_state <= P6;
               elsif YR = '1'and DIR = '1' then
               next_state <= P8;
            end if;
         when P8 =>
            if YR = '1'and DIR = '0' then
               next_state <= P7;
               elsif YR = '1'and DIR = '1' then
               next_state <= P9;
            end if;
         when P9 =>
            if YR = '1'and DIR = '0' then
               next_state <= P8;
               elsif YR = '1'and DIR = '1' then
               next_state <= P10;
            end if;
         when P10 =>
            if YR = '1'and DIR = '0' then
               next_state <= P9;
               elsif YR = '1'and DIR = '1' then
               next_state <= P11;
            end if;
         when P11 =>
            if YR = '1'and DIR = '0' then
               next_state <= P10;
               elsif YR = '1'and DIR = '1' then
               next_state <= P12;
            end if;
         when P12 =>
            if YR = '1'and DIR = '0' then
               next_state <= P11;
               elsif YR = '1'and DIR = '1' then
               next_state <= P13;
            end if;
         when P13 =>
            if YR = '1'and DIR = '0' then
               next_state <= P12;
               elsif YR = '1'and DIR = '1' then
               next_state <= P14;
            end if;
         when P14 =>
            if YR = '1'and DIR = '0' then
               next_state <= P13;
               elsif YR = '1'and DIR = '1' then
               next_state <= P15;
            end if;
         when P15 =>
            if YR = '1'and DIR = '0' then
               next_state <= P14;
               elsif YR = '1'and DIR = '1' then
               next_state <= P15;
            end if;
         when others =>
      end case;
   end process;
end Behavioral;