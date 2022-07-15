%% Decomposition

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];
xdec = [];
bookkeeping = [];
energy = [];

for acc = 1:3
    for ap = 1:6

data = importdata(strcat('../RAW_data/Montronix/QUALITY_Vc250_F910_ap',aps(ap),'_cleaned.csv'));
  
data2=data.data(:,2+acc)-mean(data.data(:,2+acc));

[wpt,l,packetlevels,f,re] = dwpt(data2, 'db10', 'Level', 4);

xdec = [xdec, wpt];
bookkeeping = [bookkeeping, l];
energy = [energy, re];

    end 
end

energy = cell2mat(energy);

figure 

subplot(1,3,1);

bar(energy(:,1:6));
title('Wavelet packet energy ratio comparison for A1')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(1,3,2);


bar(energy(:,7:12));
title('Wavelet packet energy ratio comparison for A2')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

subplot(1,3,3);

bar(energy(:,13:18));
title('Wavelet packet energy ratio comparison for A3')
xlabel('Wavelet packet')
ylabel('Energy ratio')
legend("0.75", "1.5", "2", "2.5", "3", "3.5")

%saveas("WPT.png")

%% Reconstution

sig_rec = {};
j = 0;

for acc = 1:3
    for ap = 1:6

xdec2 = {xdec{1,12+16*j}, xdec{1,13+16*j}};
j = j + 1;
xrec = idwpt(xdec2,bookkeeping([1,5],j));
writematrix(xrec,strcat("WPT_reconstruction", accs(acc), "_", aps(ap), ".csv"))

    end 
end
