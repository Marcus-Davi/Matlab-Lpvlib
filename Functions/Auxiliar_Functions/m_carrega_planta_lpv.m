function [B,A,Ts] = load_lpv_model(arquivo,teta)         

currentFolder = pwd;
nome_arquivo = sprintf('%s%c%s',currentFolder,'/',arquivo)

Planta = load(nome_arquivo);
Planta = Planta.Modelo; 

Ts = Planta.Ts;
N = Planta.N;
Na = Planta.Na;
Nb=Na;
N=N+1;
clear Theta_k;
clear b;
clear a;
Planta.A(1,:) = []; %apaga linha mônica - compatilidade
Theta_k = [Planta.A;Planta.B];

for i=1:Nb+1,
    for j=1:N,
        b(i,j) = Theta_k(i+Na,j);
    end
end

for i=1:Na,
    for j=1:N,
        a(i,j) = Theta_k(i,j);
    end
end

% ----- Definition of the polynomials A and B of the LPV system model------

clear B aux; 
B = sdpvar(1,Nb+1,'full');

for i=1:Nb+1,
    for j=1:N,
        if j==1,
            aux = b(i,j);
        else,
            aux = aux+b(i,j)*teta^(j-1);
        end
    end
    B(1,i)=aux;
end

clear A aux;
A = sdpvar(1,Na,'full');

for i=1:Na,
    for j=1:N,
        if j==1,
            aux = a(i,j);
        else,
            aux = aux+a(i,j)*teta^(j-1);
        end
    end
    A(1,i)=aux;
end
A = [1 A];

display('Planta carregada com sucesso');
display(' ');
