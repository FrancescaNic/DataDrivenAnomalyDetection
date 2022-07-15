%% Load Data

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];
energy = [];
entropy = [];
relative_nrg = [];

for acc = 1:3
    for ap = 1:6

data = importdata(strcat('../RAW_data/Montronix/QUALITY_Vc250_F910_ap',aps(ap),'_cleaned.csv'));
  
y=data.data(:,2+acc);

%% Bandpass Filter

% Eliminate Frequencies that are not chatter characteristic

T = data.data(2,2)-data.data(1,2);             % Sampling period 
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

% subplot(1,3,1);
% 
% bar(relative_nrg(:,1:6));
% title('IMFs energy comparison for A1')
% xlabel('Intrinsic mode functions')
% ylabel('Energy')
% legend("0.75", "1.5", "2", "2.5", "3", "3.5")
% 
% subplot(1,3,2);
% 
% 
% bar(relative_nrg(:,7:12));
% title('IMFs energy comparison for A2')
% xlabel('Intrinsic mode functions')
% ylabel('Energy')
% legend("0.75", "1.5", "2", "2.5", "3", "3.5")
% 
% subplot(1,3,3);
% 
% bar(relative_nrg(:,13:18));
% title('IMFs energy comparison for A3')
% xlabel('Intrinsic mode functions')
% ylabel('Energy')
% legend("0.75", "1.5", "2", "2.5", "3", "3.5")

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

subplot(1,3,1);

gscatter(energy(1,1:6),entropy(1,1:6) ,[0.75, 1.5, 2, 2.5, 3, 3.5]);
title('C0 complexity and Power Spectral Entropy of sensitive IMF for A1')
xlabel('C0 complexity')
ylabel('Power Spectral Entropy')

subplot(1,3,2);

gscatter(energy(1,7:12),entropy(1,7:12) ,[0.75, 1.5, 2, 2.5, 3, 3.5]);
title('C0 complexity and Power Spectral Entropy of sensitive IMF for A2')
xlabel('C0 complexity')
ylabel('Power Spectral Entropy')

subplot(1,3,3);
 
gscatter(energy(1,13:18),entropy(1,13:18) ,[0.75, 1.5, 2, 2.5, 3, 3.5]);
title('C0 complexity and Power Spectral Entropy of sensitive IMF for A3')
xlabel('C0 complexity')
ylabel('Power Spectral Entropy')

