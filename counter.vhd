----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/03/2019 09:42:57 AM
-- Design Name: 
-- Module Name: counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    generic (count_size:integer:= 32); 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR ( count_size - 1 downto 0));
end counter;

architecture Behavioral of counter is

signal tmp:std_logic_vector(count_size-1 downto 0); 

begin


COUNT_GEN: process(clk,rst)
           begin 
            if (rst = '1') then 
            
                tmp <= (others =>'0'); 
            elsif (rising_edge(clk)) then 
                tmp <= tmp + 1; 
            end if; 
           end process COUNT_GEN; 

 count <= tmp; 

end Behavioral;
