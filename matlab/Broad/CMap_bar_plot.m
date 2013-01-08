function CMap_bar_plot(scores,classMembers)
% CMAP_BAR_PLOT displays a plot of CMap instances ranked in response to a CMap query and where members 
% of a particular instance class fall in that ranked list
%
% USAGE:
% CMap_bar_plot(scores,classMembers) 
%
% INPUT VARIABLE DEFINITIONS
% scores: a list of connectivity scores returned by a query to a CMap data base
% classMembers: a boolean list of class membership.  classMembers is the same size as scores, with 
%               entries of 1 members and 0 for non-members
%
% Author: Corey Flynn, Broad Institute 2011

%check to make sure that each list is a vector
if ~isvector(scores) || ~isvector(classMembers)
    error('CMap_bar_plot inputs must be vectors');
end

%make sure that both lists are in column order 
if size(scores,1) == 1
    scores = transpose(scores);
end
if size(classMembers,1) == 1
    classMembers =  transpose(classMembers);
end

%sort the scores 
[sorted,inds] = sort(scores,'descend');

%divide scores by two to free up room in the color map
sorted = sorted*16+16;

%map the class members vector to the upper portion of the colormap
classMembers(classMembers==0) = 33;
classMembers(classMembers==1) = 64;

%concatenate and display the data along with the classMember
image(horzcat(sorted,classMembers(inds)));

%setup the colormap
c = zeros(64,3);
c(1:15,1:2) = 0;
c(1:15,3) = 1;
c(16,:) = .87;
c(17:32,2:3) = 0;
c(17:32,1) = 1;
c(33,:) = 1;

%apply the colormap
colormap(c);

%setup axis options
grid off;
axis off;