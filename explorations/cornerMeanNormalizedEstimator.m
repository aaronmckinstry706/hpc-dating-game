function estimate = cornerMeanNormalizedEstimator(samples,results)
    samples(results<0,:) = 1-samples(results<0,:);
    samples = samples.*2 - 1;
    samples = normr(samples);
    estimate = mean(samples,1)';
    estimate = round(0.5*(estimate + 1));
end

