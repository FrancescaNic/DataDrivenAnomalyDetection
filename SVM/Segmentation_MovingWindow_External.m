%% Segmentation and Moving window

% Load data

aps = ["0.75", "1.5", "2", "2.5", "3", "3.5"];
accs = ["A1", "A2", "A3"];

for ap = 1:6

signal_name = strcat('QUALITY_Vc250_F910_ap',aps(ap),'_cleaned');

data = importdata(strcat('../RAW_data/Montronix/QUALITY_Vc250_F910_ap',aps(ap),'_cleaned.csv'));
  
y1 = data.data(:,3);
y2 = data.data(:,4);
y3 = data.data(:,5);

y = [y1, y2, y3];

segments = 15;

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

        writematrix(y_new,strcat("Data_External/segmented_signal_", signal_name, "_seg_",string(i),".csv"));
end

    end 

