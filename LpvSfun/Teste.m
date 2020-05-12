clear ;close all;clc
%Definição do sistema LPV
%Estrutura
% y/u = B(p)/A(p)
% N -> dependencia paramétrica , Na,Nb ordens da planta.
%B(p) = [b0_0 ... b0_N ;
%              ...
%        bNB_0 ... bNB_N]    

%A(p) = [a0_0 ... a0_N ;
%              ...
%        aNA_0 ... aNA_N]    


%Exemplo de planta 2a ordem com ksi variante theta = [0,1]
Ts = 0.1;
H0 = c2d(tf(10,[1 0.8 10]),Ts);
H1 = c2d(tf(10,[1 0.2 10]),Ts);

diffnum = H1.num{1} -H0.num{1};
diffden = H1.den{1} - H0.den{1};

%Modelo exemplo proff
[Modelo,Ts,Na,N] = m_carrega_planta_lpv_matrix('Modelo_LPV_exemplo.txt');
m_printa_modelo_LPV(Modelo,Na,Na,N)
[A_LPV,B_LPV] = m_carrega_planta_lpv_AB('Modelo_LPV_exemplo.txt');
B_LPV = [0 0;B_LPV]; %Adiciona b0
A_LPV = [1 0;A_LPV]; %Adiciona "a0"

%% RST JA PROJETADO
T_LPV = [0.0740365 +0.036446911];
R_LPV = [1.2187222 +0.057908761;-2.1510871 +0.29868726;1.0064014 -0.32014911];
S_LPV = [1 0;-0.77614666 -0.086511881;-0.22385334 +0.086511881];
% S_LPV = [-0.78646593 -0.014134566;-0.21353407 +0.014134566];
