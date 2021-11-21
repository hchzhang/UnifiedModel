%__________________________________________________________________________
% violin.m - Simple violin plot using matlab default kernel density estimation
% Last update: 10/2015
%__________________________________________________________________________
% This function creates violin plots based on kernel density estimation
% using ksdensity with default settings. Please be careful when comparing pdfs
% estimated with different bandwidth!
%
% Differently to other boxplot functions, you may specify the x-position.
% This is usefule when overlaying with other data / plots.
%__________________________________________________________________________
%
% Please cite this function as:
% Hoffmann H, 2015: violin.m - Simple violin plot using matlab default kernel
% density estimation. INRES (University of Bonn), Katzenburgweg 5, 53115 Germany.
% hhoffmann@uni-bonn.de
%
%__________________________________________________________________________
%
% INPUT
%
% Y:     Data to be plotted, being either
%        a) n x m matrix. A 'violin' is plotted for each column m, OR
%        b) 1 x m Cellarry with elements being numerical colums of nx1 length.
%
% varargin:
% xlabel:    xlabel. Set either [] or in the form {'txt1','txt2','txt3',...}
% facecolor: FaceColor. (default [1 0.5 0]); Specify abbrev. or m x 3 matrix (e.g. [1 0 0])
% edgecolor: LineColor. (default 'k'); Specify abbrev. (e.g. 'k' for black); set either [],'' or 'none' if the mean should not be plotted
% facealpha: Alpha value (transparency). default: 0.5
% mc:        Color of the bars indicating the mean. (default 'k'); set either [],'' or 'none' if the mean should not be plotted
% medc:      Color of the bars indicating the median. (default 'r'); set either [],'' or 'none' if the mean should not be plotted
% bw:        Kernel bandwidth. (default []); prescribe if wanted as follows:
%            a) if bw is a single number, bw will be applied to all
%            columns or cells
%            b) if bw is an array of 1xm or mx1, bw(i) will be applied to cell or column (i).
%            c) if bw is empty (default []), the optimal bandwidth for
%            gaussian kernel is used (see Matlab documentation for
%            ksdensity()
%
% OUTPUT
%
% h:     figure handle
% L:     Legend handle
% MX:    Means of groups
% MED:   Medians of groups
% bw:    bandwidth of kernel
%__________________________________________________________________________
%{
% Example1 (default):
disp('this example uses the statistical toolbox')
Y=[rand(1000,1),gamrnd(1,2,1000,1),normrnd(10,2,1000,1),gamrnd(10,0.1,1000,1)];
[h,L,MX,MED]=violin(Y);
ylabel('\Delta [yesno^{-2}]','FontSize',14)

%Example2 (specify facecolor, edgecolor, xlabel):
disp('this example uses the statistical toolbox')
Y=[rand(1000,1),gamrnd(1,2,1000,1),normrnd(10,2,1000,1),gamrnd(10,0.1,1000,1)];
violin(Y,'xlabel',{'a','b','c','d'},'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','b',...
'bw',0.3,...
'mc','k',...
'medc','r--')
ylabel('\Delta [yesno^{-2}]','FontSize',14)

%Example3 (specify x axis location):
disp('this example uses the statistical toolbox')
Y=[rand(1000,1),gamrnd(1,2,1000,1),normrnd(10,2,1000,1),gamrnd(10,0.1,1000,1)];
violin(Y,'x',[-1 .7 3.4 8.8],'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','none',...
'bw',0.3,'mc','k','medc','r-.')
axis([-2 10 -0.5 20])
ylabel('\Delta [yesno^{-2}]','FontSize',14)

%Example4 (Give data as cells with different n):
disp('this example uses the statistical toolbox')
Y{:,1}=rand(10,1);
Y{:,2}=rand(1000,1);
violin(Y,'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','none','bw',0.1,'mc','k','medc','r-.')
ylabel('\Delta [yesno^{-2}]','FontSize',14)
%}
%%
function[h,L,MX,MED,bw,pbar,pave,pmd]=violinplot_positive(Y,varargin)
%defaults:
%_____________________
xL=[];
fc=[1 0.5 0];
lc='k';
alp=0.5;
mc='k';
medc='r';
b=[]; %bandwidth
plotlegend=1;
plotmean=1;
plotmedian=1;
x = [];
%_____________________
%convert single columns to cells:
if iscell(Y)==0
    Y = num2cell(Y,1);
end
%get additional input parameters (varargin)
if isempty(find(strcmp(varargin,'xlabel')))==0
    xL = varargin{find(strcmp(varargin,'xlabel'))+1};
end
if isempty(find(strcmp(varargin,'facecolor')))==0
    fc = varargin{find(strcmp(varargin,'facecolor'))+1};
end
if isempty(find(strcmp(varargin,'edgecolor')))==0
    lc = varargin{find(strcmp(varargin,'edgecolor'))+1};
end
if isempty(find(strcmp(varargin,'barcolor')))==0
    bcolor = varargin{find(strcmp(varargin,'barcolor'))+1};
end
if isempty(find(strcmp(varargin,'facealpha')))==0
    alp = varargin{find(strcmp(varargin,'facealpha'))+1};
end
if isempty(find(strcmp(varargin,'mc')))==0
    if isempty(varargin{find(strcmp(varargin,'mc'))+1})==0
        plotmean = 1;
    else
        plotmean = 0;
    end
end
if isempty(find(strcmp(varargin,'medc')))==0
    if isempty(varargin{find(strcmp(varargin,'medc'))+1})==0
        plotmedian = 1;
    else
        plotmedian = 0;
    end
end
if isempty(find(strcmp(varargin,'bw')))==0
    b = varargin{find(strcmp(varargin,'bw'))+1};
    if length(b)==1
        b=repmat(b,size(Y,2),1);
    elseif length(b)~=size(Y,2)
        warning('length(b)~=size(Y,2)')
    end
end
if isempty(find(strcmp(varargin,'vw')))==0
    vw = varargin{find(strcmp(varargin,'vw'))+1};
    if length(vw)==1
        vw=repmat(vw,size(Y,2),1);
    elseif length(vw)~=size(Y,2)
        warning('length(vb)~=size(Y,2)');
    end
end
if isempty(find(strcmp(varargin,'qw')))==0
    qw = varargin{find(strcmp(varargin,'qw'))+1};
    if length(qw)==1
        qw=repmat(qw,size(Y,2),1);
    elseif length(qw)~=size(Y,2)
        warning('length(qw)~=size(Y,2)');
    end
end
if isempty(find(strcmp(varargin,'tw')))==0
    tw = varargin{find(strcmp(varargin,'tw'))+1};
    if length(tw)==1
        tw=repmat(tw,size(Y,2),1);
    elseif length(tw)~=size(Y,2)
        warning('length(vb)~=size(Y,2)');
    end
end
%
if isempty(find(strcmp(varargin,'avemark')))==0
    avemark = varargin{find(strcmp(varargin,'avemark'))+1};
end
if isempty(find(strcmp(varargin,'avecolor')))==0
    avecolor = varargin{find(strcmp(varargin,'avecolor'))+1};
end
if isempty(find(strcmp(varargin,'mdmark')))==0
    mdmark = varargin{find(strcmp(varargin,'mdmark'))+1};
end
if isempty(find(strcmp(varargin,'mdcolor')))==0
    mdcolor = varargin{find(strcmp(varargin,'mdcolor'))+1};
end
if isempty(find(strcmp(varargin,'marksz')))==0
    marksz = varargin{find(strcmp(varargin,'marksz'))+1};
end
if isempty(find(strcmp(varargin,'markw')))==0
    markw = varargin{find(strcmp(varargin,'markw'))+1};
end
%
if isempty(find(strcmp(varargin,'plotlegend')))==0
    plotlegend = varargin{find(strcmp(varargin,'plotlegend'))+1};
end
if isempty(find(strcmp(varargin,'x')))==0
    x = varargin{find(strcmp(varargin,'x'))+1};
end
%%
if size(fc,1)==1
    fc=repmat(fc,size(Y,2),1);
end
%% Calculate the kernel density
i=1;
for i=1:size(Y,2)
    
    if isempty(b)==0
        [f, u, bb]=ksdensity(Y{i},'bandwidth',b(i),'Support','positive');
    elseif isempty(b)
        [f, u, bb]=ksdensity(Y{i},'Support','positive');
    end
    
    f=f/max(f)*vw(i); %normalize
    f(u>1)=0;
    
    F(:,i)=f;
    U(:,i)=u;
    MED(:,i)=nanmedian(Y{i});
    MX(:,i)=nanmean(Y{i});
    bw(:,i)=bb;

end
%%
%-------------------------------------------------------------------------
% Put the figure automatically on a second monitor
% mp = get(0, 'MonitorPositions');
% set(gcf,'Color','w','Position',[mp(end,1)+50 mp(end,2)+50 800 600])
%-------------------------------------------------------------------------
%Check x-value options
if isempty(x)
    x = zeros(size(Y,2));
    setX = 0;
else
    setX = 1;
    if isempty(xL)==0
        disp('_________________________________________________________________')
        warning('Function is not designed for x-axis specification with string label')
        warning('when providing x, xlabel can be set later anyway')
        error('please provide either x or xlabel. not both.')
    end
end
%% Plot the violins
i=1;
pbar(i)=0;
pave(i)=0;
pmd(i)=0;
for i=i:size(Y,2)
    % Violin area
    if isempty(lc) == 1
        if setX == 0
            h(i)=fill([F(:,i)+i;flipud(i-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor','none');
        else
            h(i)=fill([F(:,i)+x(i);flipud(x(i)-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor','none');
        end
    else
        if setX == 0
            h(i)=fill([F(:,i)+i;flipud(i-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor','none');
        else
            h(i)=fill([F(:,i)+x(i);flipud(x(i)-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor','none');
        end
    end
    hold on
    % Percentie 
    subY=sort(Y{i});
    p05=prctile(subY,5);
    p25=prctile(subY,25);
    p50=prctile(subY,50);
    p75=prctile(subY,75);
    p95=prctile(subY,95);
    aveY=mean(subY(~isnan(subY)));
    X=[x(i),x(i)];
    Y1=[p05,p95];
    Y2=[p25,p75];
    plot(X,Y1,'Color',bcolor,'LineWidth',tw(i));
    hold on;
    pbar(i)=plot(X,Y2,'Color',bcolor,'LineWidth',qw(i));
    hold on;
    
    if plotmean == 1
        pave(i)=scatter(x(i),aveY,marksz,avecolor,'Marker',avemark,'LineWidth',markw);
    end
    if plotmedian == 1
        pmd(i)=scatter(x(i),p50,marksz,mdcolor,'Marker',mdmark,'LineWidth',markw);
    end
end
%

%% Add legend if requested
if plotlegend==1 & plotmean==1 | plotlegend==1 & plotmedian==1
    
    if plotmean==1 & plotmedian==1
        L=legend([pave(1) pmd(1)],'Mean','Median');
    elseif plotmean==0 & plotmedian==1
        L=legend([pmd(2)],'Median');
    elseif plotmean==1 & plotmedian==0
        L=legend([pave(1)],'Mean');
    end
    
    set(L,'box','off','FontSize',14)
else
    L=[];
end
%% Set axis
% if setX == 0
%     axis([0.5 size(Y,2)+0.5, min(U(:)) max(U(:))]);
% elseif setX == 1
%     axis([min(x)-0.05*range(x) max(x)+0.05*range(x), min(U(:)) max(U(:))]);
% end
%% Set x-labels
xL2={''};
i=1;
for i=1:size(xL,2)
    xL2=[xL2,xL{i},{''}];
end
set(gca,'TickLength',[0 0],'FontSize',12)
box on
if isempty(xL)==0
    set(gca,'XtickLabel',xL2)
end
%-------------------------------------------------------------------------
end %of function