function plotMeanStdevErrorVsN(ax,m,numGoalVectors,C,D,E,F)
    maxDimensions = 100;
    meansAndStdevs = zeros(maxDimensions,2);
    for n = 2:maxDimensions
        [ave,sd] = meanStdevError(m,n,numGoalVectors,C,D,E,F);
        meansAndStdevs(n,:) = [ave,sd];
    end
    
    errorbar(ax,...
          2:maxDimensions,...
          meansAndStdevs(2:maxDimensions,1),...
          meansAndStdevs(2:maxDimensions,2),...
          '-s',...
          'MarkerSize',5,...
          'MarkerEdgeColor','red',...
          'MarkerFaceColor','red');
end