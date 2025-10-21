library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity player_move is
    Port (YR  : in std_logic;
          DIR : in std_logic;
          RST : in std_logic;
          CLK : in std_logic;
          Z   : out std_logic);
end player_move;

architecture Behavioral of player_move is
   type state_type is (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15);
   signal state, next_state : state_type;
   --Declare internal signals for all outputs of the state-machine
   signal Z_i : std_logic;  -- example output signal
   --other outputs
begin

--Insert the following in the architecture after the begin keyword
   SYNC_PROC: process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST = '1') then
            state <= P0;
            Z <= '0';
         else
            state <= next_state;
            Z <= Z_i;
         -- assign other outputs to internal signals
         end if;
      end if;
   end process;

   --MOORE State-Machine - Outputs based on state only
  OUTPUT_DECODE: process (state)
  begin
     --insert statements to decode internal output signals
     --below is simple example
     if state = P0 then
        Z_i <= '0';
     elsif state = P1 then
        Z_i <= '0';  
     elsif state = P2 then
        Z_i <= '0';           
     else
        Z_i <= '1';
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