-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity TOP_tb is
end entity;

architecture test of TOP_tb is
    -- ENTRADAS
  	signal TECLADO_top: std_logic_vector(7 downto 0):="11111111"; -- Entrada: teclado numerico
  	signal RESET_top : std_logic:='1'; -- Boton de reset para volver al estado inicial
    --signal OK_BOTON : std_logic:='0'; -- Boton comprobar si es correcto
    signal CLK_top : std_logic:='0'; -- Reloj
	
    -- SALIDAS
    signal DISPLAY_top : std_logic_vector(6 downto 0); -- Display de 7 segmentos
    signal ANODE_top: std_logic_vector(3 downto 0); -- Activacion de cada uno de los displays
    signal LED_ERROR_top: std_logic; -- LED DE ERROR
    signal LED_FATAL_ERROR_top: std_logic; -- LED DE ERROR
    signal LED_ACIERTO_top: std_logic; -- LED DE ACIERTO
    
    
    component TOP is
        port(
 	  	-- ENTRADAS
  	TECLADO_top: in std_logic_vector(7 downto 0); -- Entrada: teclado numerico
  	RESET_top : in std_logic; -- Boton de reset para volver al estado inicial
    CLK_top : in std_logic; -- Reloj
	-- SALIDAS
    LED_ERROR_top: out std_logic; -- LED DE ERROR
    LED_FATAL_ERROR_top: out std_logic; -- LED DE ERROR
    LED_ACIERTO_top: out std_logic; -- LED DE ACIERTO
    DISPLAY_top : out std_logic_vector(6 downto 0); -- Display de 7 segmentos                    
    ANODE_top : out std_logic_vector(3 downto 0) -- Activacion de cada uno de los displays       
        );
    end component;

