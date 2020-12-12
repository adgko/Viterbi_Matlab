% 1) Realizar el simulador de un sistema de comunicaciones BPSK={+1,-1} 
%  donde el canal es modelado mediante un FIR con 
%  tres coeficiente [0.3 1 0.2] y el receptor es un detector optimo 
%  implementado con el algoritmo de Viterbi. 
%  Obtener la curva de BER para SNRdB={1,2,3,4,5}. 

%============================================
% Generacion de símbolos
%============================================
n_symbols = 100;
ak=ones(1,n_symbols);
k=rand(1,n_symbols);
m=find(k<0.5);
ak(m)=-1;
f1 = figure;
h = stem(ak);
ylabel('Simbolos generados')
xlabel('n');
title('Simbolos generados antes del codificador convolucional' );
%============================================
% Código convolucional FIR
%============================================
entrada = ak;
i=1;
C0=0.3;
C1=1;
C2=0.4;
memA=1;memB=1;  %el estado inicial de las memorias es 1.
salida=[entrada]; %esto es porque el FIR tiene una única salida
for in=entrada    
    salida(i)= in*C1+memA*C1+memB*C2;
    i=i+1;
    memB=memA;memA=in;
end
f2 = figure;
stem(salida);
ylabel('Simbolos')
xlabel('n');
title('Simbolos binarios despues del codificador convolucional' );
%============================================
% Simbolos con AWGN
%============================================
SNR = 10; %en dB
y = awgn(salida,SNR);
stem(y);
ylabel('Simbolos')
xlabel('n');
title('Simbolos binarios despues del codificador convolucional con AWGN' );
%============================================
% Receptor implementado con Viterbi
%============================================
% 2) Realizar el simulador de un sistema de comunicaciones BPSK
% en donde la señal a transmitir es codificada mediante el código
% convolucional implementado en clase. El canal es AWGN. 
% Obtener la curva de BER en funcion de la SNRdB para la señal sin 
% codificación y con codificación. La señal codificada debe ser 
% escalada por 1/sqrt(2) para mantener la energía del bit de 
% información transmitido.

%A MI PARECER LO MEJOR SERÍA HACER EL VITERBI Y EL TRELLIS A MANO, COMO LO
%VENIAMOS HACIENDO HASTA AYER EN TU CASA... GASTE MUCHO TIEMPO BUSCANDO UN
%CODIGO DECENTE DEL BER/SNR ASI QUE NO TUVE TIEMPO DE HACERLO, ASI QUE
%BUENO, FIJATE SI PODES TERMINAR EL VITERBI Y SI NO AVISAME Y LO TERMINO YO

%============================================
% Gráfico BER/SNR
%============================================

num_bit=1000000;%number of bit
data=rand(1,num_bit);%random bit generation (1 or 0)
s=2*data-1;%conversion of data for BPSK modulation
SNRdB=0:10; % SNR in dB
SNR=10.^(SNRdB/10);
for(k=1:length(SNRdB))%BER (error/bit) calculation for different SNR
y=awgn(s,SNRdB(k));
error=0;
for(c=1:1:num_bit)
    if (y(c)>0&&data(c)==-1)||(y(c)<0&&data(c)==1)%logic acording to BPSK
        error=error+1;
    end
end
error=error/num_bit; %Calculate error/bit
m(k)=error;
numerrs = biterr(s,y);
end
figure(6) 
%plot start
%semilogy(SNRdB,m,'o','linewidth',2.5),grid on,hold on;
BER_th=(1/2)*erfc(sqrt(SNR)); 
semilogy(SNRdB,BER_th,'r','linewidth',2.5);
title(' curve for Bit Error Rate verses  SNR for Binary PSK modulation');
xlabel(' SNR(dB)');
ylabel('BER');
legend('simulation','theorytical')

fprintf('error de bit = %f ', numerrs);

EbNoVec = (1:5)';                % Eb/No values (dB)

axis([0 10 10^-5 1]);

%figure(7)
