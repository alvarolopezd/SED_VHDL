-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;



entity TOP is
  Port ( 
  --ENTRADAS
    TECLADO_top: in std_logic_vector(7 downto 0); -- Entrada: teclado numerico
  	RESET_top : in std_logic; -- Boton de reset para volver al estado inicial
    CLK_top : in std_logic; -- Reloj
  --SALIDAS
  
    DISPLAY_top : out std_logic_vector(6 downto 0); -- Display de 7 segmentos                    
    ANODE_top : out std_logic_vector(3 downto 0); -- Activacion de cada uno de los displays       
    LED_ERROR_top : out std_logic; -- LED DE ERROR
    LED_FATAL_ERROR_top : out std_logic; -- LED DE ERROR
    LED_ACIERTO_top : out std_logic -- LED DE ACIERTO
  );
end TOP;

architecture Behavioral of TOP is

component FSM 
    port (
     	-- ENTRADAS
  	TECLADO: in std_logic_vector(7 downto 0); -- Entrada: teclado numerico
  	RESET : in std_logic; -- Boton de reset para volver al estado inicial
    CLK : in std_logic; -- Reloj
	-- SALIDAS
	VAL_DISPLAY_TOTAL :out std_logic_vector (27 downto 0);
    LED_ERROR: out std_logic; -- LED DE ERROR
    LED_FATAL_ERROR: out std_logic; -- LED DE ERROR
    LED_ACIERTO: out std_logic -- LED DE ACIERTO
    );  
 end component;
 
 component Display 
    port (
       VAL_DISPLAY_TOTAL :in std_logic_vector (27 downto 0);
       CLK : in std_logic; -- Reloj
       DISPLAY : out std_logic_vector(6 downto 0); -- Display de 7 segmentos                     
       ANODE: out std_logic_vector(3 downto 0) -- Activacion de cada uno de los displays        -
        );  
end component;
    
 signal val_display_total : std_logic_vector(27 downto 0);   
begin
  Inst_FSM : FSM PORT MAP (
    TECLADO =>  TECLADO_top,
  	RESET   => RESET_top,
    CLK     => CLK_top,
    VAL_DISPLAY_TOTAL  => val_display_total,
    LED_ERROR  => LED_ERROR_top,
    LED_FATAL_ERROR  => LED_FATAL_ERROR_top,
    LED_ACIERTO  => LED_ACIERTO_top
 );
 
 Inst_Display : Display PORT MAP ( 
     VAL_DISPLAY_TOTAL  => val_display_total,
     CLK     => CLK_top,
     DISPLAY => DISPLAY_top,                   
     ANODE => ANODE_top
 );
end Behavioral;
