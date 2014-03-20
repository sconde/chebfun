function pass = sampleTest(op, f)
%SAMPLETEST   Test an evaluation of input OP against a FOURIERTECH approximation.
%   SAMPLETEST(OP, F) evaluates both the function OP and its FOURIERTECH
%   representation F at one or more points within [-pi,pi). The difference of
%   these values is computed, and if this is sufficiently small (relative to
%   F.VSCALE, F.HSCALE, and F.EPSLEVEL) the test passes and returns TRUE. If the
%   difference is large, it returns FALSE.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [TODO]: Describe where we evaluate? (Approx to largest derivative and at
% -pi+1e-12, pi-1e-12?)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the interpolation points:
n = length(f);

% Set a tolerance:
tol = max(f.epslevel, 1e3*eps) * n;

% Choose a point to evaluate at:
if ( n == 1 )
    xeval = 0.61; % Pseudo-random test value
else
    % TODO: implement this more robust test:
%     x = f.chebpts(n);
%     % Test a point where the (finite difference) gradient of values is largest:
%     [~, index] = max(bsxfun(@rdivide, abs(diff(f.values)), diff(x)));
%     xeval = ( x(index + 1) + 1.41*x(index) ) / 2.41;
    % For now just pick a random value.
    xeval = pi*(2*rand-1);
end
xeval = [-pi+1e-12 ; xeval ; pi-1e-12];

% Evaluate the FOURIERTECH:
vFun = feval(f, xeval);

% Evaluate the op:
vOp = feval(op, xeval);

% If the FOURIERTECH evaluation differs from the op evaluation, SAMPLETEST failed:
err = bsxfun(@rdivide, abs(vOp - vFun), f.vscale); % Relative (to vscale) error.
if ( all(max(abs(err)) > tol) )
    pass = false; % :(
else
    pass = true;  % :)
end

end