%% Plot mean/stdev of angular error for mean-estimate vs. n (hypercube distr)

delta = 2^-7;
oneDimensionPoints = (-1:delta:1)';
hypercubeDist = @(s,k) oneDimensionPoints(randi(numel(oneDimensionPoints),[s,k]));

numGoalVectorsPerDimension = 1000;
maxDimensions = 100;
meansAndStdevs = zeros(maxDimensions,2);
for n = 2:maxDimensions
    [m,sd] = meanStdevAngleError(n,numGoalVectorsPerDimension,hypercubeDist);
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
ylabel('Angle error (degrees) between goal and mean-estimate (hypercube distr)');

%% Plot mean/stdev for anglular error of mean-estimate vs n (corner distr)

cornerDistr = @(s,k) randi([0,1],[s,k]).*2 - 1;

numGoalVectorsPerDimension = 1000;
maxDimensions = 100;
meansAndStdevs = zeros(maxDimensions,2);
for n = 2:maxDimensions
    [m,sd] = meanStdevAngleError(n,numGoalVectorsPerDimension,cornerDistr);
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
ylabel('Angle error (degrees) between goal and mean-estimate (corner distr)');