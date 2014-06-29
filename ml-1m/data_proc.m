% DATA_PROC
% proc_ratings = sortrows(ratings,[1 4]);

clear;close all;clc;

load reordered_ratings.mat

diff_labels = unique(proc_ratings(:,1));
label_count = hist(proc_ratings(:,1),diff_labels);
start_label = [1, cumsum(label_count)+1];
train_num = floor(0.9*label_count);

rat_train = [];
idx = 1;
for i = 1 : size(diff_labels);
    rat_train(idx:idx+train_num(i)-1,:) = proc_ratings(start_label(i):(start_label(i)+train_num(i)-1),:);
    idx = idx+train_num(i);
end
rat_test = setxor(proc_ratings,rat_train,'rows');

num_users = size(diff_labels,1);
num_movies = size(unique(proc_ratings(:,2)),1);
% the damn fucking truth is the id is not continuous and thus num != max_id
max_user_id = max(proc_ratings(:,1));
max_movie_id = max(proc_ratings(:,2));

clear i idx diff_labels label_count start_label train_num;
save processed_dataset.mat