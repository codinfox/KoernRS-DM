%BASELINE_ESTIMATOR
close all; clear; clc;

load('ml-1m/processed_dataset.mat');
mu = mean(rat_train(:,3));

% x0 = zeros(max_user_id+max_movie_id,1); % let index represent id
% options = optimset('GradObj','on', 'Display', 'iter', 'MaxIter', 50, 'HessUpdate', 'steepdesc');
% x = fminunc(@baseline_opt_goal, x0, options);
% options = optimset('Display', 'iter', 'MaxIter', 50);
% x = fminsearch(@baseline_opt_goal, x0, options);

cost_prev = -inf;
cost_curr = 0;
x = zeros(max_user_id+max_movie_id,1); % let index represent id
index = 0;
figure;
xlabel('time');
ylabel('cost error');
hold on;
while ((cost_curr - cost_prev)^2 > 0.01)
    index = index + 1;
    cost_prev = cost_curr;
    [cost_curr, grad] = baseline_opt_goal(x);
    x = x - 0.0001*grad;
    
    % debug
    fprintf('Cost %f\n', cost_curr);
    plot(index, cost_curr, 'MarkerSize', 4);
    drawnow;
end
hold off;

bu = x(1:max_user_id,:);
bi = x(max_user_id+1:end,:);

rat_pred = zeros(size(rat_test,1),1);
for i = 1 : size(rat_test,1)
    rat_pred(i) = mu + bu(rat_test(i,1)) + bi(rat_test(i,2));
end

rat_diff = rat_pred - rat_test(:,3);
baseline_estimator_rmse = sqrt(rat_diff' * rat_diff / size(rat_diff,1));

fprintf('\n========================\n');
fprintf('RMSE: %f\n', baseline_estimator_rmse);

clear cost_curr cost_prev grad index x i rat_diff;
save 'baseline_estimator_result.mat' rat_pred baseline_estimator_rmse bu bi;