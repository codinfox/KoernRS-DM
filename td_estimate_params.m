% TD_ESTIMATE_PARAMS Estimate params

function [result, cost] = td_estimate_params(param)
global tul;
train = param.train_in_days;
% stochastic gradient descent
eta = 0.001;
lambda = 0.01;
% figure;
% hold on;
cost = zeros(31,1);
for iter = 1 : 30 % 30 iterations
    fprintf('=========== Start Iteration %d ===========\n', iter);
                cost(iter) = calc_cost(param);
%             fprintf('Cost: %f\n', cost(iter));
    for id = 1 : size(train,1)        
        
        user = train(id,1);
        movie = train(id,2);
        rate = train(id,3);
        time = train(id,4);
        
        % calculate gradient & update params
        coeff = rate - param.mu - combine_final(param, user, movie, time);
        
        prev = param;
        param.bu(user) = prev.bu(user) - eta*(-2*coeff+2*prev.bu(user)*lambda);
        position = prev.but{user,2} == time;
        param.bi(movie) = prev.bi(movie) - eta*(-2*coeff + 2*prev.bi(movie)*lambda);
        gamma = 0.3;
        e = exp(-gamma*abs(time-tul{user,1}));
        for l = 1 : tul{user,2}(4)
            param.butl{user}(l) = prev.butl{user}(l) - eta*(-2*coeff*exp(-gamma*abs(time-tul{user,1}(l)))/sum(e) + 2*prev.butl{user}(l)*lambda);
        end
        param.but{user,1}(position) = prev.but{user,1}(position) - eta*(-2*coeff+prev.but{user,1}(position));
        param.bibin(movie,td_ibin(time)) = prev.bibin(movie,td_ibin(time)) - eta*(-2*coeff + 2*prev.bibin(movie,td_ibin(time))*lambda);
%         param.cu(user) = prev.cu(user) - eta*(-2*coeff*(prev.bi(movie) + prev.bibin(movie,td_ibin(time))) + 2*prev.cu(user)*lambda);
%         param.cut{user,1}(position) = prev.cut{user,1}(position) - eta*(-2*coeff*(prev.bi(movie) + prev.bibin(movie,td_ibin(time))) + 2*prev.cut{user,1}(position)*lambda);
        
        fprintf('Done %d\n',id);
        
    end
end
            cost(end) = calc_cost(param);
%             fprintf('Cost: %f\n', cost);

result = param;
end

function cost = calc_cost(param)
fprintf('Calculating Cost...\n');
lambda = 0.01;

train = param.train_in_days;
mu = param.mu;
bu = param.bu;
bi = param.bi;
bibin = param.bibin;
butl = param.butl;
but = param.but;
% cu = param.cu;
% cut = param.cut;

% calculate cost
cost = 0;
for m = 1 : size(train,1)
    b = mu + combine_final(param, train(m,1), train(m,2), train(m,end));
    cost = cost + (train(m, 3) - b)^2;
end

% regularization
sum_butl = 0;
sum_but = 0;
% sum_cut = 0;
max_user_id = 6040;
for i = 1 : max_user_id
    sum_butl = sum_butl + butl{i}'*butl{i};
    sum_but = sum_but + but{i,1}'*but{i,1};
%     sum_cut = sum_cut + cut{i,1}'*cut{i,1};
end
cost = cost + lambda * (bu'*bu + bi'*bi + sum(sum(bibin.*bibin)) + sum_butl + sum_but);
fprintf('Done.');
end

function result = td_spline(user, t, butl)
global tul;
gamma = 0.3;
e = exp(-gamma*abs(t-tul{user,1}));
result = e'*butl / sum(e);
end

% TD_IBIN Generate the bin number with timestamp (day)
function bin = td_ibin(day)
num = 30; % by default
total_days = 1039; % by default
days_per_bin = total_days / num;
bin = ceil(day / days_per_bin);
end

% mu = mean(train_in_days(:,3));
% bu = zeros(max_user_id, 1);
% bi = zeros(max_movie_id, 1);
% bibin = zeros(max_movie_id, 30); % divided into 30 bins
% butl = cell(max_user_id, 1);
% but = cell(max_user_id, 2);
% cu = zeros(max_user_id, 1);
% cut = cell(max_user_id, 2);

function r = combine_final(param, user, movie, t)
position = param.but{user,2} == t;
combine_bu = param.bu(user) + td_spline(user, t, param.butl{user}) ...
    + param.but{user,1}(position);
combine_bi = param.bi(movie) + param.bibin(movie, td_ibin(t));
% combine_cu = param.cu(user) + param.cut{user, 1}(position);

r = combine_bu+combine_bi;
end