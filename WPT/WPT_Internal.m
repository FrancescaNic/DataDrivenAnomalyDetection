%% Decomposition

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
xdec = [];
bookkeeping = [];
energy = [];

for acc = 1:16
    for ap = 1:6

data = importdata(strcat('../RAW_data/TNCScope/Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv'));
  
data2=data.data(:,2+acc)-mean(data.data(:,2+acc));

[wpt,l,packetlevels,f,re] = dwpt(data2, 'db10', 'Level', 4);

xdec = [xdec, wpt];
bookkeeping = [bookkeeping, l];
energy = [energy, re];

    end 
end

energy = cell2mat(energy);

figure 

subplot(4,4,1);

bar(energy(:,1:6));
title('Wavelet packet energy ratio comparison for s actual X')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,2);


bar(energy(:,7:12));
title('Wavelet packet energy ratio comparison for s actual Y')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,3);

bar(energy(:,13:18));
title('Wavelet packet energy ratio comparison for s actual Z')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,4);

bar(energy(:,19:24));
title('Wavelet packet energy ratio comparison for s dif X')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,5);


bar(energy(:,25:30));
title('Wavelet packet energy ratio comparison for s dif Y')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,6);

bar(energy(:,31:36));
title('Wavelet packet energy ratio comparison for s dif Z')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,7);

bar(energy(:,37:42));
title('Wavelet packet energy ratio comparison for v act. X')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,8);


bar(energy(:,43:48));
title('Wavelet packet energy ratio comparison for v act. Y')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,9);

bar(energy(:,49:54));
title('Wavelet packet energy ratio comparison for v act. Z')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,10);

bar(energy(:,55:60));
title('Wavelet packet energy ratio comparison for v act. S1')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,11);


bar(energy(:,61:66));
title('Wavelet packet energy ratio comparison for IW SDM arms I 0 1 g')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,12);

bar(energy(:,67:72));
title('Wavelet packet energy ratio comparison for IW SDM arms J 0 1 g')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,13);

bar(energy(:,73:78));
title('Wavelet packet energy ratio comparison for I N int S1')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,14);

bar(energy(:,79:84));
title('Wavelet packet energy ratio comparison for i ist X')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,15);


bar(energy(:,85:90));
title('Wavelet packet energy ratio comparison for i ist Y')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(4,4,16);

bar(energy(:,91:96));
title('Wavelet packet energy ratio comparison for i ist Z')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

%saveas("WPT.png")

%% Reconstution

% sig_rec = {};
% j = 0;
% 
% for acc = 1:3
%     for ap = 1:6
% 
% xdec2 = {xdec{1,12+16*j}, xdec{1,13+16*j}};
% j = j + 1;
% xrec = idwpt(xdec2,bookkeeping([1,5],j));
% writematrix(xrec,strcat("WPT_reconstruction", accs(acc), "_", aps(ap), ".csv"))
% 
%     end 
% end
