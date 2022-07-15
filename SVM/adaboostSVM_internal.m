%% Load inputs

data = importdata('FFT_features_internal.csv'); % features
Q = length(data);
labels = ones(Q,1); % labels : -1 corresponds to the presence of chatter, 1 corresponds to no manufacturing defect
labels(Q/2+1:Q,1) = -1;

%% Train, Validation, Test dataset split

trainRatio = 0.7;
valRatio = 0;
testRatio = 0.3;

AccuracyT = zeros(100,1);
SensitivityT = zeros(100,1);

for i = 1:100 % average results on 100 trials

[trainInd,valInd,testInd] = dividerand(Q,trainRatio,valRatio,testRatio);

%% Optimize fit

X=data(trainInd,:);
Y=labels(trainInd);
newX=data(testInd,:);

% Training :
itt=100;
[estimateclass,model]=adaboost('train',X,Y,itt);

% Test :
ada_test=adaboost('apply',newX,model);

%% Confusion matrix

confmat = confusionmat(labels(testInd), ada_test);

TP = confmat(2, 2);
TN = confmat(1, 1);
FP = confmat(1, 2);
FN = confmat(2, 1);
AccuracyT(i) = (TP + TN) / (TP + TN + FP + FN); % number of correctly predicted samples divide total number of samples
SensitivityT(i) = TP / (FN + TP); % number of correctly predicted chatter samples divide total number of chatter samples.

end

Accuracy = sum(AccuracyT)/100
Sensitivity = sum(SensitivityT)/100
