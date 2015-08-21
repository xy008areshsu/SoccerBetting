
% %% ================ Part 3: Normal Equations ================
% 
% fprintf('Solving with normal equations...\n');
% 
% % ====================== YOUR CODE HERE ======================
% % Instructions: The following code computes the closed form 
% %               solution for linear regression using the normal
% %               equations. You should complete the code in 
% %               normalEqn.m
% %
% %               After doing so, you should complete this code 
% %               to predict the price of a 1650 sq-ft, 3 br house.
% %
% 
% %% Load Data
% data = csvread('ex1data2.txt');
% X = data(:, 1:2);
% y = data(:, 3);
X = data(:, 1:10);
y = data(:, 11);
m = length(y);

% Add intercept term to X
X = [ones(m, 1) X];

% Calculate the parameters from the normal equation
theta = normalEqn(X, y);

% Display normal equation's result
fprintf('Theta computed from the normal equations: \n');
fprintf(' %f \n', theta);
fprintf('\n');

cost = computeCostMulti(X, y, theta);