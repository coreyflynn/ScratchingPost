function correlation_report_tool(gct_one,gct_two,varargin)
% COORELATION_REPORT_TOOL compare observed gene expression data after subsampling and inference
%
% COORELATION_REPORT_TOOL takes as .gct file and ensures that only the data from the proper probe set
% space is used for comparison to the output of running an inference model on landmark probes.
% basic comparisons of sample and gene correlations are output as well as .gct and .grp files used
% for the analysis.  Additionally, a pdf report summarizing the input, intermediates, and results
% is output.
%
% USAGE:
% inferred_correlation_tool generates a correlation report based on the user selected input gct file
% and writes the results to the user selcted ouput directory.  The user specifies these inputs through
% a GUI interface
%
% correlation_report_tool('res',inputGCT,'o',outputDir) generates a correlation report based on the given 
% input gct file and writes the results to the given ouput directory.
%
% OPTIONAL PARAMETER DEFINITIONS
% inputGCT: the path to the .gct file to be operated on
% outputDir: the path to the directory in which to place all output files
%
% Author: Corey Flynn, Broad Institute 2011

%set default figure visability to 'off'
set(0, 'DefaultFigureVisible', 'off');

%parse optional arguments
pnames = {'o','sc','ec','style','hmtop','hmbot'};
dflts = {'',200,6,'long',999,-999};
args = parse_args(pnames,dflts,varargin{:});

%set base inference data path
inferencePath = '/xchip/cogs/data/vdb/spaces/';


%select files if there are no inputs
if strcmp(args.o,'') == 1 
    outputDir = uigetdir(pwd,'Select output folder');
else
    outputDir = args.o;
end

%first check for the output directory and create it if it does not exist
if ~isdir(outputDir)
    mkdir(outputDir);
end

%check for data, figures, and report directories in the ouput directory. If they don't exist, crate
%them
if ~isdir([outputDir '/data'])
    mkdir([outputDir '/data']);
end
if ~isdir([outputDir '/figures'])
    mkdir([outputDir '/figures']);
end
if ~isdir([outputDir '/report'])
    mkdir([outputDir '/report']);
end
%define the base output name for all files in the analysis and grab a list of all files in the 
%output folder for later use,
baseName = getGCTBaseName(gct_one);

%load the 22268_probes and 22268_probes_INF datasets, make sure the probe space matches, and reorder 
%the probes to match eachother
observed = parse_gct(gct_one);

inferred = parse_gct(gct_two);

commonProbes = intersect(inferred.rid,observed.rid);
observed = filter_probes(observed,commonProbes);
inferred = filter_probes(inferred,commonProbes);

[observedReord,inferredReord] = reorder_probes(observed,inferred);

% check to see if the sample wise correlations have been computed.  If not, compute it now
% only do this if the data set is under 200 samples
numSamples = length(observed.cid);
if numSamples <= args.sc
    outputDirFileList = dir([outputDir '/data']); % update the output directory file list
    if ~isFilePiece(sprintf('%s_sample_corrs.mat',baseName),outputDirFileList)
        fprintf('computing samples correlation matrix...\n');
        fullSampleCorrs = fastcorr(observedReord.mat,inferredReord.mat);
        save(sprintf('%s/data/%s_sample_corrs.mat',outputDir,baseName),'fullSampleCorrs');
    else
        disp(sprintf('%s/data/%s_sample_corrs.mat found, using it for further analysis...',outputDir,baseName));
        load(sprintf('%s/data/%s_sample_corrs.mat',outputDir,baseName));
    end
else
    disp('more than 200 samples, skipping full sample correlation computation...');
end 

%compute the sample-wise correlations
disp('computing sample correlations...');
pairedSampleCorrs = zeros(1,numSamples);
if numSamples <= args.sc
    for ii = 1:numSamples
        pairedSampleCorrs(ii) = fullSampleCorrs(ii,ii);
    end
else
    for ii = 1:numSamples
        pairedSampleCorrs(ii) = fastcorr(observedReord.mat(:,ii),inferredReord.mat(:,ii));
    end
end

%save the paired sample corrs as a gct file
gctBase = observedReord;
gctBase.mat = pairedSampleCorrs;
gctBase.rid = {'sampleCorrs'};
mkgct(sprintf('%s/data/%s_paired_sample_corrs',outputDir,baseName),gctBase);

%plot a summary of the sample correlations found as well as the ecdf of the paired sample correlations
%plot the 2 worst and 2 best correlated samples as well as the median sample.
[sortedSampleCorrs,sortedSampleCorrsInd] = sort(pairedSampleCorrs);

