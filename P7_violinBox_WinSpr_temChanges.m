
clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\Prediction\mod_yr4_4\';

T90(:,1:2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','K2:L6990');
T90(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','N2:N6990');
T20(:,1:2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','W2:X6990');
T20(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','Z2:Z6990');

% TEMop=xlsread([inpath,'Phen_ss_param.xlsx'],'Phen_ss_param','FF2:FF6934');
SS=[0,1176,1593,2742,5668,6162,6989];
nsamp=length(T90(:,1));
nspec=7; % 6 species + ALL
nsean=3;
nperiod=2;
specname={'Ah','Ag','Bp','Fs','Fe','Qr','All'};
figrank={'(a)','(b)','(c)','(d)','(e)','(f)'};
seaname={'Winter','Spring','Preseason'};


%%
fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,10,16]);

color=[115,185,255]/255;
xs=0.16; xsize=0.82; xint=0.00;
ys=0.09; ysize=0.27; yint=0.015;

fsize=11;
% 1 - RMSE
% Violin
interval=0.18;
XX0=1:nspec;
viowidth = 0.13;
transp=0.25;
% Bar
qwidth=2.5; % 25th-75th
twidth=0.25*qwidth; % 5th-95th
% Dots
avemark='o'; avecolor='k'; % mean
mdmark='^'; mdcolor='r'; % median
marksz=3; markw=1.05;

xlimp=[0.4, 7.6];
ylimp=[-1.2, 3.2];

ncol=1;
nrow=ceil(nsean/ncol);
pleg(1:nperiod)=0;

for i=1:nsean
    
    ir=ceil(i/ncol);
    ic=i-(ir-1)*ncol;
    PP=[xs+(ic-1)*(xsize+xint),ys+(nrow-ir)*(ysize+yint),xsize,ysize];
    subplot(nrow,ncol,i);
    
    for ipr=1:nperiod
        if(ipr==1)
            XX(:)=XX0(:)-interval;
            avecolor='k';
            avemark='o';
        else
            XX(:)=XX0(:)+interval;
            avecolor='r';
            avemark='o';
        end
        
        for isp=1:nspec
            if (ipr==1)
                if (isp<nspec)
                    YY=T90(SS(isp)+1:SS(isp+1),i);
                else
                    YY=T90(SS(1)+1:SS(isp),i);
                end
            elseif (ipr==2)
                if (isp<nspec)
                    YY=T20(SS(isp)+1:SS(isp+1),i);
                else
                    YY=T20(SS(1)+1:SS(isp),i);
                end
            end
            % Exclude the extreme values
            Y95p=prctile(YY,98);
            Y5p=prctile(YY,2);
            Y50p=prctile(YY,50);
            
            if(ipr==1)
                plot([0,nspec+1],[0,0],'k:','LineWidth',0.4*twidth);
                hold on;
            end
            
            bandwidth=0.2; % interval
            fillcolor=color; edgcolor=fillcolor; barcolor=fillcolor;
            [h1,L1,MX1,MED1,bw1,pbar1,pave1,pmd1]=violinplot(YY,'x',XX(isp), ...
                'facecolor',fillcolor,'facealpha',transp,...
                'edgecolor',edgcolor,'bw',bandwidth,'vw',viowidth, ...
                'barcolor',barcolor,'qw',qwidth,'tw',twidth, ...
                'avemark',avemark,'avecolor',avecolor,'mdmark',mdmark,'mdcolor',mdcolor, ...
                'marksz',marksz,'markw',markw,'mc','y','medc','', ...
                'plotlegend','','legsize',fsize);
            hold on;
            clear YY;
        end
        
        xlim([xlimp(1)  xlimp(2)]);ylim([ylimp(1) ylimp(2)]);
        set(gca,'XTick',1:1:7,'TickLength',[0.015;0.025]);
        if (ir==nrow && ipr==1)
            for isp=1:nspec
                text(isp,-1.6,specname(isp),'FontSize',fsize,'Fontangle','italic','horizontalalignment','center');
            end
            text(4,-2.2,'Plant species','FontSize',fsize,'horizontalalignment','center');
        end
        set(gca,'XTickLabel',' ','fontsize',fsize); % ,'Fontangle','italic'
%         if (ir==nrow && ic==ceil(ncol/2) && ipr==1)
%             xlabel('Plant species','FontSize',fsize,'Position',[4, -3.0]);
%         end
        
        if (ir==2 && ic==1 && ipr==1)
            ylabel('Change in temperature (^oC)','FontSize',fsize-0.5,'Position',[-0.53, mean(ylimp)]);
        end
        %
        if (ipr==1)
            set(gca,'YTick',-1.0:1.0:3.2,'TickLength',[0.015;0.025]);
            set(gca,'YTickLabel',-1.0:1.0:3.2,'fontsize',fsize);
            
            set(gca,'Position',PP);
            
            %Title
            text(0.7,2.8,figrank(i),'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
            text(1.2,2.8,seaname(i),'FontSize',fsize,'Fontangle','normal','horizontalalignment','left');
        end
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
        if (i==1 && ipr==1)
            leg1=legend(pave1(1),'?T_{1990s-1970s}'); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.35,0.94,0.01,0.05],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        elseif(i==1 && ipr==2)
            leg1=legend(pave1(1),'?T_{2010s-1970s}'); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.73,0.94,0.01,0.05],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        end
        hold on;
    end
    %
    hold off;
end

print figure
print(fig,'-djpeg','-r300',[outpath,'Tem_win_spr_preseason']);
box off;


