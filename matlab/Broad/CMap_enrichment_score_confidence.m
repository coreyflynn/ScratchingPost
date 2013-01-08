function [lower, upper, varargout] = CMap_enrichment_score_confidence(queryResult,varargin)
% CMAP_ENRICHMENT_SCORE_CONFIDENCE computes the condfidence intervals for a given CMap query 
%
% CMAP_ENRICHMENT_SCORE_CONFIDENCE takes a CMap query result vector and computes the confidence
% intervals for the CMap enrichment score using a number of random class member assignments over the number
% of instances in the given query.  This result can be used to test significance of assayed classes 
% for the input query result
%
% USAGE:
% [lower,upper] = CMAP_ENRICHMENT_SCORE_CONFIDENCE(queryResult) computes confidence intervals based
% 1000 random permutations of 40 class members
%
% [lower,upper] = CMAP_ENRICHMENT_SCORE_CONFIDENCE(queryResult,'numPerm',N) computes confidence 
% intervals based N random permutations of 40 class members
%
% [lower,upper] = CMAP_ENRICHMENT_SCORE_CONFIDENCE(queryResult,'numClassMembers',M) computes confidence 
% intervals based 1000 random permutations of M class members
%
% [lower,upper] = CMAP_ENRICHMENT_SCORE_CONFIDENCE(queryResult,'numPerm',N,'numClassMembers',M) computes 
% confidence intervals based N random permutations of M class members
%
% INPUT VARIABLE DEFINITIONS
% queryResult: a vector of connectivity scores that are the result of a CMap query
%
% OPTIONAL INPUT PARAMETERS:
% 'numPerm': the number of permutations to use. 1000 is used by defualt
% 'numClassMembers': the number of class members to use. 40 is used by defualt
%
% OUTPUT VARIABLE DEFINITIONS
% lower: the lower confidence bound of 1000 random class assignments and their corresponding CMap
%        enrichment scores
%
% upper: the upper confidence bound of 1000 random class assignments and their corresponding CMap
%        enrichment scores
%
% Author: Corey Flynn, Broad Institute 2011

%parse optional arguments
pnames = {'numPerm','numClassMembers','rank','parclose'};
dflts = {1000,40,'false','true'};
args = parse_args(pnames,dflts,varargin{:});

%set up vectors to hold the permutation results and the class labels
numInstances = length(queryResult);
scores = zeros(1,args.numPerm);
classLabels = zeros(1,length(queryResult));
classLabels(1:args.numClassMembers) = 1;


%run the desired number of permuations and get a score for each in parallel
if matlabpool('size') == 0
    matlabpool open;
end
parfor ii = 1:args.numPerm
    permLabels = classLabels(randperm(numInstances));
    if strmatch(args.rank,'true')
        [P,score] = CMap_enrichment_score(queryResult,permLabels,'rank','true');
    else
        [P,score] = CMap_enrichment_score(queryResult,permLabels);
    end
    try
        scores(ii) = score;
    catch
        score = score(1);
        scores(ii) = score;
    end
end
if strmatch(args.parclose,'true')
    matlabpool close;
end

%compute the confidence intervals 
scoreMean = mean(scores);
scoreStd = std(scores);
lower = scoreMean-2*scoreStd;
upper = scoreMean+2*scoreStd;

%check for optional output arguments 
if nargout == 3
    varargout{1} = sort(scores);
end