if numSamples <= args.sc
    figureoff;
    [n1,xout] = hist(reshape(fullSampleCorrs,1,[]),[0:.01:1]);
    [n2,xout] = hist(pairedSampleCorrs,[0:.01:1]);
    [AX,H1,H2] = plotyy(xout,n1,xout,n2,'plot');
    set(H1,'LineWidth',3);
    set(H2,'LineWidth',3);
    set(get(AX(1),'YLABEL'),'String','All Sample R');
    set(get(AX(2),'YLABEL'),'String','Paired Sample R');
    set(AX(1),'XLim',[min(fullSampleCorrs(:)) max(fullSampleCorrs(:))]);
    set(AX(2),'XLim',[min(fullSampleCorrs(:)) max(fullSampleCorrs(:))]);
    title('Sample Correlation Summary');
    
    set(gcf,'Color','w');

    saveas(gcf,sprintf('%s/figures/%s_sample_corr_summary.png',outputDir,baseName),'png');
    close(gcf);
    
    map = zeros(64,3);
    map(1:32,1) = 0:1/31:1;
    map(1:32,2) = 0:1/31:1;
    map(1:32,3) = 1;
    map(33:64,1) = 1;
    map(33:64,2) = 1:-1/31:0;
    map(33:64,3) = 1:-1/31:0;
    
    figure('position',[0 1000 1000 1000]);
    T = clusterdata(fullSampleCorrs,1);
    [Ts, Ti] = sort(T);
    imagesc(fullSampleCorrs(Ti,Ti));
    
    % handle custom heat map CLim scaling
    if args.hmtop ~= 999 && args.hmbot ~= -999
        set(gca,'CLim',[args.hmbot args.hmtop]);
    elseif args.hmtop ~= 999
        set(gca,'CLim',[min(fullSampleCorrs(:)) args.hmtop]);
    elseif args.hmbot ~= -999
        set(gca,'CLim',[args.hmbot max(fullSampleCorrs(:))]);
    end
    
    if numSamples <= 20
        set(gca,'YTickLabel',observedReord.cid(Ti));
        set(gca,'XTickLabel',observedReord.cid(Ti));
        set(gca,'xtick',1:length(observedReord.cid));
        set(gca,'ytick',1:length(observedReord.cid));
        ylabel('Observed');
        rotlabel(gca,90);
    else
        ylabel('Observed');
        xlabel('Inferred');
    end
    axis square;
    colormap(map);
    grid off;
    colorbar;
    saveas(gcf,sprintf('%s/figures/%s_sample_corr_heatmap.png',outputDir,baseName),'png');
    close(gcf);
end

[f,x,flo,fup] = ecdf(pairedSampleCorrs);
figureoff;
stairs(x,flo,'r','LineWidth',2); hold on;
stairs(x,fup,'r','LineWidth',2);
stairs(x,f,'k','LineWidth',3);
legend('lower Confidence','Upper Confidence','Mean','Location','NorthWest');
xlabel('R'); ylabel('F(R)'); title('Sample Correlation ecdf');
set(gcf,'Color','w');
saveas(gcf,sprintf('%s/figures/%s_sample_corr_ecdf.png',outputDir,baseName),'png');
close(gcf);

plotAndSaveSampleInfVsObs(inferredReord,observedReord,sortedSampleCorrsInd(1),...
                          sprintf('%s/figures/%s_worst_sample_corr.png',outputDir,baseName));
plotAndSaveSampleInfVsObs(inferredReord,observedReord,sortedSampleCorrsInd(2),...
                          sprintf('%s/figures/%s_second_worst_sample_corr.png',outputDir,baseName));
plotAndSaveSampleInfVsObs(inferredReord,observedReord,sortedSampleCorrsInd(end),...
                          sprintf('%s/figures/%s_best_sample_corr.png',outputDir,baseName));
plotAndSaveSampleInfVsObs(inferredReord,observedReord,sortedSampleCorrsInd(end-1),...
                          sprintf('%s/figures/%s_second_best_sample_corr.png',outputDir,baseName));
medianSortedSampleCorrsInd = round(length(sortedSampleCorrsInd)/2);
plotAndSaveSampleInfVsObs(inferredReord,observedReord,sortedSampleCorrsInd(medianSortedSampleCorrsInd),...
                          sprintf('%s/figures/%s_median_sample_corr.png',outputDir,baseName));
                          
%compute the probe-wise correlations for all probes    
disp('computing full probe set correlations...');
numProbes= length(observed.rid);
pairedProbeCorrs = zeros(1,numProbes);
for ii = 1:numProbes
    pairedProbeCorrs(ii) = fastcorr(transpose(observedReord.mat(ii,:)),transpose(inferredReord.mat(ii,:)));
end
pairedProbeCorrs(isnan(pairedProbeCorrs)) = 0;

