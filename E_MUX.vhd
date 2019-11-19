----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2019 12:04:10 AM
-- Design Name: 
-- Module Name: E_MUX - Behavioral
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

entity E_MUX is
    Port ( I0 : in STD_LOGIC;
           I1_1 : in STD_LOGIC;
           I1_2 : in STD_LOGIC;
           sr : in STD_LOGIC;
           sel : in STD_LOGIC;
           OP : out STD_LOGIC);
end E_MUX;

architecture Behavioral of E_MUX is


signal tmp_1: STD_LOGIC; 


begin

process (sr,sel,I0,I1_1,I1_2,tmp_1)
begin 
    case (sr) is 
        when '0' => tmp_1 <= I1_1;
        when '1' => tmp_1 <= I1_2;
    end case;
    
    case (sel) is
        when '0' => OP <= I0;
        when '1' => OP <= tmp_1;
    end case; 

end process;

end Behavioral;
