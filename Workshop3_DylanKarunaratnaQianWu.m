%% Part A
clear all;close all; clc;
% Parameters
f0 = 5*10^6;
fs = 100*10^6;
c = 1540;
% Wavelength
lamda = c/f0;
% Axial Resolution
deltaX = 0.5*(c/f0);
% Reading RF-line data and determining length 
load US_Lab_SectionA_RF_Data;
MLength = length(rf_line_A);
% Relationship
deltaT = 1/(2*fs);
t = deltaT * (MLength-1);
depth = t * c;
% Displaying RF-line A
deltaD = depth/MLength;
z = [0:deltaD:depth-deltaD];
figure;
plot(z,rf_line_A);
xlabel('Penetration Depth [m]');
ylabel('Amplitude');
title('Radio Frequency (RF) Line - A Mode');
% Displaying RF-line Ae
rf_line_A_e = abs(hilbert(rf_line_A));
figure;
plot(z,rf_line_A_e);
xlabel('Penetration Depth [m]');
ylabel('Amplitude');
title('Radio Frequency (RF) Line - Envelope Detection');
% Combining radio frequency plot with envelope detection plot
figure;
plot(z,rf_line_A,z,rf_line_A_e);
xlabel('Penetration Depth [m]');
ylabel('Amplitude');
legend('AMode','EnvelopeDetection','Location','NorthEast');
title('Radio Frequency (RF) Line - Together');


%% Part B
clear all;close all; clc;
% Parameters
f0 = 3.5*10^6;
fs = 100*10^6;
c = 1540;
n_active = 64;
focus = 0.07;
n_RF = 50;
n_scatter = 100000;
% Displaying Lines 1 10 25 and 40
ln1 = cell2mat(struct2cell(load('rf_data_B/rf_ln1','rf_data')));
ln10 = cell2mat(struct2cell(load('rf_data_B/rf_ln10','rf_data')));
ln25 = cell2mat(struct2cell(load('rf_data_B/rf_ln25','rf_data')));
ln40 = cell2mat(struct2cell(load('rf_data_B/rf_ln40','rf_data')));

depth1 = ((1/fs) * (length(ln1)-1)) * c;
depth10 = ((1/fs) * (length(ln10)-1)) * c;
depth25 = ((1/fs) * (length(ln25)-1)) * c;
depth40 = ((1/fs) * (length(ln40)-1)) * c;
deltaD1 = depth1/length(ln1);
deltaD35 = depth10/length(ln10);
deltaD25 = depth25/length(ln25);
deltaD40 = depth40/length(ln40);
z1 = [0 : deltaD1 : depth1-deltaD1];
z10 = [0 : deltaD35 : depth10-deltaD35];
z25 = [0 : deltaD25 : depth25-deltaD25];
z40 = [0 : deltaD40 : depth40-deltaD40];

figure;
subplot(4,1,1); plot(z1,ln1);
title('Line 1');
subplot(4,1,2); plot(z10,ln10);
title('Line 10');
subplot(4,1,3); plot(z25,ln25);
title('Line 25');
subplot(4,1,4); plot(z40,ln40);
title('Line 40');

% Displaying Line 15 and 35
ln15 = cell2mat(struct2cell(load('rf_data_B/rf_ln15','rf_data')));
ln35 = cell2mat(struct2cell(load('rf_data_B/rf_ln35','rf_data')));
depth15 = ((1/fs) * (length(ln15)-1)) * c;
depth35 = ((1/fs) * (length(ln35)-1)) * c;
deltaD15 = depth15/length(ln15);
deltaD35 = depth35/length(ln35);
z15 = [0 : deltaD15 : depth15-deltaD15];
z35 = [0 : deltaD35 : depth35-deltaD35];
figure;
subplot(2,1,1); plot(z15,ln15);
title('Line 15');
subplot(2,1,2); plot(z35,ln35);
title('Line 35');

% Generating rf_data_z for each line of data
demRF_Mx = [];
for i = 1:50;
    RFLine = ['load rf_data_B/rf_ln',num2str(i),'.mat'];
    eval(RFLine);
    rf_data_z = [zeros(fix(tstart*fs),1); rf_data];
    RF_Env = abs(hilbert(rf_data_z));
    demRF_Mx (1:length(RF_Env), i) = RF_Env; 
end;

% Finding dimension 
Dimension = size(demRF_Mx);
D = 10;
demRF_Mx_D = demRF_Mx (1:D:max(size(demRF_Mx)), :); 

% Finding max value of matrix
M = max(max(demRF_Mx_D));
demRF_Mx_D_N = demRF_Mx_D./M;

% Finding the values of the normalised matrix
p1 = demRF_Mx_D_N(850,40);
p2 = demRF_Mx_D_N(10,10);
ratio = p1/p2;

% Log compression
log_demRF_Mx_D_N = log10(demRF_Mx_D_N+.001);

% Log compression with substraction 
m = min(min(log_demRF_Mx_D_N));
log_demRF_Mx_D_N_S = log_demRF_Mx_D_N - m;

