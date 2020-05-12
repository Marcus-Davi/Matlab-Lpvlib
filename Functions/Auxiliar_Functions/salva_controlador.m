function [] = salva_controlador(nome_arquivo,R,S,Ts)

[lS,cS]=size(S);
[lR,cR]=size(R);
nS = lS;
nR = lR-1;
N = cS-1;
Data = [Ts zeros(1,N);
       N zeros(1,N);
       nR zeros(1,N);
       nS zeros(1,N);       
       R;
       S];
   
save(nome_arquivo,'Data','-ASCII')
display('Controlador salvo')