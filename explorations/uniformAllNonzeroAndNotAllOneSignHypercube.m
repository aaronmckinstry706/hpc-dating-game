%{
Produces s random vectors of dimension k, such that each vector has: no
zero elements, has at least one positive element, and at least one negative
element. 
%}

function result = uniformAllNonzeroAndNotAllOneSignHypercube(s,k)
    delta = 2^-7;
    onePositiveDimension = delta:delta:1;
    oneNegativeDimension = -1:delta:-delta;
    oneDimension = horzcat(onePositiveDimension,oneNegativeDimension);
    result = horzcat(...
        onePositiveDimension(randi([1,numel(onePositiveDimension)],[s,1])),...
        oneNegativeDimension(randi([1,numel(oneNegativeDimension)],[s,1])),...
        oneDimension(randi([1,numel(oneDimension)],[s,k-2]))...
    );
end


