%{
This function chooses <numGoalVectors> different goal vectors p randomly
from the distribution D, and then normalizes those p so that
positive/negative elements (within p) sum to +1/-1 (respectively). For each
goal vector p, it generates <m> random vectors from the distribution <D>(<m>,<n>).
Any vectors having a negative dot product with p are inverted through the
origin (i.e. multiplied by -1). The function <F> of [these modified vectors
and their dot products with p] is used as the estimate of p, and the error
<E> between p and the estimate is calculated. The mean and standard
deviation of this error are calculated over all <numGoalVectors> different
p, and returned. 

Constraints (R = real numbers, R^k is size k-by-1):
    n > 1                           Number of dimensions for goal/candidate/estimate vectors. 
    m >= 1                          Number of goal vectors for which error is sampled.
    C : (a,b) -> R^(a-by-b)         Used to pick m random candidates.
    D : (a,b) -> R^(a-by-b)         Used to pick random goal vector.
    E : (R^n, R^n) -> R             Used to calculate est-goal error.
    F : (R^(m-by-n), R^m) -> R^n    Used to calculate estimate. 
%}
function [m,sd] = meanStdevError(m,n,numGoalVectors,C,D,E,F)
    % angle between estimate and true goal for numGoalVectors random goals
    estimateErrors = zeros(numGoalVectors,1);
    for i = 1:numGoalVectors
        % generate goal vector
        p = D(1,n)';
        % L1-normalize positive/negative elements
        p(p>0) = p(p>0)./sum(p(p>0));
        p(p<0) = p(p<0)./abs(sum(p(p<0)));
        
        % now get a bunch of random samples
        samples = C(m,n);
        results = samples*p;
        finalEstimateOfGoal = F(samples,results);
        error = E(p,finalEstimateOfGoal);

        estimateErrors(i) = error;
    end
    
    m = mean(estimateErrors);
    sd = std(estimateErrors);
end
