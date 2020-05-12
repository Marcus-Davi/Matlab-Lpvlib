function [] = salva_modelo_lpv(nome_arquivo,Theta_k,Ts,Na,N)

Var = [Ts zeros(1,N);
       N zeros(1,N);
       Na zeros(1,N)];
   
save(nome_arquivo,'Var','Theta_k','-ASCII')
display('Modelo salvo')