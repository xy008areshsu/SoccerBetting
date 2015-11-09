clear; clc; close all

input_layer_size  = 38;
num_labels = 3; 

data = csvread('../../../../data/clean_data.csv', 1);  
data = data(randperm(size(data, 1)), :);
X = data(1:floor(0.9 * size(data, 1)), 1:input_layer_size);
y = data(1:floor(0.9 * size(data, 1)), size(data, 2));

X_test = data(floor(0.9 * size(data, 1)) : end, 1:input_layer_size);
y_test = data(floor(0.9 * size(data, 1)) : end, size(data, 2));


fprintf('Program paused. Press enter to continue.\n');
pause;



% SVM Parameters
C = 1; sigma = 0.5;

% Train the SVM
model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma));
visualizeBoundary(X, y, model);

pred = svmPredict(model, X_test);

fprintf('\nTest Set Accuracy: %f\n', mean(double(pred(1:end) == y_test(1:end))) * 100);
