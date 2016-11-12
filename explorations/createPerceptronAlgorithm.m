function algorithm = createPerceptronAlgorithm(stepSize,numIterations,...
                                               corner)
    function estimate = A(S,r)
        if ~exist('corner','var')
            corner = false;
        end
        r = sign(r);
        estimate = 0;
        for iter = 1:numIterations
            S = S(randperm(numel(r)),:);
            for i = 1:numel(r)
                estimate = estimate + r(i).*stepSize.*S(i,:)';
            end
        end
        if corner
            estimate = sign(estimate);
        end
    end
    algorithm = @A;
end




