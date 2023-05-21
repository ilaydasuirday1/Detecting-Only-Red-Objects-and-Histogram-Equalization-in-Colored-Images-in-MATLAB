fig = figure;
fig.Position = [1 100 900 500];
fig.Name = "Red Highlight";


I = imread('roses.jpg');

subplot(2,2,1)
imshow(I),
title('Original image');

subplot(2,2,2)
A = redHighlight(I);
imshow(A);
title('Red Highlighted Image');


fig2 = figure;
fig2.Position = [1001 100 900 500];
fig2.Name = "Histogram Equalization";

F = imread('deneme.png');

subplot(2,3,1)
imshow(F);
title('Original Image');

subplot(2,3,2)
A = histogramequalizationYIQ(F);
imshow(A);
title('Manually Equalized');

subplot(2,3,3)
B = histeq(F);
imshow(B);
title('Equalized with histeq method');

subplot(2,3,4)
imhist(F,64)
title('Original Image Histogram');

subplot(2,3,5)
imhist(A,64)
title('Manually Equalized Histogram');

subplot(2,3,6)
imhist(B,64)
title('Equalized with histeq method Histogram');


function A = redHighlight(I)

% Convert the image to the HSV color space
hsvImage = rgb2hsv(I);

% Extract the hue channel
hueChannel = hsvImage(:,:,1);
satChannel = hsvImage(:,:,2);
valChannel = hsvImage(:,:,3);

redMask = (hueChannel >= 0.95 | hueChannel <= 0.02);
saturationMask = (satChannel >= 0.2);
valueMask = (valChannel >= 0.2);
redMask = redMask & saturationMask & valueMask;

% Additional step: Exclude green hues
greenHueRange = [90/360 150/360 0.3]; % Define the green hue range
greenMask= (hueChannel >= greenHueRange(1) & hueChannel <= greenHueRange(2) & valChannel <= greenHueRange(3) & satChannel <= greenHueRange(3) );

redMask = redMask & ~greenMask; % Apply the exclusion

% Apply the red mask to the input image
redImage = uint8(redMask) .* I;
grayscaleImage = rgb2gray(I - redImage);
outputImage = grayscaleImage + redImage;
A = outputImage;
end

function A = histogramequalizationYIQ(image)  
 YIQ = rgb2ntsc(image);

% Extract the Y channel and scale it to the range [0, 255]
Y = YIQ(:, :, 1);
Y_scaled = uint8(Y * 255);

% Calculate the histogram of the scaled Y channel
[counts, ~] = imhist(Y_scaled);

% Calculate the cumulative distribution function (CDF) of the histogram
cdf = cumsum(counts) / numel(Y_scaled);

% Create the histogram equalization function
T = uint8(255 * cdf);

% Apply histogram equalization to the Y channel
Y_eq = T(Y_scaled + 1);

% Update the Y channel in the YIQ image with the equalized values
YIQ(:, :, 1) = double(Y_eq) / 255;

% Convert the YIQ image back to RGB color space
output = ntsc2rgb(YIQ);

A = output;
   
end