% Interpolation
RSR = 20;
[n,m] = size(log_demRF_Mx_D_N_S);
Phantom = zeros(n,m*RSR);
for i = 1:n
    Phantom(i,:) = abs(interp(log_demRF_Mx_D_N_S(i,:),RSR));
end

% Displaying the Phantom
X = (Dimension(1))*(1/(2*fs))*c*1000;
figure;
imagesc([-20 20],[0 X],Phantom);
set(gca, 'YDir','reverse');
colormap gray;
xlabel("Width [mm]");
ylabel('Length [mm]');
title('Reconstructed Phantom Image');

% Displaying appropriate region
axis image;
axis([-20 20 35 90]);

% Removing logarithmic compression
demRF_Mx = [];
for i = 1:50;
    RFLine = ['load rf_data_B/rf_ln',num2str(i),'.mat'];
    eval(RFLine);
    rf_data_z = [zeros(fix(tstart*fs),1); rf_data];
    RF_Env = abs(hilbert(rf_data_z));
    demRF_Mx (1:length(RF_Env), i) = RF_Env; 
end;

% D value
D = 10;
demRF_Mx_D = demRF_Mx (1:D:max(size(demRF_Mx)), :); 
M = max(max(demRF_Mx_D));
demRF_Mx_D_N = demRF_Mx_D./M;

% Substraction
demRF_Mx_D_N = demRF_Mx_D_N - min(min(demRF_Mx_D_N));

% Interpolation
RSR = 20;
[n,m] = size(demRF_Mx_D_N);
Phantom = zeros(n,m*RSR);
for i = 1:n
    Phantom(i,:) = abs(interp(demRF_Mx_D_N(i,:),RSR));
end
X = (max(size(demRF_Mx))-1)*(1/(2*fs))*c*1000;
figure;
x=[-20 20];
y=[0:1:X];
imagesc(x,y,Phantom);
colormap gray;
xlabel("Width [mm]");
ylabel('Length [mm]');
title('Reconstructed Phantom Image (Without Log)');
axis image;
axis([-20 20 35 90]);

% Removing Interpolation
demRF_Mx = [];
for i = 1:50;
    RFLine = ['load rf_data_B/rf_ln',num2str(i),'.mat'];
    eval(RFLine);
    rf_data_z = [zeros(fix(tstart*fs),1); rf_data];
    RF_Env = abs(hilbert(rf_data_z));
    demRF_Mx (1:length(RF_Env), i) = RF_Env; 
end;

% D value
D = 10;
demRF_Mx_D = demRF_Mx (1:D:max(size(demRF_Mx)), :); 
M = max(demRF_Mx_D,[],'all');
demRF_Mx_D_N = demRF_Mx_D./M;
% Log compression
log_demRF_Mx_D_N = log10(demRF_Mx_D_N+.001);
m = min(min(log_demRF_Mx_D_N));
log_demRF_Mx_D_N_S = log_demRF_Mx_D_N - m;

X = (max(size(demRF_Mx))-1)*(1/(2*fs))*c*1000;
figure;
x=[-20 20];
y=[0:1:X];
imagesc(x,y,log_demRF_Mx_D_N_S);
colormap gray;
xlabel("Width [mm]");
ylabel('Length [mm]');
title('Reconstructed Phantom Image (Without IP)');
axis image;
axis([-20 20 35 90]);

%% Part C
clear all;close all; clc;
% Parameters
f0 = 5*10^6;
fs = 100*10^6;
c = 1540;
n_active = 64;
focus = 0.07;
n_RF = 128;
n_scatter = 50000;
% Generating rf_data_z for each line of data
demRF_Mx = [];
for i = 1:128;
    RFLine = ['load rf_data_C/rf_ln',num2str(i),'.mat'];
    eval(RFLine);
    rf_data_z = [zeros(fix(tstart*fs),1); rf_data];
    RF_Env = abs(hilbert(rf_data_z));
    demRF_Mx (1:length(RF_Env), i) = RF_Env; 
end;
% D value
D = 20;
demRF_Mx_D = demRF_Mx (1:D:max(size(demRF_Mx)), :); 
M = max(demRF_Mx_D,[],'all');
demRF_Mx_D_N = demRF_Mx_D./M;
% Log compression
log_demRF_Mx_D_N = log10(demRF_Mx_D_N+.001);
m = min(min(log_demRF_Mx_D_N));
log_demRF_Mx_D_N_S = log_demRF_Mx_D_N - m;
% RSR 
RSR = 10;
[n,m] = size(log_demRF_Mx_D_N_S);
Phantom = zeros(n,m*RSR);
for i = 1:n
    Phantom(i,:) = abs(interp(log_demRF_Mx_D_N_S(i,:),RSR));
end
% Plotting the image
X = (max(size(demRF_Mx))-1)*(1/(2*fs))*c*1000;
figure;
x=[-120 120];
y=[0:1:X];
imagesc(x,y,log_demRF_Mx_D_N_S);
colormap gray;
xlabel("Width [mm]");
ylabel('Length [mm]');
title('Reconstructed Image for Phased Array Imaging');
axis image;
axis([-120 120 0 X]);