
clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\Prediction\mod_yr4_4\';

nsamp=6989;
CHend=zeros(nsamp,2);
GDDacc=zeros(nsamp,2);
GDD0=zeros(nsamp,2);
LUD=zeros(nsamp,2);

CHend(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','E2:E6990');
CHend(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','Q2:Q6990');
GDDacc(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','F2:F6990');
GDDacc(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','R2:R6990');
GDD0(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','G2:G6990');
GDD0(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','S2:S6990');
LUD(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','H2:H6990');
LUD(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','T2:T6990');

%%
SS=[0,1176,1593,2742,5668,6162,6989];
nsamp=length(CHend(:));
nspec=6; % 6 species + ALL
nvar=4;
nperiod=2;
specname={'Ah','Ag','Bp','Fs','Fe','Qr'};
figrank={'(a)','(b)','(c)','(d)','(e)','(f)'};
varname=["?D_{df0}","?D_{Fr}","?D_{TA0}","?LUD"];
interval=0.18;
XX0=(1:nvar);

fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,15,10]);

xs=0.095; xsize=0.29; xint=0.01;
ys=0.185; ysize=0.36; yint=0.015;
color=[0,100,200; 115,185,255; 255,100,255; 112,188,112]/255;
xlimp=[0.4,4.6];ylimp=[-21,11];

fsize=8;
% Violin
viowidth = 0.20;
transp=0.25;
% Bar
qwidth=2.5; % 25th-75th
twidth=0.25*qwidth; % 5th-95th
% Dots
avemark='o'; avecolor='k'; % mean
mdmark='^'; mdcolor='r'; % median
marksz=3; markw=1.06;

ncol=3;
nrow=ceil(nspec/ncol);
for isp=1:nspec
    ir=ceil(isp/ncol);
    ic=isp-(ir-1)*ncol;
    PP=[xs+(ic-1)*(xsize+xint),ys+(nrow-ir)*(ysize+yint),xsize,ysize];
    
    subplot(nrow,ncol,isp);
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
        
        for i=1:nvar
            if (i==1)
                YY=CHend(SS(isp)+1:SS(isp+1),ipr);
            elseif(i==2)
                YY=GDDacc(SS(isp)+1:SS(isp+1),ipr);
            elseif(i==3)
                YY=GDD0(SS(isp)+1:SS(isp+1),ipr);
            elseif(i==4)
                YY=LUD(SS(isp)+1:SS(isp+1),ipr);
            end
            % Exclude the extreme values
            Y95p=prctile(YY,98);
            Y5p=prctile(YY,2);
            Y50p=prctile(YY,50);
            
            if(ipr==1)
                plot([-1,nvar+1],[0,0],'k:','LineWidth',0.4*twidth);
                hold on;
            end
            
            bandwidth=0.5; % interval
            fillcolor=color(i,:); edgcolor=fillcolor; barcolor=fillcolor;
            [h1,L1,MX1,MED1,bw1,pbar1,pave1,pmd1]=violinplot(YY,'x',XX(i), ...
                'facecolor',fillcolor,'facealpha',transp,...
                'edgecolor',edgcolor,'bw',bandwidth,'vw',viowidth, ...
                'barcolor',barcolor,'qw',qwidth,'tw',twidth, ...
                'avemark',avemark,'avecolor',avecolor,'mdmark',mdmark,'mdcolor',mdcolor, ...
                'marksz',marksz,'markw',markw,'mc','y','medc','', ...
                'plotlegend','','legsize',fsize);
            hold on;
            clear YY;
        end
        
%         xlim([0.4  4.6]);ylim([-16 10.3]);
        xlim([xlimp(1),xlimp(2)]);ylim([ylimp(1),ylimp(2)]);
        set(gca,'XTick',1:1:4,'TickLength',[0.020;0.025]);
        set(gca,'YTick',-20:5:10,'TickLength',[0.020;0.025]);
        if (ir==nrow && ipr==1)
            set(gca,'XTickLabel',varname(:),'fontsize',fsize,'XTickLabelRotation',60); % ,'Fontangle','italic'
        else
            set(gca,'XTickLabel','','fontsize',fsize); % ,'Fontangle','italic' 
        end
        if (ic==1 && ipr==1)
            set(gca,'YTickLabel',-20:5:10,'fontsize',fsize);
        else
            set(gca,'YTickLabel',' ','fontsize',fsize);
        end
        if (ir==nrow && ic==ceil(ncol/2) && ipr==1)
            xlabel(' ','FontSize',fsize);
        end
        if (ir==ceil(nrow/2) && ic==1 && ipr==1)
            ylabel('Change in day (day)','FontSize',fsize,'Position',[-0.4, ylimp(1)-1]);
        end
        
        set(gca,'Position',PP(:));
        
        text(0.6,ylimp(2)-3,figrank(isp),'FontSize',fsize+1,'FontWeight','bold','horizontalalignment','left');
        text(1.2,ylimp(2)-3,specname(isp),'FontSize',fsize+1,'Fontangle','italic','horizontalalignment','left');
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
        if (isp==1 && ipr==1)
            leg1=legend(pave1(1),"Change from 1951-1979 to 1980-1999"); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.23,0.93,0.1,0.08],'Orientation','horizontal','FontSize',fsize+1);
            set(leg1,'box','off');
        elseif(isp==1 && ipr==2)
            leg1=legend(pave1(1),"Change from 1951-1979 to 2000-2019"); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.70,0.93,0.1,0.08],'Orientation','horizontal','FontSize',fsize+1);
            set(leg1,'box','off');
        end
        hold on;
    end
    hold off;
end

print figure
print(fig,'-dtiff','-r300',[outpath,'CH_FOR_LUD_changes']);
box off;

%%
DDtot=abs(CHend)+abs(GDDacc)+abs(GDD0);
rCHend=abs(CHend)./DDtot*100.0;
rGDDacc=abs(GDDacc)./DDtot*100.0;
rGDD0=abs(GDD0)./DDtot*100.0;
nvar=3;
MMean=zeros(nspec,2*nvar);
MMed=zeros(nspec,2*nvar);

fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,12,8]);