%save the probe corrs to a gct file
gctBase = observedReord;
gctBase.mat = transpose(pairedProbeCorrs);
gctBase.cid = {'sampleCorrs'};
mkgct(sprintf('%s/data/%s_paired_probe_corrs',outputDir,baseName),gctBase);

%plot the ecdf of the paired Probe correlations
%plot the 2 worst and 2 best correlated Probes as well as the median Probe.
[sortedProbeCorrs,sortedProbeCorrsInd] = sort(pairedProbeCorrs);

[f,x,flo,fup] = ecdf(pairedProbeCorrs);
figureoff;
stairs(x,flo,'r','LineWidth',2); hold on;
stairs(x,fup,'r','LineWidth',2);
stairs(x,f,'k','LineWidth',3);
legend('lower Confidence','Upper Confidence','Mean','Location','NorthWest');
xlabel('R'); ylabel('F(R)'); title('Probe Correlation ecdf');
set(gcf,'Color','w');
saveas(gcf,sprintf('%s/figures/%s_Probe_corr_ecdf.png',outputDir,baseName),'png');
close(gcf);

plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(1),...
                          sprintf('%s/figures/%s_worst_Probe_corr.png',outputDir,baseName));
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(2),...
                          sprintf('%s/figures/%s_second_worst_Probe_corr.png',outputDir,baseName));
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(end-978),...
                          sprintf('%s/figures/%s_best_Probe_corr.png',outputDir,baseName));
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(end-979),...
                          sprintf('%s/figures/%s_second_best_Probe_corr.png',outputDir,baseName));
medianSortedProbeCorrsInd = round(length(sortedProbeCorrsInd)/2);
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(medianSortedProbeCorrsInd),...
                          sprintf('%s/figures/%s_median_Probe_corr.png',outputDir,baseName));
                          


