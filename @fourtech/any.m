function a = any(f, dim)
%ANY   True if any element of a FOURIERTECH is a nonzero number. ANY ignores
%      entries that are NaN (Not a Number).
%   ANY(F, DIM), where F is an array-valued FOURIERTECH, works down the dimension
%   DIM.  If DIM is 1, then ANY returns a logical row vector in which the Jth
%   element is TRUE if any element of the Jth column is nonzero.  If DIM is 2,
%   ANY returns a FOURIERTECH which takes the value 1 wherever any of the columns
%   (or rows) of F are nonzero, and zero everywhere else.  In this case, F must
%   either be identically zero or have no roots in its domain.  Otherwise,
%   garbage is returned without warning.
%
%   ANY(F) is shorthand for ANY(F, 1).

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information

% Parse inputs:
if ( nargin < 2 )
    dim = 1;
end

if ( dim  == 1 )        % ANY down the columns.
    a = any(f.values);
elseif ( dim == 2 )     % ANY down the rows.
    a = f;
    arbitraryPoint = 0.1273881594;
    a.values = any(feval(a, arbitraryPoint));
    a.coeffs = a.values;
    a.vscale = abs(a.values);
    a.epslevel = eps;
else
    error('FOURIERTECH:any:dim', 'DIM input must be 1 or 2.');
end

end