
clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\param_est\mod_yr4_4\';
TEMop=xlsread([inpath,'Phen_ss_param.xlsx'],'Phen_ss_param','AV2:AV6990');
DD=xlsread([inpath,'Phen_ss_param.xlsx'],'Phen_ss_param','AT2:BB6990');
PP=DD;
PP(:,1)=DD(:,9); PP(:,2)=DD(:,8); PP(:,3)=DD(:,3); 
PP(:,4)=DD(:,5); PP(:,5)=DD(:,1); PP(:,6)=DD(:,2); 
PP(:,7)=DD(:,4); PP(:,8)=DD(:,6); PP(:,9)=DD(:,7); 
paramname={'d_{c0}','CHA0','T_{op}','T_{50}','c_1','c_2','c_3','c_4','c_5'};
Ylab={'d_{c0}','CHA0','T_{op} (^oC)','T_{50} (^oC)','c_1','c_2','c_3','c_4','c_5'};
clear DD
SS=[0,1176,1593,2742,5668,6162,6989];
nsamp=length(TEMop(:));
nspec=7; % 6 species + ALL
specname={'Ah','Ag','Bp','Fs','Fe','Qr','All'};
TT={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)','(j)','(k)'};
interval=0;

XX=(1:nspec)-interval;

%%
fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,8,5.5]);

fsize=8;
% 1 - RMSE
% Violin
viowidth = 0.25;
transp=0.25;
% Bar
qwidth=2.5; % 25th-75th
twidth=0.3*qwidth; % 5th-95th
% Dots
avemark='o'; avecolor='k'; % mean
mdmark='^'; mdcolor='r'; % median
marksz=6; markw=1.05;

% subplot(1,2,1);
for i=1:nspec
    if (i<nspec)
        YY=TEMop(SS(i)+1:SS(i+1));
    else
        YY=TEMop(SS(1)+1:SS(i));
    end
    
    % Exclude the extreme values
    Y95p=prctile(YY,98);
    Y5p=prctile(YY,2);
    Y50p=prctile(YY,50);
    
    bandwidth=0.5; % interval
    fillcolor=[0,100,200]/255.0; edgcolor=fillcolor; barcolor=fillcolor;
    [h1,L1,MX1,MED1,bw1,pbar1,pave1,pmd1]=violinplot(YY,'x',XX(i), ...
        'facecolor',fillcolor,'facealpha',transp,...
        'edgecolor',edgcolor,'bw',bandwidth,'vw',viowidth, ...
        'barcolor',barcolor,'qw',qwidth,'tw',twidth, ...
        'avemark',avemark,'avecolor',avecolor,'mdmark',mdmark,'mdcolor',mdcolor, ...
        'marksz',marksz,'markw',markw,'mc','y','medc','y', ...
        'plotlegend',0,'legsize',fsize);
    hold on;
    clear YY;
end

xlim([0.4  7.6]);ylim([-4 16]);
set(gca,'XTick',1:1:7,'TickLength',[0.015;0.025]);
set(gca,'YTick',-3:3:15,'TickLength',[0.015;0.025]);
set(gca,'XTickLabel',' ','fontsize',fsize); % ,'Fontangle','italic'
set(gca,'YTickLabel',-3:3:15,'fontsize',fsize);
set(gca,'Position',[0.13,0.18,0.85,0.81]);
xlabel('Tree species','FontSize',fsize);
ylabel('Temperature (^oC)','FontSize',fsize);
for i=1:nspec
    text(i,-5.2,specname(i),'FontSize',fsize,'Fontangle','italic','horizontalalignment','center');
end
% text(0.6,14.7,'(a)','FontSize',fsize+1,'FontWeight','bold','horizontalalignment','left');
% Delete the ticks in up and right sides
box off;
axes1=axes('Position',get(gca,'Position'), ...
           'XAxisLocation','top', ...
           'YAxisLocation','right', ...
           'Color','none', ...
           'XColor','k','YColor','k');
set(axes1,'YTick', []);
set(axes1,'XTick', []);
box on;
%
% leg1=legend([pbar1(1),pbar2(1)],'Ch_{tem}','Ch_{date}'); % ,'position',[329 135 10 10]
% set(leg1,'position',[0.26,0.94,0.2,0.07],'Orientation','horizontal','FontSize',fsize);
% set(leg1,'box','off');
%
hold off;

print figure
print(fig,'-djpeg','-r300',[outpath,'Chilling_opTem_specal']); 
box off;
close all;


%% All parameters

fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,16,10]);

nrp=3;
ncp=3;
rrs=0.12; heig=0.27; intr=0.02;
ccs=0.08; widd=0.24; intc=0.09;
viowidth = 0.25;
transp=0.25;
% Bar
qwidth=2.5; % 25th-75th
twidth=0.3*qwidth; % 5th-95th
% Dots
avemark='o'; avecolor='k'; % mean
mdmark='^'; mdcolor='r'; % median
marksz=6; markw=1.05;

