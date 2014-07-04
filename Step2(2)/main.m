load('ml-1m/processed_dataset.mat');
load('baseline_estimator_result.mat');
load('Step2(1)Item_based Neighbourhood Estimator/neighbourhood_result.mat');
load('Aij.mat');

NO_SAME_USER = -2;
NO_PEARSON = -3;
mu = mean(rat_train(:,3));


for i=1:size(rat_test,1)
    user = rat_test(i,1)
    movie_i = rat_test(i,2)
    %     user_all_movie = rat_train(rat_train(:,1)==user&rat_train(:,2)~=movie_i,2);
    
    w = calcx(finalaij,finalaij(movie_i,:));
    
    similarity_i = similarity_matrix(:,movie_i);
    
    similarity_weight = [similarity_i, w];
    index = 1:1:3952;
    index = index';
    similarity_weight_index = [similarity_weight, index];
    
    top_k = sortrows(similarity_weight_index,1);
    top_k = top_k(end:-1:1,:);
    if size(top_k,1) > 20
        top_k = top_k(1:20,:);
    end
    
    top_k(top_k(:,1)==0|top_k(:,1)==NO_SAME_USER|top_k(:,1)==NO_PEARSON,:) = [];

    adjustment = 0;
    for n = 1:size(top_k,1)
        movie_j = top_k(n,3);
        rating_u_j = rat_train((rat_train(:,1)==user)&(rat_train(:,2)==movie_j),3);
        adjustment = adjustment + top_k(n,2)*(rating_u_j - (mu + bu(user) + bi(movie_j)));
    end
    
    rat_pred_linear(i) = mu + bu(user) + bi(movie_i) + adjustment;
end