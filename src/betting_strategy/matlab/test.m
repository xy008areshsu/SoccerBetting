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
       
b365 = [1.10, 9.00, 21.00;  
        7.50, 3.60, 1.53;
        5.25, 4.50, 1.53;
        3.60, 3.50, 2.00;
        3.75, 3.00, 2.15
        3.10, 3.25, 2.30;
        1.57, 3.60, 6.50;
        2.30, 3.00, 3.40;
        1.57, 3.80, 6.00;
        2.38, 3.20, 3.00;
        11.00, 4.50,1.33;
        3.75, 3.50, 1.95;
        3.50, 3.75, 1.95;
        4.50, 3.50, 1.80;
        1.50, 4.00, 7.00;
        1.20, 7.00, 11.00;
        2.38, 3.30, 2.90;
        3.60, 3.40, 2.05;
        1.44, 4.33, 7.00;
        1.36, 4.75, 8.00;
        ];
        
        
        

bwin = [1.09, 9.25, 21.00;
        6.00, 3.70, 1.57;
        6.00, 4.40, 1.48;
        3.40, 3.50, 2.05;
        3.30, 3.20, 2.20;
        3.60, 3.00, 2.20;
        1.60, 3.75, 5.75;
        2.40, 3.10, 3.00;
        1.70, 3.60, 4.90;
        2.45, 3.30, 2.80;
        6.75, 4.75, 1.40;
        2.95, 3.30, 2.35;
        3.10, 3.30, 2.25;
        4.40, 3.50, 1.78;
        1.50, 4.00, 6.50;
        1.18, 6.75, 13.00;
        2.40, 3.30, 2.85;
        3.60, 3.40, 2.00;
        1.42, 4.40, 7.00;
        1.35, 4.75, 8.25;
        ];
        
       
bookmakers = b365;
bookmakers(:, :, 2) = bwin;
% bookmakers(:, :, 3) = oddset;
% bookmakers(:, :, 4) = betfair;

% bookmakers = b1;
% bookmakers(:, :, 2) = b2;
% bookmakers(:, :, 3) = b3;
% bookmakers(:, :, 4) = b4;


% p_games = zeros(10, 3);
% for i = 1 : 10
%     for j = 1 : 3
%         p_games(i, j) = 1 / b3(i, j) - 0.033;
%     end
% end

% p_games = zeros(3, 3);
% for i = 1 : 3
%     for j = 1 : 3
%         p_games(i, j) = 1 / b365(i, j) - 0.033;
%     end
% end

% p_games = [0.56, 0.26, 0.18;
%            0.45, 0.27, 0.28;
%            0.43, 0.27, 0.40;];

p_games = [0.57, 0.26, 0.17;  % Real Madrid vs Getafe
           0.21, 0.27, 0.52;  % Granada vs Atletico
           0.29, 0.32, 0.39;  % Valencia vs Barcelona
           0.21, 0.28, 0.51;  % Real Betis vs Celta
           0.29, 0.31, 0.40;  % Lazio vs Juventus
           0.33, 0.33, 0.34;  % Torino vs Roma
           0.57, 0.26, 0.17;  % Inter vs Genoa
           0.34, 0.33, 0.33;  % Lorient vs Nice
%            0.17, 0.26, 0.57;  % Angers vs PSG
%            0.31, 0.32, 0.37;  % Nantes vs Lyon
%            0.40, 0.31, 0.29;  % Monaco vs Caen
%            0.38, 0.32, 0.30;  % Bastia vs Bordeaux
           0.59, 0.24, 0.17;  % Schalke 04 vs Hannover 96
%            0.36, 0.33, 0.31;  % Koln vs Augsburg
           0.48, 0.29, 0.23;  % Ingolstadt vs Hoffenheim
           0.29, 0.31, 0.40;  % Borussia MG vs Bayern
           0.42, 0.31, 0.27;  % Hertha vs Leverkusen
           0.37, 0.32, 0.31;  % Wolfsburg vs Dortmund
           0.29, 0.34, 0.37;  % Stoke vs Man City
           0.52, 0.27, 0.21;  % Southampton vs Aston Villa
           0.50, 0.28, 0.22;  % Arsenal vs Sunderland
           0.19, 0.26, 0.55;  % Swansea vs Leicester
           0.31, 0.32, 0.37;  % West Brom vs Tottenham
           0.45, 0.30, 0.25;  % Man United vs West Ham
           0.48, 0.29, 0.23;  % Chelsea vs Bournemouth
%            0.44, 0.30, 0.26;  % Watford vs Norwich City
           ];
           
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

