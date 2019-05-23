library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Brightness_Controller is
  port (
    i_Clk    : in  std_logic;
    i_Select : in  std_logic;
    o_Bright : out std_logic
  );
end Brightness_Controller;

architecture RTL of Brightness_Controller is
    type t_SM_Main is (s_Low, s_Med, s_High, s_Max);

    signal r_Select : std_logic := '0';
    signal r_Brightness : t_SM_Main := s_Max;           -- selected brightness state
    signal r_Level : integer range 0 to 7 := 0;         -- selected brightness level
    signal r_PWM_Counter : integer range 0 to 7 := 0;   -- free running PWM counter

begin

    --
    -- Cycle the brightness selector
    --
   	p_Brightness : process (i_Clk) is
	begin
		if rising_edge(i_Clk) then
			r_Select <= i_Select;
		
			if i_Select = '0' and r_Select = '1' then  -- switch released\
                -- next brightness (dimness) level
                case r_Brightness is
                    when s_Low  => r_Brightness <= s_Max;
                    when s_Med  => r_Brightness <= s_Low;
                    when s_High => r_Brightness <= s_Med;
                    when s_Max  => r_Brightness <= s_High;
                end case;

                -- counter value for each level
                case r_Brightness is
                    when s_Low  => r_Level <= 0;
                    when s_Med  => r_Level <= 1;
                    when s_High => r_Level <= 2;
                    when s_Max  => r_Level <= 7;
                end case;
			end if;
		end if;
	end process p_Brightness;

    --
    -- Cycle the PWM index
    --
    p_PWM : process(i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_PWM_Counter = 7 then
                r_PWM_Counter <= 0;
            else
                r_PWM_Counter <= r_PWM_Counter + 1;
            end if;
        end if;
    end process p_PWM;

    -- PWM signal
    o_Bright <= '1' when r_Level >= r_PWM_Counter else '0';
  
end RTL;