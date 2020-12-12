%============================
% ALGORITMO DE VITERBI
%============================
n = 16;
ak=ones(1,n);
k=rand(1,n);
m=find(k<0.5);
ak(m)=-1;
entrada = ak;
tamAlfa = 2; %Tamaño del alfabeto
memorias = 2;
cantEstados = tamAlfa^memorias;
Estados(1:cantEstados,1:n) = 0; %Inicializo array de metricas
sz = size(Estados);
Estados = zeros(sz);
Sobrevivientes(cantEstados,n) = 0;
Metricas(1:cantEstados,1:cantEstados) = 0;
%============================
% Estados imposibles
%============================
inf = -999
Estados(2,1) = inf;
Estados(3,1) = inf;
Estados(4,1) = inf;
Estados(3,2) = inf;
Estados(4,2) = inf;
Estados(2,n+1) = inf;
Estados(3,n+1) = inf;
Estados(4,n+1) = inf;
Estados(2,n) = inf;
Estados(4,n) = inf;
%============================
% Matriz de metricas
%============================
Metrica(1:cantEstados,1:cantEstados) = inf;
Metrica(1,1)=1.7;
Metrica(2,1)=1.1;
Metrica(3,2)=-0.3;
Metrica(4,2)=-0.9;
Metrica(1,3)=0.3;
Metrica(2,3)=0.9;
Metrica(3,4)=-1.1;
Metrica(4,4)=-1.7;
NuevasMetrica(1:cantEstados,1:cantEstados) = 0;
C0=0.3;
C1=1;
C2=0.4;
i=1;
memA=1;
memB=1;  %el estado inicial de las memorias es 1.
salida=[entrada];
for in=entrada    
    salida(i)= in*C0+memA*C1+memB*C2;
    i=i+1;
    memB=memA;
    memA=in;
end
%=======================================
% Actualización de matriz de estados
%=======================================
Aux(1:cantEstados) = 0;
for iteracion=1:1:n
    for i=1:1:cantEstados
        for j=1:1:cantEstados
        NuevasMetrica(i,j)=Metrica(i,j)*salida(iteracion);
        end
    end
    for j=1:1:cantEstados
        for i=1:1:cantEstados
            if(Metrica(j,i)>-500)
            Aux(i) = NuevasMetrica(j,i);     %Copio la fila j correspondiente de nuevasMetricas
            else
            Aux(i) = Metrica(j,i);
            end
        end
        for i=1:1:cantEstados
            Aux(i)=Aux(i)+Estados(i,iteracion);
            p=0;
        end
    [max_num,max_idx] = max(Aux(:)); %Obtengo el maximo valor y su destino 
    %valAnt = Estados(max_idx,iteracion);
    if(Estados(j,iteracion+1)~=inf)
    Estados(j,iteracion+1)= max_num;  %Actualizo matriz de estados
    Sobrevivientes(j,iteracion+1) = max_idx;   %Guardo el sobreviviente
    end
    end
end
%=======================================
% Matriz de decodificación
%=======================================

Decoder(1:cantEstados,1:cantEstados) = 0;
Decoder(1,1)=1;
Decoder(2,1)=-1;
Decoder(3,2)=1;
Decoder(4,2)=-1;
Decoder(1,3)=1;
Decoder(2,3)=-1;
Decoder(3,4)=1;
Decoder(4,4)=-1;
% %=======================================
% % Traceback
% %=======================================
 Transiciones(n)=0;
 x=1;
 prox = Sobrevivientes(1,n+1);
 for i=n:-1:1 
    Transiciones(i) = prox;
    prox = Sobrevivientes(prox,i);
    %x = x+1;
 end
 Transiciones(n+1)=1;
% =======================================
%  Decodificación
% =======================================
simbolosDecodificados(n)=0;
for z=1:1:n
    origen = Transiciones(z);
    destino = Transiciones(z+1);
    simbolo = Decoder(destino,origen);
    simbolosDecodificados(z)=simbolo;
end