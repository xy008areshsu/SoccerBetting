function [ profit, bets_reshape ] = actual_profit( bets, results, bookmakers )

num_of_games = size(results, 1);
num_of_bookmakers = size(bookmakers, 3);
num_of_results = size(bookmakers, 2);

bets_reshape = zeros(num_of_games, num_of_results, num_of_bookmakers);
bets_temp = bets';
bets_temp = reshape(bets_temp, num_of_results, length(bets_temp) / num_of_results);
bets_temp = bets_temp';

rows = 1 : size(bets_temp, 1);

for i = 1 : num_of_bookmakers - 1
    bets_reshape(:, :, i) = bets_temp(mod(rows, num_of_bookmakers) == i, :);
end



bets_reshape(:, :, num_of_bookmakers) = bets_temp(mod(rows, num_of_bookmakers) == 0, :);

res_reshape = zeros(num_of_games, num_of_results, num_of_bookmakers);
res_temp = zeros(num_of_games, num_of_results);
res_temp(results == 1, 1) = 1;
res_temp(results == 2, 2) = 1;
res_temp(results == 3, 3) = 1;

for i = 1 : num_of_bookmakers
    res_reshape(:, :, i) = res_temp;
end

received = zeros(num_of_games, num_of_results, num_of_bookmakers);
received(res_reshape == 1) = bets_reshape(res_reshape == 1) .* bookmakers(res_reshape == 1);

total_bets = sum(sum(sum(bets_reshape)));
total_received = sum(sum(sum(received)));

profit = total_received - total_bets;


end

