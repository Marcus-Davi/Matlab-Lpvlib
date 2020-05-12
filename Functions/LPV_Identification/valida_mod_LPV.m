function id = valida_mod_LPV(yv,uv,pv,Theta_k,Ts,Na,N,grafico)             

[rows,columns] = size(yv);
if rows<columns,
    yv=yv';
    uv=uv';
    pv=pv';
end

T = length(yv);

Nb = Na;

n = Na+Nb+1; % Number of parametric functions to be identified

N=N+1;

%display(' ');
%display('Montando Simula��o do Modelo...');

k=Na+1;

ye=zeros(1,T);

while k<T,
    % Fi(k) = [-y(k-1)... -y(k-Na) | u(k) ... u(k-Nb)]
    FiYe = [-ye(k-1)];
    for i=2:Na,
        FiYe = [FiYe -ye(k-i)];
    end

    FiUv = [uv(k)];
    for i=1:Nb,
        FiUv = [FiUv uv(k-i)];
    end

    Fi_kv = [FiYe FiUv];
    
    % Pi(k) = [1 p(k) .. p(k)^(N-1)]
        
    Pi_kv = [1];
    for i=1:(N-1),
        Pi_kv = [Pi_kv (pv(k))^i];
    end
        
    Psi_kv = Fi_kv'*Pi_kv; % Regressor Matrix - I/O data and parameter trajectories

    ye(k) = trace(Theta_k'*Psi_kv);

    k=k+1;
end


if grafico=='plota1', 
    tempo = [0:Ts:(Ts*length(yv(:,1)))];
    tempo = tempo(1:length(tempo)-1)';
    figure
    hold on 
    plot(tempo,yv,'k--')
    plot(tempo,ye,'b')
    plot(tempo,pv,'r')
    legend('System Output','Model Output','Parameter');
    hold off
end

% performance index

id = max(1-(var(yv -ye'))/(var(yv)))*100;


