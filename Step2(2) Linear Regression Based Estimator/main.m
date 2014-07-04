load('ml-1m/processed_dataset.mat');
load('baseline_estimator_result.mat');
load('Step2(1)Item_based Neighbourhood Estimator/neighbourhood_result.mat');
load('Aij.mat');
load('Nij.mat');

NO_SAME_USER = -2;
NO_PEARSON = -3;
mu = mean(rat_train(:,3));
avgij=avg_non_diagonal*ones(3952,3952);
avgij= avgij-(avg_non_diagonal-avg_diagonal)*diag(ones(3952,1));
beta = 500;

user_pre = 1;

for i=1:size(rat_test,1)
    user = rat_test(i,1)
    movie_i = rat_test(i,2)
    
    similarity_i = similarity_matrix(:,movie_i);
    mask = um(:,user)~=0;
    similarity_i = similarity_i .* mask;
    index = 1:1:3952;
    index = index';
    similarity_index = [similarity_i, index];
    
    top_k = sortrows(similarity_index,1);
    top_k = top_k(end:-1:1,:);
    top_k = top_k(1:20,:);
    
    top_k(top_k(:,1)==0|top_k(:,1)==NO_SAME_USER|top_k(:,1)==NO_PEARSON,:) = [];
    
    ajk = Aij(top_k(:,2),top_k(:,2));
    
    njk = nij(top_k(:,2),top_k(:,2));
    avg_jk = avgij(top_k(:,2),top_k(:,2));
    ajk_shrunk = ajk + (avg_jk .* beta);
    ajk_shrunk = ajk_shrunk ./ (njk + beta);
    
    njk = nij(top_k(:,2),movie_i);
    bj = Aij(top_k(:,2),movie_i);
    avg_j = avgij(top_k(:,2),movie_i);
    bj = bj + (avg_j .* beta);
    bj = bj ./ (njk + beta);
    
    w = calcx(ajk_shrunk,bj);
    top_k = [top_k, w];
  
    adjustment = 0;
    for n = 1:size(top_k,1)
        movie_j = top_k(n,2);
        adjustment = adjustment + top_k(n,3)*um(movie_j,user);
        
    end

    rat_pred_linear(i) = adjustment;
end

rat_diff = rat_pred_linear' - rat_test(:,3);
linear_rmse = sqrt(rat_diff' * rat_diff / size(rat_diff,1));

fprintf('\n========================\n');
fprintf('RMSE: %f\n', linear_rmse);

save 'Step2(2)/linear_result.mat' linear_rmse rat_pred_linear;