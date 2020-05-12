function [R,S,T,P] = PP(B,A,d,Hs,Hr,Pd,Ts)

B = [zeros(1,d) B];
% plant model
nA=length(A)-1;
nB=length(B)-1;

% Building of extended plant polynomials
nHs = length(Hs)-1;
nHr = length(Hr)-1;

BB=conv(B,Hr);
AA=conv(A,Hs);

% Definition of the degree of AA and BB 
nBB=length(BB)-1-d;
nAA=length(AA)-1;

% Matriz formada pelos elementos do polin�mio A:
MA = zeros((nAA+nBB+d),(nBB+d));
for i=1:(nBB+d)
    MA(i:nAA+i,i)=AA';
end

% Matriz formada pelos elementos do polin�mio B:
MB = zeros((nAA+nBB+d),(nAA));

for i=1:(nAA)
%    MB(i:nBB+i,i)=BB(d+1:nBB+1+d)';
    MB(i:nBB+i+d,i)=BB';
end

% Building matrix M:
MM = [MA MB]
%
% Specification of Auxiliary poles :
display(sprintf('Forne�a os %d P�los Auxiliares de malha fechada desejados: (Ex.: [-0.2 -0.3...])', (nAA+nBB+d-1-2)));
pdf = input('Digite os polos: ');
Pf = [poly(pdf)];
%
%Polin�mio caracter�stico desejado:
P = conv(Pd,Pf);
%
X = inv(MM)*P';
%
nS = nBB+d-1;
nR = nAA-1;

So=X(1:nS+1);
Ro=X(nS+2:length(X));

R=conv(Hr,Ro)';
S=conv(Hs,So)';
T=sum(R);
