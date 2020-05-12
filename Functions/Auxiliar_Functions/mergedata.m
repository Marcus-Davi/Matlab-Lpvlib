function out = mergedata(in,Num_div,Periodo)             
% Num_div = Numero de divisões
% Periodo = Numero de divisões em cada período

T = length(in);           % Tamanho do vetor de dados
Tam_div = floor(T/Num_div);  % Cada divisão possui 4 medidas

b = Tam_div*Periodo; 

i=0;
j=0;
k = 0;
out = zeros(1,T-1);
while(j<Num_div),
    out((1+(j*Tam_div)):(Tam_div+(j*Tam_div))) = in(((1+(k*Tam_div))+(b)*i):((Tam_div+(k*Tam_div))+(b)*i));
    i=i+1;
    j=j+1;
    if(i >= (Num_div/Periodo))
        i= 0;
        k= k+1;
    end
end
