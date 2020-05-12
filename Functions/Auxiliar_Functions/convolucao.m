
function w = convolucao(u,v)

m = length(u);
n = length(v);

w = sdpvar(1,m+n-1);

for k=1:(m+n-1)
    i=1;
    for j=max(1,k+1-n): min(k,m),
        if i==1
            w(k)=(u(j)*v(k-j+1));
        else
            w(k)=w(k)+(u(j)*v(k-j+1));
        end
        i=i+1;
    end
end