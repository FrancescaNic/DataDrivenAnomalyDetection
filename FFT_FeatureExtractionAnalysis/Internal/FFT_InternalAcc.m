aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = categorical({'s_actual_X','s_actual_Y','s_actual_Z','s_dif_X','s_dif_Y','s_dif_Z','v_act._X','v_act._Y','v_act._Z','v_act._S1','IW_SDM_arms_I_0_1_g','IW_SDM_arms_J_0_1_g','I_N_int_S1','i_ist_X','i_ist_Y','i_ist_Z'});
accs_names = categorical({'s actual X','s actual Y','s actual Z','s dif X','s dif Y','s dif Z','v act. X','v act. Y','v act. Z','v act. S1','IW SDM arms I 0 1 g','IW SDM arms J 0 1 g','I N int S1','i ist X','i ist Y','i ist Z'});

for ap = 1:6

data = importdata(strcat('../../RAW_data/TNCScope/Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv'));

T = (data.data(2,2)-data.data(1,2))*0.000001;             % Sampling period 
Fs = 1/T;            % Sampling frequency                          
L = length(data.data);             % Length of signal
t = (0:L-1)*T;        % Time vector

    for acc = 3:18
data2=(data.data(:,acc)-mean(data.data(:,acc)))*0.000001;
Y = fft(data2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;


fig = plot(f,P1);
title(strcat('Single-Sided Amplitude Spectrum of acceleration data ', string(accs_names(acc-2)), ' of ap = ', aps(ap)))
xlabel('Frequency [Hz]')
ylabel('Amplitude')
saveas(fig,strcat("FFT_", string(accs(acc-2)), "_", aps(ap), ".png"))
    end 
end 