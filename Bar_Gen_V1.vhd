----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2019 11:42:03 PM
-- Design Name: 
-- Module Name: Bar_Gen_V1 - Behavioral
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

entity Bar_Gen_V1 is
    generic (DATA_SIZE:positive:= 8;
             count_size_top: integer:= 32);
    Port ( 
           Data_in  : in STD_LOGIC_VECTOR (DATA_SIZE - 1 downto 0);                                 -- Data in for TX
           SRB      : in STD_LOGIC_VECTOR (integer(ceil(log2(real(DATA_SIZE)))) - 1 downto 0);      -- Shift/Rotate amount 
           SR_SW    : in STD_LOGIC;                                                                 -- Shift/Rotate selector
           --SL_SW    : in STD_LOGIC;
           --Data_out : out STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0);
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           an       : out STD_LOGIC_VECTOR (7 downto 0);
           dig_c    : out STD_LOGIC_VECTOR (6 downto 0);
           --
           tx_btn   : in STD_LOGIC;            -- Transmitter button
           tx_act   : out STD_LOGIC;           -- Transmitter Signal LED 
           tx_ser_o : out STD_LOGIC;           -- Transmitted Signal 
           tx_done  : out STD_LOGIC;           -- Transmitter Signal Done LED 
           --  
           rx_ser_i : in  std_logic;           -- Serial Signal
           rx_btn   : in  std_logic;           -- Serial Signal Button in... Unnecessary? 
           rx_out   : out std_logic           -- Serial Signal Out LED 
           --   
           );
end Bar_Gen_V1;


architecture Behavioral of Bar_Gen_V1 is

--------------------------------- Wires & Signals --------------------------------------------------

--------------- Shifter Signals ------------------
type tmp_array is array (0 to integer(ceil(Log2(real(DATA_SIZE))))) of std_logic_vector(DATA_SIZE-1 downto 0); -- Array for hold input values and Barel shift them 
signal tmp: tmp_array; 
signal total: Integer;
--signal tmp_LR: STD_LOGIC;

-------------- SSEG Signals ----------------------
signal dig_t: STD_LOGIC_VECTOR (3 downto 0);
signal dig_enc: std_logic_vector(6 downto 0);
signal count_out:std_logic_vector(count_size_top-1 downto 0);

-------------- TX & RX Signals -------------------
signal d_out : STD_LOGIC_vector(data_size - 1 downto 0);
signal t_d_out : STD_LOGIC_vector(data_size - 1 downto 0);

--------------------------------- Components -------------------------------------------------------

-------------------- BARREL SHIFTER COMPONENTS -----------------------
component E_MUX is
    Port ( I0 : in STD_LOGIC;
           I1_1 : in STD_LOGIC;
           I1_2 : in STD_LOGIC;
           sr : in STD_LOGIC;
           sel : in STD_LOGIC;
           OP : out STD_LOGIC);
end component;


component MUX_2x1 is
    Port ( I0 : in STD_LOGIC;
           I1 : in STD_LOGIC;
           sel : in STD_LOGIC;
           OP : out STD_LOGIC);
end component;

---------------------- SSEG DISPLAY COMPONENTS ------------------------
component counter is
    generic (count_size:integer:= 32); 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR ( count_size - 1 downto 0));
end component;

component sseg_encoder is
    Port ( s : in STD_LOGIC_VECTOR (3 downto 0);
           dig : out STD_LOGIC_VECTOR (6 downto 0));
end component;

------------------ TX & RX COMPONENTS ---------------------------------

component UART_TX is
  generic (g_CLKS_PER_BIT: POSITIVE:= 50000); 
  Port (
         i_clk      : in  std_logic;                    -- Clock for the system 
         i_TX_DV    : in  std_logic;                    -- This is the ready bit to signal the transmission to start 
                                                        -- (set it to a button in the xdc file)
         i_TX_BYTE  : in  std_logic_vector(7 downto 0); --INTEGER(log2(real(g_CLKS_PER_BIT))) - 1 downto 0); 
         o_TX_active: out std_logic;                    -- Set to an LED lets you know when you are transmitting
         o_TX_SERIAL: out std_logic;                    -- Set this under PIN D4 so send out TX_byte in serial form
         o_TX_Done  : out std_logic                     -- Set to an LED to know when the transmission is done 
       );
end component;


