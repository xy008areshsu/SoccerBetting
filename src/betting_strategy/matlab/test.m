clear; clc; close all

% p_games = [0.56, 0.26, 0.18;
%            0.45, 0.27, 0.28;
%            0.43, 0.27, 0.40;];
       
% p_games = [0.90, 0.05, 0.05;
%            0.70, 0.15, 0.15;
%            0.75, 0.10, 0.15;];
       
% b365 = [1.61, 3.80, 5.50;
%         2.10, 3.40, 3.40;
%         2.20, 3.40, 3.20;];
%     
% bwin = [1.60, 3.75,	5.50;
%         2.10, 3.40,	3.30;
%         2.10, 3.30,	3.40;];
%     
% oddset = [1.60, 3.60, 5.50;
%           2.00, 3.40, 3.40;
%           2.15, 3.30, 3.20;];
%       
%       
% betfair = [1.30, 3.55, 5.20;
%            1.90, 3.25, 3.25;
%            1.91, 3.30, 3.10;];
       
b1 = [1.3	5	9.5;
2.75	3.25	2.25;
2.1	3.25	3;
1.57	3.4	5.5;
2.4	3.2	2.6;
1.44	3.75	6.5;
2.37	3.2	2.62;
2.75	3.25	2.25;
1.5	3.5	6;
3	3.25	2.1;];

b2 = [1.35	4.2	8;
2.85	3.35	2.2;
1.95	3.3	3.5;
1.55	3.7	5.35;
2.5	3.15	2.6;
1.4	4	7.2;
2.5	3.35	2.5;
2.7	3.35	2.3;
1.5	3.8	5.8;
3.15	3.4	2.05;];

b3 = [1.36	4.25	9;
3	3.35	2.25;
2.05	3.25	3.5;
1.6	3.65	5.5;
2.6	3.15	2.65;
1.45	4	7.25;
2.45	3.25	2.75;
2.75	3.35	2.4;
1.57	3.6	6;
3	3.35	2.25;];

b4 = [1.35	4	7.5;
2.7	3	2.3;
1.9	3.1	3.5;
1.55	3.5	4.8;
2.5	3	2.5;
1.4	3.9	6;
2.4	3	2.6;
2.7	3	2.3;
1.5	3.7	5;
2.9	3	2.2;];
       
% bookmakers = b365;
% bookmakers(:, :, 2) = bwin;
% bookmakers(:, :, 3) = oddset;
% bookmakers(:, :, 4) = betfair;

bookmakers = b1;
bookmakers(:, :, 2) = b2;
bookmakers(:, :, 3) = b3;
bookmakers(:, :, 4) = b4;


p_games = zeros(10, 3);
for i = 1 : 10
    for j = 1 : 3
        p_games(i, j) = 1 / b3(i, j) - 0.033;
    end
end

% p_games = zeros(3, 3);
% for i = 1 : 3
%     for j = 1 : 3
%         p_games(i, j) = 1 / b365(i, j) - 0.033;
%     end
% end

% p_games = [0.56, 0.26, 0.18;
%            0.45, 0.27, 0.28;
%            0.43, 0.27, 0.40;];

total_budget = 150;  % Total budget
single_bet_budget = 50;   % single bet upper bound


[ A, b, Aeq, beq, lb, ub, intcon, f, kellies, bookmaker_row_vector, prob_row_vector] ...
    = config_params_2( total_budget, single_bet_budget, p_games, bookmakers);


[X,FVAL,EXITFLAG] = intlinprog(f, intcon, A, b, [], [], lb, ub);

bets = (kellies * single_bet_budget) .* X';
get_back = (kellies * single_bet_budget) .* X' .* bookmaker_row_vector .* prob_row_vector;

if EXITFLAG == 1 && sum(bets) ~= 0
    fprintf(strcat('Optimal Solution Found! Total Money Bet is: ', num2str(sum(bets)), '\n'));
    fprintf(strcat('Optimal Solution Found! Total Money Get Back is: ', num2str(sum(get_back)), '\n'));
    fprintf(strcat('Optimal Solution Found! Total Potential Profit is: ', num2str(sum(get_back) - sum(bets)), '\n'));
%     fprintf(strcat('Optimal Solution Found! Total Potential Profit is: ', num2str(-FVAL), '\n'));
elseif EXITFLAG == 1 && sum(bets) == 0
    
    fprintf('No Solution Found!\n')
end

