
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
data = csvread('bettings.csv');  
l = size(data, 1);
X = data(1 : floor(0.9 * l), 1 : 3);
y = data(1 : floor(0.9 * l), end);
m = length(y);
X_test = data(floor(0.9 * l) + 1 : end, 1 : 3);
y_test = data(floor(0.9 * l) + 1 : end, end);
n = length(y_test);

% Add intercept term to X
X = [ones(m, 1) X];
X_test = [ones(n, 1) X_test];

% Calculate the parameters from the normal equation
theta = normalEqn(X, y);

% Display normal equation's result
fprintf('Theta computed from the normal equations: \n');
fprintf(' %f \n', theta);
fprintf('\n');

cost = computeCostMulti(X, y, theta)
cost = computeCostMulti(X_test, y_test, theta)