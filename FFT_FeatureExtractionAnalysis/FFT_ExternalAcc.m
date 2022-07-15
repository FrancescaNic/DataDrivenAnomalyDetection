aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];

for ap = 1:6

data = importdata(strcat('../RAW_data/Montronix/QUALITY_Vc250_F910_ap',aps(ap),'_cleaned.csv'));

T = data.data(2,2)-data.data(1,2);             % Sampling period 
Fs = 1/T;            % Sampling frequency                          
L = length(data.data);             % Length of signal
t = (0:L-1)*T;        % Time vector

    for acc = 1:3
data2=data.data(:,2+acc)-mean(data.data(:,2+acc));
Y = fft(data2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;


fig = plot(f,P1);
title(strcat('Single-Sided Amplitude Spectrum of acceleration data ', accs(acc), ' of ap = ', aps(ap)))
xlabel('Frequency [Hz]')
ylabel('Amplitude')
saveas(fig,strcat("FFT_", accs(acc), "_", aps(ap), ".png"))
    end 
end 