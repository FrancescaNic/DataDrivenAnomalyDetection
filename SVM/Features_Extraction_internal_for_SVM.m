aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];

features = [];

%% Load data

data = importdata(strcat('../RAW_data/TNCScope/Vc250_F910_ae100_ap0.75_cleaned.csv'));

T = (data.data(2,2)-data.data(1,2))*0.000001;             % Sampling period 
Fs = 1/T;            % Sampling frequency  

for ap = 1:6
        for i = 1:20
signal_name = strcat('Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv');
data0 = importdata(strcat("Data_Internal/segmented_signal_", signal_name, "_seg_",string(i),".csv"));

                        
L = length(data0);             % Length of signal
t = (0:L-1)*T;        % Time vector

features_acc = [];

for acc =1:14

data1=data0(:,acc);
%% Time domain features

% Features from "Milling chatter detection by multi-feature fusion and Adaboost-SVM"

S = sum(abs(data1).^3)/length(data1); % Skewness
K = sum(data1.^4)/length(data1); % Kurtosis
V = sum(data1.^2)/length(data1); % Variance

Sv = S/V; % Skewness index
Kv = K/V; % Kurtosis index

% Extra features from "Online chatter detection of the end milling based on wavelet packet transform and support vector machine recursive feature elimination"

xstd = std(data1); % Standard deviation
xp = max(abs(data1)); % Peak

TF = [Sv, Kv, xstd, xp];

end
features = [features; TF];
        end 
end


%% Plots

% acc = 1; % Set the acceleration axis
% 
% fe = features([acc, 3+15+acc, 6+30+acc, 9+45+acc, 12+60+acc, 15+75+acc],:);
% features_names = categorical({'Sf', 'Cf', 'CLf', 'Sv', 'Kv', 'Ifm', 'Xm', 'Xstd', 'Xp', 'FC', 'MSF', 'VF', 'ro'});
% 
% for i = 1:13
%     subplot(4,4,i)
%     aps_c = categorical({'0.75', '1.5', '2', '2.5', '3', '3.5'});
%     scatter(aps_c,fe(:,i));
%     xlabel('aps')
%     ylabel(features_names(i))
% 
% end


%% Student T-Test
% student = [];
% 
% for acc=1:3
% 
% fe = features([acc, 3+acc, 6+acc, 9+acc, 12+acc, 15+acc],:);
% 
% for i = 1:length(fe)
% [h p] = ttest(fe(1:3,i),fe(4:6,i),'Alpha',0.10);
% student = [student; h, p];
% 
% if h==0
%     features([acc, 3+acc, 6+acc, 9+acc, 12+acc, 15+acc],i)=-1;
% end
% end
% end


% If the null-hypothesis is set to be that the two independent samples have identical average (expected) values.
% Then, if the p-value < 0.10, the null-hypothesis can be rejected and so it can said that there is a significant difference between the two series of data. 

%% Export results

writematrix(features,strcat("FFT_features_internal.csv"))