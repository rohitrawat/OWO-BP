function MSE = mlp_calc_class_mse(ic, y)
% Computes the MSE from t and y. Also returns the error at each output as
% Ei.

[Nv M] = size(y);

t = zeros(Nv, M);
for p=1:Nv
    t(p,ic(p)) = 1;
end

MSE = 0;
for p = 1:Nv
    for i = 1:M
        if(i == ic(p))
            if(y(p,i) > t(p,i))
                % for the correct class, 
                % y>t reduces MSE, y<t increases MSE
                MSE = MSE - (y(p,i) - t(p,i))^2;
            else
                MSE = MSE + (y(p,i) - t(p,i))^2;
            end
        else
            % for the incorrect class, 
            % y>t increases MSE, y<t decreases MSE
            if(y(p,i) < t(p,i))
                MSE = MSE - (y(p,i) - t(p,i))^2;
            else
                MSE = MSE + (y(p,i) - t(p,i))^2;
            end
        end
    end
end
MSE = MSE / Nv;
