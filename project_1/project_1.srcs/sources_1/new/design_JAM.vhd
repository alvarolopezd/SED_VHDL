-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- S0 ESTADO ESPERA
-- S1 1º DIGITO
-- S2 2º DIGITO
-- S3 3º DIGITO
-- S4 4º DIGITO
-- S5 COMPROBACION
-- S6 ACIERTO
-- S7 ERROR. QUEDAN INTENTOS
-- S8 ERROR. NO QUEDAN INTENTOS


entity FSM is
  port (
 	-- ENTRADAS
  	TECLADO: in std_logic_vector(7 downto 0); -- Entrada: teclado numerico
  	RESET : in std_logic; -- Boton de reset para volver al estado inicial
    --OK_BOTON : in std_logic; -- Boton comprobar si es correcto
    CLK : in std_logic; -- Reloj
	-- SALIDAS
    LED_ERROR: out std_logic; -- LED DE ERROR
    LED_FATAL_ERROR: out std_logic; -- LED DE ERROR
    LED_ACIERTO: out std_logic; -- LED DE ACIERTO
    VAL_DISPLAY_TOTAL :out std_logic_vector (27 downto 0);
    actual_state: out std_logic_vector(3 downto 0)		--Estado real.
);
end FSM;


architecture behavioral of FSM is
    type STATES is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
    signal current_state: STATES:=S0;
    signal next_state: STATES;
    signal correct_pasw : std_logic_vector(15 downto 0) := "0001001000110100"; -- CONTRASEÑA CORRECTA 0001 0010 0011 0100 (1 2 3 4)
    signal current_pasw : std_logic_vector(15 downto 0):= "0000000000000000"; -- VECTOR DONDE ALMACENO CONTRASEÑA QUE EL USARUAIO TECLEA
    signal digito_BCD: std_logic_vector(3 downto 0); -- Reocger valor en binario BCD del teclado
    signal cnt_error: integer:=0; -- CONTADOR DE NUMERO DE ERRORES QUE LLEVO
    
---Manejo y actualización de display.
    signal refresh_counter: integer range 0 to 900000;	--Contador de ciclos.
    signal valor_display: std_logic_vector (6 downto 0); --Para saber el numero en singular que imprime el display
    signal valor_display_total :std_logic_vector (27 downto 0); --para saber el numero total en display
  begin


