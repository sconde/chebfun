function r = deflate(N, r0, alp)

if (nargin(N.op) < 2 )
    error('must pass x and u to N.op');
end

N.op = @(x,u) deflationFun(N.op(x,u), u, r0, alp);

r = N\0;

end