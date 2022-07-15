%% Load Data

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
energy = [];
entropy = [];
relative_nrg = [];

for acc = 1:16
    for ap = 1:6

data = importdata(strcat('../RAW_data/TNCScope/Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv'));
  
y=data.data(:,2+acc);

%% Bandpass Filter

% Eliminate Frequencies that are not chatter characteristic

T = (data.data(2,2)-data.data(1,2))*0.000001;             % Sampling period 
Fs = 1/T;            % Sampling frequency    

y = bandpass(y,[1100 1250],Fs);

%% Ensemble Empirical Mode Decomposition algorithm

M = 100;
goal = 8;

modes = zeros(length(y), goal);

for m = 1:M

    y1 = y + wgn(length(y),1,0);
    emd_computation = emd(y1,'MaxNumIMF',goal);
    if length(emd_computation(1,:))~=8
        emd_computation(:,8) = zeros(length(emd_computation),1);
    end
    modes = modes + emd_computation;

end
modes = modes./M;

%%

C0 = zeros(goal, 1);
E = zeros(goal, 1);
RE = zeros(goal, 1);

for i = 1:goal
%% C0 Complexity algorithm

s = modes(:,i)-mean(modes(:,i));
F = fft(s); % Fourier Transformation

G = sum(abs(F).^2)/length(y);

r = 5; % range of values 5-10 in practical application
F_new = zeros(length(y), 1);

for j = 1:length(F)
    if abs(F(j))^2 > r*G
        F_new(j) = F(j);
    end
end

y_new = ifft(F_new);


C0(i) = sum(abs(modes(:,i)-y_new).^2)/sum(abs(modes(:,i)).^2);

%% Power Spectral Entropy algorithm

xt = timetable(seconds(data.data(:,2)),modes(:,i));
[p,fp,tp] = pspectrum(xt,'spectrogram');
se = pentropy(p,fp,tp);
E(i) = sum(se)/length(se);

%% Relative energy

RE(i) = sum(abs(F).^2)/length(F); % Energy computation

end

energy = [energy, C0];
entropy = [entropy, E];
relative_nrg = [relative_nrg, RE];

    end
end

%% PLOTS 

%% IMFS

% subplot(2,2,1);
% 
% plot(data.data(:,2), modes(:,1));
% title('IMF 1 for ap = 3.5 & A3')
% xlabel('Time')
% ylabel('Amplitude')
% 
% subplot(2,2,2);
% 
% plot(data.data(:,2), modes(:,2));
% title('IMF 2 for ap = 3.5 & A3')
% xlabel('Time')
% ylabel('Amplitude')
% 
% subplot(2,2,3);
% 
% plot(data.data(:,2), modes(:,3));
% title('IMF 3 for ap = 3.5 & A3')
% xlabel('Time')
% ylabel('Amplitude')
% 
% subplot(2,2,4);
% 
% plot(data.data(:,2), modes(:,4));
% title('IMF 4 for ap = 3.5 & A3')
% xlabel('Time')
% ylabel('Amplitude')

%% IMF 1 Fourier spectrum

% T = data.data(2,2)-data.data(1,2);             % Sampling period 
% Fs = 1/T;            % Sampling frequency                          
% L = length(data.data);             % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% data2=modes(:,1)-mean(modes(:,1));
% Y = fft(data2);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% 
% 
% fig = plot(f,P1);
% title(strcat('Single-Sided Amplitude Spectrum of IMF 1 for ap = 3.5 & A3'))
% xlabel('Frequency [Hz]')
% ylabel('Amplitude')

%% Energy comparison

subplot(4,4,1);

bar(relative_nrg(:,1:6));
title('IMFs energy comparison for s actual X')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,2);

bar(relative_nrg(:,7:12));
title('IMFs energy comparison for s actual Y')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,3);

bar(relative_nrg(:,13:18));
title('IMFs energy comparison for s actual Z')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,4);

bar(relative_nrg(:,19:24));
title('IMFs energy comparison for s dif X')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,5);


bar(relative_nrg(:,25:30));
title('IMFs energy comparison for s dif Y')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,6);

bar(relative_nrg(:,31:36));
title('IMFs energy comparison for s dif Z')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,7);

bar(relative_nrg(:,37:42));
title('IMFs energy comparison for v act. X')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,8);


bar(relative_nrg(:,43:48));
title('IMFs energy comparison for v act. Y')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,9);

bar(relative_nrg(:,49:54));
title('IMFs energy comparison for v act. Z')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,10);

bar(relative_nrg(:,55:60));
title('IMFs energy comparison for v act. S1')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,11);


bar(relative_nrg(:,61:66));
title('IMFs energy comparison for IW SDM arms I 0 1 g')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,12);

bar(relative_nrg(:,67:72));
title('IMFs energy comparison for IW SDM arms J 0 1 g')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,13);

bar(relative_nrg(:,73:78));
title('IMFs energy comparison for I N int S1')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,14);

bar(relative_nrg(:,79:84));
title('IMFs energy comparison for i ist X')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,15);

bar(relative_nrg(:,85:90));
title('IMFs energy comparison for i ist Y')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,16);

bar(relative_nrg(:,91:96));
title('IMFs energy comparison for i ist Z')
xlabel('Intrinsic mode functions')
ylabel('Energy')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")


%% Relative Energy ratio comparison

% for i = 1:length(relative_nrg)
%     relative_nrg(:,i) = relative_nrg(:,i)./sum(relative_nrg(:,i));
% end
% 
% subplot(1,3,1);
% 
% bar(relative_nrg(:,1:6));
% title('IMFs energy ratio comparison for A1')
% xlabel('Intrinsic mode functions')
% ylabel('Relative Energy ratio')
% legend("0.75", "1.5", "2", "2.5", "3", "3.5")
% 
% subplot(1,3,2);
% 
% 
% bar(relative_nrg(:,7:12));
% title('IMFs energy ratio comparison for A2')
% xlabel('Intrinsic mode functions')
% ylabel('Relative Energy ratio')
% legend("0.75", "1.5", "2", "2.5", "3", "3.5")
% 
% subplot(1,3,3);
% 
% bar(relative_nrg(:,13:18));
% title('IMFs energy ratio comparison for A3')
% xlabel('Intrinsic mode functions')
% ylabel('Relative Energy ratio')
% legend("0.75", "1.5", "2", "2.5", "3", "3.5")

%% C0 complexity & Power Spectral Entropy algorithm

% subplot(1,3,1);
% 
% gscatter(energy(1,1:6),entropy(1,1:6) ,[0.75, 1.5, 2, 2.5, 3, 3.5]);
% title('C0 complexity and Power Spectral Entropy of sensitive IMF for A1')
% xlabel('C0 complexity')
% ylabel('Power Spectral Entropy')
% 
% subplot(1,3,2);
% 
% gscatter(energy(1,7:12),entropy(1,7:12) ,[0.75, 1.5, 2, 2.5, 3, 3.5]);
% title('C0 complexity and Power Spectral Entropy of sensitive IMF for A2')
% xlabel('C0 complexity')
% ylabel('Power Spectral Entropy')
% 
% subplot(1,3,3);
%  
% gscatter(energy(1,13:18),entropy(1,13:18) ,[0.75, 1.5, 2, 2.5, 3, 3.5]);
% title('C0 complexity and Power Spectral Entropy of sensitive IMF for A3')
% xlabel('C0 complexity')
% ylabel('Power Spectral Entropy')
% 
