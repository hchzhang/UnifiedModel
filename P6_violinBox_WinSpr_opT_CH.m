
clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\Prediction\mod_yr4_4\';
inpath1='D:\Phenology\Data\param_est\mod_yr4_4\';

opT=xlsread([inpath1,'Phen_ss_param.xlsx'],'Phen_ss_param','AV2:AV6990');
Twin(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','AQ2:AQ6990');
Twin(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','BK2:BK6990');
Twin(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','CE2:CE6990');
Tspr(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','AR2:AR6990');
Tspr(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','BL2:BL6990');
Tspr(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','CF2:CF6990');

nperiod=length(Twin(1,:));
for ipr=1:nperiod
    Twin(:,ipr)=Twin(:,ipr)-opT(:);
    Tspr(:,ipr)=Tspr(:,ipr)-opT(:);
end

% TEMop=xlsread([inpath,'Phen_ss_param.xlsx'],'Phen_ss_param','FF2:FF6934');
SS=[0,1176,1593,2742,5668,6162,6989];
nsamp=length(Twin(:,1));
nspec=7; % 6 species + ALL
nsean=2;

%%
seaname={'Winter','Spring','Preseason'};
specname={'Ah','Ag','Bp','Fs','Fe','Qr','All'};
prname=["?T_{1951-1979}","?T_{1980-1999}","?T_{2000-2019}"];
figrank={'(a)','(b)','(c)','(d)','(e)','(f)'};

fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,10,12]);

% color=[115,185,255]/255;
color=[115,185,255; 112,188,112; 255,100,255]/255;
% color=[255,128,64; 255,128,128; 255,128,255]/255;
xs=0.16; xsize=0.82; xint=0.00;
ys=0.11; ysize=0.40; yint=0.02;

fsize=9;
% 1 - RMSE
% Violin
interval=0.25;
XX0=1:nspec;
viowidth = 0.12;
transp=0.3;
% Bar
qwidth=2.5; % 25th-75th
twidth=0.25*qwidth; % 5th-95th
% Dots
avemark='o'; avecolor='k'; % mean
mdmark='^'; mdcolor='r'; % median
marksz=3; markw=1.05;

ncol=1;
nrow=ceil(nsean/ncol);
pleg(1:nperiod)=0;

for i=1:nsean
    ir=ceil(i/ncol);
    ic=i-(ir-1)*ncol;
    PP=[xs+(ic-1)*(xsize+xint),ys+(nrow-ir)*(ysize+yint),xsize,ysize];
    subplot(nrow,ncol,i);
    
    for ipr=1:nperiod
        avecolor='r';
        avemark='o';
        if(ipr==1)
            XX(:)=XX0(:)-interval;
        elseif (ipr==2)
            XX(:)=XX0(:);
        elseif (ipr==3)
            XX(:)=XX0(:)+interval;
        end
        
        for isp=1:nspec
            if (i==1)
                if (isp<nspec)
                    YY=Twin(SS(isp)+1:SS(isp+1),ipr);
                else
                    YY=Twin(SS(1)+1:SS(isp),ipr);
                end
            elseif (i==2)
                if (isp<nspec)
                    YY=Tspr(SS(isp)+1:SS(isp+1),ipr);
                else
                    YY=Tspr(SS(1)+1:SS(isp),ipr);
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
            
            bandwidth=0.5; % interval
            fillcolor=color(ipr,:); edgcolor=fillcolor; barcolor=fillcolor;
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
        
        xlim([0.4  7.6]);
        if(i==1)
            ylim([-17 4.0]);
        elseif(i==2)
            ylim([-8.5 12.5]);
        end
        set(gca,'XTick',1:1:7,'TickLength',[0.015;0.025]);
        if (ir==nrow && ipr==1)
            for isp=1:nspec
                text(isp,-10,specname(isp),'FontSize',fsize,'Fontangle','italic','horizontalalignment','center');
            end
            text(4,-12.5,'Tree species','FontSize',fsize,'horizontalalignment','center');
        end
        set(gca,'XTickLabel',' ','fontsize',fsize); % ,'Fontangle','italic'
%         if (ir==nrow && ic==ceil(ncol/2) && ipr==1)
%             xlabel('Plant species','FontSize',fsize,'Position',[4, -3.0]);
%         end
        
        if (ir==1 && ic==1 && ipr==1)
            ylabel('Difference between mean winter/spring temperature and T_{op} (^oC)', ...
                'FontSize',fsize-0.5,'Position',[-0.3, -17]);
        end
        %
        if (ipr==1)
            if (i==1)
                set(gca,'YTick',-15:3:6,'TickLength',[0.015;0.025]);
                set(gca,'YTickLabel',-15:3:6,'fontsize',fsize);
                %Title
                text(0.7,2.5,figrank(i),'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
                text(1.2,2.5,seaname(i),'FontSize',fsize,'Fontangle','normal','horizontalalignment','left');
            elseif (i==2)
                set(gca,'YTick',-8:4:12,'TickLength',[0.015;0.025]);
                set(gca,'YTickLabel',-8:4:12,'fontsize',fsize);
                %Title
                text(0.7,11,figrank(i),'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
                text(1.2,11,seaname(i),'FontSize',fsize,'Fontangle','normal','horizontalalignment','left');
            end
            
            set(gca,'Position',PP);
            
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
            leg1=legend(pbar1(1),prname(ipr)); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.255,0.94,0.01,0.05],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        elseif(i==1 && ipr==2)
            leg1=legend(pbar1(1),prname(ipr)); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.55,0.94,0.01,0.05],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        elseif(i==1 && ipr==3)
            leg1=legend(pbar1(1),prname(ipr)); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.85,0.94,0.01,0.05],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        end
        hold on;
    end
    %
    hold off;
end

print figure
print(fig,'-dtiff','-r300',[outpath,'DIFF_opTem_WinSpr']);
box off;


