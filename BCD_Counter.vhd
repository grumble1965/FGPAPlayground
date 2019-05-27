library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCD_Counter is
    port (
        i_Clk       : in std_logic;
        i_Pulse     : in std_logic;
        o_Low_Byte  : out integer range 0 to 9;
        o_High_Byte : out integer range 0 to 9
    );
end BCD_Counter;

architecture RTL of BCD_Counter is
    signal r_Counter_Clk : std_logic := '0';
    signal r_Count_Low   : integer range 0 to 9 := 0;
    signal r_Count_High  : integer range 0 to 5 := 0;

begin
    p_60Counter : process(i_Clk)
    begin
   		if rising_edge(i_Clk) then
			r_Counter_Clk <= i_Pulse;
			
			if (i_Pulse = '1' and r_Counter_Clk = '0') then
				if (r_Count_High = 5) and (r_Count_Low = 9) then
					r_Count_Low <= 0;
                    r_Count_High <= 0;
				elsif r_Count_Low = 9 then
					r_Count_Low <= 0;
                    r_Count_High <= r_Count_High + 1;
                else
                    r_Count_Low <= r_Count_Low + 1;
				end if;
			end if;			
		end if;		
    end process;

    o_Low_Byte  <= r_Count_Low;
    o_High_Byte <= r_Count_High;
end RTL;