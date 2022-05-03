clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% 1
% first way
disp(37:37:1000)
% second way
find(~mod(1:1000,37))
% third way
x = 1:1000;
disp(x(floor(x/37)==ceil(x/37)))
% fourth way
i = 2;
z = 37;
while z < 1000
    disp(z)
    z = 37*i;
    i = i + 1;
end


%% 2
NumberToGuess = randi(10);
UserGuess = input('Please enter your guess -> ');
if UserGuess == NumberToGuess
    disp('Congratulations! You won!')
else
    disp('You lost! Better luck next time! The number was')
    disp(NumberToGuess)
end


%% 3
% Pad array A with one cell on each edge so that each cell of A has 8 neighbours.
% Then construct a double loop to go through the rows and the columns of A.
m = 20; n = 30;
A = rand(m,n) < 0.1;         % sparse
% A = rand(m,n) < 0.5;       % medium
% A = rand(m,n) < 0.7;       % dense

B = zeros(m+2,n+2);          % padding
B(2:end-1,2:end-1) = A;      % inset A
S = 0;                       % sum of neighbours
for i = 2:m+1
    for j = 2:n+1
        if B(i,j)            % bug
            S = S + sum(sum(B(i-1:i+1,j-1:j+1))) - 1;     % only neighbours
        end
    end
end
disp('Averge number of neighbours per bug:')
disp(S/sum(B(:)))