%generate a .tex and .pdf report 
    %write header
    fid = fopen(sprintf('%s/report/%s_report.tex',outputDir,baseName),'w');
    tex_includes(fid);
    tex_title_author_date(fid,horzcat(dashit(baseName),' inference report}'),'CMap');

    %write comparison parameters
    tex_line(fid,'\section{Inference Comparison Parameters}');
    tex_line(fid,horzcat('\textbf{Data file 1=} ',dashit(gct_one)));
    tex_line(fid,horzcat('\textbf{Data file 2=} ',dashit(gct_two)));
    
    %write sample correlation report
    tex_line(fid,'\section{Sample Correlation}');
    tex_line(fid,horzcat('Mean R = ',num2str(mean(pairedSampleCorrs))));
    tex_line(fid,horzcat('R standard deviation = ',num2str(std(pairedSampleCorrs))));
    tex_line(fid,horzcat('Median R  = ',num2str(median(pairedSampleCorrs))));
    tex_line(fid,horzcat('Samples above mean correlation = ',...
                num2str(length(find(pairedSampleCorrs>mean(pairedSampleCorrs))))));
    if numSamples <= args.sc
        tex_fig(fid,horzcat('../figures/',baseName,'_sample_corr_summary.png'),...
                            'Sample Correlation Summary');
        tex_fig(fid,horzcat('../figures/',baseName,'_sample_corr_heatmap.png'),...
                            'Sample Correlation Summary');
        tex_line(fid,'\clearpage');        
    end
    tex_fig(fid,horzcat('../figures/',baseName,'_sample_corr_ecdf.png'),...
                        'Sample Correlation ecdf');
    tex_line(fid,'\clearpage');
    tex_fig_two_panel(fid,horzcat('../figures/',baseName,'_best_sample_corr.png'),...
               horzcat('Best Sample, R = ',num2str(sortedSampleCorrs(end))),...
               horzcat('../figures/',baseName,'_second_best_sample_corr.png'),...
               horzcat('Second Best Sample, R = ',num2str(sortedSampleCorrs(end-1))),...
               'Best Samples');
    tex_fig(fid,horzcat('../figures/',baseName,'_median_sample_corr.png'),['Median Sample, R = '...
                                    num2str(sortedSampleCorrs(medianSortedSampleCorrsInd))],'0.45');           
    tex_fig_two_panel(fid,horzcat('../figures/',baseName,'_worst_sample_corr.png'),...
               horzcat('Worst Sample, R = ',num2str(sortedSampleCorrs(1))),...
               horzcat('../figures/',baseName,'_second_worst_sample_corr.png'),...
               horzcat('Second Worst Sample, R = ',num2str(sortedSampleCorrs(2))),...
               'Worst Samples');
           
    %write probe correlation report
        %all probes
        tex_line(fid,'\clearpage');
        tex_line(fid,'\section{Probe Correlation}');
        tex_line(fid,'\subsection{All Probes}');
        tex_line(fid,horzcat('Mean correlation coefficient = ',num2str(mean(pairedProbeCorrs))));
        tex_line(fid,horzcat('Correlation coefficient standard deviation = ',num2str(std(pairedProbeCorrs))));
        tex_line(fid,horzcat('Samples above mean correlation = ',...
                    num2str(length(find(pairedProbeCorrs>mean(pairedProbeCorrs))))));
        tex_fig(fid,horzcat('../figures/',baseName,'_Probe_corr_ecdf.png'),'Probe Correlation ecdf');
        tex_line(fid,'\clearpage');
        tex_fig_two_panel(fid,horzcat('../figures/',baseName,'_best_Probe_corr.png'),...
                   horzcat('Best Probe, R = ',num2str(sortedProbeCorrs(end-978))),...
                   horzcat('../figures/',baseName,'_second_best_Probe_corr.png'),...
                   horzcat('Second Best Probe, R = ',num2str(sortedProbeCorrs(end-979))),...
                   'Best Probes');
        tex_fig(fid,horzcat('../figures/',baseName,'_median_Probe_corr.png'),...
                    horzcat('Median Probe, R = ',num2str(sortedProbeCorrs(medianSortedProbeCorrsInd))),'0.45');           
        tex_fig_two_panel(fid,horzcat('../figures/',baseName,'_worst_Probe_corr.png'),...
                   horzcat('Worst Probe, R = ',num2str(sortedProbeCorrs(1))),...
                   horzcat('../figures/',baseName,'_second_worst_Probe_corr.png'),...
                   horzcat('Second Worst Probe, R = ',num2str(sortedProbeCorrs(2))),...
                   'Worst Probes');
        landmarkList =  parse_grp([inferencePath 'lm_epsilon5253_978.grp']);%load landmarks list for use below
        
        %sweet space probes
        tex_line(fid,'\clearpage');
        tex_line(fid,'\subsection{Sweet Space Probes}');
        sweet_space_n7096 = parse_grp([inferencePath 'sweet_affx_n7096.grp']);
        diff = setdiff(sweet_space_n7096,landmarkList);
        [f_sweet,x_sweet] = makeProbeFiguresAndTexForList(observed,inferred,...
                diff,outputDir,baseName,'sweet',fid);

        %probes over expression of args.ec log units in the observed data
        tex_line(fid,'\clearpage');
        tex_line(fid,'\subsection{Probes over expression cutoff}');
        tex_line(fid,horzcat('\textbf{Expression cutoff = } ',num2str(args.ec)));
        probeNamesExp6 = filter_probes_exp_list(observed,args.ec);
        diff = setdiff(probeNamesExp6,landmarkList);
        [f_exp6,x_exp6] = makeProbeFiguresAndTexForList(observed,inferred,...
                diff,outputDir,baseName,'exp',fid);
        
        if strcmp(args.style,'long')
            %most Variable 1000 probes in the observed data
            tex_line(fid,'\clearpage');
            tex_line(fid,'\subsection{1000 Most Variable Observed Probes}');
            probeNames1000 = filter_probes_var_list(observed,1000);
            diff = setdiff(probeNames1000,landmarkList);
            [f_cv1000,x_cv1000] = makeProbeFiguresAndTexForList(observed,inferred,...
                    diff,outputDir,baseName,'cv1000',fid);
                
            %least Variable 1000 probes in the observed data
            tex_line(fid,'\clearpage');
            tex_line(fid,'\subsection{1000 Least Variable Observed Probes}');
            probeNames21268 = filter_probes_var_list(observed,21268);
            [commonset,probeNames21268Inds,fullProbeInds] = intersect_ord(probeNames21268,observed.rid);
            probeNamesUnder21268 = observed.rid;
            probeNamesUnder21268(fullProbeInds)=[];
            diff = setdiff(probeNames21268,landmarkList);
            [f_cvUnder21268,x_cvUnder21268] = makeProbeFiguresAndTexForList(observed,inferred,...
                    diff,outputDir,baseName,'cvUnder21268',fid);
        end

        %write a summary of all probe sets examined
        figureoff;
        hold on;
        stairs(x_sweet,f_sweet,'r','LineWidth',2);
        stairs(x_exp6,f_exp6,'g','LineWidth',2);
        if strcmp(args.style,'long')
            stairs(x_cv1000,f_cv1000,'c','LineWidth',2);
            stairs(x_cvUnder21268,f_cvUnder21268,'b','LineWidth',2);
        end
        stairs(x,f,'k','LineWidth',5); 
        xlabel('R'); ylabel('F(R)'); title('Probe Correlation ecdf');
        if strcmp(args.style,'long')
            legend('Sweet Space',['Expression over ' num2str(args.ec)],'1000 Most Variable',...
                    '1000 Least Variable','All Probes','Location','NorthWest');
        else
            legend('Sweet Space',['Expression over ' num2str(args.ec)],'All Probes','Location','NorthWest');
        end
        set(gcf,'Color','w');
        saveas(gcf,sprintf('%s/figures/%s_Probe_corr_ecdf_summary.png',outputDir,baseName),'png');
        close(gcf);
        
        tex_line(fid,'\clearpage');
        tex_line(fid,'\subsection{Probe Correlation Summary}');
        tex_fig(fid,horzcat('../figures/',baseName,'_Probe_corr_ecdf_summary.png'),'Probe Correlation Summary');
        
        %write a summary table reported as raw numbers
        tex_line(fid,'\clearpage');
        tex_line(fid,'\begin{table}\caption{Number of probes by correlation value}\begin{tabular}{|l|c c c c c c|}',0)
        tex_line(fid,'\hline',0);
        tex_line(fid,'Set Name&$R < 0$&$0-0.2$&$0.2-0.4$&$0.4-0.6$&$0.6-0.8$&0.8-1$');
        tex_line(fid,'\hline',0);
        tex_line(fid,horzcat('All Probes&',num2str(length(find(x<0))),'&',...
                num2str(length(find(x<0.2&x>=0))),'&',...
                num2str(length(find(x<0.4&x>=0.2))),'&',...
                num2str(length(find(x<0.6&x>=0.4))),'&',...
                num2str(length(find(x<0.8&x>=0.6))),'&',...
                num2str(length(find(x<=1&x>=0.8)))));
        tex_line(fid,horzcat('Sweet Space&',num2str(length(find(x_sweet<0))),'&',...
                num2str(length(find(x_sweet<0.2&x_sweet>=0))),'&',...
                num2str(length(find(x_sweet<0.4&x_sweet>=0.2))),'&',...
                num2str(length(find(x_sweet<0.6&x_sweet>=0.4))),'&',...
                num2str(length(find(x_sweet<0.8&x_sweet>=0.6))),'&',...
                num2str(length(find(x_sweet<=1&x_sweet>=0.8)))));
        tex_line(fid,horzcat('Exp \textgreater 6&',num2str(length(find(x_exp6<0))),'&',...
                num2str(length(find(x_exp6<0.2&x_exp6>=0))),'&',...
                num2str(length(find(x_exp6<0.4&x_exp6>=0.2))),'&',...
                num2str(length(find(x_exp6<0.6&x_exp6>=0.4))),'&',...
                num2str(length(find(x_exp6<0.8&x_exp6>=0.6))),'&',...
                num2str(length(find(x_exp6<=1&x_exp6>=0.8)))));
        if strcmp(args.style,'long')
            tex_line(fid,horzcat('1000 Most Variable&',num2str(length(find(x_cv1000<0))),'&',...
                    num2str(length(find(x_cv1000<0.2&x_cv1000>=0))),'&',...
                    num2str(length(find(x_cv1000<0.4&x_cv1000>=0.2))),'&',...
                    num2str(length(find(x_cv1000<0.6&x_cv1000>=0.4))),'&',...
                    num2str(length(find(x_cv1000<0.8&x_cv1000>=0.6))),'&',...
                    num2str(length(find(x_cv1000<=1&x_cv1000>=0.8)))));
            tex_line(fid,horzcat('1000 Least Variable&',num2str(length(find(x_cvUnder21268<0))),'&',...
                    num2str(length(find(x_cvUnder21268<0.2&x_cvUnder21268>=0))),'&',...
                    num2str(length(find(x_cvUnder21268<0.4&x_cvUnder21268>=0.2))),'&',...
                    num2str(length(find(x_cvUnder21268<0.6&x_cvUnder21268>=0.4))),'&',...
                    num2str(length(find(x_cvUnder21268<0.8&x_cvUnder21268>=0.6))),'&',...
                    num2str(length(find(x_cvUnder21268<=1&x_cvUnder21268>=0.8)))));
        end
        tex_line(fid,'\hline',0);
        tex_line(fid,'\end{tabular}\end{table}');

        %reported as proportions
        tex_line(fid,'\begin{table}\caption{Percentage of probes by correlation value}\begin{tabular}{|l|c c c c c c|}',0)
        tex_line(fid,'\hline',0);
        tex_line(fid,'Set Name&$R < 0$&$0-0.2$&$0.2-0.4$&$0.4-0.6$&$0.6-0.8$&0.8-1$');
        tex_line(fid,'\hline',0);
        x_len = length(x);
        tex_line(fid,horzcat('All Probes&',num2str(length(find(x<0))/x_len*100),'&',...
                num2str(length(find(x<0.2&x>=0))/x_len*100),'&',...
                num2str(length(find(x<0.4&x>=0.2))/x_len*100),'&',...
                num2str(length(find(x<0.6&x>=0.4))/x_len*100),'&',...
                num2str(length(find(x<0.8&x>=0.6))/x_len*100),'&',...
                num2str(length(find(x<=1&x>=0.8))/x_len*100)));
        x_len = length(x_sweet);
        tex_line(fid,horzcat('Sweet Space&',num2str(length(find(x_sweet<0))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.2&x_sweet>=0))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.4&x_sweet>=0.2))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.6&x_sweet>=0.4))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.8&x_sweet>=0.6))/x_len*100),'&',...
                num2str(length(find(x_sweet<=1&x_sweet>=0.8))/x_len*100)));
        x_len = length(x_exp6);
        tex_line(fid,horzcat('Exp \textgreater 6&',num2str(length(find(x_exp6<0))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.2&x_exp6>=0))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.4&x_exp6>=0.2))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.6&x_exp6>=0.4))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.8&x_exp6>=0.6))/x_len*100),'&',...
                num2str(length(find(x_exp6<=1&x_exp6>=0.8))/x_len*100)));
        if strcmp(args.style,'long')
            x_len = length(x_cv1000);
            tex_line(fid,horzcat('1000 Most Variable&',num2str(length(find(x_cv1000<0))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.2&x_cv1000>=0))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.4&x_cv1000>=0.2))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.6&x_cv1000>=0.4))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.8&x_cv1000>=0.6))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<=1&x_cv1000>=0.8))/x_len*100)));
            x_len = length(x_cvUnder21268);
            tex_line(fid,horzcat('1000 Least Variable&',num2str(length(find(x_cvUnder21268<0))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.2&x_cvUnder21268>=0))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.4&x_cvUnder21268>=0.2))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.6&x_cvUnder21268>=0.4))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.8&x_cvUnder21268>=0.6))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<=1&x_cvUnder21268>=0.8))/x_len*100)));
        end
        tex_line(fid,'\hline',0);
        tex_line(fid,'\end{tabular}\end{table}');

        %reported as cumulative totals
        tex_line(fid,'\begin{table}\caption{Cumulative number of probes by correlation value}\begin{tabular}{|l|c c c c c c|}',0)
        tex_line(fid,'\hline',0);
        tex_line(fid,'Set Name&$R < 0$&$R < 0.2$&$R < 0.4$&$R < 0.6$&$R < 0.8$&R \le 1$');
        tex_line(fid,'\hline',0);
        tex_line(fid,horzcat('All Probes&',num2str(length(find(x<0))),'&',...
                num2str(length(find(x<0.2))),'&',...
                num2str(length(find(x<0.4))),'&',...
                num2str(length(find(x<0.6))),'&',...
                num2str(length(find(x<0.8))),'&',...
                num2str(length(find(x<=1)))));
        tex_line(fid,horzcat('Sweet Space&',num2str(length(find(x_sweet<0))),'&',...
                num2str(length(find(x_sweet<0.2))),'&',...
                num2str(length(find(x_sweet<0.4))),'&',...
                num2str(length(find(x_sweet<0.6))),'&',...
                num2str(length(find(x_sweet<0.8))),'&',...
                num2str(length(find(x_sweet<=1)))));
        tex_line(fid,horzcat('Exp \textgreater 6&',num2str(length(find(x_exp6<0))),'&',...
                num2str(length(find(x_exp6<0.2))),'&',...
                num2str(length(find(x_exp6<0.4))),'&',...
                num2str(length(find(x_exp6<0.6))),'&',...
                num2str(length(find(x_exp6<0.8))),'&',...
                num2str(length(find(x_exp6<=1)))));
        if strcmp(args.style,'long')
            tex_line(fid,horzcat('1000 Most Variable&',num2str(length(find(x_cv1000<0))),'&',...
                    num2str(length(find(x_cv1000<0.2))),'&',...
                    num2str(length(find(x_cv1000<0.4))),'&',...
                    num2str(length(find(x_cv1000<0.6))),'&',...
                    num2str(length(find(x_cv1000<0.8))),'&',...
                    num2str(length(find(x_cv1000<=1)))));
            tex_line(fid,horzcat('1000 Least Variable&',num2str(length(find(x_cvUnder21268<0))),'&',...
                    num2str(length(find(x_cvUnder21268<0.2))),'&',...
                    num2str(length(find(x_cvUnder21268<0.4))),'&',...
                    num2str(length(find(x_cvUnder21268<0.6))),'&',...
                    num2str(length(find(x_cvUnder21268<0.8))),'&',...
                    num2str(length(find(x_cvUnder21268<=1)))));
        end
        tex_line(fid,'\hline',0);
        tex_line(fid,'\end{tabular}\end{table}');

        %reported as cumulative proportions
        tex_line(fid,'\begin{table}\caption{Cumulative percentage of probes by correlation value}\begin{tabular}{|l|c c c c c c|}',0)
        tex_line(fid,'\hline',0);
        tex_line(fid,'Set Name&$R < 0$&$R < 0.2$&$R < 0.4$&$R < 0.6$&$R < 0.8$&R \le 1$');
        tex_line(fid,'\hline',0);
        x_len = length(x);
        tex_line(fid,horzcat('All Probes&',num2str(length(find(x<0))/x_len*100),'&',...
                num2str(length(find(x<0.2))/x_len*100),'&',...
                num2str(length(find(x<0.4))/x_len*100),'&',...
                num2str(length(find(x<0.6))/x_len*100),'&',...
                num2str(length(find(x<0.8))/x_len*100),'&',...
                num2str(length(find(x<=1.1))/x_len*100)));
        x_len = length(x_sweet);
        tex_line(fid,horzcat('Sweet Space&',num2str(length(find(x_sweet<0))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.2))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.4))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.6))/x_len*100),'&',...
                num2str(length(find(x_sweet<0.8))/x_len*100),'&',...
                num2str(length(find(x_sweet<=1))/x_len*100)));
        x_len = length(x_exp6);
        tex_line(fid,horzcat('Exp \textgreater 6&',num2str(length(find(x_exp6<0))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.2))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.4))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.6))/x_len*100),'&',...
                num2str(length(find(x_exp6<0.8))/x_len*100),'&',...
                num2str(length(find(x_exp6<=1))/x_len*100)));
        if strcmp(args.style,'long')
            x_len = length(x_cv1000);
            tex_line(fid,horzcat('1000 Most Variable&',num2str(length(find(x_cv1000<0))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.2))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.4))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.6))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<0.8))/x_len*100),'&',...
                    num2str(length(find(x_cv1000<=1))/x_len*100)));
            x_len = length(x_cvUnder21268);
            tex_line(fid,horzcat('1000 Least Variable&',num2str(length(find(x_cvUnder21268<0))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.2))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.4))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.6))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<0.8))/x_len*100),'&',...
                    num2str(length(find(x_cvUnder21268<=1))/x_len*100)));
        end
        tex_line(fid,'\hline',0);
        tex_line(fid,'\end{tabular}\end{table}');
    
    %close the document and compile it
