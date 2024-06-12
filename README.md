# Image-steganography-using-LSB
This method is based on hiding the message in the least significant bit (LSB) of the image. The goal is to minimize the changes in the stego image.
LSB-based encryption is one of the simplest encryption methods. In this method, the secret message is hidden in the low-value bits of the desired pixels. The changes made in this method cannot be detected by the eye, but this method often affects the histogram of the image and can be detected by hidden mining algorithms.

In this method, first the image pixels are selected to hide the message and then the complement of the message is hidden in the low value bits of the selected pixels.

To solve some of the problems of the LSB method and to minimize the changes, the pixels are grouped based on the values ​​of the second to eighth bits. In each group, the ratio of changed pixels to unchanged pixels is calculated if this ratio is greater than one. The low value bits of that category are reversed and the changes are minimized
