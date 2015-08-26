function G = mlp_calc_input_gradient(x, t, y, net, hidden_to_output_weights)
% Calculates matrix of negative partial derivatives of E w.r.t. input weights. 
% x is NvxN+1 t,y are NvxM, net is NvxNh,
% hidden_to_output_weights is MxNh
% Result G is Nhx(N+1)

Nv = size(x,1);

output_delta = 2*(t - y);

fnet = mlp_calc_activation(net);
dfnet = fnet.*(1-fnet);
hidden_delta = dfnet .* (output_delta * hidden_to_output_weights);
% delta(p,k) = f'(net(p,k))*sum[i=1:M]{delta_o(p,i)*woh(i,k)}

G = hidden_delta' * x / Nv;
% G = -dE/dwi = 1/Nv * sum_p[ delta(p,k)*x(p,n) ]