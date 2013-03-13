function pass = test_isinf(pref)

if ( nargin < 1 )
    pref = funcheb.pref;
end
p = pref;

for ( n = 1:2 )
    if ( n == 1 )
        testclass = funcheb1();
    else 
        testclass = funcheb2();
    end

    % Test a scalar-valued function:
    p.funcheb.n = 11;
    f = testclass.make(@(x) 1./x, 0, p);
    % [TODO]:  This test fails for funcheb1.
    pass(n, 1) = isinf(f);
    
    % Test a vector-valued function:
    p.funcheb.n = 11;
    f = testclass.make(@(x) [1./x, x], 0, p);
    % [TODO]:  This test fails for funcheb1.
    pass(n, 2) = isinf(f);
    
    % Test a finite scalar-valued function:
    p = pref;
    f = testclass.make(@(x) x, 0, p);
    pass(n, 3) = ~isinf(f);
    
    % Test a finite vector-valued function:
    f = testclass.make(@(x) [x, x], 0, p);
    pass(n, 4) = ~isinf(f);
end

end