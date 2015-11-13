p_games = [0.05, 0.05, 0.9;
           0.70, 0.20, 0.10;
           0.4365, 0.2809, 0.2826;];
       
b365 = [1.61, 3.80, 5.50;
        2.10, 3.40, 3.40;
        2.20, 3.40, 3.20;];
    
bwin = [1.60, 3.75,	5.50;
        2.10, 3.40,	3.30;
        2.10, 3.30,	3.40;];
    
oddset = [1.60, 3.60, 5.50;
          2.00, 3.40, 3.40;
          2.15, 3.30, 3.20;];
      
      
betfair = [1.30, 3.55, 5.20;
           1.90, 3.25, 3.25;
           1.91, 3.30, 3.10;];
       
bookmakers = b365;
bookmakers(:, :, 2) = bwin;
bookmakers(:, :, 3) = oddset;
bookmakers(:, :, 4) = betfair;


B = 1000;  % Total budget
SB = 1000;   % single bet upper bound

A = zeros(1, 3 * 4 * 3);
b = zeros(1, 1);
lb = zeros(3 * 4 * 3, 1);
ub = SB * ones(3 * 4 *3, 1);

A(1, :) = ones(1, 3 * 4 * 3);
b(1) = B;

f = zeros(1, 3 * 4 * 3);
for i = 1 : 3   % number of games
    for j = 1 : 4   % number of bookmakers
        for k = 1 : 3  % number of results
            f(1, (i - 1) * 4 *3 + (j - 1) * 3 + k) = - p_games(i, k) * bookmakers(i, k, j);
        end
    end
end

[X,FVAL,EXITFLAG] = linprog(f,A,b, [], [], lb, ub)

if EXITFLAG == 1
    fprintf(strcat('Optimal Solution Found! Total Expected Profit is: ', num2str(-FVAL - sum(X)), '\n'));
else
    fprintf('No Solution Found\n!')
end

