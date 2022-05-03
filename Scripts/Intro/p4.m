clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% 1
P = [3 4;1 2]; Q = [-2 5;3 -1; 7 4];
disp(euclidean_distance_arrays(P,Q))
disp(euclidean_distance_arrays2(P,Q))


%% 2
point_in_a_square(0.3,0.8,0,0,1)
point_in_a_square(0.3,1.8,0,0,1)
point_in_a_square(1,0.8,0,0,1)


%% 3
for i = 1:10
    disp(fibo_recursive(i))
end



%% 1
function D = euclidean_distance_arrays(A,B)
    for i = 1:size(A,1)
        x = A(i,:);         % ith row of A
        for j = 1:size(B,1)
            y = B(j,:);     % jth row of B
            D(i,j) = sqrt(sum((x-y).^2));
        end
    end
end

% Here is a solution without loops:
function D = euclidean_distance_arrays2(A,B)
    N = size(A,1); M = size(B,1);
    AA = repmat(A,M,1); BB = repmat(B',1,N)';
    D = reshape(sqrt(sum((AA-BB).^2,2)),M,N);
end


%% 2
function is_in = point_in_a_square(x,y,p,q,s)
    is_in = x >= p & x <= p + s & y >= q & y <= q + s;
end


%% 3
function o = fibo_recursive(k)
    if k < 2
        o = k;
    else
        o = fibo_recursive(k-1) + fibo_recursive(k-2);
    end
end