fprintf(fid,'%s\n','\end{document}');
fclose(fid);
pdflatex(sprintf('%s/report/%s_report.tex',outputDir,baseName),'cleanup',1);


%set default figure visability to 'on'
set(0, 'DefaultFigureVisible', 'on');


%BEGIN UTILITY FUNCTIONS

function gctName = getGCTBaseName(pathToGCT)
%utility function to strip off the _nXXXxXXX.gct file ending as well as any the path leading up
%to the file name of a given .gct file
extenstionInd = regexp(pathToGCT,'_n');
baseString = pathToGCT(1:extenstionInd-1);
[gctPath,gctName,gctExt] = fileparts(baseString);

function pieceFlag = isFilePiece(filePieceString,fileList)
%utility funciton to determine the existance of a file from a piece of its name in the given file list
indCell = cellfun(@(x)regexp(x,filePieceString),{fileList(:).name},'UniformOutput',0);
if isempty(cell2mat(indCell))
    pieceFlag = 0;
else
    pieceFlag = 1;
end

function fileString = fullFileFromPiece(filePieceString,fileList)
%utility funciton to return a full file name from a piece of its name in the given file list
indCell = cellfun(@(x)regexp(x,filePieceString),{fileList(:).name},'UniformOutput',0);
notEmpties = ~cellfun(@isempty,indCell);
fileInd = find(notEmpties==1,1);
fileString = fileList(fileInd).name;

