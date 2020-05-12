function [R_out,S_out] = gain_schd_lpv_RST(B,A,teta,d,C,Hr,Hs,Nc,maximo,minimo,Ts,LimHoo)             
% Algorithm for the design of a discrete LPV damping controller 
% Authors: Fabr�cio Gonzalez Nogueira / Walter Barra Jr. 
% Current version: 20/09/2018

% --------------------- Load the LPV system model -------------------------
% sdpvar teta;   % scheduling parameter
% [B,A] = carrega_planta_lpv(arquivo,teta);

%Including the delay, B'(z)= B(z)z^-d 
B = [zeros(1,d) B];

nB=length(B)-1-d;
nA=length(A)-1;

nHs = length(Hs)-1;
nHr = length(Hr)-1;

Ns = nB+nHr+d-1;
Nr = nA+nHs-1;

% ------------------ initialization -------------- 
r = sdpvar(Nc+1, Nr+1,'full')';
s = sdpvar(Nc+1 , Ns,'full')';

sdpvar lambda t;    % variables used in the design


% ----- Definition of the polynomials R and S of the LPV controller -------

% Build polynomial R
clear R_LPV
for i=1:Nr+1,
	aux = r(i,1);
    for j=2:Nc+1,
        aux2 = aux+(r(i,j)*teta^(j-1));
        aux = aux2;
    end
    R_LPV(1,i) = [aux2];
end

clear S_LPV

for i=1:Ns,
	aux = s(i,1);
    for j=2:Nc+1,
        aux2 = aux+(s(i,j)*teta^(j-1));
        aux = aux2;
    end
    S_LPV(1,i) = [aux2];
end
S_LPV = [1 S_LPV];


% Including fixed parts Hr and Hs
B=convolucao(B,Hr);
A=convolucao(A,Hs);
% Closed-loop system

N = convolucao(B,R_LPV);
D = convolucao(A,S_LPV) + convolucao(B,R_LPV);


% -------------------- Data input ---------- 

display(' ');
display('--------------------------------------------------------------------');
display('|            Programa para Projeto de Controlador LPV              |');
display('--------------------------------------------------------------------');
display(' ');
%display(sprintf('Ordem dos polin�mios A e B (Na=Nb): %g',Na));
%display(sprintf('Ordem da fun��o param�trica (N-1): %g',N-1));

%gama = input('Entre com o limite da  norma Hoo:');
gama = 1/LimHoo;

display(' ');
display('Inicia projeto do controlador...');
display(' ');

d=length(C)-1;

P = sdpvar(d,d);

Pi1 = [zeros(d,1) eye(d,d)];
Pi2 = [eye(d,d) zeros(d,1)];

Fd = Pi1'*P*Pi1 - Pi2'*P*Pi2;
%Fd = (Pi2'*P*Pi2) - (Pi1'*P*Pi1);

S = [((C'*D)+(D'*C)-Fd-(lambda*(C'*C))) N'; N (lambda*(gama^2))];

g1 = teta-minimo;
g2 = maximo-teta;

degree(S)

m = size(S,1);
u = monolist([teta],(degree(S)/2)); %degree(S)/2
                       
Q0 = sdpvar(length(u)*m);
Q1 = sdpvar(length(u)*m);
Q2 = sdpvar(length(u)*m);

S0 = kron(eye(m),u)'*Q0*kron(eye(m),u);
S1 = kron(eye(m),u)'*Q1*kron(eye(m),u);  
S2 = kron(eye(m),u)'*Q2*kron(eye(m),u);

F = [sos(S-t-(S0 +S1*g1 + S2*g2)), sos(S0), sos(S1), sos(S2), sos(P)];

%F = [sos(S-t-(S0 + S1*g1 + S2*g2)), sos(S0), sos(S1), sos(S2)];

display('Chama programa m�dulo de otimiza��o SOS do Yalmip...');

%opt = sdpsettings('solver','sdpt3');
opt = sdpsettings('solver','sedumi');

y=1;
for i=1:length(P),
    for j=1:length(P),
        Pvet(1,y) = P(i,j);
        y=y+1;
    end
end

y=1;
for i=1:length(Q0),
    for j=1:length(Q0),
        Q0vet(1,y) = Q0(i,j);
        y=y+1;
    end
end

y=1;
for i=1:length(Q1),
    for j=1:length(Q1),
        Q1vet(1,y) = Q1(i,j);
        y=y+1;
    end
end

y=1;
for i=1:length(Q2),
    for j=1:length(Q2),
        Q2vet(1,y) = Q2(i,j);
        y=y+1;
    end
end

y=1;
[l,c] = size(r);
for i=1:l,
    for j=1:c,
        rvet(1,y) = r(i,j);
        y=y+1;
    end
end

y=1;
[l,c] = size(s);
for i=1:l,
    for j=1:c,
        svet(1,y) = s(i,j);
        y=y+1;
    end
end

[sol,m,Bi,residual] = solvesos(F,-t,opt,[lambda t rvet svet Pvet Q0vet Q1vet Q2vet ]');

% -------------- Leitura dos Par�metros do Controlador Projetado ---------

R_out = double(r);
S_out = double(s);

display('Projeto Conclu�do ');
display(' ');
display('Autovalores das Matrizes P>0, Q1>0, Q2>0..., Qn>0 e B1>0, ... Bn>0');
%display(sprintf('Menor Autovalor de P: %.5g',min(eig(double(P)))))
%display(sprintf('Menor Autovalor de Q1: %.5g',min(eig(double(Q1)))))
%display(sprintf('Menor Autovalor de Q2: %.5g',min(eig(double(Q2)))))

for i=1:length(Bi),
    display(sprintf('Menor Autovalor de B{%.g}: %.5g',i,min(eig(Bi{i}))))    
end
display(' ');
display(sprintf('Valor do escalar "l�mbda": %.5g',double(lambda)))
