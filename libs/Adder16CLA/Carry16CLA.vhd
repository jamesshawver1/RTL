----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:04:08 09/14/2014 
-- Design Name: 
-- Module Name:    Carry16CLA - Behavioral 
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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
Entity Adder16CLA is 
	PORT(
		 x_in      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
         c_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
         c_out :  OUT  STD_LOGIC
        );
END Adder16CLA;

ARCHITECTURE rtl  of Adder16CLA is

	signal c :    STD_LOGIC_VECTOR(15 downto 0);
	signal g :    STD_LOGIC_VECTOR(15 downto 0);
	signal p :    STD_LOGIC_VECTOR(15 downto 0);
	
	begin
	g <= x_in and y_in;
	p <= x_in xor y_in;
	--stage 0
	c(0) <= c_in;

	--stage 1
	c(1) <= g(0) or
			(p(0) and c_in);

	--stage 2
	c(2) <=  g(1) or
			(p(1) and g(0)) or
			(p(1) and p(0) and c_in);

	--stage 3
	c(3) <=  g(2) or
			(p(2) and g(1)) or
			(p(2) and p(1) and g(0)) or
			(p(2) and p(1) and p(0) and c_in);

	--stage 4
	c(4) <=  g(3) or
			(p(3) and g(2)) or
			(p(3) and p(2) and g(1)) or
			(p(3) and p(2) and p(1) and g(0)) or
			(p(3) and p(2) and p(1) and p(0) and c_in);
	
	--stage 5
	c(5) <=  g(4) or
			(p(4) and g(3)) or
			(p(4) and p(3) and g(2)) or
			(p(4) and p(3) and p(2) and g(1)) or
			(p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(4) and p(3) and p(2) and p(1) and p(0) and c_in);
	
	--stage 6
	c(6) <=  g(5) or
			(p(5) and g(4)) or
			(p(5) and p(4) and g(3)) or
			(p(5) and p(4) and p(3) and g(2)) or
			(p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);
	
	--stage 7
	c(7) <=  g(6) or
			(p(6) and g(5)) or
			(p(6) and p(5) and g(4)) or
			(p(6) and p(5) and p(4) and g(3)) or
			(p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);
	
	--stage 8
	c(8) <=  g(7) or
			(p(7) and g(6)) or
			(p(7) and p(6) and g(5)) or
			(p(7) and p(6) and p(5) and g(4)) or
			(p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);
	
	--stage 9
	c(9) <=  g(8) or
			(p(8) and g(7)) or
			(p(8) and p(7) and g(6)) or
			(p(8) and p(7) and p(6) and g(5)) or
			(p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);

	--stage 10
	c(10) <=  g(9) or
			(p(9) and g(8)) or
			(p(9) and p(8) and g(7)) or
			(p(9) and p(8) and p(7) and g(6)) or
			(p(9) and p(8) and p(7) and p(6) and g(5)) or
			(p(9) and p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);

	--stage 11
	c(11) <=  g(10) or
			(p(10) and g(9)) or
			(p(10) and p(9) and g(8)) or
			(p(10) and p(9) and p(8) and g(7)) or
			(p(10) and p(9) and p(8) and p(7) and g(6)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and g(5)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);

	--stage 12
	c(12) <=  g(11) or
			(p(11) and g(10)) or
			(p(11) and p(10) and g(9)) or
			(p(11) and p(10) and p(9) and g(8)) or
			(p(11) and p(10) and p(9) and p(8) and g(7)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and g(6)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and g(5)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);

	--stage 13
	c(13) <=  g(12) or
			(p(12) and g(11)) or
			(p(12) and p(11) and g(10)) or
			(p(12) and p(11) and p(10) and g(9)) or
			(p(12) and p(11) and p(10) and p(9) and g(8)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and g(7)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and g(6)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and g(5)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);

	--stage 14
	c(14) <=  g(13) or
			(p(13) and g(12)) or
			(p(13) and p(12) and g(11)) or
			(p(13) and p(12) and p(11) and g(10)) or
			(p(13) and p(12) and p(11) and p(10) and g(9)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and g(8)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and g(7)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and g(6)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and g(5)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);

	--stage 15
	c(15) <=  g(14) or
			(p(14) and g(13)) or
			(p(14) and p(13) and g(12)) or
			(p(14) and p(13) and p(12) and g(11)) or
			(p(14) and p(13) and p(12) and p(11) and g(10)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and g(9)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and g(8)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and g(7)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and g(6)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and g(5)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and g(4)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and g(3)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			(p(14) and p(13) and p(12) and p(11) and p(10) and p(9) and p(8) and p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c_in);


	sum <= p xor c;
	c_out <= c(15);
end rtl;
