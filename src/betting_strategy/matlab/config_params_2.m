function [ A, b, Aeq, beq, lb, ub, intcon, f, kellies, bookmaker_row_vector, prob_row_vector] = config_params_2( total_budget, single_bet_budget, p_games, bookmakers)
%CONFIG_PARAMS Summary of this function goes here
%   Detailed explanation goes here

num_of_games = size(p_games, 1);
num_of_bookmakers = size(bookmakers, 3);
num_of_results = size(p_games, 2);

%% Initialize the parameters of intlingprog function
A = zeros(1 + num_of_games * num_of_bookmakers * num_of_results,...
    num_of_games * num_of_bookmakers * num_of_results);
b = zeros(1 + num_of_games * num_of_bookmakers * num_of_results, 1);
lb = zeros(num_of_games * num_of_bookmakers * num_of_results, 1);
ub = ones(num_of_games * num_of_bookmakers * num_of_results, 1);
intcon = 1 : num_of_games * num_of_bookmakers * num_of_results;
Aeq = [];
beq = [];

%% Kelly, bookmakers, and probabilities of the results of each game
kellies = zeros(1, num_of_games * num_of_bookmakers * num_of_results);
bookmaker_row_vector = zeros(1, num_of_games * num_of_bookmakers * num_of_results);
prob_row_vector = zeros(1, num_of_games * num_of_bookmakers * num_of_results);

%% Populate the parameters of constraints
x_idx = 1;
n = 1;
for i = 1 : num_of_games
    for j = 1 : num_of_bookmakers
        for k = 1 : num_of_results
            kelly = p_games(i, k) - (1 - p_games(i, k)) / (bookmakers(i, k, j) - 1);
            kellies(1, x_idx) = kelly;
            bookmaker_row_vector(x_idx) = bookmakers(i, k, j);
            prob_row_vector(x_idx) = p_games(i, k);            
            x_idx = x_idx + 1;
            
%             A(n, (i - 1) * num_of_bookmakers *num_of_results + (j - 1) * num_of_results + k) = kelly * total_budget;
%             b(n) = single_bet_budget;  % x_i * kelly * total_budget <= single_bet_budget
%             n = n + 1;
%             
            A(n, (i - 1) * num_of_bookmakers *num_of_results + (j - 1) * num_of_results + k) = -kelly * single_bet_budget;
            b(n) = 0;    % x_i * kelly * single_bet_budget >= 0
            n = n + 1;
        end
    end
end

for i = 1 : num_of_games
    for j = 1 : num_of_bookmakers
        for k = 1 : num_of_results
            A(end, (i - 1) * num_of_bookmakers *num_of_results + (j - 1) * num_of_results + k) ...
                = kellies((i - 1) * num_of_bookmakers *num_of_results + (j - 1) * num_of_results + k) * single_bet_budget;
            b(end) = total_budget;   % Total bet should be less or equal to total_budget
        end
    end
end
            
%% objective functions
f = zeros(1, num_of_games * num_of_bookmakers * num_of_results);
for i = 1 : num_of_games   
    for j = 1 : num_of_bookmakers  
        for k = 1 : num_of_results 
            f(1, (i - 1) * num_of_bookmakers *num_of_results + (j - 1) * num_of_results + k) =...
                - (kellies((i - 1) * num_of_bookmakers *num_of_results ...
                + (j - 1) * num_of_results + k) * single_bet_budget * (bookmakers(i, k, j) - 1));  
        end
    end
end


end

