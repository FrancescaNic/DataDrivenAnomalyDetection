%% FFT of WPT reconstruced signal

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];

T = 3.085470000003809e-04;             % Sampling period 
Fs = 1/T;            % Sampling frequency                          


for ap = 1:6
for acc = 1:3
data = importdata(strcat("WPT_reconstruction", accs(acc), "_", aps(ap), ".csv"));

L = length(data);             % Length of signal
t = (0:L-1)*T;        % Time vector

data2=data-mean(data);
Y = fft(data2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

fig = plot(f,P1);
title(strcat('Single-Sided Amplitude Spectrum of WPT reconstructed acceleration data ', accs(acc), ' of ap = ', aps(ap)))
xlabel('Frequency [Hz]')
ylabel('Amplitude')
saveas(fig,strcat("FFT_WPT_reconstruction", accs(acc), "_", aps(ap), ".png"))
    end 
end 

