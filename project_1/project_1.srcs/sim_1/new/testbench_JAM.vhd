-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity FSM_tb is
end entity;

architecture test of FSM_tb is
    -- ENTRADAS
  	signal TECLADO: std_logic_vector(7 downto 0):="11111111"; -- Entrada: teclado numerico
  	signal RESET : std_logic:='1'; -- Boton de reset para volver al estado inicial
    --signal OK_BOTON : std_logic:='0'; -- Boton comprobar si es correcto
    signal CLK : std_logic:='0'; -- Reloj
	
    -- SALIDAS
    signal DISPLAY : std_logic_vector(6 downto 0); -- Display de 7 segmentos
    signal ANODE: std_logic_vector(3 downto 0); -- Activacion de cada uno de los displays
    signal LED_ERROR: std_logic; -- LED DE ERROR
    signal LED_FATAL_ERROR: std_logic; -- LED DE ERROR
    signal LED_ACIERTO: std_logic; -- LED DE ACIERTO
    signal actual_state: std_logic_vector(3 downto 0);	--Estado real
    signal selecion:  std_logic_vector(1 downto 0);
    
    component FSM is
        port(
 	-- ENTRADAS
  	TECLADO: in std_logic_vector(7 downto 0); -- Entrada: teclado numerico
  	RESET : in std_logic; -- Boton de reset para volver al estado inicial
    --OK_BOTON : in std_logic; -- Boton comprobar si es correcto
    CLK : in std_logic; -- Reloj
	-- SALIDAS
    DISPLAY : out std_logic_vector(6 downto 0); -- Display de 7 segmentos
    ANODE: out std_logic_vector(3 downto 0); -- Activacion de cada uno de los displays
    LED_ERROR: out std_logic; -- LED DE ERROR
    LED_FATAL_ERROR: out std_logic; -- LED DE ERROR
    LED_ACIERTO: out std_logic; -- LED DE ACIERTO
    selecion: out std_logic_vector(1 downto 0);
        actual_state: out std_logic_vector(3 downto 0)		--Estado real.
        );
    end component;

begin

	uut: FSM	--Unit Under Test
    	port map (
	    	TECLADO    => TECLADO,
            RESET => RESET,
            --OK_BOTON => OK_BOTON,
            CLK => CLK,
            DISPLAY => DISPLAY,
            ANODE => ANODE,
            LED_ERROR => LED_ERROR,
            LED_FATAL_ERROR => LED_FATAL_ERROR,
            LED_ACIERTO => LED_ACIERTO,
            actual_state => actual_state,
            selecion => selecion
        );


	CLK <= not CLK after 2 ms;  ---La placa va a una frecuencia de 450 MHz.
    
						----- 1º ERROR (2234) ------
    TECLADO <= "11111111",
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
    
    
            RESET<=
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

