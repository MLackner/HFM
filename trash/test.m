clc,clear
sizeA = 4;
A = randi(100,sizeA)
tic
B(:,:,1) = A(2:end-1,2:end-1) - A(2:end-1,1:end-2);
B(:,:,2) = A(2:end-1,2:end-1) - A(1:end-2,2:end-1);
B(:,:,3) = A(2:end-1,2:end-1) - A(2:end-1,3:end);
B(:,:,4) = A(2:end-1,2:end-1) - A(3:end,2:end-1);
B

S = mean(B,3)
toc