library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_Fibonacci is
  --Entrada do clock e reset do cálculo de fibonacci e saída dos 7 segmentos de todos os 6 displays (42 segmentos)
  port (
    clk, rst   :   in   std_logic;
    display    :   out   std_logic_vector(0 to 41)
  );
end FSM_Fibonacci;

architecture fsm of FSM_Fibonacci is
	
	--Criação de um tipo que armazena a nomenclatura dos 5 estados
    type fsm_state is (s0, s1, s2, s3, s4);
	signal estado : fsm_state := s0;
	 
	
	signal countOneSec : integer := 0;  --Variável auxiliar para contar 1 segundo (50 M de clk)

	--Valor para cada display
    signal disp1value, disp2value, disp3value, disp4value, disp5value, disp6value : integer := 0;

	--Auxiliares para cálculo de fibonacci
    signal fibo0, fibo1 : integer;
	 signal fibo2			: integer := 0;
begin
	--Entidade do conversor binário pra decimal a partir do último valor de fibonacci calculado
    conv : entity work.binToDec(rtl) port map(fibo2, disp1value, disp2value, disp3value, disp4value, disp5value, disp6value);

	--Decodificador de todos os 6 display
    generate_display1 : entity work.decod7seg(logic) port map (disp1value, display(0 to 6));
    generate_display2 : entity work.decod7seg(logic) port map (disp2value, display(7 to 13));
    generate_display3 : entity work.decod7seg(logic) port map (disp3value, display(14 to 20));
    generate_display4 : entity work.decod7seg(logic) port map (disp4value, display(21 to 27));
    generate_display5 : entity work.decod7seg(logic) port map (disp5value, display(28 to 34));
    generate_display6 : entity work.decod7seg(logic) port map (disp6value, display(35 to 41));


	--Process acionado a partir de mudanças em clk ou rst para atualizar os estados e contar 1s
	fsm_cases: process(clk, rst) is        
	begin
		--Reset assíncrono: reinicia o estado e a contagem de 1s
		if rst = '0' then
			estado <= s0;
			countOneSec <= 0;

		elsif rising_edge(clk) then
			--Contagem corrige os 5 ciclos (1 por estado) para manter o digito no display por apenas 1 s
			if countOneSec > 49999994 then --Somente avança para a próxima rodada de estados quando passar 1 s
				case estado is
						--Estado 0
						when s0 =>
							--(Re)Inicia fibonacci
							fibo0<= 0;
							fibo1<= 1;
							
							estado <=s1;
						
						--Estado 1
						when s1 =>
							--Fibo2 recebe a soma dos dois anteriores
							fibo2<=fibo0 + fibo1;
							
							estado <=s2;

						--Estado 2
						when s2 =>
							--Rotaciona penultimo digito calculado
							fibo0<= fibo1;

							estado <=s3;
						
						--Estado 3  
						when s3 =>
							--Rotaciona ultimo digito calculado
							fibo1<= fibo2;

							estado <=s4;

						--Estado 4    
						when s4 =>
							--Se próximo digito estourar o contador de 6 digitos decimais
							if (fibo0+fibo1)>999999 then
								--Reinicia cálculo
								estado <=s0;

							--Se não
							else
								--Continua para próximo digito
								estado <=s1;
							end if;

							--Reinicia contagem de 1 s
							countOneSec <= 0;
							
						--Caso para estado imprevisto
						when others =>
							fibo2 <= 999999;
						end case;

			--Se não tiver atingido 1 s
			else
				--Incrementa 1 a cada borda de subida do clk
				countOneSec <= countOneSec + 1;
			end if;
		end if;
	end process fsm_cases;
end fsm ; -- fsm