xs=0.095; xsize=0.29; xint=0.01;
ys=0.185; ysize=0.36; yint=0.015;
color=[0,100,200; 115,185,255; 255,100,255; 112,188,112]/255;
xlimp=[0.4,3.6];
ylimp=[0, 90];

fsize=7;
% Violin
viowidth = 0.18;
transp=0.25;
% Bar
qwidth=2.5; % 25th-75th
twidth=0.25*qwidth; % 5th-95th
% Dots
avemark='o'; avecolor='k'; % mean
mdmark='^'; mdcolor='r'; % median
marksz=3; markw=1.06;

ncol=3;
nrow=ceil(nspec/ncol);
for isp=1:nspec
    ir=ceil(isp/ncol);
    ic=isp-(ir-1)*ncol;
    PP=[xs+(ic-1)*(xsize+xint),ys+(nrow-ir)*(ysize+yint),xsize,ysize];
    
    subplot(nrow,ncol,isp);
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
        
        for i=1:nvar
            if (i==1)
                YY=rCHend(SS(isp)+1:SS(isp+1),ipr);
            elseif(i==2)
                YY=rGDDacc(SS(isp)+1:SS(isp+1),ipr);
            elseif(i==3)
                YY=rGDD0(SS(isp)+1:SS(isp+1),ipr);
            end
            % Exclude the extreme values
            Y95p=prctile(YY,98);
            Y5p=prctile(YY,2);
            Y50p=prctile(YY,50);
            
            if(ipr==1)
                plot([-1,nvar+1],[0,0],'k:','LineWidth',0.4*twidth);
                hold on;
            end
            
            bandwidth=2.0; % interval
            fillcolor=color(i,:); edgcolor=fillcolor; barcolor=fillcolor;
            [h1,L1,MX1,MED1,bw1,pbar1,pave1,pmd1]=violinplot(YY,'x',XX(i), ...
                'facecolor',fillcolor,'facealpha',transp,...
                'edgecolor',edgcolor,'bw',bandwidth,'vw',viowidth, ...
                'barcolor',barcolor,'qw',qwidth,'tw',twidth, ...
                'avemark',avemark,'avecolor',avecolor,'mdmark',mdmark,'mdcolor',mdcolor, ...
                'marksz',marksz,'markw',markw,'mc','y','medc','', ...
                'plotlegend','','legsize',fsize);
            hold on;
            clear YY;
            MMean(isp,nvar*(ipr-1)+i)=MX1;
            MMed(isp,nvar*(ipr-1)+i)=MED1;
        end
        
        xlim([xlimp(1),xlimp(2)]);ylim([ylimp(1),ylimp(2)]);
        set(gca,'XTick',1:1:3,'TickLength',[0.020;0.025]);
        set(gca,'YTick',0:20:80,'TickLength',[0.020;0.025]);
        if (ir==nrow && ipr==1)
            set(gca,'XTickLabel',varname(:),'fontsize',fsize,'XTickLabelRotation',60); % ,'Fontangle','italic'
        else
            set(gca,'XTickLabel','','fontsize',fsize); % ,'Fontangle','italic' 
        end
        if (ic==1 && ipr==1)
            set(gca,'YTickLabel',0:20:80,'fontsize',fsize);
        else
            set(gca,'YTickLabel',' ','fontsize',fsize);
        end
        if (ir==nrow && ic==ceil(ncol/2) && ipr==1)
            xlabel(' ','FontSize',fsize);
        end
        if (ir==ceil(nrow/2) && ic==1 && ipr==1)
            ylabel('Relative contribution to LUD changes (%)','FontSize',fsize,'Position',[-0.35, 2]);
        end
        
        set(gca,'Position',PP(:));
        
        text(0.6,82,figrank(isp),'FontSize',fsize+1,'FontWeight','bold','horizontalalignment','left');
        text(1.2,82,specname(isp),'FontSize',fsize+1,'Fontangle','italic','horizontalalignment','left');
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
        if (isp==1 && ipr==1)
            leg1=legend(pave1(1),"Change from 1951-1979 to 1980-1999"); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.23,0.925,0.1,0.08],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        elseif(isp==1 && ipr==2)
            leg1=legend(pave1(1),"Change from 1951-1979 to 2000-2019"); % ,'position',[329 135 10 10]
            set(leg1,'position',[0.70,0.925,0.1,0.08],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        end
        hold on;
    end
    hold off;
end

print figure
print(fig,'-dtiff','-r300',[outpath,'CH_FOR_LUD_change_percent_mean']);
box off;

%% Significance test
SIGV=zeros(nspec,nvar);
for isp=1:nspec
    for iv=1:nvar
        if (iv==1)
            A1=rCHend(SS(isp)+1:SS(isp+1),1);
            A2=rCHend(SS(isp)+1:SS(isp+1),2);
        elseif(iv==2)
            A1=rGDDacc(SS(isp)+1:SS(isp+1),1);
            A2=rGDDacc(SS(isp)+1:SS(isp+1),2);
        elseif(iv==3)
            A1=rGDD0(SS(isp)+1:SS(isp+1),1);
            A2=rGDD0(SS(isp)+1:SS(isp+1),2);
        end
        [h,p,ci] = ttest2(A1,A2,0.05);
        SIGV(isp,iv)=p;
    end
end