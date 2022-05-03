clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% 1
% To find the solution using matrix equation, 
% we should recall that we need the matrix with the coefficients 
% in front of the variables (A) 
% and the vector with the right-hand-side values (b)
% A = [7 -12; 12 -45];
% b = [-4 -26]';

% The solution is x = A^-1* b.

A = [7 -12;12 -45]; % coefficients
b = [-4;-26];       % right-hand side vector
x = inv(A)*b;       % solution [x;y]
disp(x)


%% 2
% Suppose m = 4 and n = 3.
% Using meshgrid, we can create all row and column indices i and j:
% Notice that the columns are the x-coordinate,
% therefore they are the first output arguments of meshgrid,
% and the rows are the second output argument
m = 4; n = 3;
[cols,rows] = meshgrid(1:n,1:m);
A = (cols - 4).^2 .* (rows + 1).^-3 + rows.*cols;

% Just to be sure, let’s check with one of the values, A(2; 3)
disp(A(2, 3));
% A(2,3) = (3-4)^2*(2+1)^3 + 2*3 = 6.0307


%% 3
% To calculate the x and y for part (a), we can use
x = [0:10 10:-1:0];         % bottom x’s followed by top x’s (reverse)
y1 = [repmat([1 0],1,5) 1]; % bottom y’s
y2 = y1 + 3;                % top y’s (no need to be reversed)
y = [y1 y2];                % put the y’s together
figure, plot(x,y,'b.-'), grid on

% For part (b), y goes from 1 to 40 while x goes forth and back. 
% We can create one of the upward lines of x’s, and shift it by 10 
% to obtain the other.
% Then we need to merge them like the teeth of two cog wheels:
x1 = 1:20;          % left
x2 = x1 + 10;       % right
x(1:2:40) = x1;     % insert the left x’s (odd)
x(2:2:40) = x2;     % insert the right x’s (even)
y = 1:40;
figure, plot(x,y,'b.-'), grid on

%Part (c) is quite similar to part (b).
% This time y oscillates between 0 and 1. One possible solution is:
x1 = 1:20;          % left
x2 = x1 + 10;       % right
x(2:2:40) = x1;     % insert the left x’s (odd)
x(1:2:40) = x2;     % insert the right x’s (even)
y = repmat([0 1],1,20);
figure, plot(x,y,'b.-'), grid on
