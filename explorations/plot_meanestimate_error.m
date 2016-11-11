delta = 2^-7;
oneDimension = -1:delta:1;
uniformHypercube = @(s,k) oneDimension(randi([1,numel(oneDimension)],[s,k]));
uniformNonnegativeHypercube = @(s,k) abs(uniformHypercube(s,k));
uniformNonnegativeBinary = @(s,k) randi([0 1],[s k]);
% TODO: make it so there are never all negatives

dotProduct = @(est,p) dot(est,p);
normalizedDotProduct = @(est,p) dot(est,p)/(norm(est)*norm(p));
angle = @(est,p) acos(dot(est,p)/(norm(est)*norm(p)))*180/pi;

m = 20; % num samples per goal vector
k = 1000; % num goal vectors used to calculate mean/stdev
C = uniformNonnegativeBinary;
D = @uniformAllNonzeroAndNotAllOneSignHypercube;
E = dotProduct;
F = @meanEstimator;

figure;

ax = subplot(1,1,1);

hold on;
plotMeanStdevErrorVsN(ax,m,k,C,D,E,@meanEstimator);
plotMeanStdevErrorVsN(ax,m,k,C,D,E,@cornerMeanEstimator);
plotMeanStdevErrorVsN(ax,m,k,C,D,E,@cornerMeanNormalizedEstimator);
hold off;
legend(ax,'mean-estimator','corner-mean-estimator','corner-mean-norm2-estimator');
title(ax,'Mean dot product for mean-estimate of goal vector, vs. n');
xlabel(ax,'Dimension n');
ylabel(ax,'Mean dot(goal,estimate) for estimate of goal vector');

% figure;
% subplot(1,3,1);
% hist(estimateErrorSamples(m,2,k,C,D,E,@meanEstimator));
% subplot(1,3,2);
% hist(estimateErrorSamples(m,2,k,C,D,E,@cornerMeanEstimator));
% subplot(1,3,3);
% hist(estimateErrorSamples(m,2,k,C,D,E,@cornerMeanNormalizedEstimator));


