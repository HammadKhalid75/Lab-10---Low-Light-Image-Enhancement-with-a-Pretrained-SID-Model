%% Low-Light Enhancement - Fixed & Optimized for Your Dark Image
clear; clc; close all;

%% 1) Download pretrained model (only once)
dataDir = fullfile(tempdir, "Sony2025");
if ~exist(dataDir, "dir"), mkdir(dataDir); end
modelFile = fullfile(dataDir, "trainedLowLightCameraPipelineNet.mat");

if ~isfile(modelFile)
    fprintf("Downloading pretrained model (~60 MB)...\n");
    modelURL = "https://ssd.mathworks.com/supportfiles/vision/data/trainedLowLightCameraPipelineDlnetwork.zip";
    zipFile = fullfile(dataDir, "trainedLowLightCameraPipelineDlnetwork.zip");
    websave(zipFile, modelURL);
    unzip(zipFile, dataDir);
    fprintf("Download complete!\n");
end

%% 2) Load network
load(modelFile, "netTrained");

%% 3) Read your real dark image (already very dark!)
I_original = imread("Example_03.png");
I = im2single(imresize(I_original, [512 512]));

%% 4) NO extra darkening needed! Just add realistic sensor noise
I_dark_noisy = imnoise(I, "gaussian", 0, 0.0005);  % Very little added noise

%% 5) Create 4-channel fake RAW input (trick from the original paper)
I_gray = rgb2gray(I_dark_noisy);
rawFake = repmat(I_gray, 1, 1, 4);

%% 6) Prepare for network
input = dlarray(rawFake, "SSCB");
if canUseGPU, input = gpuArray(input); end

%% 7) Run the "Learning to See in the Dark" network
out = predict(netTrained, input);

%% 8) Extract result
out = gather(extractdata(out));
out = squeeze(out);
out = im2uint8(out);  % Now it's a proper RGB uint8 image

%% 9) MY IMPROVEMENT: Proper post-processing (no imadjust error!)
% Correct way to increase contrast on RGB images:
out_enhanced = imlocalbrighten(out);                    % Modern MATLAB function
out_enhanced = imsharpen(out_enhanced, 'Radius', 1.5, 'Amount', 1.2);
out_enhanced = histeq(out_enhanced);                    % Gentle histogram equalization

%% 10) Display everything
figure('Position', [100, 100, 1600, 400]);
subplot(1,4,1); imshow(I_original);      title('Your Original (very dark)');
subplot(1,4,2); imshow(I_dark_noisy);     title('Input to Network (with light noise)');
subplot(1,4,3); imshow(out);              title('Raw Network Output');
subplot(1,4,4); imshow(out_enhanced);     title('FINAL ENHANCED (Best Result)');

%% Save result
imwrite(out_enhanced, 'enhanced_result.png');
fprintf('Enhanced image saved as: enhanced_result.png\n');