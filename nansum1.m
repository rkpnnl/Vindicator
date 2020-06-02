function y = nansum1(x,dim)
%NANSUM1 Sum, ignoring NaNs.
%   Y = NANSUM1(X) returns the sum of X, treating NaNs as missing values.
%   For vector input, Y is the sum of the non-NaN elements in X.  For
%   matrix input, Y is a row vector containing the sum of non-NaN elements
%   in each column.  For N-D arrays, NANSUM1 operates along the first
%   non-singleton dimension.
%
%   Y = NANSUM1(X,DIM) takes the sum along dimension DIM of X.
%
%   See also SUM, nanmean1, nanvar1, nanstd1, nanmin1, nanmax1, nanmedian1.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 2.10.2.4 $  $Date: 2004/07/28 04:38:44 $

% Find NaNs and set them to zero.  Then sum up non-NaNs.  Cols of all NaNs
% will return zero.
x(isnan(x)) = 0;
if nargin == 1 % let sum figure out which dimension to work along
    y = sum(x);
else           % work along the explicitly given dimension
    y = sum(x,dim);
end
