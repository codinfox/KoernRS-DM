
% redundent FIXME

function r = td_predict(param, user, movie, t)
r = evalin('base','mu')+combine_bu(param, user, t) ...
    +  combine_bi(param, movie, t);
end

function result = td_spline(user, t, butl)
global tul;
gamma = 0.3;
e = exp(-gamma*abs(t-tul{user,1}));
result = e'*butl / sum(e);
end

% TD_IBIN Generate the bin number with timestamp (day)
function bin = td_ibin(day, total_days, num)
if nargin < 3
    num = 30; % by default
    if nargin < 2
        total_days = evalin('base','total_days');
    else
        error('Number of params not match.');
    end
end
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

function r = combine_bu(param, user, t)
pos_in_but = find(param.but{user,2} == t);
but = 0;
if ~isempty(pos_in_but) 
    but = param.but{user,1}(pos_in_but);
end
r = param.bu(user) + td_spline(user, t, param.butl{user}) ...
    + but;
end

function r = combine_bi(param, movie, t)
r = param.bi(movie) + param.bibin(movie, td_ibin(t));
end