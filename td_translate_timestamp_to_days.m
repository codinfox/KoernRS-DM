% TD_TRANSLATE_TIMESTAMP_TO_DAYS Translate timestamp to number of days with
% the lower bound at the min timestamp and upper bound at the max timestamp

function [rat_train_in_days, rat_test_in_days, total_days] ...
         = td_translate_timestamp_to_days(min_timestamp, rat_train, rat_test)
% the beginning day is denoted as the 1st day instead of the 0th day
train_ts = ceil((rat_train(:,end) - min_timestamp + 1) / (60*60*24));
test_ts = ceil((rat_test(:,end) - min_timestamp + 1) / (60*60*24));

rat_train_in_days = [rat_train(:,1:end-1), train_ts];
rat_test_in_days = [rat_test(:,1:end-1), test_ts];
total_days = max(max(train_ts),max(test_ts));
end