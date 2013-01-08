function Z=gauss2D(height,sizex,sizey,sigmax,sigmay)
% GAUSS2D generates a 2D gausian with the given height and signma parameters drawn on a grid given
% by the xsize and ysize parameters.  The gird will contain n+1 pixels where in each dimension where
% n is the specified size.
%
% USAGE:
% Z=gauss2D(height,xsize,ysize,sigmax,sigmay)
%
% INPUT VARIABLE DEFINITIONS
% height: the maximal height(value) of the gaussian
% sizex: the size of the returned image in the x dimension
% sizey: the size of the returned image in the y dimension
% sigmax: the sigma (falloff) of the gaussian in the x dimension
% sigmay: the sigma (falloff) of the gaussian in the y dimension
%
% OUPUT VARIABLE DEFINITIONS
% Z = the returned image of the gaussian

xstep=2/sizex;
ystep=2/sizey;
[X,Y]=meshgrid(-1:xstep:1,-1:ystep:1);
Z=height*exp(-((X.^2/2*sigmax^2)+(Y.^2/2*sigmay^2)));