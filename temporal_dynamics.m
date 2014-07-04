% TEMPORAL_DYNAMICS Source code for step.3

close all; clear; clear global; clc;

% load and process data
load('./ml-1m/processed_dataset.mat');
[train_in_days, test_in_days, total_days] = ...
    td_translate_timestamp_to_days(min(proc_ratings(:,end)), ...
    rat_train, rat_test);
clear proc_ratings ratings rat_test rat_train;

% initialization
fprintf('Initializing...');
mu = mean(train_in_days(:,3));
bu = zeros(max_user_id, 1);
bi = zeros(max_movie_id, 1);
bibin = zeros(max_movie_id, 30); % divided into 30 bins
butl = cell(max_user_id, 1);
but = cell(max_user_id, 2);
% cu = zeros(max_user_id, 1);
% cut = cell(max_user_id, 2);
global tul; % since tul is not a parameter that needs estimating
tul = cell(max_user_id, 2);
for i = 1 : max_user_id
    % initialize t_l^u
    id = find(train_in_days(:,1) == i);
    ku = round(size(id,1) ^ 0.25);
    if ku == 0
        continue;
    end
    max_day = max(train_in_days(id,end));
    min_day = min(train_in_days(id,end));
    per = (max_day - min_day) / ku;
    tmp = zeros(ku,1) + per;
    tmp(1) = tmp(1) + min_day;
    tul{i,1} = round(cumsum(tmp) - 0.5*per);
    tul{i,2} = [min_day, max_day, per, ku];
    
    % initialize butl
    butl{i} = zeros(ku,1);
    
    % initialize but
    % - but{i,1} is the but param needs estimating
    % - but{i,2} is a lookup table to find the corresponding day in but{i,1}
    but{i,2} = unique(train_in_days(id,end));
    but{i,1} = zeros(size(but{i,2},1), 1);
    
    % initialize cut
    % - cut{i,1} is the cut param needs estimating
    % - cut{i,2} is a lookup table to find the corresponding day in cut{i,1}
%     cut{i,2} = unique(train_in_days(id,end));
%     cut{i,1} = ones(size(cut{i,2},1), 1); % to keep the bi at the beginning
    
    fprintf('%d Done\n',floor(i/max_user_id*100));
end
param.mu = mu;
param.bu = bu;
param.bi = bi;
param.bibin = bibin;
param.butl = butl;
param.but = but;
% param.cu = cu;
% param.cut = cut;
% shuffle
rp = randperm(size(train_in_days,1));
param.train_in_days = train_in_days(rp,:);

clear bu bi bibin butl but cu cut;
fprintf(' Done.\n');

% estimate parameters
[model, r_cost] = td_estimate_params(param);

% predict
pred = zeros(size(test_in_days,1),1);
for i = 1 : size(test_in_days,1)
    pred(i) = td_predict(model, test_in_days(i,1), test_in_days(i,2), test_in_days(i,4));
end

d = pred - test_in_days(:,3);
temporal_dynamics_rmse = sqrt(d'*d/size(d,1));

save 'temporal_dynamics_result.mat' model pred temporal_dynamics_rmse