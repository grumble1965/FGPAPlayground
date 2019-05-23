library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity KMH_Counter_1 is
    port (
        i_Clk           : in std_logic;
        i_Switch_1      : in std_logic;

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
end KMH_Counter_1;

architecture RTL of KMH_Counter_1 is

    signal w_1HZ : std_logic;
    signal w_Fast : std_logic;
    signal w_Counter_Clk : std_logic;
    signal r_Counter_Clk : std_logic := '0';

	signal r_Count : integer range 0 to 255 := 0;

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
    --   We only use the 1Hz output, the rest are unconnected
    --
    LED_Blink_Inst : entity work.LED_Blink
        generic map (
            g_COUNT_10HZ => 1250000,
            g_COUNT_5HZ  => 2500000,
            g_COUNT_2HZ  => 6250000,
            g_COUNT_1HZ  => 12500000)
        port map (
            i_Clk   => i_Clk,
            o_LED_1 => w_Fast,
            o_LED_2 => open,
            o_LED_3 => open,
            o_LED_4 => w_1Hz
        );

    --
    -- Select the normal / fast clock based on Switch 1
    --
    w_Counter_Clk <= (i_Switch_1 and w_Fast) or (not i_Switch_1 and w_1HZ);

    --
    -- Build a counter
    --
    p_Counter : process(i_Clk)
    begin
   		if rising_edge(i_Clk) then
			r_Counter_Clk <= w_Counter_Clk;
			
			if (w_Counter_Clk = '1' and r_Counter_Clk = '0') then
				if (r_Count = 255) then
					r_Count <= 0;
				else
					r_Count <= r_Count + 1;
				end if;
			end if;			
		end if;		
    end process;

    --
    -- Instantiate two nibble decoders
    --
    SevenSeg1_Low_Inst : entity work.Binary_To_7Segment
		port map (
			i_Clk 			=> i_Clk,
			i_Binary_Num	=> std_logic_vector(to_unsigned(r_Count, 8))(3 downto 0),
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
			i_Binary_Num	=> std_logic_vector(to_unsigned(r_Count, 8))(7 downto 4),
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
	o_Segment1_A <= not w_Segment1_A;
	o_Segment1_B <= not w_Segment1_B;
	o_Segment1_C <= not w_Segment1_C;
	o_Segment1_D <= not w_Segment1_D;
	o_Segment1_E <= not w_Segment1_E;
	o_Segment1_F <= not w_Segment1_F;
	o_Segment1_G <= not w_Segment1_G;

	o_Segment2_A <= not w_Segment2_A;
	o_Segment2_B <= not w_Segment2_B;
	o_Segment2_C <= not w_Segment2_C;
	o_Segment2_D <= not w_Segment2_D;
	o_Segment2_E <= not w_Segment2_E;
	o_Segment2_F <= not w_Segment2_F;
	o_Segment2_G <= not w_Segment2_G;
end RTL;