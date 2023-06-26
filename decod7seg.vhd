library ieee;
use ieee.std_logic_1164.all;

entity decod7seg is
	--Entrada para digito inteiro (0 até 15) e saída para os 7 segmentos
	port(
		i	:	in	integer;
    	led	:	out std_logic_vector(0 to 6)
	);
end entity;

architecture logic of decod7seg is
	--Array com a configuração do display para formar o digíto do respectivo índice
	type my_array is array (0 to 16) of std_logic_vector(0 to 6);
    constant s  :   my_array := (
									"1111110",
									"0110000",
									"1101101",
									"1111001",
									"0110011",
									"1011011",
									"1011111",
									"1110000",
									"1111111",	
									"1110011",
									"1110111",
									"0011111",
									"1001110",
									"0111101",
									"1001111",
									"1000111",
									"0000000"
											);
begin

--Entrega na saída a formatação (7 seg) do dígito (índice) negado (correção Anodo comum)
led <= not s(i);
	
end architecture;
	