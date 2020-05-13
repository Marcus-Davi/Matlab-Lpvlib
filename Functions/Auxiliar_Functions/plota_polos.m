function [] = plota_polos(A,teta,maximo,minimo,precisao,color)             

%Valor M�nimo e M�ximo do Par�metro vari�vel
% The plotting is performed throught the discretization of the scheduling
% parameter
 hold on;
%  figure
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

 