component UART_RX_V1 is
  generic (
    g_CLKS_PER_BIT : integer := 50000     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component;

-------------------------------------- Port Mapping ----------------------------------------------------------

begin

COUNT: counter generic map (count_size => count_size_top)   
                       port map    (
                                      clk => clk,
                                      rst => rst,
                                      count =>  count_out 
                                    );
                                    
SSEG_ENC: sseg_encoder port map (
                                    s   => dig_t,
                                    dig => dig_enc 
                                 );
                                 
----------------------- TX & RX COMPONENTS ------------------------------                                 
 dig_c <= not dig_enc;
    
UART_TX_GEN: UART_TX  port map (
                             i_clk       => clk,                    -- Clock for the system 
                             i_TX_DV     => tx_btn ,                -- This is the ready bit to signal the transmission to start 
                                                                    -- (set it to a button in the xdc file)
                             i_TX_BYTE   => t_d_out,                  --INTEGER(log2(real(g_CLKS_PER_BIT))) - 1 downto 0); 
                             o_TX_active => tx_act,                 -- Set to an LED lets you know when you are transmitting
                             o_TX_SERIAL => tx_ser_o,               -- Set this under PIN D4 so send out TX_byte in serial form
                             o_TX_Done   => tx_done                 -- Set to an LED to know when the transmission is done 
                           );
                           
                           
 UART_RX_GEN: UART_RX_V1 port map (
                            i_Clk       => clk,                     -- Clock for the system                     -- Reset for the RX system IDK WHY 
                            i_RX_Serial => rx_ser_i,                -- Serial input for the block form the UART Cable
                            o_RX_DV     => rx_out,                  -- LED signal light 
                            o_RX_Byte   => d_out                    -- Send out the save RX signal to the Dispaly
                            );
                         
--------------------------------------------------- Barrel Shifter (MUX) ------------------------------------------------------------


tmp(0) <= Data_in;

O_LOOP: for J in 0 to (integer(ceil(log2(real(DATA_SIZE)))) - 1) generate
        
        
        
        I_LOOP: for I in 0 to DATA_SIZE - 1 generate 
        
                Mid_MUX: if I < DATA_SIZE - (2**J) generate
                    
                    MUX_1: MUX_2x1 port map (
                                                I0 => tmp(J)(I),
                                                I1 => tmp(J)(I + (2**J)),
                                                sel => SRB(integer(ceil(log2(real(DATA_SIZE)))) - (J + 1)),
                                                OP => tmp(J+1)(I) 
                                            );
                end generate Mid_MUX;
                
                
               
                END_MUX: if I >= DATA_SIZE - (2**J) generate
                    MUX_2: E_MUX port map (
                                               I0    => tmp(J)(I),
                                               I1_1  => '0',
                                               I1_2  => tmp(J)(abs(DATA_SIZE - I - (2**J))),
                                               sr    => SR_SW,
                                               sel   => SRB(integer(ceil(log2(real(DATA_SIZE)))) - (J + 1)),  
                                               OP    => tmp(J+1)(I)                                               
                                             );                    
                 end generate END_MUX; 
                 

       
        end generate I_LOOP;        
        total <= (J+1);
          
end generate O_LOOP; 

            t_d_out <= tmp(total);

--------------------------------------------------------- 7 Segment Display -----------------------------------------------------
  
DECODING_SEG: process(count_out(count_size_top-16 downto count_size_top-19))
              begin 
                  case count_out(count_size_top-16 downto count_size_top-19) is 
                      when "0000" => an <= "11111110";
                      when "0001" => an <= "11111101";
                      when "0010" => an <= "11111111";
                      when "0011" => an <= "11111111";
                      when "0100" => an <= "11111111";
                      when "0101" => an <= "11111111";
                      when "0110" => an <= "11111111";
                      when "0111" => an <= "11111111";
                      when others => an <= (others =>'1'); 
                  end case; 
              end process DECODING_SEG;
                            
              

SEND_DIG: process(count_out(count_size_top-16 downto count_size_top-19),d_out)
              begin 
                  case count_out(count_size_top-16 downto count_size_top-19) is 
                      when "0000" => dig_t <= d_out (3 downto 0);
                      when "0001" => dig_t <= d_out (7 downto 4);
                    --  when "0010" => dig_t <= d_out (11 downto 8);
                    --  when "0011" => dig_t <= d_out (15 downto 12);
                    --  when "0100" => dig_t <= d_out (19 downto 16);
                    --  when "0101" => dig_t <= d_out (23 downto 20);
                    --  when "0110" => dig_t <= d_out (27 downto 24);
                    --  when "0111" => dig_t <= d_out (31 downto 28);
                      when others => dig_t <= (others =>'Z'); 
                  end case; 
              end process SEND_DIG;   
   
   
   


end Behavioral;
