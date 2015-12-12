clear; clc; close all

      
% b365 = [1.10, 9.00, 21.00;  
%         7.50, 3.60, 1.53;
%         5.25, 4.50, 1.53;
%         3.60, 3.50, 2.00;
%         3.75, 3.00, 2.15
%         3.10, 3.25, 2.30;
%         1.57, 3.60, 6.50;
%         2.30, 3.00, 3.40;
%         1.57, 3.80, 6.00;
%         2.38, 3.20, 3.00;
%         11.00, 4.50,1.33;
%         3.75, 3.50, 1.95;
%         3.50, 3.75, 1.95;
%         4.50, 3.50, 1.80;
%         1.50, 4.00, 7.00;
%         1.20, 7.00, 11.00;
%         2.38, 3.30, 2.90;
%         3.60, 3.40, 2.05;
%         1.44, 4.33, 7.00;
%         1.36, 4.75, 8.00;
%         ];
%         
%         
%         
% 
% bwin = [1.09, 9.25, 21.00;
%         6.00, 3.70, 1.57;
%         6.00, 4.40, 1.48;
%         3.40, 3.50, 2.05;
%         3.30, 3.20, 2.20;
%         3.60, 3.00, 2.20;
%         1.60, 3.75, 5.75;
%         2.40, 3.10, 3.00;
%         1.70, 3.60, 4.90;
%         2.45, 3.30, 2.80;
%         6.75, 4.75, 1.40;
%         2.95, 3.30, 2.35;
%         3.10, 3.30, 2.25;
%         4.40, 3.50, 1.78;
%         1.50, 4.00, 6.50;
%         1.18, 6.75, 13.00;
%         2.40, 3.30, 2.85;
%         3.60, 3.40, 2.00;
%         1.42, 4.40, 7.00;
%         1.35, 4.75, 8.25;
%         ];
%         
%        
% bookmakers = b365;
% bookmakers(:, :, 2) = bwin;

% p_games = [0.57, 0.26, 0.17;  % Real Madrid vs Getafe
%            0.21, 0.27, 0.52;  % Granada vs Atletico
%            0.29, 0.32, 0.39;  % Valencia vs Barcelona
%            0.21, 0.28, 0.51;  % Real Betis vs Celta
%            0.29, 0.31, 0.40;  % Lazio vs Juventus
%            0.33, 0.33, 0.34;  % Torino vs Roma
%            0.57, 0.26, 0.17;  % Inter vs Genoa
%            0.34, 0.33, 0.33;  % Lorient vs Nice
%            0.59, 0.24, 0.17;  % Schalke 04 vs Hannover 96
%            0.48, 0.29, 0.23;  % Ingolstadt vs Hoffenheim
%            0.29, 0.31, 0.40;  % Borussia MG vs Bayern
%            0.42, 0.31, 0.27;  % Hertha vs Leverkusen
%            0.37, 0.32, 0.31;  % Wolfsburg vs Dortmund
%            0.29, 0.34, 0.37;  % Stoke vs Man City
%            0.52, 0.27, 0.21;  % Southampton vs Aston Villa
%            0.50, 0.28, 0.22;  % Arsenal vs Sunderland
%            0.19, 0.26, 0.55;  % Swansea vs Leicester
%            0.31, 0.32, 0.37;  % West Brom vs Tottenham
%            0.45, 0.30, 0.25;  % Man United vs West Ham
%            0.48, 0.29, 0.23;  % Chelsea vs Bournemouth
%            ];
       
data = csvread('121115.csv', 0, 1);
p_games = data(:, 1 : 3);
b365 = data(:, 4 : 6);
bwin = data(:, 7 : 9);
bookmakers = b365;
bookmakers(:, :, 2) = bwin;
% results = [1, 3, 2, 2, 3, 2, 1, 2, 1, 2, 1, 1, 3, 1, 2, 1, 3, 2, 2, 3]';

num_of_games = size(p_games, 1);
num_of_bookmakers = size(bookmakers, 3);
num_of_results = size(bookmakers, 2);
           
total_budget = 500;  % Total budget
single_bet_budget = 50;   % single bet upper bound


[ A, b, Aeq, beq, lb, ub, intcon, f, kellies, bookmaker_row_vector, prob_row_vector] ...
    = config_params_2( total_budget, single_bet_budget, p_games, bookmakers);


[X,FVAL,EXITFLAG] = intlinprog(f, intcon, A, b, [], [], lb, ub);

bets = (kellies * single_bet_budget) .* X';

bets_reshape = zeros(num_of_games, num_of_results, num_of_bookmakers);
bets_temp = bets';
bets_temp = reshape(bets_temp, num_of_results, length(bets_temp) / num_of_results);
bets_temp = bets_temp';

rows = 1 : size(bets_temp, 1);

for i = 1 : num_of_bookmakers - 1
    bets_reshape(:, :, i) = bets_temp(mod(rows, num_of_bookmakers) == i, :);
end



bets_reshape(:, :, num_of_bookmakers) = bets_temp(mod(rows, num_of_bookmakers) == 0, :);



potential_received = (kellies * single_bet_budget) .* X' .* bookmaker_row_vector .* prob_row_vector;

if EXITFLAG == 1 && sum(bets) ~= 0
    fprintf(strcat('Optimal Solution Found! Total Money Bet is: ', num2str(sum(bets)), '\n'));
    fprintf(strcat('Optimal Solution Found! Total Potential Money Get Back is: ', num2str(sum(potential_received)), '\n'));
    fprintf(strcat('Optimal Solution Found! Total Potential Profit is: ', num2str(sum(potential_received) - sum(bets)), '\n'));
%     fprintf(strcat('Optimal Solution Found! Total Potential Profit is: ', num2str(-FVAL), '\n'));
elseif EXITFLAG == 1 && sum(bets) == 0
    
    fprintf('No Solution Found!\n')
end
bets_reshape




% [profit, received, actual_bets] = actual_profit(bets, results, bookmakers);
% correct_pred_rate = pred_rate(p_games, results);
% 
% fprintf(strcat('Total Actual Money Get Back is: ', num2str(received), '\n'));
% fprintf(strcat('Total Actual Profit is: ', num2str(profit), '\n'));
% fprintf('We bet on: \n');
% actual_bets



