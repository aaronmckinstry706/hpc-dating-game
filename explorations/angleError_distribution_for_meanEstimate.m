%% Calculates distribution of angle error between estimate and goal
%{
A random p is chosen from hypercube [-1:delta:1]^n
Estimate is calculated by averaging 20 random vectors v such
that v dot p > 0. 
Angle between p and estimate is calculated. 
Histogram, mean, standard deviation of angles is calculated.
%}

n = 100;
delta = 2^-7;
oneDimensionPoints = (-1:delta:1)';
generateRandomVectors = @(s,k) oneDimensionPoints(randi(numel(oneDimensionPoints),[s,k]));

numSamplesPerGoalVector = 20;
numGoalVectors = 10000;

% angle between estimate and true goal for numGoalVectors random goals
estimateErrorAngles = zeros(numGoalVectors,1);
for i = 1:numGoalVectors
    % generate goal vector
    p = generateRandomVector(n);
    
    % now get a bunch of random samples
    samples = generateRandomVectors(numSamplesPerGoalVector,n);
    results = samples*p;
    samples(results<0,:) = -samples(results<0,:);
    finalEstimateOfGoal = sum(samples,1)';
    angleBetweenEstimateAndGoal = ...
        acos(dot(p,finalEstimateOfGoal)...
             /(norm(p)*norm(finalEstimateOfGoal)));
    
    estimateErrorAngles(i) = angleBetweenEstimateAndGoal;
end

hist(estimateErrorAngles./pi.*180);
title('Distribution of Angle Error between Estimate and Goal')
ylabel('Frequency');
xlabel('Angle (degrees)');