function plotAndSaveSampleInfVsObs(inferredStruct,observedStruct,sampleNum,plotOut)
%utility funciton to plot and save sample expression figures to the ouput directory
figureoff;
plot(inferredStruct.mat(:,sampleNum),observedStruct.mat(:,sampleNum),'.');
set(gca,'XLim',[4 15]);
set(gca,'YLim',[4 15]);
xlabel('Observed Probe Data');
ylabel('Inferred Probe Data');
title(sprintf('Probe expression for %s',inferredStruct.cid{sampleNum}));
set(gcf,'Color','w');
saveas(gcf,plotOut,'png');
close(gcf);

function plotAndSaveProbeInfVsObs(inferredStruct,observedStruct,ProbeNum,plotOut)
%utility funciton to plot and save Probe expression figures to the ouput directory
figure;
plot(inferredStruct.mat(ProbeNum,:),observedStruct.mat(ProbeNum,:),'.','MarkerSize',20);
xlabel('Observed Sample Data');
ylabel('Inferred Sample Data');
title(sprintf('Probe expression for %s',inferredStruct.rid{ProbeNum}));
set(gcf,'Color','w');
saveas(gcf,plotOut,'png');
close(gcf);

function [f,x] = makeProbeFiguresAndTexForList(observed,inferred,probeList,outputDir,baseName,listName,fid)
%write the list of probes used to filter to file
probeListPath = sprintf('%s/data/%s_%s.grp',outputDir,baseName,listName);
mkgrp(probeListPath,probeList);

