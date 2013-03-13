% Test file for funcheb/max.

function pass = test_max(pref)

% Get preferences.
if ( nargin < 1 )
    pref = funcheb.pref;
end

for ( n = 1:2 )
    if ( n == 1 )
        testclass = funcheb1();
    else 
        testclass = funcheb2();
    end

    %%
    % Spot-check the extrema for a few functions.

    pass(n, 1) = test_spotcheck_max(testclass, @(x) ...
        ((x-0.2).^3 -(x-0.2) + 1).*sec(x-0.2), ...
        1.884217141925336, pref);
    pass(n, 2) = test_spotcheck_max(testclass, @(x) sin(10*x), 1, pref);
    pass(n, 3) = test_spotcheck_max(testclass, @airy, airy(-1), pref);
    pass(n, 4) = test_spotcheck_max(testclass, @(x) -1./(1 + x.^2), -0.5, pref);
    pass(n, 5) = test_spotcheck_max(testclass, @(x) (x - 0.25).^3.*cosh(x), ...
        0.75^3*cosh(1), pref);

    %%
    % Check operation for vectorized inputs.

    fun_op = @(x) [sin(10*x) airy(x) (x - 0.25).^3.*cosh(x)];
    f = testclass.make(fun_op, pref);
    [y, x] = max(f);
    exact_max = [1 airy(-1) 0.75^3*cosh(1)];
    fx = [sin(10*x(1)) airy(x(2)) (x(3) - 0.25).^3.*cosh(x(3))];
    pass(n, 6) = (all(abs(y - exact_max) < 10*f.epslevel) && ...
               all(abs(fx - exact_max) < 10*f.epslevel));

    %%
    % Test for complex-valued funcheb objects.
    pass(n, 7) = test_spotcheck_max(testclass, ...
        @(x) x.*(exp(1i*x)+1i*sin(x)), ...
        -0.540302305868140 + 1.682941969615793i, pref);

    fun_op = @(x) [sin(1i*x) tan(-1i*x)];
    f = testclass.make(fun_op, pref);
    [y, x] = max(f);
    exact_max = [1.175201193643801i 0.761594155955765i];
    fx = [sin(1i*x(1)) tan(-1i*x(2))];
    % [TODO]:  This test fails for funcheb1.
    pass(n, 8) = (all(abs(y - exact_max) < 10*f.epslevel) && ...
               all(abs(fx - exact_max) < 10*f.epslevel));
end

end

% Spot-check the results for a given function.
function result = test_spotcheck_max(testclass, fun_op, exact_max, pref)

f = testclass.make(fun_op, pref);
[y, x] = max(f);
fx = fun_op(x);
result = (all(abs(y - exact_max) < 10*f.epslevel) && ... 
          all(abs(fx - exact_max) < 10*f.epslevel));

end