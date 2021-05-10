function animateTRN(globalMap, TRNCoords)

figure
hold on
imagesc(globalMap)
plot3(TRNCoords(1,1),TRNCoords(1,2),0,'go','LineWidth',6)
plot3(TRNCoords(end,1),TRNCoords(end,2),0,'bx','LineWidth',6)
title('TRN coords over time'), 
zlabel('time(seconds)'),
ylabel('y pixels'),
xlabel('pixels'),


a1 = animatedline('Color', 'r', 'LineWidth', 3);
[row, ~] = size(TRNCoords);

for i = 1:row
    addpoints(a1, TRNCoords(i,1), TRNCoords(i,2));
    drawnow
end

hold off

end