%compute the probe-wise correlations for probes in the probeList set
disp(['computing ' listName ' probe set correlations...']);
observedReord = filter_probes(observed,probeList);
inferredReord = filter_probes(inferred,probeList);
numProbes= length(observedReord.rid);
pairedProbeCorrs = zeros(1,numProbes);
for ii = 1:numProbes
    pairedProbeCorrs(ii) = fastcorr(transpose(observedReord.mat(ii,:)),transpose(inferredReord.mat(ii,:)));
end
pairedProbeCorrs(isnan(pairedProbeCorrs)) = 0;

%plot the ecdf of the paired Probe correlations
%plot the 2 worst and 2 best correlated Probes as well as the median Probe.
[sortedProbeCorrs,sortedProbeCorrsInd] = sort(pairedProbeCorrs);

ecdfPath = sprintf('%s/figures/%s_%s_Probe_corr_ecdf.png',outputDir,baseName,listName);
[f,x] = correlation_ecdf(observedReord,inferredReord,'output',ecdfPath,...
                                                    'listFilter',probeListPath,...
                                                    'plotTitle',[listName ' Probes']);


plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(1),...
                          sprintf('%s/figures/%s_%s_worst_Probe_corr.png',outputDir,baseName,listName));
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(2),...
                          sprintf('%s/figures/%s_%s_second_worst_Probe_corr.png',outputDir,baseName,listName));
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(end),...
                          sprintf('%s/figures/%s_%s_best_Probe_corr.png',outputDir,baseName,listName));
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(end-1),...
                          sprintf('%s/figures/%s_%s_second_best_Probe_corr.png',outputDir,baseName,listName));
