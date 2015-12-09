function [ correct_pred_rate ] = pred_rate( p_games, results )

[~, pred] = max(p_games, [], 2);

correct_pred_rate = mean(pred == results);

end

