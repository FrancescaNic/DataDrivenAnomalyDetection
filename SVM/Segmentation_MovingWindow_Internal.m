%% Segmentation and Moving window

% Load data

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];

for ap = 1:6

signal_name = strcat('Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv');

data = importdata(strcat('../RAW_data/TNCScope/Vc250_F910_ae100_ap',aps(ap),'_cleaned.csv'));
  
y1 = data.data(:,3);
y2 = data.data(:,4);
y3 = data.data(:,5);
y4 = data.data(:,6);
y5 = data.data(:,7);
y6 = data.data(:,8);
y7 = data.data(:,9);
y8 = data.data(:,10);
y9 = data.data(:,11);
y10 = data.data(:,13);
y11 = data.data(:,14);
y12 = data.data(:,15);
y13 = data.data(:,16);
y14 = data.data(:,18);

y = [y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14];

segments = 20;

l = length(y);
l_segment = fix(length(y)/segments); 

for i = 1:segments
        sig_beg = 1+(i-1)*l_segment;
        sig_end = i*l_segment;

        if sig_end > l
            y_new = y(sig_beg:l,:);
        else
            y_new = y(sig_beg:sig_end,:);
        end

        writematrix(y_new,strcat("Data_Internal/segmented_signal_", signal_name, "_seg_",string(i),".csv"));
end
end 

