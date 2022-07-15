aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];

% frequencies = [];
% ftransforms = [];

features = [];
features2 = [];

T = 3.085470000003809e-04;             % Sampling period 
Fs = 1/T;            % Sampling frequency 

for ap = 1:6
    for acc = 1:3
data1 = importdata(strcat('WPT_reconstruction',accs(acc),'_',aps(ap),'.csv'));
                         
L = length(data1);             % Length of signal
t = (0:L-1)*T;        % Time vector


%% Time domain features

% Features from "Milling chatter detection by multi-feature fusion and Adaboost-SVM"

xrms = sqrt(sum(data1.^2)/length(data1)); % Root mean square
xs = (sum(sqrt(abs(data1)))/length(data1))^2; % Square root amplitude
xa = sum(abs(data1))/length(data1); % Average amplitude
S = sum(abs(data1).^3)/length(data1); % Skewness
K = sum(data1.^4)/length(data1); % Kurtosis
V = sum(data1.^2)/length(data1); % Variance

Sf = xrms/xa; % Waveform index
Cf = max(data1)/xrms; % Peak index
CLf = max(data1)/xa; % Pulse index
Sv = S/V; % Skewness index
Kv = K/V; % Kurtosis index
Ifm = max(data1)/xs; % Margin index

TF = [Sf, Cf, CLf, Sv, Kv, Ifm];

% Extra features from "Online chatter detection of the end milling based on wavelet packet transform and support vector machine recursive feature elimination"

xm = mean(data1); % Mean
xstd = std(data1); % Standard deviation
xp = max(abs(data1)); % Peak

TF2 = [xm, xstd, xp];


%% Frequency domain features
data2=data.data(:,2+acc)-mean(data.data(:,2+acc));
Y = fft(data2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = (Fs*(0:(L/2))/L)';

FC = sum(f.*P1)/sum(P1); % Gravity frequency index (Frequency center)
MSF = sum(f.^2.*P1)/sum(P1); % Mean square frequency index
VF = sum((f-FC).^2.*P1)/sum(P1); % Frequency variance index (Standard frequency)

FF = [FC, MSF, VF];

features = [features; TF, FF];
features2 = [features2; TF2];

% frequencies = [frequencies, f];
% ftransforms = [ftransforms, P1];
    end 
end 

%% Plots

acc = 3; % Set the acceleration axis

fe = features([acc, 3+acc, 6+acc, 9+acc, 12+acc, 15+acc],:);
features_names = categorical({'Sf', 'Cf', 'CLf', 'Sv', 'Kv', 'Ifm', 'FC', 'MSF', 'VF'});

for i = 1:9
    subplot(3,3,i)
    aps_c = categorical({'0.75', '1.5', '2', '2.5', '3', '3.5'});
    scatter(aps_c,fe(:,i));
    xlabel('aps')
    ylabel(features_names(i))

end

fe2 = features2([acc, 3+acc, 6+acc, 9+acc, 12+acc, 15+acc],:);
% features_names = categorical({'Xm', 'Xstd', 'Xp'});
% 
% for i = 1:3
%     subplot(1,3,i)
%     aps_c = categorical({'0.75', '1.5', '2', '2.5', '3', '3.5'});
%     scatter(aps_c,fe2(:,i));
%     xlabel('aps')
%     ylabel(features_names(i))
% 
% end

%saveas("FFT_features.png")



%% Student T-Test

student = [];

for i = 1:length(fe)
[h p] = ttest(fe(1:3,i),fe(4:6,i),'Alpha',0.10);
student = [student; h, p];
end

student2 = [];

for i = 1:3
[h p] = ttest(fe2(1:3,i),fe2(4:6,i),'Alpha',0.10);
student2 = [student2; h, p];
end

% If the null-hypothesis is set to be that the two independent samples have identical average (expected) values.
% Then, if the p-value < 0.10, the null-hypothesis can be rejected and so it can said that there is a significant difference between the two series of data. 
