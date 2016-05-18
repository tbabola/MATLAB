function [D0] = MakeD(num_pts,dt,tau)
%[D0] = MakeD(num_pts,dt,tau)
%
% If tau is scalar, assumes exp(-t/tau).
% If tau is 2-valued, assumes exp(-t/tau1)*[1-exp(-t/tau2)]

if length(tau)==1
    exp_sig = exp(-(1:num_pts)*dt/tau);
else
    exp_sig = exp(-(1:num_pts)*dt/tau(1))...
        - exp(-(1:num_pts)*dt/tau(2));
%     exp_sig = exp(-(1:num_pts)*dt/tau(1)).*(1-exp(-(1:num_pts)*dt/tau(2)));
end

D0 = conv2(exp_sig',eye(num_pts));
D0 = D0(1:num_pts,:);

D0 = D0./repmat(sqrt(sum(D0.^2)),num_pts,1);

end

