% Workshop 1 - Dylan Karunaratna 1079286 and Qian Wu 813560
clear all; close all; clc

%% Section A 

% Design and display the initials "Q & W" 
ImgA = zeros(50,80);

% Printing letter Q
ImgA(10:40,10:15) = 1;
ImgA(10:15,15:30) = 1;
ImgA(35:40,15:30) = 1;
ImgA(15:35,25:30) = 1;
ImgA(35:40,30:34) = 1;

% Printing letter W
ImgA(10:40,40:45) = 1;
ImgA(10:40,65:70) = 1;
ImgA(10:40,52.5:57) = 1;
ImgA(35:40,40:70) = 1;

figure;
imagesc(ImgA);
colormap gray;
axis image; axis off
title('Original Image, Section A');

% Applying sobel filter and display
fSx = [-1 0 1; -2 0 2; -1 0 1];
fSy = [1 2 1; 0 0 0; -1 -2 -1];
SobXEdges = conv2(ImgA,fSx,'same');
SobYEdges = conv2(ImgA,fSy,'same');

figure;
imagesc(SobXEdges);
colormap gray;
axis image; axis off;
title('Sobel Filtered at X-axis, Section A');
figure;
imagesc(SobYEdges);
colormap gray;
axis image; axis off;
title('Sobel Filtered at Y-axis, Section A');

SobelMagEdges = sqrt(SobXEdges.^2 + SobYEdges.^2);
SobelLetterEdges = (SobelMagEdges >= 1);
figure;
imagesc(SobelLetterEdges);
colormap gray;
axis image; axis off;
title('Sobel Filtered Image, Section A');

% Edge Function 
Edged = edge(ImgA,'sobel');
figure;
imagesc(Edged);
colormap gray;
axis image; axis off;
title('Sobel Filtered Image with edge function, Section A');

%% Section B 

% Read the original image and display
ImgB = imread('NoisyBrainMRI.jpg');
figure;
imagesc(ImgB);
colormap gray;
axis image; axis off;
title('Original Image, Section B');

% Change data type from unit 8 to double
ImgB= double(ImgB);

% Create the Gaussian filter
G = fspecial('gaussian',5,2);

% Filter the image and display
SmoothB = conv2(ImgB,G,'same');
figure;
imagesc(SmoothB);
colormap gray;
axis image; axis off;
title('Smoothed Image, Section B');

% Downsampling the Original Image and display
DownsampB = ImgB(1:10:end,1:10:end);
figure;
imagesc(DownsampB);
colormap gray;
axis image; axis off;
title('Downsampled Original Image, Section B');

% Downsampling the Smoothed Image and display
DownsampB0 = SmoothB(1:10:end,1:10:end);
figure;
imagesc(DownsampB0);
colormap gray;
axis image; axis off;
title('Downsampled Smooth Image, Section B');

%% Section C 

% Read and display the original image
ImgC = load('Kiwi.mat');
ImgC = ImgC.Kiwi;
figure;
imagesc(ImgC);
colormap gray;
axis image; axis off;
title('Original Image, Section C');

% Create the Gaussian filter
g = fspecial('gaussian',3,1);

% Smooth the image and display
SmoothC = conv2(ImgC,g,'same');
figure;
imagesc(SmoothC);
colormap gray;
axis image; axis off;
title('Smoothed Image, Section C');

% Applying unsharp masking with alpha = 0.5 and display
MaskedC = (ImgC-SmoothC)*0.5+ImgC;
figure;
imagesc(MaskedC);
colormap gray;
axis image; axis off;
title('Masked Image, alpha = 0.5, Section C');

% Applying unsharp masking with alpha = 2 and displaying with coloured
% boxes
MaskedC = (ImgC-SmoothC)*0.5+ImgC;
figure;
imagesc(MaskedC);
colormap gray;
axis image; axis off;
title('Masked Image, alpha = 0.5, Coloured Boxes Section C');
h = images.roi.Rectangle(gca,'Position',[40,25,40,35]);
h = images.roi.Rectangle(gca,'Position',[5,5,25,10]);

% Applying unsharp masking with alpha = 2
MaskedC0 = (ImgC-SmoothC)*2+ImgC;
figure;
imagesc(MaskedC0);
colormap gray;
axis image; axis off;
title('Masked Image, alpha = 2, Section C');

% Calculate Signal-Noise-Ratio for all situations
Area1 = ImgC(25:60,40:80);
A1=mean(mean(Area1));
noise1=ImgC(5:15,5:30);
sigma1=std(noise1,0,'all');
SNR1=A1/sigma1

Area2 = SmoothC(25:60,40:80);
A2=mean(mean(Area2));
noise2=SmoothC(5:15,5:30);
sigma2=std(noise2,0,'all');
SNR2=A2/sigma2

Area3 = MaskedC(25:60,40:80);
A3=mean(mean(Area3));
noise3=MaskedC(5:15,5:30);
sigma3=std(noise3,0,'all');
SNR3=A3/sigma3

Area4 = MaskedC0(25:60,40:80);
A4=mean(mean(Area4));
noise4=MaskedC0(5:15,5:30);
sigma4=std(noise4,0,'all');
SNR4=A4/sigma4

%% Section D

% Grayscale the image and display
ImgD = imread('Texture.jpg');
GreyD = mean(ImgD,3);
figure;
imagesc(GreyD);
colormap gray;
axis image; axis off;
title('Greyscaled Image, Section D');

% 2D fast fourier analysis
FT = fft2(GreyD);
FTImg = log(fftshift(abs(FT)));
figure;
imagesc(FTImg);
colormap gray;
axis image; axis off
title('Magnitude Spectrum, Section D');

% Zoom In 
figure
imagesc(FTImg);
colormap gray;
axis image;
axis([610 810 365 565])
axis off;
title('Zoomed In Magnitude Spectrum, Section D');

% Smoothing 
f = ones(1,30)/30;
smoothD = conv2(GreyD, f,'same');
figure
imagesc(smoothD);
colormap gray;
axis image;
title('Smoothed Image, Section D');

% FFT analysis for smoothed picture
FT1 = fft2(smoothD);
FTImg1 = log(fftshift(abs(FT1)));

figure;
imagesc(FTImg1);
colormap gray;
axis image;
axis off
title('Magnitude Spectrum of Smoothed Picture, Section D');

figure
imagesc(FTImg1);
colormap gray;
axis image;
axis([610 810 365 565])
axis off;
title('Zoomed In Magnitude Spectrum of Smoothed Picture, Section D');
