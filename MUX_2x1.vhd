----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2019 12:04:10 AM
-- Design Name: 
-- Module Name: MUX_2x1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_2x1 is
    Port ( I0 : in STD_LOGIC;
           I1 : in STD_LOGIC;
           sel : in STD_LOGIC;
           OP : out STD_LOGIC);
end MUX_2x1;

architecture Behavioral of MUX_2x1 is

begin

OP <= (I0 and not sel) or (I1 and sel);


end Behavioral;
