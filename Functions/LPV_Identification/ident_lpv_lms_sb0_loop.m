function Theta_k = ident_lpv_lms_sb0_loop(y,u,p,Ts,Na,N,alpha_max,alpha_min,grafico,loop)             
% Algorithm for Identification of input-output discrete-time LPV models with polynomial dependence on scheduling parameters
% Authors: Fabr�cio Gonzalez Nogueira / Walter Barra Jr. 
% Date: 31/05/2011

%Input-output collected data y(k), u(k) and p(k)
% y = [1:100]; % Plant output
% u = [1:100]; % Plant input
% p = 2*ones(1,100); % Parameter-varying

% Build Column vector

[rows,columns] = size(y);
if rows<columns,
    y=y';
    u=u';
    p=p';
end

T = length(y);

Nb = Na;

n = Na+Nb; % Number of parametric functions to be identified

N=N+1;

Theta_k = zeros(n,N);% Matrix of Estimated Parameters at time k

% Least Means Square Algorithm (LMS)

k=Na+1;

clear Theta;

iteracoes = T-k;
passos = round([(iteracoes/10)+k:(iteracoes/10):iteracoes+k]);
contador = 1;

% display(' ');
% display('--------------------------------------------------------------------');
% display('|       Programa para Identifica��o de Modelos LPV (LMS)            |');
% display('--------------------------------------------------------------------');
% display(sprintf('Ordem dos polin�mios A e B (Na=Nb): %g',Na));
% display(sprintf('Ordem da fun��o param�trica: %g',N-1));
% display(' ');
% display('Estima��o Iniciada...');
cont_loop = 1;

id = zeros(1,loop);

tic
while k<T,
    
    % Fi(k) = [-y(k-1)... -y(k-Na) | u(k) ... u(k-Nb) ]
    FiY = [-y(k-1)];
    for i=2:Na,
        FiY = [FiY -y(k-i)];
    end

    FiU = [u(k-1)];
    for i=2:Nb,
        FiU = [FiU u(k-i)];
    end

    Fi_k = [FiY FiU];
    
    % Pi(k) = [1 p(k) .. p(k)^(N-1)]
        
    Pi_k = [1];
    for i=1:(N-1),
        Pi_k = [Pi_k (p(k))^i];
    end
        
    Psi_k= Fi_k'*Pi_k; % Regressor Matrix - I/O data and parameter trajectories
    
    %E(k) = y(k)- trace(Theta_k'*Psi_k);
    E_k = y(k)- trace(Theta_k'*Psi_k);
    
    %alpha = alpha_max - ((k/T)*(alpha_max-alpha_min));
      
    %alpha_int = alpha_max - ((cont_loop/loop)*(alpha_max-alpha_min));

    alpha_int = alpha_max - (((k+T*(cont_loop-1))/(loop*T))*(alpha_max-alpha_min));
    
    %alpha_int = alpha_max;
    %alpha = alpha_int/(0.0000000000001 + norm(Psi_k)^2);
    %alpha = alpha_int/(0.0000000000001 + trace(Psi_k'*Psi_k));

    alpha = alpha_int;
    
    Theta_k1 = Theta_k + (alpha*E_k*Psi_k);
        
    Theta_k = Theta_k1;
    
    if grafico=='plota2', 
        Theta(:,:,k) = Theta_k;
    end
 
    k=k+1;
     
    if(k==T)
        Modelo = [Theta_k((1:Na),1:N); zeros(1,N); Theta_k((Na+1:Na+Nb),1:N)];
        id(cont_loop) = valida_mod_LPV(y,u,p,Modelo,Ts,Na,N-1,'plota0');
        display(sprintf('Loop: %g | Alpha: %.5g | Desempenho: %.5g o/o ',cont_loop, alpha_int, id(cont_loop)));
        if(cont_loop~=loop),
            k = Na+1;
        end
        %Theta_k = zeros(n,N);
        cont_loop = cont_loop+1;
    end
    
    if k == (passos(contador)),
        %display(sprintf('Conclu�do: %i o/o ',contador*10))
        contador = contador+1;
    end
    
end

[idmax,ind_idmax]=max(id);
display(sprintf('Desempenho m�ximo: %.5g o/o  | Loop: %g',idmax,ind_idmax));
if(length(id)>1),
    plot(id)
end

Tempo_estimacao = toc;
%display(sprintf('Tempo de estima��o: %.5g segundos ',Tempo_estimacao))

if grafico=='plota2', 
    %Evolution of the Parameters During Estimation 
    l=1;
    figure
    hold on
    P = [];
    for i=1:n,
        for j=1:N,
            P(l,:) = Theta(i,j,:);
            plot(P(l,:))
            l=l+1;
        end
    end
    hold off
end

Theta_k = [Theta_k((1:Na),1:N); zeros(1,N); Theta_k((Na+1:Na+Nb),1:N)];



