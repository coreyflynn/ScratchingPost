function [f,x] = correlation_ecdf(gct,gct2,varargin)
% CORRELATION_ECDF computes the probe-probe correlations of two input .gct files
%
% CORRELATION_ECDF takes two .gct files and additional optional parameters as arguments and outputs
% the survival function (f) as well as the probability (x) of the observed correlations between
% the two input .gct files.  These outputs can be used ot generate ecdf plots outside of 
% CORRELATION_ECDF.
%
% USAGE:
% [f,x] = correlation_ecdf(gct,gct2) plots the ecdf for all of the probes found in common between
% gct and gct2.  The resulting plot is displayed on screen
%
% [f,x] = correlation_ecdf(...,'output','outputFilePath') saves the generated plot to the path 
% specified in 'outputFilePath'.  The plot is not displayed on screen
%
% [f,x] = correlation_ecdf(...,'varFilter',numProbes) plots the ecdf for only the X most variable 
% probes, where X is numProbes.  The variance of all probes is computed as the coeficient of 
%variance observed in gct.
%
% [f,x] = correlation_ecdf(...,'listFilter','list') plots the ecdf for only those probes found in
% 'list'.  
%
% [f,x] = correlation_ecdf(...,'plotTitle','title') changes the title of the produced ecdf plot to 
% title
%
% INPUT VARIABLE DEFINITIONS
% gct: the first .gct file to be used when computing the ecdf of probe-probe correlations
% gct2: the second .gct file to be used when computing the ecdf of probe-probe correlations
%
% OPTIONAL PARAMETERS
% 'output': the file path to which the produced ecdf plot will be written
% 'varFilter': the number of probes to retain in a variance based filter before computing the ecdf
% 'listFilter': the list of probes to retain in a list based filter before computing the ecdf
% 'plotTitle': the user defined title for the produced plot
%
% OUTPUT VARIABLE DEFINITIONS
% f: the survivial function of the ecdf
% x: the probabilities of the the ecdf
%
% Author: Corey Flynn, Broad Institute 2011


%parse optional arguments
pnames = {'output','varFilter','listFilter','plotTitle'};
dflts = {'none','none','none','none'};
args = parse_args(pnames,dflts,varargin{:});

%check to see if the input gct files are workspace structure variables.  If they are not, assume 
%that they are file paths and parse them.
if isstruct(gct) == 0
    gct = parse_gct(gct);
end
if isstruct(gct2) == 0
    gct2 = parse_gct(gct2);
end

%if both the varFilter flag and listFilter flag are set to 'none', find pair-wise correlations 
%between probes in gct and gct2.  Plot the ecdf of those probes
if strcmp(args.varFilter,'none') && strcmp(args.listFilter,'none')
    [gctReord,gct2Reord] = reorder_probes(gct,gct2);
    FiltCorrs = zeros(1,22268);
    for ii = 1:22268
        FiltCorrs(ii) = corr(transpose(gctReord.mat(ii,:)),transpose(gct2Reord.mat(ii,:)));
    end
    [f,x] = ecdf(FiltCorrs);
    figure;
    stairs(x,f,'k','LineWidth',3);
    title('All Probes ecdf');
    xlabel('R');
    ylabel('F(R)');
end

%if the varFilter flag is set to a value other than 'none', find the X most variable probes, where X
%is the value given to varFilter.  Produce the same ecdf plot for this data set
if ~strcmp(args.varFilter,'none')
    gctFilt = filter_probes_var(gct,str2num(args.varFilter));

    %intersect that filtered list with the inferred dataset
    [gctReord,gct2Reord] = reorder_probes(gctFilt,gct2);
    FiltCorrs = zeros(1,str2num(args.varFilter));
    for ii = 1:str2num(args.varFilter)
        FiltCorrs(ii) = corr(transpose(gctReord.mat(ii,:)),transpose(gct2Reord.mat(ii,:)));
    end

    [f,x] = ecdf(FiltCorrs);
    figure;
    stairs(x,f,'k','LineWidth',3);
    title([args.varFilter ' Most Variable Probes ecdf']);
    xlabel('R');
    ylabel('F(R)');
end

%if the listFilter flag is set to a value other than 'none', find the probes in that list.
%Produce the same ecdf plot for this data set
if ~strcmp(args.listFilter,'none')
    gctFilt = filter_probes(gct,args.listFilter);

    %intersect that filtered list with the inferred dataset
    [gctReord,gct2Reord] = reorder_probes(gctFilt,gct2);
    FiltCorrs = zeros(1,length(gctReord.rid));
    for ii = 1:length(gctReord.rid)
        FiltCorrs(ii) = corr(transpose(gctReord.mat(ii,:)),transpose(gct2Reord.mat(ii,:)));
    end

    [f,x] = ecdf(FiltCorrs);
    figure;
    stairs(x,f,'k','LineWidth',3);
    title('List Filtered ecdf');
    xlabel('R');
    ylabel('F(R)');
end

%if the plotTitle flag is set, use is value to set the title of the plot
if ~strcmp(args.plotTitle,'none')
    title([args.plotTitle]);
end

%if there is an output specified, save a png of the figure to that location
if ~strcmp(args.output,'none')
    set(gcf,'Color','w');
    saveas(gcf,[args.output],'png');
    close(gcf);
end