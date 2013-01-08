function [P,score] = CMap_enrichment_score(K, S, varargin)
% CMAP_ENRICHMENT_SCORE computes the enrichment of CMap connectivities from a rank list of instances
% and binary class labels
%
% CMAP_ENRICHMENT_SCORE takes a ranked list of instances generated from a query into a CMap database
% as well as a binary vector of class labels as inputs. The class labels are binary labels for the 
% class of drug or biological state of interest.  All member instances in the class are labeled as
% 1's and those outside of the class are labeled as 0's.  The output of CMAP _ENRICHMENT_SCORE is a
% vector of the running sum of the Kolomorov-Smirnov type statistic used and the final enrichment 
% score
%
% USAGE:
% [P,score] = CMAP_ENRICHMENT_SCORE(K, S) computes the running sum and score for the input ranked 
% list (K) and the given class labels (S)
%
% [P,score] = CMAP_ENRICHMENT_SCORE(K, S, 'plot', 'on') computes the running sum and score for the input ranked 
% list (K) and the given class labels (S) and plots the running sum.
%
% INPUT VARIABLES:
% K: the ranked list of CMap instances in respose to a query to the CMap database
% S: the binary vector of class labels
%
% OPTIONAL PARAMETERS:
% 'plot': 'on'|{'off'} determines whether or not to plot the running sum, P.  default is 'off'
%
% OUPUT VARIABLES:
% P: the vector containing the running K-S like score
% score: the final score defined as the maximum deviation from zero in either the positive or 
%        negative direction
%
% Authors: Dave Wadden, Corey Flynn, Broad Institute 2011

%parse optional arguments
pnames = {'plot','rank'};
dflts = {'off','false'};
args = parse_args(pnames,dflts,varargin{:});


%check to make sure that each list is a vector
if ~isvector(K) || ~isvector(S)
    error('CMap_enrichment_score inputs must be vectors');
end

%make sure that both lists are in column order 
if size(K,1) == 1
    K = transpose(K);
end
if size(S,1) == 1
    S =  transpose(S);
end

%rank order the lists by K
[s,i] = sort(K,'descend');
K = s;
S = S(i);

%if the rank flag is specified, used the ranked list instead of the scores
if strmatch(args.rank,'true')
    K = transpose([length(K):-1:1]-length(K)/2);
end

%force the zeros in the score list to be the smallest observed score so we don't miss those class
%members that land in the zeros of the ranked list.
tmp = min(abs(K(K ~= 0)));
Kzeros = find(K==0);
K(Kzeros) = tmp(1);

%set up normalization variables
N = length(S);
N_h = sum(S);
N_r = sum(abs(K) .* S);

%set up sets
P = zeros(N, 1);
tmp1 = abs(K) .* S;
tmp2 = ~S;

%compute the score
for ii = 1:N
    P_hit = sum(tmp1(1:ii)) ./ N_r;
    P_miss = sum(tmp2(1:ii)) ./ (N - N_h);
    P(ii) = P_hit - P_miss;
end

[score, scoreInd] = max(abs(P));
%score = P(abs(P) == max(abs(P)));
%avoid more than one max
score = score(1);
score = P(abs(P) == score);
scoreInd = scoreInd(1);

%make the running score plot if it is requested
if strmatch(args.plot,'on')
    hold on;
    K(Kzeros)=0;
    line([Kzeros(1) Kzeros(end)],[0 0],'Color',[.8 .8 .8],'LineWidth',50);
    Kpos = find(K>0);
    line([Kpos(1) Kpos(end)],[0 0],'Color',[1 0 0],'LineWidth',50);
    Kneg = find(K<0);
    line([Kneg(1) Kneg(end)],[0 0],'Color',[0 0 1],'LineWidth',50);    
    classMembers = find(S == 1);
    for ii = 1:length(classMembers)
        line([classMembers(ii) classMembers(ii)],[-.1 .1],'Color','k');
    end
    plot(P,'g','LineWidth',3);
    scatter(scoreInd,score,70,'k','filled');
    hold off;
end