function err = errorReportingDotProduct(p,est)
    if dot(est,p) > 1.5
        [est p]
        error('Dot product bigger than 1!');
    end
    err = dot(est,p);
end