xmin=0.4; xmax=7.6;
xlabmin=1; xlabmax=7; xlabint=1;
ymina=   [-35, 0., -4, 2.0, 0.000, 0.005, -2.3, 0.00, -0.105];
ymaxa=   [ 95, 38, 16, 16., 0.042, 0.045, 0.40, 165., 0.0250];
ylabmina=[-30, 0., -3, 3.0, 0.000, 0.010, -2.0, 0.00, -0.100]; 
ylabmaxa=[ 90, 35, 15, 15., 0.040, 0.040, 0.00, 150., 0.0200]; 
ylabinta=[ 30, 5., 3., 3.0, 0.010, 0.010, 0.50, 30.0, 0.0200]; 
fsize=8;

% 1 - RMSE
% Violin
for ir=1:nrp
    for ic=1:ncp
        irank=(ir-1)*ncp+ic;
        irpos=rrs+(heig+intr)*(nrp-ir);
        icpos=ccs+(widd+intc)*(ic-1);
        VAR=PP(:,irank); VAR=squeeze(VAR);
        
        ymin=ymina(irank); ymax=ymaxa(irank);
        ylabmin=ylabmina(irank); ylabmax=ylabmaxa(irank); 
        ylabint=ylabinta(irank);
        
        subplot(nrp,ncp,irank);
        for i=1:nspec
            if (i<nspec)
                YY=VAR(SS(i)+1:SS(i+1));
            else
                YY=VAR(SS(1)+1:SS(i));
            end
            
            % Exclude the extreme values
            Y95p=prctile(YY,98);
            Y5p=prctile(YY,2);
            Y50p=prctile(YY,50);
            
            bandwidth=(Y95p-Y5p)/20; % interval
            fillcolor=[0,100,200]/255.0; edgcolor=fillcolor; barcolor=fillcolor;
            [h1,L1,MX1,MED1,bw1,pbar1,pave1,pmd1]=violinplot(YY,'x',XX(i), ...
                'facecolor',fillcolor,'facealpha',transp,...
                'edgecolor',edgcolor,'bw',bandwidth,'vw',viowidth, ...
                'barcolor',barcolor,'qw',qwidth,'tw',twidth, ...
                'avemark',avemark,'avecolor',avecolor,'mdmark',mdmark,'mdcolor',mdcolor, ...
                'marksz',marksz,'markw',markw,'mc','y','medc','y', ...
                'plotlegend',0,'legsize',fsize);
            hold on;
            clear YY;
        end
        
        xlim([xmin xmax]);ylim([ymin ymax]);
        set(gca,'XTick',xlabmin:xlabint:xlabmax,'TickLength',[0.03;0.025]);
        set(gca,'YTick',ylabmin:ylabint:ylabmax,'TickLength',[0.03;0.025]);
        set(gca,'XTickLabel',' ','fontsize',fsize); % ,'Fontangle','italic'
        set(gca,'YTickLabel',ylabmin:ylabint:ylabmax,'fontsize',fsize);
        set(gca,'Position',[icpos,irpos,widd,heig]);
        if(ir==nrp&&ic==2)
            xlabel('Tree species','FontSize',fsize+1, ...
                'position',[(xmax+xmin)/2, ymin-(ymax-ymin)/5]);
        end
        ylabel(Ylab{irank},'FontSize',fsize);
        if (ir==nrp)
            for ispc=1:nspec
                text(ispc,ymin-(ymax-ymin)/10,specname(ispc),'FontSize',fsize, ...
                    'Fontangle','italic','horizontalalignment','center');
            end
        end
        
        text(0.6,ymax-(ymax-ymin)/9,TT{irank},'FontSize',fsize+1,'FontWeight','bold','horizontalalignment','left');
        text(1.7,ymax-(ymax-ymin)/9,paramname{irank},'FontSize',fsize+1,'FontWeight','normal','horizontalalignment','left');
        % Delete the ticks in up and right sides
        box off;
        axes1=axes('Position',get(gca,'Position'), ...
            'XAxisLocation','top', ...
            'YAxisLocation','right', ...
            'Color','none', ...
            'XColor','k','YColor','k');
        set(axes1,'YTick', []);
        set(axes1,'XTick', []);
        box on;
        %
        % leg1=legend([pbar1(1),pbar2(1)],'Ch_{tem}','Ch_{date}'); % ,'position',[329 135 10 10]
        % set(leg1,'position',[0.26,0.94,0.2,0.07],'Orientation','horizontal','FontSize',fsize);
        % set(leg1,'box','off');
        %
        hold off;
    end
end

print figure
print(fig,'-djpeg','-r300',[outpath,'Chilling_AllParam_specal']); 
box off;


