
clc;clear;close all;

file_name = './IUT.jpg';

% Open images
cover_image = imread('./Cover_Image.png');

F = fopen(file_name);
iut_image = fread(F,'uint8');
fclose(F);

% Convert to binary
binaryvector = decimalToBinaryVector(iut_image,8);
binaryvector = logical(binaryvector(:));
size_bibinaryvector = size(binaryvector);


plane1 = logical(bitget(cover_image , 1));
plane2 = logical(bitget(cover_image , 2));
plane3 = logical(bitget(cover_image , 3));
plane4 = logical(bitget(cover_image , 4));
plane5 = logical(bitget(cover_image , 5));
plane6 = logical(bitget(cover_image , 6));
plane7 = logical(bitget(cover_image , 7));
plane8 = logical(bitget(cover_image , 8));

plane1 = plane1(:);
plane2 = plane2(:);
plane3 = plane3(:);
plane4 = plane4(:);
plane5 = plane5(:);
plane6 = plane6(:);
plane7 = plane7(:);
plane8 = plane8(:);

plane2 = plane2(1:size_bibinaryvector);
plane3 = plane3(1:size_bibinaryvector);
plane4 = plane4(1:size_bibinaryvector);
plane5 = plane5(1:size_bibinaryvector);
plane6 = plane6(1:size_bibinaryvector);
plane7 = plane7(1:size_bibinaryvector);
plane8 = plane8(1:size_bibinaryvector);

% Segmentation of pixels based on planes 2 to 8
number = binaryVectorToDecimal([plane8,plane7,plane6,plane5,plane4,plane3,plane2]) + 1;

% Get the number of pixels per segment
unique_number = unique(number);
TotalNumberOfPixels = int32(zeros([128 1]));
count = int32(hist(number, unique(number)));

for i=1:size(count ,2)
    TotalNumberOfPixels(unique_number(i)) = count(i);
end

% Generate random pattern
lsb = plane1;
Key = rng; % seed
random_pattern = logical((round(rand(size_bibinaryvector))));

lsb(1:size_bibinaryvector) = xor(random_pattern,binaryvector);

% Get the number of unchanged pixels of each segment
CheckChange = abs(lsb(1:size_bibinaryvector) - plane1(1:size_bibinaryvector));
NumberCheckChange = number - (number .* CheckChange);

unique_NumberCheckChange = unique(NumberCheckChange);
unique_NumberCheckChange = unique_NumberCheckChange(2:end);
NumberOfPixelsNotChanged = int32(zeros([128 1]));
count_NumberOfPixelsNotChanged = int32(hist(NumberCheckChange, unique(NumberCheckChange)));
count_NumberOfPixelsNotChanged = count_NumberOfPixelsNotChanged(2:end);

for i=1:size(count_NumberOfPixelsNotChanged ,2)
    NumberOfPixelsNotChanged(unique_NumberCheckChange(i)) = count_NumberOfPixelsNotChanged(i);
end

% Construction of vector p and xor sections
P = logical(zeros([128 1]));

for i=1:128
    if(round(NumberOfPixelsNotChanged(i) / TotalNumberOfPixels(i)) < 0.5)
        P(i) = 1;
    end
end

for i=1:size_bibinaryvector
    number(i) = P(number(i));
end

lsb(1:size_bibinaryvector) = xor(lsb(1:size_bibinaryvector),number);


lsb = reshape(lsb,[size(cover_image,1)  size(cover_image,2)]);
stego_image = bitset(cover_image, 1, lsb);

subplot(1 , 2 ,1);
imshow(stego_image , []);
title('stego image');

subplot(1 , 2 ,2);
imshow(cover_image , []);
title('cover image');

sgtitle(['psnr(stego,cover) :' num2str( psnr(stego_image , cover_image))]);

imwrite(stego_image,'./Stego_image.png');
size_iut_image = [size(binaryvector)];
[~,~,format] = fileparts(file_name);

struct.key = Key;
struct.size = size_iut_image(1);
struct.array_p = P;
struct.format = format;

save('./struct' , 'struct');

