%% Plot mean/stdev for dot(mean-estimate,goal) vs n (corner distr)

cornerDistr = @(s,k) randi([0,1],[s,k]).*2 - 1;

numGoalVectorsPerDimension = 1000;
maxDimensions = 100;
meansAndStdevs = zeros(maxDimensions,2);
for n = 2:maxDimensions
    [m,sd] = meanStdevDotProductError(n,numGoalVectorsPerDimension,cornerDistr);
    meansAndStdevs(n,:) = [m,sd];
end

errorbar(2:maxDimensions,...
         meansAndStdevs(2:maxDimensions,1).*180./pi,... (convert to deg)
         meansAndStdevs(2:maxDimensions,2).*180./pi,... (convert to deg)
         '-s',...
         'MarkerSize',5,...
         'MarkerEdgeColor','red',...
         'MarkerFaceColor','red');
title('Mean and Standard Deviation of Angle Error for varying n');
xlabel('Dimension n');
ylabel('Dot product score between goal and mean-estimate (corner distr)');
