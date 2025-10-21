library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity player_move_YL is
    Port (YL  : in std_logic;
          DIR : in std_logic;
          RST : in std_logic;
          CLK : in std_logic;
          player_YL : out STD_LOGIC_VECTOR(15 downto 0));
end player_move_YL;

architecture Behavioral of player_move_YL is
   type state_type is (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15);
   signal state, next_state : state_type;
   --Declare internal signals for all outputs of the state-machine
   signal player_YL_i : std_logic_vector(15 downto 0);   -- example output signal
   --other outputs
begin

--Insert the following in the architecture after the begin keyword
   SYNC_PROC: process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST = '1') then
            state <= P0;
            player_YL <= "0000000000000000";
         else
            state <= next_state;
            player_YL <= player_YL_i;
         -- assign other outputs to internal signals
         end if;
      end if;
   end process;

   --MOORE State-Machine - Outputs based on state only
  OUTPUT_DECODE: process (state)
  begin
    if state = P0 then
        player_YL_i <= "0000000000000001";
     elsif state = P1 then
     player_YL_i <= "0000000000000010";
     elsif state = P2 then
     player_YL_i <= "0000000000000100";
     elsif state = P3 then
     player_YL_i <= "0000000000001000";
     elsif state = P4 then
     player_YL_i <= "0000000000010000";
     elsif state = P5 then
     player_YL_i <= "0000000000100000";
     elsif state = P6 then
     player_YL_i <= "0000000001000000";
     elsif state = P7 then
     player_YL_i <= "0000000010000000";
     elsif state = P8 then
     player_YL_i <= "0000000100000000";
     elsif state = P9 then
     player_YL_i <= "0000001000000000";
     elsif state = P10 then
     player_YL_i <= "0000010000000000";
     elsif state = P11 then
     player_YL_i <= "0000100000000000";
     elsif state = P12 then
     player_YL_i <= "0001000000000000";
     elsif state = P13 then
     player_YL_i <= "0010000000000000";
     elsif state = P14 then
     player_YL_i <= "0100000000000000";
     elsif state = P15 then
     player_YL_i <= "1000000000000000";
         
     
     end if;
     
   end process;

   NEXT_STATE_DECODE: process (state, YL, DIR)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when P0 =>
            if YL = '1'and DIR = '0' then
               next_state <= P0;
               elsif YL = '1'and DIR = '1' then
               next_state <= P1;
            end if;
         when P1 =>
            if YL = '1'and DIR = '0' then
               next_state <= P0;
               elsif YL = '1'and DIR = '1' then
               next_state <= P2;
            end if;
         when P2 =>
            if YL = '1'and DIR = '0' then
               next_state <= P1;
               elsif YL = '1'and DIR = '1' then
               next_state <= P3;
            end if;
         when P3 =>
            if YL = '1'and DIR = '0' then
               next_state <= P2;
               elsif YL = '1'and DIR = '1' then
               next_state <= P4;
            end if;
         when P4 =>
            if YL = '1'and DIR = '0' then
               next_state <= P3;
               elsif YL = '1'and DIR = '1' then
               next_state <= P5;
            end if;
         when P5 =>
            if YL = '1'and DIR = '0' then
               next_state <= P4;
               elsif YL = '1'and DIR = '1' then
               next_state <= P6;
            end if;
         when P6 =>
            if YL = '1'and DIR = '0' then
               next_state <= P5;
               elsif YL = '1'and DIR = '1' then
               next_state <= P7;
            end if;
         when P7 =>
            if YL = '1'and DIR = '0' then
               next_state <= P6;
               elsif YL = '1'and DIR = '1' then
               next_state <= P8;
            end if;
         when P8 =>
            if YL = '1'and DIR = '0' then
               next_state <= P7;
               elsif YL = '1'and DIR = '1' then
               next_state <= P9;
            end if;
         when P9 =>
            if YL = '1'and DIR = '0' then
               next_state <= P8;
               elsif YL = '1'and DIR = '1' then
               next_state <= P10;
            end if;
         when P10 =>
            if YL = '1'and DIR = '0' then
               next_state <= P9;
               elsif YL = '1'and DIR = '1' then
               next_state <= P11;
            end if;
         when P11 =>
            if YL = '1'and DIR = '0' then
               next_state <= P10;
               elsif YL = '1'and DIR = '1' then
               next_state <= P12;
            end if;
         when P12 =>
            if YL = '1'and DIR = '0' then
               next_state <= P11;
               elsif YL = '1'and DIR = '1' then
               next_state <= P13;
            end if;
         when P13 =>
            if YL = '1'and DIR = '0' then
               next_state <= P12;
               elsif YL = '1'and DIR = '1' then
               next_state <= P14;
            end if;
         when P14 =>
            if YL = '1'and DIR = '0' then
               next_state <= P13;
               elsif YL = '1'and DIR = '1' then
               next_state <= P15;
            end if;
         when P15 =>
            if YL = '1'and DIR = '0' then
               next_state <= P14;
               elsif YL = '1'and DIR = '1' then
               next_state <= P15;
            end if;
         when others =>
      end case;
   end process;
end Behavioral;
