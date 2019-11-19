----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2019 08:45:40 AM
-- Design Name: 
-- Module Name: Bar_Gen - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Bar_Gen is
    generic (DATA_SIZE:positive:= 8);
    Port ( Data_in : in STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0);
           SEL : in STD_LOGIC_VECTOR (integer(ceil(Log2(real(DATA_SIZE))))-1 downto 0);
           Data_out : out STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0));
end Bar_Gen;

architecture Behavioral of Bar_Gen is

type tmp_array is array (0 to integer(ceil(Log2(real(DATA_SIZE))))) of std_logic_vector(DATA_SIZE-1 downto 0);
signal tmp: tmp_array;
signal B_tmp: Integer;
signal total: Integer;

begin

tmp(0) <= Data_in;

mux_gen_i: for i in 0 to integer(ceil(Log2(real(DATA_SIZE)))) - 1 generate 

    mux_gen_j1: for j in 0 to DATA_SIZE-1-(2**i) generate       
               tmp(i+1)(j) <= (tmp(i)(j) and not SEL(i)) or (tmp(i)(j+2**i) and SEL(i));
               end generate mux_gen_j1; 
               
    mux_gen_j2: for j in DATA_SIZE-(2**i) to DATA_SIZE-1 generate
                   tmp(i+1)(j) <= (tmp(i)(j) and not SEL(i)) or (tmp(i)(j+(2**i)-2**integer(ceil(Log2(real(DATA_SIZE))))) and SEL(i));
               end generate mux_gen_j2;
               
               total <= i+1;
               
           end generate mux_gen_i;

    Data_out <= tmp(total);

end Behavioral;