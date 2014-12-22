--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:42:57 09/14/2014
-- Design Name:   
-- Module Name:   C:/Users/jjshawver/Documents/DHD/RTL/Adder16CLA/tb_adder16cla.vhd
-- Project Name:  Adder16CLA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Adder16CLA
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_adder16cla IS
END tb_adder16cla;
 
ARCHITECTURE behavior OF tb_adder16cla IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Adder16CLA
    PORT(
         x_in : IN  std_logic_vector(15 downto 0);
         y_in : IN  std_logic_vector(15 downto 0);
         c_in : IN  std_logic;
         sum : OUT  std_logic_vector(15 downto 0);
         c_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x_in : std_logic_vector(15 downto 0) := (others => '0');
   signal y_in : std_logic_vector(15 downto 0) := (others => '0');
   signal carry_in : std_logic := '0';

	
 	--Outputs
   signal sum : std_logic_vector(15 downto 0);
   signal carry_out : std_logic;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Adder16CLA PORT MAP (
          x_in => x_in,
          y_in => y_in,
          c_in => carry_in,
          sum => sum,
          c_out => carry_out
        );

   -- Clock process definitions

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

			for i in 0 to 256 loop
				
				for j in 0 to 257 loop
					wait for 10 ns;
					x_in <= std_logic_vector(to_unsigned(j, x_in'length));
				end loop;
				y_in <= std_logic_vector(to_unsigned(i, y_in'length));
			end loop;

      wait;
   end process;

END;
