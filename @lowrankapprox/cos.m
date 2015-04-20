function f = cos( f ) 
%COS   Cosine of a LOWRANKAPPROX.
%   COS(F) returns the cosine of F.
%
% See also COSH.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Check for empty:
if ( isempty( f ) )
    return
end 

f = compose( f, @cos ); 

end