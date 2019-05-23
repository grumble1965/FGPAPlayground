library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock_Generator is
  generic (
    g_COUNT_OUT1 : integer;
    g_COUNT_OUT2  : integer;
    g_COUNT_OUT3  : integer;
    g_COUNT_OUT4  : integer);
  port (
    i_Clk   : in  std_logic;
    o_Out_1 : out std_logic;
    o_Out_2 : out std_logic;
    o_Out_3 : out std_logic;
    o_Out_4 : out std_logic
    );
end Clock_Generator;

architecture RTL of Clock_Generator is

  -- These signals will be the counters:
  signal r_Count_Out1 : integer range 0 to g_COUNT_OUT1;
  signal r_Count_Out2 : integer range 0 to g_COUNT_OUT2;
  signal r_Count_Out3 : integer range 0 to g_COUNT_OUT3;
  signal r_Count_Out4 : integer range 0 to g_COUNT_OUT4;
  
  -- These signals will toggle at the frequencies needed:
  signal r_Toggle_Out1 : std_logic := '0';
  signal r_Toggle_Out2 : std_logic := '0';
  signal r_Toggle_Out3 : std_logic := '0';
  signal r_Toggle_Out4 : std_logic := '0';

begin

  -- Wire up outputs
  o_Out_1 <= r_Toggle_Out1;
  o_Out_2 <= r_Toggle_Out2;
  o_Out_3 <= r_Toggle_Out3;
  o_Out_4 <= r_Toggle_Out4;
  
  -- All processes toggle a specific signal at a different frequency.
  
  p_Out1 : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
     if r_Count_Out1 = g_COUNT_OUT1 then
        r_Toggle_Out1 <= not r_Toggle_Out1;
        r_Count_Out1  <= 0;
     else
        r_Count_Out1 <= r_Count_Out1 + 1;
      end if;
    end if;
  end process p_Out1;


  p_Out2 : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_Out2 = g_COUNT_OUT2 then
        r_Toggle_Out2 <= not r_Toggle_Out2;
        r_Count_Out2  <= 0;
      else
        r_Count_Out2 <= r_Count_Out2 + 1;
      end if;
    end if;
  end process p_Out2;

  
  p_2_Hz : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_Out3 = g_COUNT_OUT3 then
        r_Toggle_Out3 <= not r_Toggle_Out3;
        r_Count_Out3  <= 0;
      else
        r_Count_Out3 <= r_Count_Out3 + 1;
      end if;
    end if;
  end process p_2_Hz;

  
  p_Out4 : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if r_Count_Out4 = g_COUNT_OUT4 then
        r_Toggle_Out4 <= not r_Toggle_Out4;
        r_Count_Out4  <= 0;
      else
        r_Count_Out4 <= r_Count_Out4 + 1;
      end if;
    end if;
  end process p_Out4;
  
end RTL;