----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:01 10/05/2014 
-- Design Name: 
-- Module Name:    Btns - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pulse is
    Port ( data_in : in  STD_LOGIC;
           clk_in : in  STD_LOGIC;
           pulse_out : out  STD_LOGIC
			  );
end Pulse;



architecture Behavioral of Pulse is 

signal q : std_logic;

begin
pulse_out <= q and data_in;
 process (data_in,clk_in)  begin
	if(clk_in'event and clk_in = '1') then
		q <= not data_in;
	else 
	end if;
 end process ;
 
end Behavioral;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Btns is
    Port ( BTNS_IN : in  STD_LOGIC_VECTOR (3 downto 0);
			  CLK_IN : in  STD_LOGIC;
           BTNS_OUT : out  STD_LOGIC_VECTOR (3 downto 0)
			 );
end Btns;

architecture Behavioral of Btns is


begin
B0: entity work.Pulse
	PORT map(
		data_in => BTNS_IN(0),
		CLK_IN => clk_in,
		pulse_out => BTNS_OUT(0)
	);
B1: entity work.Pulse
	PORT map(
		data_in => BTNS_IN(1),
		clk_in => CLK_IN,
		pulse_out => BTNS_OUT(1)
	);
B2: entity work.Pulse
	PORT map(
		data_in => BTNS_IN(2),
		clk_in => CLK_IN,
		pulse_out => BTNS_OUT(2)
	);
B3: entity work.Pulse
	PORT map(
		data_in => BTNS_IN(3),
		clk_in => CLK_IN,
		pulse_out => BTNS_OUT(3)
	);

end Behavioral;