begin

	uut: TOP	--Unit Under Test
    	port map (
	TECLADO_top =>  TECLADO_top,
  	RESET_top   => RESET_top,
    CLK_top     => CLK_top,
    LED_ERROR_top  => LED_ERROR_top,
    LED_FATAL_ERROR_top  => LED_FATAL_ERROR_top,
    LED_ACIERTO_top  => LED_ACIERTO_top,
    DISPLAY_top => DISPLAY_top,   
    ANODE_top => ANODE_top
        );


	CLK_top <= not CLK_top after 2 ms;  ---La placa va a una frecuencia de 450 MHz.
    
						----- 1º ERROR (2234) ------
    TECLADO_top <= "11111111",
    "01111011"after 0.2 sec, "11111111" after 0.5 sec, -- 2
    "01111011" after 1 sec, "11111111" after 1.5 sec, --2
    "01111101" after 2 sec, "11111111" after 2.5 sec, --3
    "10110111" after 3 sec, "11111111" after 3.5 sec,--4
    "10111011" after 4 sec, "11111111" after 4.5 sec, -- 5 DEBE SER IGNORADO ( ESTOY EN S4)
    -- LE DOY AL OK (#)
    "11101101" after 5 sec, "11111111" after 5.5 sec,--#
    "01111011" after 6 sec, "11111111" after 6.5 sec, -- 2 DEBE SER IGNORADO ( ESTOY EN S7)
    
    --Y LUEGO RESET    
    
    					----- 2º ERROR (3423) ------
    
    "01111101" after 8 sec, "11111111" after 8.5 sec,--3
    "10110111" after 9 sec, "11111111" after 9.5 sec,--4
    "01111011" after 10 sec, "11111111" after 10.5 sec,--2
    "01111101" after 11 sec, "11111111" after 11.5 sec,--3
    "10111011" after 12 sec, "11111111" after 12.5 sec, -- 5 DEBE SER IGNORADO ( ESTOY EN S4)
     -- LE DOY AL OK (#)
    "11101101" after 13 sec, "11111111" after 13.5 sec,--#
    "10110111" after 14 sec, "11111111" after 14.5 sec, -- 4 PERO NO LO DEBE COGER PORQUE ESTA EN EL ESTADO 7
    
    --Y LUEGO RESET    
    
    					---------- ACIERTO (1234) ----------
                        
    "01110111" after 16 sec, "11111111" after 16.5 sec,--1
    "01111011" after 17 sec, "11111111" after 17.5 sec,--2
    "01111101" after 18 sec, "11111111" after 18.5 sec,--3
    "10110111" after 19 sec, "11111111" after 19.5 sec,--4
    "10111011" after 20 sec, "11111111" after 20.5 sec, -- 5 DEBE SER IGNORADO ( ESTOY EN S4)
     -- LE DOY AL OK (#)
    "11101101" after 21 sec, "11111111" after 21.5 sec,--#
    "10110111" after 22 sec, "11111111" after 22.5 sec, -- 4 PERO NO LO DEBE COGER PORQUE ESTA EN EL ESTADO 7
    
    --Y LUEGO RESET   
    
       						----- 1º ERROR (2234) ------
    "01111011" after 24 sec, "11111111" after 24.5 sec, -- 2
    "01111011" after 25 sec, "11111111" after 25.5 sec, --2
    "01111101" after 26 sec, "11111111" after 26.5 sec, --3
    "10110111" after 27 sec, "11111111" after 27.5 sec,--4
    "10111011" after 28 sec, "11111111" after 28.5 sec, -- 5 DEBE SER IGNORADO ( ESTOY EN S4)
    -- LE DOY AL OK (#)
    "11101101" after 29 sec, "11111111" after 29.5 sec,--#
    "01111011" after 30 sec, "11111111" after 30.5 sec, -- 2 DEBE SER IGNORADO ( ESTOY EN S7)
    
    --Y LUEGO RESET    
    
    					----- 2º ERROR (3423) ------
    
    "01111101" after 32 sec, "11111111" after 32.5 sec,--3
    "10110111" after 33 sec, "11111111" after 33.5 sec,--4
    "01111011" after 34 sec, "11111111" after 34.5 sec,--2
    "01111101" after 35 sec, "11111111" after 35.5 sec,--3
    "10111011" after 36 sec, "11111111" after 36.5 sec, -- 5 DEBE SER IGNORADO ( ESTOY EN S4)
     -- LE DOY AL OK (#)
    "11101101" after 37 sec, "11111111" after 37.5 sec,--#
    "10110111" after 38 sec, "11111111" after 38.5 sec, -- 4 PERO NO LO DEBE COGER PORQUE ESTA EN EL ESTADO 7
    
    --Y LUEGO RESET    
    
        					----- 3º ERROR (9876) ------
    
    "11011101" after 40 sec, "11111111" after 40.5 sec,--9
    "11011011" after 41 sec, "11111111" after 41.5 sec,--8
    "11010111" after 42 sec, "11111111" after 42.5 sec,--7
    "10111101" after 43 sec, "11111111" after 43.5 sec,--6
    "10111101" after 44 sec, "11111111" after 44.5 sec, -- 5 DEBE SER IGNORADO ( ESTOY EN S4)
     -- LE DOY AL OK (#)
    "11101101" after 45 sec, "11111111" after 45.5 sec,--#
    "10110111" after 46 sec, "11111111" after 46.5 sec; -- 4 PERO NO LO DEBE COGER PORQUE ESTA EN EL ESTADO 7
    
    --Y LUEGO RESET   
    
    
            RESET_top<=
        '0' after 7 sec, '1' after 7.5 sec, -- 1º ERROR
        '0' after 15 sec, '1' after 15.5 sec, -- 2º ERROR
        '0' after 23 sec, '1' after 23.5 sec, -- ACIERTO 
        '0' after 31 sec, '1' after 31.5 sec, -- 1º ERROR
        '0' after 39 sec, '1' after 39.5 sec, -- 2º ERROR
        '0' after 47 sec, '1' after 47.5 sec; -- 3º ERROR
   	
    --OK_BOTON <= '1' after 3.3 us, '0' after 4.5 us, '1' after 11 us, '0' after 11.5 us; -- Aqui ocurre que el primero si pasa al estado 5, pero en el segunod caso no porque se pulsa OK_BOTON una vez se suelta el ultimo boton del ultimo numero

   
    process
    begin
    	wait for 50 sec;
        assert false
        	report "[SUCCESS]: simulation finished."
            severity failure;
        end process;

end architecture;
