load('ml-1m/processed_dataset.mat');
load('baseline_estimator_result.mat');
load('Step2(1)Item_based Neighbourhood Estimator/neighbourhood_result.mat');
% load('Aij.mat');
% load('Nij.mat');

NO_SAME_USER = -2;
NO_PEARSON = -3;
mu = mean(rat_train(:,3));
% avg_diagonal = mean(diag())
% avg_non_diagonal = (sum(A) - sum(diag(A)))/(3952*(3952-1))
avgij=avg*ones(3952,3952);
avgij= avgij-(avg-avg_diag)*diag(ones(3952,1));
beta = 500;

user_pre = 1;

for i=1:size(rat_test,1)
    user = rat_test(i,1)
    movie_i = rat_test(i,2)
    %     user_all_movie = rat_train(rat_train(:,1)==user&rat_train(:,2)~=movie_i,2);
    
    
    
    similarity_i = similarity_matrix(:,movie_i);
    
    index = 1:1:3952;
    index = index';
    similarity_index = [similarity_i, index];
    
    top_k = sortrows(similarity_index,1);
    top_k = top_k(end:-1:1,:);
    if size(top_k,1) > 20
        top_k = top_k(1:20,:);
    end
    
    top_k(top_k(:,1)==0|top_k(:,1)==NO_SAME_USER|top_k(:,1)==NO_PEARSON,:) = [];
    
    ajk_avg = aij(top_k(:,2),top_k(:,2));
    
    njk = nij(top_k(:,2),top_k(:,2));
    avg_jk = avgij(top_k(:,2),top_k(:,2));
    ajk_shrunk = (ajk_avg .* njk) + (avg_jk .* beta);
    ajk_shrunk = ajk_shrunk ./ (njk + beta);
    
    
    njk = nij(movie_i,top_k(:,2));
    bj = aij(movie_i,top_k(:,2));
    bj = (bj .* njk) + (bj .* beta);
    bj = bj ./ (njk + beta);
    
    w = calcx(ajk_shrunk,bj);
    top_k = [top_k, w];
    
    %     weight_matrix(user, movie_i) = w;
    
    adjustment = 0;
    for n = 1:size(top_k,1)
        movie_j = top_k(n,2);
        rating_u_j = rat_train((rat_train(:,1)==user)&(rat_train(:,2)==movie_j),3);
        adjustment = adjustment + top_k(n,3)*(rating_u_j - (mu + bu(user) + bi(movie_j)));
    end
    
    rat_pred_linear(i) = mu + bu(user) + bi(movie_i) + adjustment;
    
    if user_pre+10 == user
        user_pre = user;
        
        non_zero = size(rat_pred_neighbour(rat_pred_neighbour~=0),1);
        
        rat_diff = rat_pred_neighbour(1:non_zero) - rat_test(1:non_zero,3);
        neighbour_rmse = sqrt(rat_diff' * rat_diff / size(rat_diff,1));
        
        fprintf('\n========================\n');
        fprintf('RMSE: %f\n', neighbour_rmse);
    end
end

save 'Step2(1)Item_based Neighbourhood Estimator/neighbourhood_result.mat' avgij rat_pred_linear;