clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% 1    
A = imread('myImg.jpg');
s = size(A);
midR = round(s(1)/2); midC = round(s(2)/2);
A(1:midR,1:midC,1) = 255;               % red top left
A(1:midR,midC+1:end,3) = 255;           % blue top right
A(midR+1:end,1:midC,2) = 255;           % green bottom left
A(midR+1:end,midC+1:end,[1 3]) = 255;   % purple bottom right
figure, imshow(A)


%% 2
A = imread('myImg.jpg');
figure, imshow(A)
s = size(A);
lw = ceil(s(1)/200);
tenrows = round(linspace(1,s(1)-lw,11));
tencolumns = round(linspace(1,s(2)-lw,11));
B = A;
for i = 1:lw
    B(tenrows+i-1,:,:) = 0;
    B(tenrows+i-1,:,2) = 255;
    B(:,tencolumns+i-1,:) = 0;
    B(:,tencolumns+i-1,2) = 255;
end
figure, imshow(B)


%% 3
A = imread('myImg.jpg');
B = shuffle_image(A,4,5);
figure,imshow(A)
figure,imshow(B)


%% 3
function Im = shuffle_image(A,M,N)
    if ismatrix(A)          % is a matrix
        A = cat(3,A,A,A);   % make a grey image into rgb
    end
    Rows = floor(size(A,1)/M);
    Columns = floor(size(A,2)/N);
    Im = uint8(zeros(size(A)));
    % Shuffle index
    RP = reshape(randperm(M*N),M,N);
    k = 1;
    for i = 1:M
        for j = 1:N
            T = A((i-1)*Rows + 1 : i*Rows,(j-1)*Columns + 1 : j*Columns,:);    % take current block
            [new_r,new_c] = find(RP == k);
            % position in the new row/column
            Im((new_r-1)*Rows + 1 : new_r*Rows,(new_c-1)*Columns + 1 : new_c*Columns,:) = T;
            k = k + 1;
        end
    end
end     