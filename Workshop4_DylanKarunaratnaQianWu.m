%% Section A
clear all;close all; clc;
% Q1, 2
load MRI_SectionA_Data;
% Q3
size(MRI_SectionA_Data);
% Q4, 5
figure;
subplot(2,2,1);
mesh(abs(MRI_SectionA_Data(:,:,1)));
xlabel('kx');
ylabel('ky');
zlabel('Magnitude');
title('Spatial Freq Spectrum at echo 1');
subplot(2,2,2);
mesh(abs(MRI_SectionA_Data(:,:,71)));
xlabel('kx');
ylabel('ky');
zlabel('Magnitude');
title('Spatial Freq Spectrum at echo 71');
subplot(2,2,3);
mesh(abs(MRI_SectionA_Data(:,:,141)));
xlabel('kx');
ylabel('ky');
zlabel('Magnitude');
title('Spatial Freq Spectrum at echo 141');
subplot(2,2,4);
mesh(abs(MRI_SectionA_Data(:,:,211)));
xlabel('kx');
ylabel('ky');
zlabel('Magnitude');
title('Spatial Freq Spectrum at echo 211');

% Q6
ReconImages = zeros(size(MRI_SectionA_Data));
for nn = 1:1:256
    ReconImages (:,:,nn) = fftshift(fft2(MRI_SectionA_Data(:,:,nn)));
end;
% Q7
figure;
imagesc(abs(ReconImages(:,:,1)));
colormap gray;
xlabel('x');
ylabel('y');
title('Top View of Vials');
h = images.roi.Rectangle(gca,'Position',[9,5,5,5]);
h = images.roi.Rectangle(gca,'Position',[6,21,5,5]);
h = images.roi.Rectangle(gca,'Position',[23,9,5,5]);
h = images.roi.Rectangle(gca,'Position',[21,24,5,5]);
% Q8
M = abs(ReconImages);
ROI1 = M(5:9,9:13,:);   % Top Left
ROI2 = M(21:25,6:10,:); % Down Left
ROI3 = M(9:13,23:27,:); % Top Right
ROI4 = M(24:28,21:25,:); % Down Right
roi1 = reshape(mean(mean(ROI1)),[1,256]);
roi2 = reshape(mean(mean(ROI2)),[1,256]);
roi3 = reshape(mean(mean(ROI3)),[1,256]);
roi4 = reshape(mean(mean(ROI4)),[1,256]);
tvec = [3.5e-3:3.5e-3:896e-3];
figure
plot(tvec,roi1);
hold on;
plot(tvec,roi2);
hold on;
plot(tvec,roi3);
hold on;
plot(tvec,roi4);
legend('Top Left Vial','Down Left Vial','Top Right Vial','Down Right Vial');
xlabel('Time [s]');
ylabel('Magnitude');
title('Mean ROI Timeseries');

% Q9, 10
T2map = zeros(32,32);
M0map = zeros(32,32);
for i = 1:1:32
    for j = 1:1:32
        datavec = squeeze(M(i,j,:));
        CurrentFit = fit(tvec',datavec,fittype('exp1'));
        M0map(i,j) = CurrentFit.a;
        T2map(i,j) = -1/CurrentFit.b;
    end;
end;
figure;
imagesc(T2map);
colormap gray;
set(gca,'Clim',[0 0.5]);
title('T2 map');
xlabel('x');
ylabel('y');

Mean1 = mean(mean(T2map(5:9,9:13,:)));
Mean2 = mean(mean(T2map(21:25,6:10,:)));
Mean3 = mean(mean(T2map(9:13,23:27,:)));
Mean4 = mean(mean(T2map(24:28,21:25,:)));

%% Section B
clear all;close all; clc;
% Q1, 2
load MRI_SectionB_Data;
t = [3:3:162];
figure;
plot(t,X);
xlabel('Time [s]');
ylabel('X');
title('Time vs Task Timing Information Vector X');

% Q3
Beta = zeros(128,128);
Y = zeros(128,128);
Y_ij = zeros(128,128,54);
for i = 1:1:128
    for j = 1:1:128
        Y = squeeze(LabData(i,j,:));
        Y_ij(i,j,:) = Y;
        Beta(i,j) = (X'*Y)/((X'*X)');
    end
end
% Q4, 5, 6
I = Beta.*MaskBrain;
figure;
imagesc(I);
xlabel('y');
ylabel('x');
title('Map of Estimated Activation Weights');
colormap gray;
colorbar;
