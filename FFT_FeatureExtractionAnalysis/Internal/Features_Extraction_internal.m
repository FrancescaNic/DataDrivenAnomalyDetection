aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = categorical({'s_actual_X','s_actual_Y','s_actual_Z','s_dif_X','s_dif_Y','s_dif_Z','v_act._X','v_act._Y','v_act._Z','v_act._S1','IW_SDM_arms_I_0_1_g','IW_SDM_arms_J_0_1_g','I_N_int_S1','i_ist_X','i_ist_Y','i_ist_Z'});


features = [];

for ap = 1:6

data = importdata(strcat('../../RAW_data/TNCScope/Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv'));

T = (data.data(2,2)-data.data(1,2))*0.000001;             % Sampling period 
Fs = 1/T;            % Sampling frequency                          
L = length(data.data);             % Length of signal
t = (0:L-1)*T;        % Time vector

    for acc = 3:18
%% Time domain features
data1=data.data(:,acc);

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

% Extra features from "Online chatter detection of the end milling based on wavelet packet transform and support vector machine recursive feature elimination"

xm = mean(data1); % Mean
xstd = std(data1); % Standard deviation
xp = max(abs(data1)); % Peak

TF = [Sf, Cf, CLf, Sv, Kv, Ifm, xm, xstd, xp];

%% Frequency domain features
data2=data.data(:,acc)-mean(data.data(:,acc));
Y = fft(data2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = (Fs*(0:(L/2))/L)';

FC = sum(f.*P1)/sum(P1); % Gravity frequency index (Frequency center)
MSF = sum(f.^2.*P1)/sum(P1); % Mean square frequency index
VF = sum((f-FC).^2.*P1)/sum(P1); % Frequency variance index (Standard frequency)

% Extra features from "Online chatter detection of the end milling based on wavelet packet transform and support vector machine recursive feature elimination"

ro = sum(cos(2*pi*T*f).*P1)/sum(P1); % One-step autocorrelation

FF = [FC, MSF, VF, ro];

features = [features; TF, FF];

    end 
end 

%% Plots

acc = 18; % Set the acceleration axis (going from 3 to 18)

fe = features([acc-2, 16+acc-2, 32+acc-2, 48+acc-2, 64+acc-2, 80+acc-2],:);
features_names = categorical({'Sf', 'Cf', 'CLf', 'Sv', 'Kv', 'Ifm', 'Xm', 'Xstd', 'Xp', 'FC', 'MSF', 'VF', 'ro'});

for i = 1:13
    subplot(4,4,i)
    aps_c = categorical({'0.75', '1.5', '2', '2.5', '3', '3.5'});
    scatter(aps_c,fe(:,i));
    xlabel('aps')
    ylabel(features_names(i))

end


%% Student T-Test
student = [];

for acc=3:18

fe = features([acc-2, 16+acc-2, 32+acc-2, 48+acc-2, 64+acc-2, 80+acc-2],:);

fprintf('PARAMETER : %s\n\n', accs(acc-2))

for i = 1:length(fe)
[h p] = ttest(fe(1:3,i),fe(4:6,i),'Alpha',0.10);
student = [student; h, p];

if h==0
    features([acc-2, 16+acc-2, 32+acc-2, 48+acc-2, 64+acc-2, 80+acc-2],i)=-1;
    fprintf('%s is rejected\n', string(features_names(i)))
else
    fprintf('%s is VALID\n', string(features_names(i)))
end
end
end


% If the null-hypothesis is set to be that the two independent samples have identical average (expected) values.
% Then, if the p-value < 0.10, the null-hypothesis can be rejected and so it can said that there is a significant difference between the two series of data. 

%% Export results

writematrix(features,strcat("FFT_internal_features.csv"))