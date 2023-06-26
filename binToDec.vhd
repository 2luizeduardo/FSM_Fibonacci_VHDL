library ieee;
use ieee.std_logic_1164.all;

entity binToDec is
  --Entrada do digito completo e saída separado por cada um dos 6 displays
  port (
    binData   :   in   integer;
    disp1value, disp2value, disp3value, disp4value, disp5value, disp6value :   out  integer
  ) ;
end binToDec;

architecture rtl of binToDec is
    --Variáveis auxiliares para fazer leitura e escrita (evitando o uso de porta buffer)
    signal auxData1, auxData2, auxData3, auxData4, auxData5, auxData6 : integer;
begin
    --Conversão da base do digito de binário para decimal e separação em cada display
    auxData6 <= binData/(10**5);
    auxData5 <= binData/(10**4)-auxData6*(10**1);
    auxData4 <= binData/(10**3)-auxData6*(10**2)-auxData5*(10**1);
    auxData3 <= binData/(10**2)-auxData6*(10**3)-auxData5*(10**2)-auxData4*(10**1);
    auxData2 <= binData/(10**1)-auxData6*(10**4)-auxData5*(10**3)-auxData4*(10**2)-auxData3*(10**1);
    auxData1 <= binData        -auxData6*(10**5)-auxData5*(10**4)-auxData4*(10**3)-auxData3*(10**2)-auxData2*(10**1);
    
    --Conduz na saída os valores das variáveis auxiliares 
    disp1value <= auxData1;
    disp2value <= auxData2;
    disp3value <= auxData3;
    disp4value <= auxData4;
    disp5value <= auxData5;
    disp6value <= auxData6;
end architecture;