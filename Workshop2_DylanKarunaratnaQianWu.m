% Workshop 2 - Dylan Karunaratna 1079286 Qian Wu 813560
clear all;close all; clc;

%% Section A
% Creating 100x100 Pixel Image With a White Square and Plotting
SquareImg = zeros(100);
SquareImg(40:50,76:86) = 1;
figure;
imagesc(SquareImg);
colormap gray;
axis image;
axis off;
title('Square Image')

% Creating the Sinogram of the Square Image using Radon 
theta = 0:1:179;

[R_square, xp_square] = radon(SquareImg,theta);
figure;
imagesc(xp_square,theta,R_square');
xlabel('Parallel sensor position, r (pixels)');
ylabel('Parallel rotation angle, \theta (degrees)');
colormap gray;
axis image;
title('Square Image Sinogram')

% Backprojection of Square Image
output_size = max(size(SquareImg));
Img_est_square = iradon(R_square,theta,output_size);
figure;
imagesc(Img_est_square);
colormap gray;
axis image;
title('Backprojection of Square Image')

% Unfiltered Backprojection of Square Image 
Img_est_square_unfilter = iradon(R_square,theta,'linear','none',output_size);
figure;
imagesc(Img_est_square_unfilter);
colormap gray;
axis image;
title('Unfiltered Backprojection of Square Image')

% Creating Brain Phantom and Plotting the Image
PhantomImg = phantom(256);
figure;
imagesc(PhantomImg);
colormap gray;
axis image;
title('Phantom Image');

% Plotting Sinogram of Phantom Image using Radon
% Theta = 180
theta = 0:1:179;
[R_square_ph, xp_square_ph] = radon(PhantomImg,theta);
figure;
imagesc(xp_square_ph,theta,R_square_ph');
xlabel('Parallel sensor position, r (pixels)');
ylabel('Parallel rotation angle, \theta (degrees)');
colormap gray;
axis image;
title('Phantom Sinogram');

% Plotting Backprojection of Phantom Image using Radon
output_size_ph = max(size(PhantomImg));
Img_est_square_ph = iradon(R_square_ph,theta,output_size_ph);
figure;
imagesc(Img_est_square_ph);
colormap gray;
axis image;
title('Phantom Backprojection (theta = 180)');

% Theta = 90
theta = 0:1:89;
[R_square_ph, xp_square_ph] = radon(PhantomImg,theta);

output_size_ph = max(size(PhantomImg));
Img_est_square_ph = iradon(R_square_ph,theta,output_size_ph);
figure;
imagesc(Img_est_square_ph);
colormap gray;
axis image;
title('Phantom Backprojection (theta = 90)');

% Theta = 360
theta = 0:1:359;
[R_square_ph, xp_square_ph] = radon(PhantomImg,theta);

output_size_ph = max(size(PhantomImg));
Img_est_square_ph = iradon(R_square_ph,theta,output_size_ph);
figure;
imagesc(Img_est_square_ph);
colormap gray;
axis image;
title('Phantom Backprojection (theta = 360)');

%% Section B
% Sinogram of Phantom Image using Fanbeam
D = 190;
[R_phantom_fan, sensors_fan, theta_fan] = fanbeam(PhantomImg,D);
figure;
imagesc(sensors_fan, theta_fan, R_phantom_fan');
title("Phantom Sinogram (Fanbeam) at default")
xlabel('Fanbeam Sensor Position, r (pixels)');
ylabel('Fanbeam Rotation Angle, \theta (degrees)');
colormap gray;
axis image;

% Backprojection of Phantom Image using Fanbeam
output_size_fan = max(size(PhantomImg));
[Img_est_phantom_fan, H_Ram] = ifanbeam(R_phantom_fan,D,'OutputSize',output_size_fan);
figure;
imagesc(Img_est_phantom_fan);
title("Phantom Backprojection (Fanbeam) at default")
colormap gray;
axis image;

% Changing the Sensor Spacing from 1 to 2 Degrees
[R_phantom_fan1, sensors_fan1, theta_fan1] = fanbeam(PhantomImg,D,'FanSensorSpacing',2);
figure;
imagesc(sensors_fan1, theta_fan1, R_phantom_fan1');
title("Phantom Sinogram (Fanbeam) with SenorSpacing at 2 Degrees")
xlabel('Fanbeam Sensor Position, r (pixels)');
ylabel('Fanbeam Rotation Angle, \theta (degrees)');
colormap gray;
axis image;

% Backprojection with Sensor Spacing at 2 Degrees
output_size_fan = max(size(PhantomImg));
Img_est_phantom_fan = ifanbeam(R_phantom_fan1,D,'FanSensorSpacing',2);
figure;
imagesc(Img_est_phantom_fan);
title("Phantom Backprojection (Fanbeam) with SenorSpacing at 2 Degrees")
colormap gray;
axis image;

% Changing the Sensor Spacing to 0.25 Degrees
[R_phantom_fan2, sensors_fan2, theta_fan2] = fanbeam(PhantomImg,D,'FanSensorSpacing',0.25);
figure;
imagesc(sensors_fan2, theta_fan2, R_phantom_fan2');
title("Phantom Sinogram (Fanbeam) with SenorSpacing at 0.25 Degrees")
xlabel('Fanbeam Sensor Position, r (pixels)');
ylabel('Fanbeam Rotation Angle, \theta (degrees)');
colormap gray;
axis image;

% Backprojection with Sensor Spacing at 0.25 Degrees
output_size_fan = max(size(PhantomImg));
Img_est_phantom_fan = ifanbeam(R_phantom_fan2,D,'FanSensorSpacing',0.25);
figure;
imagesc(Img_est_phantom_fan);
title("Phantom Backprojection (Fanbeam) with SenorSpacing at 0.25 Degrees")
colormap gray;
axis image;

% Changing Fan Projection Angle Space to 5 Degrees
[R_phantom_fan3, sensors_fan3, theta_fan3] = fanbeam(PhantomImg,D,'FanRotationIncrement',5);
output_size_fan = max(size(PhantomImg));
Img_est_phantom_fan = ifanbeam(R_phantom_fan3,D,'FanRotationIncrement',5);
figure;
imagesc(Img_est_phantom_fan);
title("Phantom Backprojection (Fanbeam) with RotationIncrement of 5 Degrees")
colormap gray;
axis image;

% Zooming Into Reconstructed Images (Ram-Lak)
figure;
imagesc(Img_est_phantom_fan(50:200,1:50));
title("Phantom Backprojection (Fanbeam) with Ram-Lak (Zoomed)")
colormap gray;
axis image;

% Changing Filter from Ram-Lak to Hamming 
[R_phantom_fan4, sensors_fan4, theta_fan4] = fanbeam(PhantomImg,D);
output_size_fan = max(size(PhantomImg));
[Img_est_phantom_fan, H_hamming] = ifanbeam(R_phantom_fan4,D,'Filter','Hamming');
figure;
imagesc(Img_est_phantom_fan);
title("Phantom Backprojection (Fanbeam) with Hamming")
colormap gray;
axis image;

% Zooming Into Reconstructed Images (Hamming)
figure;
imagesc(Img_est_phantom_fan(50:200,1:50));
title("Phantom Backprojection (Fanbeam) with Hamming (Zoomed)")
colormap gray;
axis image;

% Frequency response of Ram-Lak filter
x1=(0:1/(length(H_Ram)-1):1);
figure;
plot(x1,H_Ram);
title("Frequency Response of Ram-Lak filter")
xlabel('Normalized Frequency');
ylabel('Amplitude');

% Frequency Response of Hamming Filter
x2=(0:1/(length(H_hamming)-1):1);
figure;
plot(x2,H_hamming);
title("Frequency Response of Hamming Filter")
xlabel('Normalized Frequency');
ylabel('Amplitude');

%% Section C
% Plotting the Sinogram for the Original Square Image Between 0 and 90
% Degrees with a 1 Degree Increment 
SquareImg = zeros(100);
SquareImg(40:50,76:86) = 1;

theta = 0:1:89;

[R1, xp1] = radon(SquareImg,theta);
figure;
imagesc(xp1,theta,R1');
title('Sinogram of Original Square Image Between 0 and 90 Degrees')
xlabel('Parallel sensor position, r (pixels)');
ylabel('Parallel rotation angle, \theta (degrees)');
colormap gray;
axis image;

% Plotting the Sinogram for the Translated Square Image Between 91 and 179
% Degrees with a 1 Degree Increment 
SquareImg = zeros(100);
SquareImg(41:51,75:85) = 1;

theta = 90:1:179;

[R2, xp2] = radon(SquareImg,theta);
figure;
imagesc(xp2,theta,R2');
title("Sinogram of Translated Square Image Between 91 and 179 Degrees")
xlabel('Parallel sensor position, r (pixels)');
ylabel('Parallel rotation angle, \theta (degrees)');
colormap gray;
axis image;

% Plotting the Combined Sinogram
R_combined = [R1 R2];
figure;
imagesc(xp1, theta, R_combined');
title("Combined Sinogram")
xlabel('Parallel sensor position, r (pixels)');
ylabel('Parallel rotation angle, \theta (degrees)');
colormap gray;
axis image;

% Plotting the Backprojection of the Combined Sinogram 
output_size = max(size(SquareImg));
theta = 0:1:179;
Img_est_square = iradon(R_combined,theta,output_size);
figure;
imagesc(Img_est_square);
title("Backprojection of Combined Sinogram")
colormap gray;
axis image;

%% Section D
% Plotting a Noisy Sinogram of the Original Square Image that Simulates
% Poisson Noise in X-Ray Production
SquareImg = zeros(100);
SquareImg(40:50,76:86) = 1;

NoiseSquareImg = poissrnd(SquareImg);
theta = 0:1:179;
[R_noisysquare,xp_square] = radon(NoiseSquareImg,theta);
figure;
imagesc(xp_square,theta,R_noisysquare');
title('Noisy Sinogram that Simulates Poisson Noise in X-Ray Production')
xlabel('Parallel sensor position, r (pixels)');
ylabel('Parallel rotation angle, \theta (degrees)');
colormap gray;
axis image;

% Reconstruction or Backprojection of the Noisy Square Image Sinogram
output_size = max(size(SquareImg));
Img_est_noisysquare = iradon(R_noisysquare,theta);
figure;
imagesc(Img_est_noisysquare);
title("Backprojection of Noisy Square Image Sinogram")
colormap gray;
axis image;

% Displaying the Backprojection on a Log Scale to See Artifact
Img_est_noisysquare = log( Img_est_noisysquare - min(min(Img_est_noisysquare)));
figure;
imagesc(Img_est_noisysquare);
title("Backprojection of Noisy Square Image Sinogram (Log Scale)")
colormap gray;
axis image;