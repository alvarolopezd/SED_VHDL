-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity Display is
  port (
       CLK : in std_logic; -- Reloj
       VAL_DISPLAY_TOTAL :in std_logic_vector (27 downto 0);
       DISPLAY : out std_logic_vector(6 downto 0); -- Display de 7 segmentos                     
       ANODE: out std_logic_vector(3 downto 0) -- Activacion de cada uno de los displays        -
   ); 
end Display;

architecture Behavioral of Display is
 signal refresh_counter: integer range 0 to 900000;	--Contador de ciclos.
 signal selection: std_logic_vector (1 downto 0):= "00";	--Seleccion de cifra. 00 01 10 11 00
 signal selected_display: std_logic_vector (3 downto 0):="0000";	--Display seleccionado.
 signal valor_display_total :std_logic_vector (27 downto 0); --para saber el numero total en display
 
begin

--ACTUALIZAR DISPLAY.
---Comprueba que ha transcurrido el tiempo de actalización en la cifra presente. Cuando ya ha transcurrido todo el tiempo salta a hacer lo mismo con la cifra siguiente.
clock_counter: process(CLK)   
begin
	if CLK'event and CLK='1' then 
    	if refresh_counter < 2 then  --a menos numero menor tiempo de espera para cambiar el display
        	refresh_counter <= refresh_counter+1;
      	else
      	    if selection ="11" then
      	    selection <= "00";
      	    refresh_counter <= 0;
      	    else
        	selection <= selection +1;
            refresh_counter <= 0;
            end if;
        end if;
    end if;
end process;


--MOSTRAR DISPLAY.
show_display: process(selection)
begin
	--Elegir digito del display.
    case selection is
		when "00" => selected_display <= "0111";  --Cifra 0 del display activada.
        when "01" => selected_display <= "1011";  --Cifra 1 del display activada.
      	when "10" => selected_display <= "1101";  --Cifra 2 del display activada.
        when "11" => selected_display <= "1110";  --Cifra 3 del display activada.
        when others => selected_display <= "1111";	--Todas las cifras del display apagadas.
    end case;
    
    case selected_display is         --SIEMPRE IMPRIME EL NUMERO ACTUAL INTRODUCIDO
    	when "1110" => DISPLAY <= valor_display_total (27 downto 21);--(6 downto 0);  
        when "1101" => DISPLAY <= valor_display_total (6 downto 0);--(13 downto 7);
        when "1011" => DISPLAY <= valor_display_total (13 downto 7);--(20 downto 14);
        when "0111" => DISPLAY <= valor_display_total (20 downto 14);--(27 downto 21);
        when others => DISPLAY <= "1111111" ;
    end case;
end process;

ANODE <= selected_display;
valor_display_total <= VAL_DISPLAY_TOTAL ;

end Behavioral;
