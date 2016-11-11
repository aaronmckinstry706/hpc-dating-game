n = 100;
delta = 2^-7;
oneDimensionPoints = (-1:delta:1)';
generateRandomVectors = @(s,k) oneDimensionPoints(randi(numel(oneDimensionPoints),[s,k]));

[m,sd] = meanStdevAngleError(n,1000);
maxAngle = m + 3*sd; % experimentally verified: maxAngle<pi for n<100

% get random goal vector
p = generateRandomVectors(1,n);
% normalize so positives add to 1 and negatives add to -1
p(p>0) = p(p>0)./sum(p(p>0));
p(p<0) = p(p<0)./sum(p(p<0));

% get initial 20 random attempts
initial20 = generateRandomVectors(20,n);

% flip ones that have negative dot products with p
initial20(initial20*p < 0) = -initial20(initial20*p < 0);

% get initial estimate
estimate = mean(initial20,1);
% normalize to unit sphere
estimate = estimate./norm(estimate);

% do 20 iterations of stochastic gradient ascent
stepSize = 0.2;
for i = 1:20
    r = randi([0,1],n,1).*2 - 1;
    
    % project onto unit sphere and 
    r = r./norm(r);
    
    % get score
    rscore = dot(p,estimate+r.*stepSize);
    
    % update estimate
    estimate = estimate + r.*rscore.*stepSize;
    % normalize to unit sphere
    estimate = estimate./norm(estimate);
end

finalEstimate = sign(estimate);
finalScore = dot(estimate,p);
finalScore


