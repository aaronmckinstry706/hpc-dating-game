function estimate = meanEstimator(samples,results)
    samples(results<0,:) = 1-samples(results<0,:);
    estimate = mean(samples,1)';
end
