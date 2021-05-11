function plotKFOutputs(t, xHist, PHist, xTrue)
%PLOTKFOUTPUTS Summary of this function goes here
% ====== Inputs ======
%   t
%       time vector
%
%   xHist
%       N x 4 time history of state [x;y;vx;vy]
%
%   PHist
%       4 x 4 x N time history of covariance
%
%   xTrue [optional]
%       N x 4 time history of true state

plot_truth = false;
if nargin > 3
    plot_truth = true;
end

%% Plotting
c1 = 'XY';
c2 = {'Position', 'Velocity'};
for k=1:2
    figure('name', sprintf('%s vs Time', c2{k}))
    istart = -1 + 2*k;
    for i=1:2
        ind = istart + (i-1);
        subplot(2, 1, i)
        hold on
        
        if plot_truth
            plot(t, xTrue(ind,:), 'DisplayName', 'Truth')
        end
        plot(t, xHist(ind,:), 'DisplayName', 'Kalman')
        hold off
        legend('location', 'best')
        
        xlabel('Time')
        ylabel(c2{k})
        title(sprintf('%s %s', c1(i), c2{k}))
    end
end

for k=1:2
    figure('name', sprintf('%s Error vs Time', c2{k}))
    for i=1:2
        ind = k + (i-1)*2;
        subplot(2, 1, i)
        hold on
        if plot_truth
            plot(t, xHist(ind,:) - xTrue(ind,:), 'DisplayName', 'Error')
        end
        sig3 = 3 * sqrt(squeeze(PHist(ind,ind,:)));
        plot(t, sig3, 'r', 'DisplayName', '3-sigma')
        plot(t, -1*sig3, 'r', 'HandleVisibility', 'off')
        
        hold off
        legend('location', 'best')
        
        xlabel('Time (s)')
        ylabel('Error')
        title(sprintf('%s %s Error', c1(i), c2{k}));
    end
end

figure('name', 'KF - 2D Position')
hold on
if plot_truth
    plot(xTrue(1,:), xTrue(2,:), 'DisplayName', 'Truth')
end
plot(xHist(1,:), xHist(2,:), 'DisplayName', 'Kalman')
hold off
legend('location', 'best')
title('2D Position')


end

