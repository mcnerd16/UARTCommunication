----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/03/2019 09:44:00 AM
-- Design Name: 
-- Module Name: sseg_encoder - Behavioral
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

entity sseg_encoder is
    Port ( s : in STD_LOGIC_VECTOR (3 downto 0);
           dig : out STD_LOGIC_VECTOR (6 downto 0));
end sseg_encoder;

architecture Behavioral of sseg_encoder is

begin


ENCODER:process(s)
        begin 
           CASE_ENCODER: case s is 
            when "0000" => dig <= "1111110";
            when "0001" => dig <= "0110000";
            when "0010" => dig <= "1101101";
            when "0011" => dig <= "1111001";
            when "0100" => dig <= "0110011";
            when "0101" => dig <= "1011011";
            when "0110" => dig <= "1011111";
            when "0111" => dig <= "1110000";
            when "1000" => dig <= "1111111";
            when "1001" => dig <= "1111011";
            when "1010" => dig <= "1110111";
            when "1011" => dig <= "0011111";
            when "1100" => dig <= "1001110";
            when "1101" => dig <= "0111101";
            when "1110" => dig <= "1001111";
            when "1111" => dig <= "1000111";
            when others => dig <= (others =>'Z'); 
            
            end case CASE_ENCODER; 
        end process ENCODER; 

end Behavioral;
