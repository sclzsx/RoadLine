clc;
clear;

obj = VideoReader('data/VideoS/1.mp4');
rgb = read(obj,1);
% imwrite(frame,strcat('D:\image\cankao1\',num2str(k),'.jpg'),'jpg');
[H,W,C] = size(rgb);
% frame = imresize(frame, 0.5);

crop_mask = ones([H, W]);
crop_mask(1:floor(H/5*4), :) = 0;
crop_mask(H - floor(H/14):end, :) = 0;
crop_mask(:, 1:floor(H/10)) = 0;
crop_mask(:, W - floor(H/10):end) = 0;

rgb = even_light(rgb);
rgb = double(rgb);

hsv = rgb2hsv(rgb);
v = hsv(:,:,3);
v2=histeq(v);
v3 = v2.^2;
white_mask = zeros([H, W]);
white_mask(v3 > 0.95) = 1;
se = strel('disk', 3);
white_mask = imdilate(white_mask,se);
back_mask = 1 - white_mask;
% white_mask = imerode(white_mask,se);

gray = rgb2gray(rgb);
med = medfilt2(gray, [3, 3]);
med = double(med);

level = graythresh(med);
BW = imbinarize(med,level);

% gX = [1 0 -1;
%       2 0 -2;
%       1 0 -1];
% X = imfilter(med, gX, 'same');
% gY = [1  2  1;
%       0  0  0;
%      -1 -2 -1];
% Y = imfilter(med, gY, 'same');
% sob = sqrt(X.^2 + Y.^2);

BW1 = BW .* crop_mask;
BW2 = BW1 .* white_mask;

BW2 = imdilate(BW2,se);
BW2 = imerode(BW2,se);
