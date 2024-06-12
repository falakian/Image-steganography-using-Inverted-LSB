
clc ; clear;

% Load variables
load './struct'

size_iut_image = struct.size;

% Open image
stego_image = imread('./Stego_image.png');

% Generate random pattern
rng(struct.key);
random_pattern = logical(round(rand([size_iut_image 1])));


plane1 = logical(bitget(stego_image , 1));
plane2 = logical(bitget(stego_image , 2));
plane3 = logical(bitget(stego_image , 3));
plane4 = logical(bitget(stego_image , 4));
plane5 = logical(bitget(stego_image , 5));
plane6 = logical(bitget(stego_image , 6));
plane7 = logical(bitget(stego_image , 7));
plane8 = logical(bitget(stego_image , 8));

plane1 = plane1(:);
plane2 = plane2(:);
plane3 = plane3(:);
plane4 = plane4(:);
plane5 = plane5(:);
plane6 = plane6(:);
plane7 = plane7(:);
plane8 = plane8(:);

plane2 = plane2(1:size_iut_image);
plane3 = plane3(1:size_iut_image);
plane4 = plane4(1:size_iut_image);
plane5 = plane5(1:size_iut_image);
plane6 = plane6(1:size_iut_image);
plane7 = plane7(1:size_iut_image);
plane8 = plane8(1:size_iut_image);

% Segmentation of pixels based on planes 2 to 8
number = binaryVectorToDecimal([plane8,plane7,plane6,plane5,plane4,plane3,plane2]) + 1;

% Get the number of pixels per segment
unique_number = unique(number);
TotalNumberOfPixels = int16(zeros([128 1]));
count = int16(hist(number, unique(number)));

for i=1:size(count ,2)
    TotalNumberOfPixels(unique_number(i)) = count(i);
end

lsb = plane1;

binaryvector = xor(random_pattern,lsb(1:size_iut_image));

for i=1:size_iut_image
    number(i) = struct.array_p(number(i));
end

binaryvector = xor(binaryvector,number);

binaryvector = reshape(binaryvector,[size_iut_image/8  8]);
iut_image = binaryVectorToDecimal(binaryvector);
iut_image = uint8(iut_image);

file_name = strcat('Extract', struct.format);
F = fopen(file_name , 'w');
fwrite(F,iut_image , 'uint8');
fclose(F);