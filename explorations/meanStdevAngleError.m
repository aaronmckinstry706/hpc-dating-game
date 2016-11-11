%{
For a given number of dimensions n, this function chooses numGoalVectors
different goal vectors p. For each goal vector p, it generates 20 random
vectors from the distribution D(20,n). Any vectors having a negative
dot product with p are inverted through the origin (i.e. multiplied by -1).
The average of these modified vectors is used as the estimate of p, and the
angle between p and the estimate is calculated. The mean and standard
deviation of this angular error is calculated over all <numGoalVectors>
different p, and returned. 
%}
function [m,sd] = meanStdevAngleError(n,numGoalVectors,D)
    numSamplesPerGoalVector = 20;
    
    % angle between estimate and true goal for numGoalVectors random goals
    estimateErrorAngles = zeros(numGoalVectors,1);
    for i = 1:numGoalVectors
        % generate goal vector
        p = D(n,1);
        
        % now get a bunch of random samples
        samples = D(numSamplesPerGoalVector,n);
        results = samples*p;
        samples(results<0,:) = -samples(results<0,:);
        finalEstimateOfGoal = sum(samples,1)';
        angleBetweenEstimateAndGoal = ...
            acos(dot(p,finalEstimateOfGoal)...
                 /(norm(p)*norm(finalEstimateOfGoal)));

        estimateErrorAngles(i) = angleBetweenEstimateAndGoal;
    end
    
    m = mean(estimateErrorAngles);
    sd = std(estimateErrorAngles);
end