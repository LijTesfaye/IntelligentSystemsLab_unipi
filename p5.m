clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% 1
fig = figure;
hold on, axis equal off
for i = 1:30
	plot_circle(rand,rand,rand*0.2,rand(1,3))
end
saveas(fig, 'myFig.jpg');
close(fig);


%% 2
nested_squares(7);



%% 1
function plot_circle(x,y,r,c)
    theta = linspace(0,2*pi,100);
    fill(x+sin(theta)*r,y+cos(theta)*r,c)
end


%% 2
function nested_squares(k)
    hold on
    for i = 1:k
        w = k-i+1;
        fill([w,w,-w,-w],[-w,w,w,-w],rand(1,3))
    end
    axis equal off
end