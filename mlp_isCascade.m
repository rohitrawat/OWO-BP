function cascade = mlp_isCascade(Wi, Wo)

[Nh Li] = size(Wi);
L = size(Wo,2);
if(L == Nh+Li)
    cascade = false;
elseif(L == Nh+1)
    cascade = true;
else
    error('Network is neither cascade, nor fully connected.');
end
