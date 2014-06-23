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
clear i idx;

save processed_dataset.mat