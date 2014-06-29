% BASELINE_OPT_GOAL The cost function of baseline estimator.
function [cost, grad] = baseline_opt_goal(b)
% read from workspace
max_user_id = evalin('base', 'max_user_id');
rat_train = evalin('base', 'rat_train');
mu = evalin('base', 'mu');

% constants
lambda1 = 0.2;

% restore
bu = b(1:max_user_id,:);
bi = b(max_user_id+1:end,:);

cost = 0;
n_bu = zeros(size(bu));
n_bi = zeros(size(bi));
for i = 1 : size(rat_train,1)
    % calculate cost
    rubb = rat_train(i,3) - mu - bu(rat_train(i, 1)) - bi(rat_train(i, 2));
    cost = cost + rubb*rubb;
    
    % calculate gradient
    % \frac{{\partial COST}}{{\partial {u_t}}} = \sum { - 2({r_{{u_t}i}} - \mu  - {b_{{u_t}}} - {b_i})}  + 2{\lambda _1}{b_{{u_t}}}
    n_bu(rat_train(i,1)) = n_bu(rat_train(i,1)) - 2*rubb;
    n_bi(rat_train(i,2)) = n_bi(rat_train(i,2)) - 2*rubb;
end
cost = cost + lambda1 * (bu'*bu + bi'*bi);
n_bu = n_bu + 2*lambda1*bu;
n_bi = n_bi + 2*lambda1*bi;

grad = [n_bu;n_bi];
end
