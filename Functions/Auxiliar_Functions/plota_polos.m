function [] = plota_polos(A,teta,maximo,minimo,precisao,color)             

%Valor Mínimo e Máximo do Parâmetro variável
% The plotting is performed throught the discretization of the scheduling
% parameter
 hold on;
 
 for Parm=minimo:precisao:maximo,
     assign(teta,Parm);
     poles = roots(double(A));
     n=length(poles);
     for j=1:n
        if(isreal(poles(j)))
         poles(j) = poles(j)+0.000000000000000001*i;
        end
     end
     plot(poles,color);
 end
 zgrid
 hold off;

 