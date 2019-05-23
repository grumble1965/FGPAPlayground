-- Testbench for And_Gate_Project gate
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

-- DUT component
component Switches_To_LEDs is
	port (
		-- Momentary Switches
		i_Switch_1 : in std_logic;
		i_Switch_2 : in std_logic;
		i_Switch_3 : in std_logic;
		i_Switch_4 : in std_logic;
		
		-- LEDs
		o_LED_1 : out std_logic;
		o_LED_2 : out std_logic;
		o_LED_3 : out std_logic;
		o_LED_4 : out std_logic
	);
end component;

signal sw1_in, sw2_in, sw3_in, sw4_in: std_logic;
signal LED1_out, LED2_out, LED3_out, LED4_out: std_logic;

begin

  -- Connect DUT
  DUT: Switches_To_LEDs port map(sw1_in, sw2_in, sw3_in, sw4_in, LED1_out, LED2_out, LED3_out, LED4_out);

  process
  begin
    sw1_in <= '0';  sw2_in <= '0';  sw3_in <= '0';  sw4_in <= '0';
    wait for 1 ns;
  	assert (LED1_out='0' and LED2_out='0'and LED3_out='0' and LED4_out='0')
      report "Fail 0/0/0/0" severity error;

    sw1_in <= '1';  sw2_in <= '0';  sw3_in <= '0';  sw4_in <= '0';
    wait for 1 ns;
  	assert (LED1_out='1' and LED2_out='0'and LED3_out='0' and LED4_out='0')
      report "Fail 1/0/0/0" severity error;

    sw1_in <= '0';  sw2_in <= '1';  sw3_in <= '0';  sw4_in <= '0';
    wait for 1 ns;
  	assert (LED1_out='0' and LED2_out='1'and LED3_out='0' and LED4_out='0')
      report "Fail 0/1/0/0" severity error;

    sw1_in <= '0';  sw2_in <= '0';  sw3_in <= '1';  sw4_in <= '0';
    wait for 1 ns;
  	assert (LED1_out='0' and LED2_out='0'and LED3_out='1' and LED4_out='0')
      report "Fail 0/0/1/0" severity error;

    sw1_in <= '0';  sw2_in <= 'X';  sw3_in <= '1';  sw4_in <= 'X';
    wait for 1 ns;
  	assert (LED1_out='0' and LED2_out='X'and LED3_out='1' and LED4_out='X')
      report "Fail 0/X/1/X" severity error;
   
    -- Clear inputs
    sw1_in <= '0';    sw2_in <= '0';    sw3_in <= '0';    sw4_in <= '0';

    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