medianSortedProbeCorrsInd = round(length(sortedProbeCorrsInd)/2);
plotAndSaveProbeInfVsObs(inferredReord,observedReord,sortedProbeCorrsInd(medianSortedProbeCorrsInd),...
                          sprintf('%s/figures/%s_%s_median_Probe_corr.png',outputDir,baseName,listName));


%tex report                          
tex_line(fid,horzcat('Mean correlation coefficient = ',num2str(mean(pairedProbeCorrs))));
tex_line(fid,horzcat('Correlation coefficient standard deviation = ',num2str(std(pairedProbeCorrs))));
tex_line(fid,horzcat('Probes above mean correlation = ',...
            num2str(length(find(pairedProbeCorrs>mean(pairedProbeCorrs))))));
tex_line(fid,horzcat('list of filtered probes = ',dashit(probeListPath)));
            
tex_fig(fid,horzcat('../figures/',baseName,'_',listName,'_Probe_corr_ecdf.png'),'Probe Correlation ecdf');
tex_line(fid,'\clearpage');

tex_fig_two_panel(fid,horzcat('../figures/',baseName,'_',listName,'_best_Probe_corr.png'),...
           horzcat('Best Probe, R = ',num2str(sortedProbeCorrs(end))),...
           horzcat('../figures/',baseName,'_',listName,'_second_best_Probe_corr.png'),...
           horzcat('Second Best Probe, R = ',num2str(sortedProbeCorrs(end-1))),...
           'Best Probes');
tex_fig(fid,horzcat('../figures/',baseName,'_',listName,'_median_Probe_corr.png'),...
            horzcat('Median Probe, R = ',num2str(sortedProbeCorrs(medianSortedProbeCorrsInd))),'0.45');           
tex_fig_two_panel(fid,horzcat('../figures/',baseName,'_',listName,'_worst_Probe_corr.png'),...
           horzcat('Worst Probe, R = ',num2str(sortedProbeCorrs(1))),...
           horzcat('../figures/',baseName,'_',listName,'_second_worst_Probe_corr.png'),...
           horzcat('Second Worst Probe, R = ',num2str(sortedProbeCorrs(2))),...
           'Worst Probes');