-- ACTUALIZACION DEL CURRENT_STATE
state_register: process (RESET, CLK)
  begin
  	if RESET='0' then -- usamos pulsador pull-up de la placa
    	if (current_state=S1) OR (current_state=S2) OR (current_state=S3) OR (current_state=S4) OR (current_state=S6) OR (current_state=S7) OR (current_state=S8) then 
    		current_state <= S0;
        end if;
    elsif (CLK'event) and (CLK='1') then
    	current_state<=next_state;
    end if;    
end process;
  
-- TRANSICIONES  
nextstate_decod: process (TECLADO, current_state) 
  begin
  next_state <= current_state;
  case current_state is
  when S0 =>				-- S0 Introducir un numero del teclado
  	if TECLADO /= "11111111" and (TECLADO'event) then
  		next_state <= S1;
  	end if;
  when S1 =>				-- S1 Introducir un numero del teclado
    if TECLADO /= "11111111" and (TECLADO'event) then
    	next_state <= S2;
    end if;
  when S2 =>				-- S2 Introducir un numero del teclado
    if TECLADO /= "11111111" and (TECLADO'event) then
    	next_state <= S3;
    end if;
  when S3 =>				-- S3 Introducir un numero del teclado
    if TECLADO /= "11111111" and (TECLADO'event) then
      next_state <= S4;
    end if;  
    when S4 =>				-- S4 Pulsar el boton de OK para comprobar
  	if TECLADO= "11101101" and  (TECLADO'event) then	-- PULSO # o if OK_BOTON='1' then
  		next_state <= S5;
  	end if;
  when S5 =>				-- S5 Se comprueba si es correcto
    if (correct_pasw = current_pasw) then
    	next_state <= S6;
    elsif (correct_pasw /= current_pasw) AND (cnt_error<2) then
    	next_state <= S7;    
    elsif (correct_pasw /= current_pasw) AND (cnt_error=2) then
      next_state <= S8;    
    end if;
  when S6 =>				
    if RESET='0' then
    	next_state <= S0;
    end if;
  when S7 =>
    if RESET='0' then
      next_state <= S0;
   	end if; 
  when S8 =>
   	if RESET='0' then
     	next_state <= S0;
    end if; 
  when others => 
  	next_state <= S0;  
	end case;
end process;
  

-- ACCIONES DE CADA ESTADO 
output_decod: process (current_state)
  begin
  case current_state is
  when S0 =>								-- S0
  	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
    	actual_state<="0000";
  --  ANODE<="1111";
    current_pasw <= "0000000000000000";
    valor_display_total <= "1111110111111011111101111110"; -- display tiene ahora ----
    --DISPLAY<="0000000"; DEBERIA SER TODO 1
  when S1 =>								-- S1
  	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
    	actual_state<="0001";
    --ANODE<="0111";
    	current_pasw(15)<=digito_BCD(3);
        current_pasw(14)<=digito_BCD(2);
        current_pasw(13)<=digito_BCD(1);
        current_pasw(12)<=digito_BCD(0);
        valor_display_total(27) <= valor_display(6);
        valor_display_total(26) <= valor_display(5);
        valor_display_total(25) <= valor_display(4);
        valor_display_total(24) <= valor_display(3);
        valor_display_total(23) <= valor_display(2);
        valor_display_total(22) <= valor_display(1);
        valor_display_total(21) <= valor_display(0);
        
  when S2 =>								-- S2
  	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
        actual_state<="0010";
   -- ANODE<="0011";
        current_pasw(11)<=digito_BCD(3);
        current_pasw(10)<=digito_BCD(2);
        current_pasw(9)<=digito_BCD(1);
        current_pasw(8)<=digito_BCD(0);
        valor_display_total(20) <= valor_display(6);
        valor_display_total(19) <= valor_display(5);
        valor_display_total(18) <= valor_display(4);
        valor_display_total(17) <= valor_display(3);
        valor_display_total(16) <= valor_display(2);
        valor_display_total(15) <= valor_display(1);
        valor_display_total(14) <= valor_display(0);
  when S3 =>								-- S3
  	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
        actual_state<="0011";
   -- ANODE<="0001";
        current_pasw(7)<=digito_BCD(3);
        current_pasw(6)<=digito_BCD(2);
        current_pasw(5)<=digito_BCD(1);
        current_pasw(4)<=digito_BCD(0);   
        valor_display_total(13) <= valor_display(6);
        valor_display_total(12) <= valor_display(5);
        valor_display_total(11) <= valor_display(4);
        valor_display_total(10) <= valor_display(3);
        valor_display_total(9) <= valor_display(2);
        valor_display_total(8) <= valor_display(1);
        valor_display_total(7) <= valor_display(0);     
  when S4 =>								-- S4
  	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
        actual_state<="0100";
   -- ANODE<="0000";
        current_pasw(3)<=digito_BCD(3);
        current_pasw(2)<=digito_BCD(2);
        current_pasw(1)<=digito_BCD(1);
        current_pasw(0)<=digito_BCD(0);   
        valor_display_total(6) <= valor_display(6);
        valor_display_total(5) <= valor_display(5);
        valor_display_total(4) <= valor_display(4);
        valor_display_total(3) <= valor_display(3);
        valor_display_total(2) <= valor_display(2);
        valor_display_total(1) <= valor_display(1);
        valor_display_total(0) <= valor_display(0);     
  when S5 =>								-- S5
	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
        actual_state<="0101";
  when S6 =>								-- S6
	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='1';
    	    actual_state<="0110";
    cnt_error<=0;
  when S7 =>								-- S7
	LED_ERROR<='1';
    LED_ACIERTO<='0';
        actual_state<="0111";
    cnt_error<=cnt_error+1;
  when S8 =>								-- S8
   	LED_ERROR<='0';
    LED_FATAL_ERROR<='1';
    LED_ACIERTO<='0';
        actual_state<="1000"; 
    cnt_error<=0;
  end case;
end process;

-- PASAR DE TECLADO A DIGITO EN BCD PARA GUARDARLO EN CURRENT_PASW
decoder: process (TECLADO)
begin
    if     TECLADO = "11101011" then digito_BCD <= "0000" ; --0
    elsif  TECLADO = "01110111" then digito_BCD <= "0001" ; --1
    elsif  TECLADO = "01111011" then digito_BCD <= "0010" ; --2
    elsif  TECLADO = "01111101" then digito_BCD <= "0011" ; --3 
    elsif  TECLADO = "10110111" then digito_BCD <= "0100" ; --4
    elsif  TECLADO = "10111011" then digito_BCD <= "0101" ; --5
    elsif  TECLADO = "10111101" then digito_BCD <= "0110" ; --6
    elsif  TECLADO = "11010111" then digito_BCD <= "0111" ; --7
    elsif  TECLADO = "11011011" then digito_BCD <= "1000" ; --8 
    elsif  TECLADO = "11011101" then digito_BCD <= "1001" ; --9
    end if ;
end process;

-- PASAR DE DIGITO EN BCD A LEDS DISPLAY
process(digito_BCD)
begin
    case digito_BCD is
	-- Depende del numero, se iluminan unos leds u otros 
    when "0000" => valor_display <= "0000001"; -- "0" 
    when "0001" => valor_display <= "1001111"; -- "1" 
    when "0010" => valor_display <= "0010010"; -- "2" 
    when "0011" => valor_display <= "0000110"; -- "3" 
    when "0100" => valor_display <= "1001100"; -- "4" 
    when "0101" => valor_display <= "0100100"; -- "5" 
    when "0110" => valor_display <= "0100000"; -- "6" 
    when "0111" => valor_display <= "0001111"; -- "7" 
    when "1000" => valor_display <= "0000000"; -- "8" 
    when "1001" => valor_display <= "0000100"; -- "9" 
    when others => valor_display <= "1111110"; -- "-" indica que no hay nada 
    end case;
end process;

VAL_DISPLAY_TOTAL <= valor_display_total;

end behavioral;


