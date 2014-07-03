load('../ml-1m/processed_dataset.mat');
load('../baseline_estimator_result.mat');
load('neighbourhood_result.mat');

NO_SAME_USER = -2;
NO_PEARSON = -3;
mu = mean(rat_train(:,3));
% movie_count = max(ratings(:,2));
% similarity_matrix = zeros(movie_count, movie_count); % similarity of movies matrix
% rat_pred_neighbour = zeros(size(rat_test,1),1); % predicted result

% user_pre = 1425;

for i = 1 : size(rat_test,1)
%     if rat_pred_neighbour(i) ~= 0
%         continue;
%     end
    user = rat_test(i,1)
    movie_i = rat_test(i,2)
    user_all_movie = rat_train(rat_train(:,1)==user&rat_train(:,2)~=movie_i,2);
    
    top_k_similarity = zeros(size(user_all_movie,1),2);
    
    for j = 1 : size(user_all_movie,1)
        movie_j = user_all_movie(j);
        
        
%         if similarity_matrix(movie_j,movie_i) ~= 0
%             similarity_matrix(movie_i,movie_j) = similarity_matrix(movie_j,movie_i);
%         end
        
        if similarity_matrix(movie_i,movie_j) == 0
            other_rating_j = rat_train(rat_train(:,2)==movie_j,:);
            other_rating_i = rat_train(rat_train(:,2)==movie_i,:); % other ratings of of i movie
            
            [same_user, index_i, index_j] = intersect(other_rating_i(:,1),other_rating_j(:,1)); % searching user rated i and j.
            
            % if no other users rated i and j both.
            if isempty(same_user)
                similarity_matrix(movie_i,movie_j) = NO_SAME_USER;
                similarity_matrix(movie_j,movie_i) = NO_SAME_USER;
                continue;
            end
            
            pearson_i_j = corr(other_rating_i(index_i,3), other_rating_j(index_j,3));
            
            similarity = (size(same_user,1)*pearson_i_j)/(size(same_user,1)+100); % equation (2), \lamda_2 = 100\
            
            
            if isnan(similarity)
                similarity_matrix(movie_i, movie_j) = NO_PEARSON;
                similarity_matrix(movie_j, movie_i) = NO_PEARSON;
                continue;
            end
            similarity_matrix(movie_i, movie_j) = similarity;
            similarity_matrix(movie_j, movie_i) = similarity;
        end
        
        if similarity_matrix(movie_i, movie_j)==NO_SAME_USER || similarity_matrix(movie_i, movie_j)==NO_PEARSON
            continue;
        end
        
        top_k_similarity(j,1) = similarity_matrix(movie_i, movie_j);
        top_k_similarity(j,2) = movie_j;
    end
    
    top_k_similarity = sortrows(top_k_similarity,1);
    top_k_similarity = top_k_similarity(end:-1:1,:);
    if size(top_k_similarity,1) > 20
        top_k_similarity = top_k_similarity(1:20,:);
    end
    
    top_k_similarity(top_k_similarity(:,2)==0,:) = [];
    
    % compute predicted r_ui
    similarity_sum = 0;
    adjustment = 0;
    for n = 1:size(top_k_similarity,1)
        movie_j = top_k_similarity(n,2);
        rating_u_j = rat_train((rat_train(:,1)==user)&(rat_train(:,2)==movie_j),3);
        similarity_sum = similarity_sum + top_k_similarity(n,1);
        adjustment = adjustment + top_k_similarity(n,1)*(rating_u_j - (mu + bu(user) + bi(movie_j)));
        
    end
    
    if 0 == similarity_sum
        adjustment = 0;
    else
        adjustment = adjustment/similarity_sum;
    end
    
    rat_pred_neighbour(i) = mu + bu(user) + bi(movie_i) + adjustment;
    
    if user_pre+10 == user
        user_pre = user;
        
        non_zero = size(rat_pred_neighbour(rat_pred_neighbour~=0),1);
        
        rat_diff = rat_pred_neighbour(1:non_zero) - rat_test(1:non_zero,3);
        neighbour_rmse = sqrt(rat_diff' * rat_diff / size(rat_diff,1));
        
        fprintf('\n========================\n');
        fprintf('RMSE: %f\n', neighbour_rmse);
    end
end

rat_diff = rat_pred_neighbour - rat_test(:,3);
neighbour_rmse = sqrt(rat_diff' * rat_diff / size(rat_diff,1));

fprintf('\n========================\n');
fprintf('RMSE: %f\n', neighbour_rmse);

clear pred i rat_diff adjustment similarity_sum rating_u_j rating_u mu similarity_sum movie_j movie_i user pearson_i_j rating_i_j other_rating_j other_rating_i user_all_movie;
save 'neighbourhood_result.mat' rat_pred_neighbour neighbour_rmse similarity_matrix;