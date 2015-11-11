%% Machine Learning Online Class - Exercise 3 | Part 1: One-vs-all

%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  linear exercise. You will need to complete the following functions 
%  in this exericse:
%
%     lrCostFunction.m (logistic regression cost function)
%     oneVsAll.m
%     predictOneVsAll.m
%     predict.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
clear ; close all; clc

%% Setup the parameters you will use for this part of the exercise
input_layer_size  = 37;  % 20x20 Input Images of Digits
num_labels = 3;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============
%  We start the exercise by first loading and visualizing the dataset. 
%  You will be working with a dataset that contains handwritten digits.
%

data = csvread('../../../../data/clean_data.csv', 1);  
data = data(randperm(size(data, 1)), :);
X = data(1:floor(0.9 * size(data, 1)), 1:input_layer_size);
y = data(1:floor(0.9 * size(data, 1)), size(data, 2));

X_test = data(floor(0.9 * size(data, 1)) : end, 1:input_layer_size);
y_test = data(floor(0.9 * size(data, 1)) : end, size(data, 2));


fprintf('Program paused. Press enter to continue.\n');
pause;

%% ============ Part 2: Vectorize Logistic Regression ============
%  In this part of the exercise, you will reuse your logistic regression
%  code from the last exercise. You task here is to make sure that your
%  regularized logistic regression implementation is vectorized. After
%  that, you will implement one-vs-all classification for the handwritten
%  digit dataset.
%

fprintf('\nTraining One-vs-All Logistic Regression...\n')

max_iter = 1000;
lambda = 0;
[all_theta] = oneVsAll(X, y, num_labels, lambda, max_iter);

fprintf('Program paused. Press enter to continue.\n');
pause;




%% ================ Part 3: Predict for One-Vs-All ================
%  After ...
[pred, pred_val] = predictOneVsAll(all_theta, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred(1:end) == y(1:end))) * 100);

[pred, pred_val] = predictOneVsAll(all_theta, X_test);

fprintf('\nTest Set Accuracy: %f\n', mean(double(pred(1:end) == y_test(1:end))) * 100);



csvwrite('theta.csv', all_theta)
