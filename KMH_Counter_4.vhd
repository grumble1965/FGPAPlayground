library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity KMH_Counter_4 is
    port (
        i_Clk           : in std_logic;
        i_Switch_1      : in std_logic;
        i_Switch_4      : in std_logic;

        o_LED_1         : out std_logic;
        o_LED_2         : out std_logic;
        o_LED_3         : out std_logic;
        o_LED_4         : out std_logic;

        o_Segment1_A    : out std_logic;
        o_Segment1_B    : out std_logic;
        o_Segment1_C    : out std_logic;
        o_Segment1_D    : out std_logic;
        o_Segment1_E    : out std_logic;
        o_Segment1_F    : out std_logic;
        o_Segment1_G    : out std_logic;

        o_Segment2_A    : out std_logic;
        o_Segment2_B    : out std_logic;
        o_Segment2_C    : out std_logic;
        o_Segment2_D    : out std_logic;
        o_Segment2_E    : out std_logic;
        o_Segment2_F    : out std_logic;
        o_Segment2_G    : out std_logic
    );
end KMH_Counter_4;

architecture RTL of KMH_Counter_4 is

    signal w_1HZ : std_logic;
    signal w_Fast : std_logic;
    signal w_PWM_Clk : std_logic;

    signal w_Switch_4 : std_logic;

    signal w_Counter_Clk : std_logic;
    signal w_Count_Low   : integer range 0 to 9;
    signal w_Count_High  : integer range 0 to 9;

    signal w_Brightness : std_logic;

   	signal w_Segment1_A : std_logic;
	signal w_Segment1_B : std_logic;
	signal w_Segment1_C : std_logic;
	signal w_Segment1_D : std_logic;
	signal w_Segment1_E : std_logic;
	signal w_Segment1_F : std_logic;
	signal w_Segment1_G : std_logic;

   	signal w_Segment2_A : std_logic;
	signal w_Segment2_B : std_logic;
	signal w_Segment2_C : std_logic;
	signal w_Segment2_D : std_logic;
	signal w_Segment2_E : std_logic;
	signal w_Segment2_F : std_logic;
	signal w_Segment2_G : std_logic;

begin

    --
    -- Instantiate a clock divider
    --   1Hz  is default clock for counter60
    --   10Hz is fast clock for counter60
    --   1KHz is PWM clock for LED brightness
    --
    Clk_Gen_Inst : entity work.Clock_Generator
        generic map (
            g_COUNT_OUT1 => 1250000,    -- 25e6 Hz / 1.25e6 = 20 toggles / Hz = 10 Hz clock
            g_COUNT_OUT2 => 12500,      -- 25e6 Hz / 12.5e3 = 2K toggles / Hz = 1 KiloHz clock
            g_COUNT_OUT3 => 6250000,    -- 25e6 Hz / 6.25e6 = 4 toggles / Hz = 2 Hz clock
            g_COUNT_OUT4 => 12500000)   -- 25e6 Hz / 12.5e6 = 2 toggles / Hz = 1 Hz clock
        port map (
            i_Clk   => i_Clk,
            o_Out_1 => w_Fast,
            o_Out_2 => w_PWM_Clk,
            o_Out_3 => open,
            o_Out_4 => w_1Hz
        );

    --
    -- Instantiate a debouncer for the brightness select
    --
    Debounce_Inst: entity work.Debounce_Switch
	port map (
		i_Clk		=> i_Clk,
		i_Switch	=> i_Switch_4,
		o_Switch	=> w_Switch_4
    );

    --
    -- Instantiate the brightness controller
    --
    Brightness_Inst: entity work.Brightness_Controller
    port map (
        i_Clk       => w_PWM_Clk,
        i_Select    => w_Switch_4,
        o_Bright    => w_Brightness
    );

    --
    -- Select the normal / fast clock based on Switch 1
    --   No debounce here since there's no apparent glitch to annoy the user
    --
    w_Counter_Clk <= (i_Switch_1 and w_Fast) or (not i_Switch_1 and w_1HZ);

    --
    -- Instantiate the counter
    --
    Counter_Inst: entity work.BCD_Counter
    port map (
        i_Clk       => i_Clk,
        i_Carry_In  => w_Counter_Clk,
        o_Low_Byte  => w_Count_Low,
        o_High_Byte => w_Count_High,
        o_Carry_Out => o_LED_1
    );

    --
    -- Instantiate two nibble decoders
    --
    SevenSeg1_Low_Inst : entity work.Binary_To_7Segment
		port map (
			i_Clk 			=> i_Clk,
			i_Binary_Num	=> std_logic_vector(to_unsigned(w_Count_Low, 4)),
			o_Segment_A		=> w_Segment2_A,
			o_Segment_B		=> w_Segment2_B,
			o_Segment_C		=> w_Segment2_C,
			o_Segment_D		=> w_Segment2_D,
			o_Segment_E		=> w_Segment2_E,
			o_Segment_F		=> w_Segment2_F,
			o_Segment_G		=> w_Segment2_G);

    SevenSeg1_High_Inst : entity work.Binary_To_7Segment
		port map (
			i_Clk 			=> i_Clk,
			i_Binary_Num	=> std_logic_vector(to_unsigned(w_Count_High, 4)),
			o_Segment_A		=> w_Segment1_A,
			o_Segment_B		=> w_Segment1_B,
			o_Segment_C		=> w_Segment1_C,
			o_Segment_D		=> w_Segment1_D,
			o_Segment_E		=> w_Segment1_E,
			o_Segment_F		=> w_Segment1_F,
			o_Segment_G		=> w_Segment1_G);

    --
    -- Seven Segment LEDs are active low
    --
	o_Segment1_A <= not (w_Segment1_A and w_Brightness);
	o_Segment1_B <= not (w_Segment1_B and w_Brightness);
	o_Segment1_C <= not (w_Segment1_C and w_Brightness);
	o_Segment1_D <= not (w_Segment1_D and w_Brightness);
	o_Segment1_E <= not (w_Segment1_E and w_Brightness);
	o_Segment1_F <= not (w_Segment1_F and w_Brightness);
	o_Segment1_G <= not (w_Segment1_G and w_Brightness);

	o_Segment2_A <= not (w_Segment2_A and w_Brightness);
	o_Segment2_B <= not (w_Segment2_B and w_Brightness);
	o_Segment2_C <= not (w_Segment2_C and w_Brightness);
	o_Segment2_D <= not (w_Segment2_D and w_Brightness);
	o_Segment2_E <= not (w_Segment2_E and w_Brightness);
	o_Segment2_F <= not (w_Segment2_F and w_Brightness);
	o_Segment2_G <= not (w_Segment2_G and w_Brightness);

    --
    -- Keep the LEDs from floating
    --
    -- o_LED_1 <= '0' and w_Brightness;
    o_LED_2 <= '0' and w_Brightness;
    o_LED_3 <= '0' and w_Brightness;
    o_LED_4 <= '0' and w_Brightness;

end RTL;