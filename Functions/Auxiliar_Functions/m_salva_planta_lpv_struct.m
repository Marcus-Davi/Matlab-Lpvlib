%@Params
%nome_arquivo = filename
%planta = model matrix
%Na = system order
%N = parameter order
%Ts = sampling time
function [] = m_salva_planta_lpv_struct(nome_arquivo,planta,Ts,Na,N)   
Modelo.Ts = Ts;
Modelo.N = N; %dep Parametrica
Modelo.Na =  Na; %Na = Nb
Modelo.A = [1 zeros(1,N);planta(1:Na,:)]; %Já transforma em modelo geral (mônico)
Modelo.B = planta(Na+1:end,:); 

save(nome_arquivo,'Modelo');
disp('Modelo salvo com sucesso.')
end


