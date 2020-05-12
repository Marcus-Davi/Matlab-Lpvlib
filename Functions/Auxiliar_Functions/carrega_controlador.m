function [R,S] = carrega_controlador(arquivo,teta)         

currentFolder = pwd;
nome_arquivo = sprintf('%s%c%s',currentFolder,'/',arquivo)

controlador = load(nome_arquivo);

Ts = controlador(1,1);
N = controlador(2,1);
Nr = controlador(3,1);
Ns = controlador(4,1);
N=N+1;
clear Theta_k;
clear r;
clear s;

%Data = controlador(4:(Nr*2+4),1:N);
Data = controlador(5:(Nr+Ns+1)+4,1:N)

for i=1:Nr+1,
    for j=1:N,
        r(i,j) = Data(i,j);
    end
end

for i=1:Ns,
    for j=1:N,
        s(i,j) = Data(i+Nr+1,j);
    end
end

% ----- Definition of the polynomials R and S of the LPV system model------


N=N-1;
% clear R aux; 
% R = sdpvar(1,Nr+1,'full');
% clear S aux;
% S = sdpvar(1,Ns,'full');

for i=1:Nr+1,
	aux = r(i,1);
    for j=2:N+1,
        aux2 = aux+(r(i,j)*teta^(j-1));
        aux = aux2;
    end
    R(1,i) = [aux2];
end

for i=1:Ns,
	aux = s(i,1);
    for j=2:N+1,
        aux2 = aux+(s(i,j)*teta^(j-1));
        aux = aux2;
    end
    S(1,i) = [aux2];
end
S = [1 S];

display('Controlador carregado com sucesso');

