function [values, giveUp] = refine(op, values, pref)
%REFINE   Refinement method for FOURIERTECH construction.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Obtain some preferences:
% if ( nargin < 3 )
    pref = chebtech.techPref();
% end

% No values were given:
if ( nargin < 2 )
    values = [];
end

% Grab the refinement function from the preferences:
% refFunc = pref.refinementFunction;
% TODO: Implement other options.
refFunc = 'resampling';

% Decide which refinement to use:
if ( strcmpi(refFunc, 'nested') )
    % Nested ('single') sampling:
    [values, giveUp] = refineNested(op, values, pref);
elseif ( strcmpi(refFunc, 'resampling') )
    % Double sampling:
    [values, giveUp] = refineResampling(op, values, pref);
else
    % User defined refinement function:
    error('CHEBFUN:FOURIETECH:refine', ...
          'No user defined refinement options allowed')
%     [values, giveUp] = refFunc(op, values, pref);
end
    
end

function [values, giveUp] = refineResampling(op, values, pref)
%REFINERESAMPLING   Default refinement function for resampling scheme.

    if ( isempty(values) )
        % Choose initial n based upon minPoints:
        n = 2^ceil(log2(pref.minPoints - 1));
    else
        % (Approximately) powers of sqrt(2):
        pow = log2(size(values, 1));
        if ( (pow == floor(pow)) && (pow > 5) )
            n = round(2^(floor(pow) + .5)) + 1;
            n = n - mod(n, 2) + 1;
        else
            n = 2^(floor(pow) + 1);
        end
    end
    
    % n is too large:
    if ( n > pref.maxPoints )
        giveUp = true;
        return
    else
        giveUp = false;
    end
   
    % TODO: Allow "first-kind" fourier points.
    x = fourierpts(n);    

    % TODO: What if preferences is set to extrapolate?
    % Evaluate the operator:
    values = feval(op, x);
    
    % Force the value at x(1) to be equal to the value at x(1)+2*pi, thus
    % enforcing symmetry.
    valRightBoundary = feval(op,x(1)+2*pi);
    
    values(1,:) = 0.5*(values(1,:) + valRightBoundary);
end

function [values, giveUp] = refineNested(op, values, pref)
%REFINENESTED  Default refinement function for single ('nested') sampling.

    if ( isempty(values) )
        % The first time we are called, there are no values
        % and REFINENESTED is the same as REFINERESAMPLING.
        [values, giveUp] = refineResampling(op, values, pref);

    else
    
        % Compute new n by doubling (we must do this when not resampling).
        n = 2*size(values, 1);
        
        % n is too large:
        if ( n > pref.maxPoints )
            giveUp = true;
            return
        else
            giveUp = false;
        end
        
        % 2nd-kind Fourier points:
        x = fourierpts(n);
        % Take every 2nd entry:
        x = x(2:2:end);

        % Shift the stored values:
        values(1:2:n,:) = values;
        % Compute and insert new ones:
        values(2:2:end,:) = feval(op, x);

    end
end