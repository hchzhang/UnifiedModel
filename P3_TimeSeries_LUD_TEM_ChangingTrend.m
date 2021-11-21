clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\';

PHEN=xlsread([inpath,'Phen_40yr_sim.xlsx'],'Phen_40yr_sim','C2:O388144');
nphen=length(PHEN(:,1));
PHENm=xlsread([inpath,'Phen_ss_param.xlsx'],'Phen_ss_param','A2:M7037');
nphenm=length(PHENm(:,1));
yrs=1951;
yre=2019;
nyr=yre-yrs+1;
YR=1951:1:2019;
nspec=6;
latmidd=50.0;
latumd=[52,48];
p25=10;
p75=90;

for ii=1:nphen
    isp=PHEN(ii,1);
    iss=PHEN(ii,6);
    im=find(PHENm(:,1)==isp&PHENm(:,6)==iss);
    PHEN(ii,9:13)=PHEN(ii,9:13)-PHENm(im,9:13);
end

LUD=zeros(nspec,nyr,3);
LUDn=zeros(nspec,nyr,3);
LUDs=zeros(nspec,nyr,3);
LUDup=zeros(nspec,nyr,3);
LUDmidd=zeros(nspec,nyr,3);
LUDdown=zeros(nspec,nyr,3);
T_spr=zeros(nspec,nyr,3);
Tn_spr=zeros(nspec,nyr,3);
Ts_spr=zeros(nspec,nyr,3);
Tup_spr=zeros(nspec,nyr,3);
Tmidd_spr=zeros(nspec,nyr,3);
Tdown_spr=zeros(nspec,nyr,3);
T_win=zeros(nspec,nyr,3);
Tn_win=zeros(nspec,nyr,3);
Ts_win=zeros(nspec,nyr,3);
Tup_win=zeros(nspec,nyr,3);
Tmidd_win=zeros(nspec,nyr,3);
Tdown_win=zeros(nspec,nyr,3);

for ii=1:nspec
    for iyr=yrs:yre
        %All sites
        REE=find(PHEN(:,1)==ii&PHEN(:,8)==iyr);
        nree=length(REE);
        iyrth=iyr-yrs+1;
        if (nree>0)
            LUDsamp=PHEN(REE,9);
            TSPRsamp=PHEN(REE,11);
            TWINsamp=PHEN(REE,13);
            LUDsamp=sort(LUDsamp);
            TSPRsamp=sort(TSPRsamp);
            TWINsamp=sort(TWINsamp);
            LUD(ii,iyrth,1)=mean(LUDsamp);
            LUD(ii,iyrth,2)=prctile(LUDsamp,p25);
            LUD(ii,iyrth,3)=prctile(LUDsamp,p75);
            T_spr(ii,iyrth,1)=mean(TSPRsamp);
            T_spr(ii,iyrth,2)=prctile(TSPRsamp,p25);
            T_spr(ii,iyrth,3)=prctile(TSPRsamp,p75);
            T_win(ii,iyrth,1)=mean(TWINsamp);
            T_win(ii,iyrth,2)=prctile(TWINsamp,p25);
            T_win(ii,iyrth,3)=prctile(TWINsamp,p75);
        end
        
        %Latitude > 50.0 N
        REE=find(PHEN(:,1)==ii&PHEN(:,8)==iyr&PHEN(:,3)>latmidd);
        nree=length(REE);
        if (nree>0)
            LUDsamp=PHEN(REE,9);
            TSPRsamp=PHEN(REE,11);
            TWINsamp=PHEN(REE,13);
            LUDsamp=sort(LUDsamp);
            TSPRsamp=sort(TSPRsamp);
            TWINsamp=sort(TWINsamp);
            LUDn(ii,iyrth,1)=mean(LUDsamp);
            LUDn(ii,iyrth,2)=prctile(LUDsamp,p25);
            LUDn(ii,iyrth,3)=prctile(LUDsamp,p75);
            Tn_spr(ii,iyrth,1)=mean(TSPRsamp);
            Tn_spr(ii,iyrth,2)=prctile(TSPRsamp,p25);
            Tn_spr(ii,iyrth,3)=prctile(TSPRsamp,p75);
            Tn_win(ii,iyrth,1)=mean(TWINsamp);
            Tn_win(ii,iyrth,2)=prctile(TWINsamp,p25);
            Tn_win(ii,iyrth,3)=prctile(TWINsamp,p75);
        end
        
        %Latitude <= 50.0 N
        REE=find(PHEN(:,1)==ii&PHEN(:,8)==iyr&PHEN(:,3)<=latmidd);
        nree=length(REE);
        if (nree>0)
            LUDsamp=PHEN(REE,9);
            TSPRsamp=PHEN(REE,11);
            TWINsamp=PHEN(REE,13);
            LUDsamp=sort(LUDsamp);
            TSPRsamp=sort(TSPRsamp);
            TWINsamp=sort(TWINsamp);
            LUDs(ii,iyrth,1)=mean(LUDsamp);
            LUDs(ii,iyrth,2)=prctile(LUDsamp,p25);
            LUDs(ii,iyrth,3)=prctile(LUDsamp,p75);
            Ts_spr(ii,iyrth,1)=mean(TSPRsamp);
            Ts_spr(ii,iyrth,2)=prctile(TSPRsamp,p25);
            Ts_spr(ii,iyrth,3)=prctile(TSPRsamp,p75);
            Ts_win(ii,iyrth,1)=mean(TWINsamp);
            Ts_win(ii,iyrth,2)=prctile(TWINsamp,p25);
            Ts_win(ii,iyrth,3)=prctile(TWINsamp,p75);
        end
        
        %Latitude > 52.0 N
        REE=find(PHEN(:,1)==ii&PHEN(:,8)==iyr&PHEN(:,3)>latumd(1));
        nree=length(REE);
        if (nree>0)
            LUDsamp=PHEN(REE,9);
            TSPRsamp=PHEN(REE,11);
            TWINsamp=PHEN(REE,13);
            LUDsamp=sort(LUDsamp);
            TSPRsamp=sort(TSPRsamp);
            TWINsamp=sort(TWINsamp);
            LUDup(ii,iyrth,1)=mean(LUDsamp);
            LUDup(ii,iyrth,2)=prctile(LUDsamp,p25);
            LUDup(ii,iyrth,3)=prctile(LUDsamp,p75);
            Tup_spr(ii,iyrth,1)=mean(TSPRsamp);
            Tup_spr(ii,iyrth,2)=prctile(TSPRsamp,p25);
            Tup_spr(ii,iyrth,3)=prctile(TSPRsamp,p75);
            Tup_win(ii,iyrth,1)=mean(TWINsamp);
            Tup_win(ii,iyrth,2)=prctile(TWINsamp,p25);
            Tup_win(ii,iyrth,3)=prctile(TWINsamp,p75);
        end
        
        %Latitude <= 52.0 N & Latitude > 48.0 N
        REE=find(PHEN(:,1)==ii&PHEN(:,8)==iyr&PHEN(:,3)<=latumd(1)&PHEN(:,3)>latumd(2));
        nree=length(REE);
        if (nree>0)
            LUDsamp=PHEN(REE,9);
            TSPRsamp=PHEN(REE,11);
            TWINsamp=PHEN(REE,13);
            LUDsamp=sort(LUDsamp);
            TSPRsamp=sort(TSPRsamp);
            TWINsamp=sort(TWINsamp);
            LUDmidd(ii,iyrth,1)=mean(LUDsamp);
            LUDmidd(ii,iyrth,2)=prctile(LUDsamp,p25);
            LUDmidd(ii,iyrth,3)=prctile(LUDsamp,p75);
            Tmidd_spr(ii,iyrth,1)=mean(TSPRsamp);
            Tmidd_spr(ii,iyrth,2)=prctile(TSPRsamp,p25);
            Tmidd_spr(ii,iyrth,3)=prctile(TSPRsamp,p75);
            Tmidd_win(ii,iyrth,1)=mean(TWINsamp);
            Tmidd_win(ii,iyrth,2)=prctile(TWINsamp,p25);
            Tmidd_win(ii,iyrth,3)=prctile(TWINsamp,p75);
        end
        
        %Latitude <= 48.0 N
        REE=find(PHEN(:,1)==ii&PHEN(:,8)==iyr&PHEN(:,3)<=latumd(2));
        nree=length(REE);
        if (nree>0)
            LUDsamp=PHEN(REE,9);
            TSPRsamp=PHEN(REE,11);
            TWINsamp=PHEN(REE,13);
            LUDsamp=sort(LUDsamp);
            TSPRsamp=sort(TSPRsamp);
            TWINsamp=sort(TWINsamp);
            LUDdown(ii,iyrth,1)=mean(LUDsamp);
            LUDdown(ii,iyrth,2)=prctile(LUDsamp,p25);
            LUDdown(ii,iyrth,3)=prctile(LUDsamp,p75);
            Tdown_spr(ii,iyrth,1)=mean(TSPRsamp);
            Tdown_spr(ii,iyrth,2)=prctile(TSPRsamp,p25);
            Tdown_spr(ii,iyrth,3)=prctile(TSPRsamp,p75);
            Tdown_win(ii,iyrth,1)=mean(TWINsamp);
            Tdown_win(ii,iyrth,2)=prctile(TWINsamp,p25);
            Tdown_win(ii,iyrth,3)=prctile(TWINsamp,p75);
        end
    end
end

%% Make figures

TT={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)','(j)','(k)', ...
    '(l)','(m)','(n)','(o)','(p)','(q)','(r)','(s)','(t)','(u)','(v)'};
specname={'Ah','Ag','Bp','Fs','Fe','Qr'};

clrpool=[0,  0,  0;   ...     % 1-Black
     70,155,225; ...     % 2-light blue
     0,  128,64;  ...     % 3-dark green
     0,  70, 200; ...     % 4-dark blue
     243,208,10;  ...     % 5-Yellow
     230,115,0;   ...     % 6-Dark orgrange (bric red
     255,30, 255; ...     % 7-Pink
     255,113,184; ...     % 8-light red
     193,15, 0];          % 9-Dark red
icolor=[8,3,4];
clr=clrpool(icolor,:)/255.0;
Alph=0.20;
% 
% % All sites
fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,16,12]);

fsize=9;

nrp=3;
ncp=2;
rrs=0.10; heig=0.26; intr=0.02;
ccs=0.09; widd=0.40; intc=0.02;
for ir=1:nrp
    for ic=1:ncp
        ispec=(ir-1)*ncp+ic;
        irank=(ir-1)*ncp+ic;
        irpos=rrs+(heig+intr)*(nrp-ir);
        icpos=ccs+(widd+intc)*(ic-1);
        LUDave=LUD(ispec,:,1); LUD25p=LUD(ispec,:,2); LUD75p=LUD(ispec,:,3);
        TWave=T_win(ispec,:,1);  TW25p=T_win(ispec,:,2);  TW75p=T_win(ispec,:,3);
        TSave=T_spr(ispec,:,1);  TS25p=T_spr(ispec,:,2);  TS75p=T_spr(ispec,:,3);
        xxlmin=yrs-4; xxlmax=yre+4;
        xxmin=yrs-1; xxmax=yre+1; xxint=10;
        ylmin=-30; ylmax=38; ylint=10;
        yrmin=-6; yrmax=5; yrint=2;
        
        subplot(nrp,ncp,irank);
        yyaxis left;
        xlim([xxlmin  xxlmax]);ylim([ylmin ylmax]);
        set(gca,'XTick',xxmin:xxint:xxmax,'TickLength',[0.015;0.025]);
        set(gca,'YTick',ylmin:ylint:ylmax,'TickLength',[0.015;0.025]);
        if (ir==nrp)
            set(gca,'XTickLabel',xxmin:xxint:xxmax,'fontsize',fsize);
        else
            set(gca,'XTickLabel','','fontsize',fsize);
        end
        if(ic==1)
            set(gca,'YTickLabel',ylmin:ylint:ylmax,'fontsize',fsize,'YColor','k');
        else
            set(gca,'YTickLabel','','fontsize',fsize,'YColor','k');
        end
        set(gca,'Position',[icpos,irpos,widd,heig]);
        patch([YR,fliplr(YR)],[LUD25p,fliplr(LUD75p)], ...
            clr(1,:),'FaceAlpha',Alph,'EdgeColor',clr(1,:),'EdgeAlpha',Alph);
        box on;
        hold on;
        
        yyaxis right;
        ylim([yrmin yrmax]);
        set(gca,'YTick',yrmin:yrint:yrmax,'TickLength',[0.015;0.025]);
        if(ic==ncp)
            set(gca,'YTickLabel',yrmin:yrint:yrmax,'fontsize',fsize,'YColor','k');
        else
            set(gca,'YTickLabel','','fontsize',fsize,'YColor','k');
        end
        patch([YR,fliplr(YR)],[TW25p,fliplr(TW75p)], ...
            clr(2,:),'FaceAlpha',Alph*0.6,'EdgeColor',clr(2,:),'EdgeAlpha',Alph*0.6);
        patch([YR,fliplr(YR)],[TS25p,fliplr(TS75p)], ...
            clr(3,:),'FaceAlpha',Alph*0.6,'EdgeColor',clr(3,:),'EdgeAlpha',Alph*0.6);
        hold on;
        
        yyaxis left;
        H1=line(YR,LUDave,'color',clr(1,:),'linestyle','-','LineWidth',1.0);
        if (ir==2&&ic==1)
            ylabel('Mean LUD anomaly (day)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/7, (ylmax+ylmin)/2]);
        end
        hold on;
        
        yyaxis right;
        H2=line(YR,TWave,'color',clr(2,:),'linestyle','-','LineWidth',0.3);
        H3=line(YR,TSave,'color',clr(3,:),'linestyle','-','LineWidth',0.3);
        if (ir==2&&ic==2)
            ylabel('Mean temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmax+(xxlmax-xxlmin)/9, (yrmax+yrmin)/2]);
        end
        if (ir==nrp&&ic==1)
           xlabel('Year','position',[xxlmax, ylmin-(ylmax-ylmin)/5], ...
                    'FontSize',fsize);
        end
        hold on;
        
        % Title
        text(xxlmin+(xxlmax-xxlmin)/20,yrmax-(yrmax-yrmin)/10,TT{irank}, ...
            'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
        text(xxlmin+(xxlmax-xxlmin)/7,yrmax-(yrmax-yrmin)/10,specname{ispec}, ...
            'FontSize',fsize,'FontAngle','italic','horizontalalignment','left');
        % Legend
        leg1=legend([H1,H2,H3],'LUD','T_{Winter}','T_{Spring}');
        set(leg1,'position',[0.40,0.92,0.2,0.07],'Orientation','horizontal','FontSize',fsize);
        set(leg1,'box','off');
        hold off;
    end
end
print figure
print(fig,'-djpeg','-r600',[outpath,'TimeSeries_LUDTwinspr']); 
box off;

%%
fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,16,12]);

fsize=6;

nrp=nspec;
ncp=3;
rrs=0.08; heig=0.13; intr=0.02;
ccs=0.06; widd=0.26; intc=0.07;
for ir=1:nrp
    for ic=1:ncp
        ispec=ir;
        irank=(ir-1)*ncp+ic;
        irpos=rrs+(heig+intr)*(nrp-ir);
        icpos=ccs+(widd+intc)*(ic-1);
        xxlmin=yrs-4; xxlmax=yre+4;
        xxmin=yrs-1; xxmax=yre+1; xxint=10;
        if (ic==1)
            VVave=LUD(ispec,:,1);   VV25p=LUD(ispec,:,2);   VV75p=LUD(ispec,:,3);
            ylmin=-30; ylmax=38; ylint=10;
        elseif(ic==2)
            VVave=T_win(ispec,:,1); VV25p=T_win(ispec,:,2); VV75p=T_win(ispec,:,3);
            ylmin=-6; ylmax=7; ylint=2;
        elseif(ic==3)
            VVave=T_spr(ispec,:,1); VV25p=T_spr(ispec,:,2); VV75p=T_spr(ispec,:,3);
            ylmin=-6; ylmax=7; ylint=2;
        end
        % Regression
        Xreg=[ones(size(YR')),YR'];
        Yreg=VVave';
        [b,bint,r,rint,stats]=regress(Yreg,Xreg);
        Yest=b(2)*YR(:)+b(1);
        
        subplot(nrp,ncp,irank);
        xlim([xxlmin  xxlmax]);ylim([ylmin ylmax]);
        set(gca,'XTick',xxmin:xxint:xxmax,'TickLength',[0.015;0.025]);
        set(gca,'YTick',ylmin:ylint:ylmax,'TickLength',[0.015;0.025]);
        if (ir==nrp)
            set(gca,'XTickLabel',xxmin:xxint:xxmax,'fontsize',fsize);
        else
            set(gca,'XTickLabel','','fontsize',fsize);
        end
        set(gca,'YTickLabel',ylmin:ylint:ylmax,'fontsize',fsize,'YColor','k');
        
        set(gca,'Position',[icpos,irpos,widd,heig]);
        patch([YR,fliplr(YR)],[VV25p,fliplr(VV75p)], ...
            clr(ic,:),'FaceAlpha',Alph,'EdgeColor',clr(ic,:),'EdgeAlpha',Alph);
        box on;
%         hold on;
        
        H1=line(YR,VVave,'color',clr(ic,:),'linestyle','-','LineWidth',0.6);
%         hold on;
        H2=line(YR,Yest,'color','k','linestyle','--','LineWidth',0.4);
        hold off;
        if (ir==4&&ic==1)
            ylabel('Mean LUD anomaly (day)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/7, (ylmin+ylmax)/2]);
        elseif ((ir==4&&ic==2))
            ylabel('Mean winter temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/8, (ylmin+ylmax)/2]);
        elseif ((ir==4&&ic==3))
            ylabel('Mean spring temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/8, (ylmin+ylmax)/2]);
        end

        if (ir==nrp&&ic==2)
           xlabel('Year','position',[(xxlmax+xxlmin)/2, ylmin-(ylmax-ylmin)/3], ...
                    'FontSize',fsize);
        end
        
        % Title
        text(xxlmin+(xxlmax-xxlmin)/20,ylmax-(ylmax-ylmin)/9,TT{irank}, ...
            'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
        text(xxlmin+(xxlmax-xxlmin)/7,ylmax-(ylmax-ylmin)/9,specname{ispec}, ...
            'FontSize',fsize,'FontAngle','italic','horizontalalignment','left');
%         regfun=['Y = ',num2str(round(b(2),2)),'X + ',num2str(round(b(1),1)), ...
%             'R^2 = ',num2str(round(stats(1),2))];
        regfun=['k=',num2str(round(b(2),2)),', R^2=',num2str(round(stats(1),2))];
        text(xxlmin+(xxlmax-xxlmin)/4,ylmax-(ylmax-ylmin)/9,regfun, ...
            'FontSize',fsize,'FontAngle','normal','horizontalalignment','left');
        % Legend
%         leg1=legend([H1,H2,H3],'LUD','T_{Winter}','T_{Spring}');
%         set(leg1,'position',[0.40,0.92,0.2,0.07],'Orientation','horizontal','FontSize',fsize);
%         set(leg1,'box','off');
        hold off;
    end
end
print figure
print(fig,'-djpeg','-r600',[outpath,'TimeSeries_LUDTwinsprSep']); 
box off;

%% North South
fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,16,12]);

fsize=6;

nrp=nspec;
ncp=3;
rrs=0.07; heig=0.13; intr=0.02;
ccs=0.06; widd=0.26; intc=0.07;
for ir=1:nrp
    for ic=1:ncp
        ispec=ir;
        irank=(ir-1)*ncp+ic;
        irpos=rrs+(heig+intr)*(nrp-ir);
        icpos=ccs+(widd+intc)*(ic-1);
        xxlmin=yrs-4; xxlmax=yre+4;
        xxmin=yrs-1; xxmax=yre+1; xxint=10;
        
        if (ic==1)
            VVave=LUDn(ispec,:,1);   VV25p=LUDn(ispec,:,2);   VV75p=LUDn(ispec,:,3);
            VVaves=LUDs(ispec,:,1);   VV25ps=LUDs(ispec,:,2);   VV75ps=LUDs(ispec,:,3);
            ylmin=-30; ylmax=38; ylint=10;
        elseif(ic==2)
            VVave=Tn_win(ispec,:,1); VV25p=Tn_win(ispec,:,2); VV75p=Tn_win(ispec,:,3);
            VVaves=Ts_win(ispec,:,1); VV25ps=Ts_win(ispec,:,2); VV75ps=Ts_win(ispec,:,3);
            ylmin=-6; ylmax=7; ylint=2;
        elseif(ic==3)
            VVave=Tn_spr(ispec,:,1); VV25p=Tn_spr(ispec,:,2); VV75p=Tn_spr(ispec,:,3);
            VVaves=Ts_spr(ispec,:,1); VV25ps=Ts_spr(ispec,:,2); VV75ps=Ts_spr(ispec,:,3);
            ylmin=-6; ylmax=7; ylint=2;
        end
        % Regression
        Xreg=[ones(size(YR')),YR'];
        Yreg=VVave';
        [b,bint,r,rint,stats]=regress(Yreg,Xreg);
        Yest=b(2)*YR(:)+b(1);
        Yreg=VVaves';
        [b1,bint1,r1,rint1,stats1]=regress(Yreg,Xreg);
        Yests=b1(2)*YR(:)+b1(1);
        
        subplot(nrp,ncp,irank);
        xlim([xxlmin  xxlmax]);ylim([ylmin ylmax]);
        set(gca,'XTick',xxmin:xxint:xxmax,'TickLength',[0.015;0.025]);
        set(gca,'YTick',ylmin:ylint:ylmax,'TickLength',[0.015;0.025]);
        if (ir==nrp)
            set(gca,'XTickLabel',xxmin:xxint:xxmax,'fontsize',fsize);
        else
            set(gca,'XTickLabel','','fontsize',fsize);
        end
        set(gca,'YTickLabel',ylmin:ylint:ylmax,'fontsize',fsize,'YColor','k');
        
        set(gca,'Position',[icpos,irpos,widd,heig]);
        
        patch([YR,fliplr(YR)],[VV25p,fliplr(VV75p)], ...
            clr(1,:),'FaceAlpha',Alph,'EdgeColor',clr(1,:),'EdgeAlpha',Alph);
        patch([YR,fliplr(YR)],[VV25ps,fliplr(VV75ps)], ...
            clr(3,:),'FaceAlpha',Alph,'EdgeColor',clr(3,:),'EdgeAlpha',Alph);
        H1=line(YR,VVave,'color',clr(1,:),'linestyle','-','LineWidth',0.6);
        H2=line(YR,VVaves,'color',clr(3,:),'linestyle','-','LineWidth',0.6);
        H3=line(YR,Yest,'color',clr(1,:),'linestyle','--','LineWidth',0.4);
        H4=line(YR,Yests,'color',clr(3,:),'linestyle','--','LineWidth',0.4);
        box on;
        hold off;
        
        if (ir==4&&ic==1)
            ylabel('Mean LUD anomaly (day)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/7, (ylmin+ylmax)/2]);
        elseif ((ir==4&&ic==2))
            ylabel('Mean winter temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/8, (ylmin+ylmax)/2]);
        elseif ((ir==4&&ic==3))
            ylabel('Mean spring temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/8, (ylmin+ylmax)/2]);
        end

        if (ir==nrp&&ic==2)
           xlabel('Year','position',[(xxlmax+xxlmin)/2, ylmin-(ylmax-ylmin)/3], ...
                    'FontSize',fsize);
        end
        
        % Title
        text(xxlmin+(xxlmax-xxlmin)/20,ylmax-(ylmax-ylmin)/9,TT{irank}, ...
            'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
        text(xxlmin+(xxlmax-xxlmin)/7,ylmax-(ylmax-ylmin)/9,specname{ispec}, ...
            'FontSize',fsize,'FontAngle','italic','horizontalalignment','left');
%         regfun=['Y = ',num2str(round(b(2),2)),'X + ',num2str(round(b(1),1)), ...
%             'R^2 = ',num2str(round(stats(1),2))];
        regfun=['k=',num2str(round(b(2),2)),', R^2=',num2str(round(stats(1),2)),';'];
        text(xxlmin+(xxlmax-xxlmin)/4,ylmax-(ylmax-ylmin)/9,regfun, ...
            'FontSize',fsize-1,'Color',clr(1,:),'FontAngle','normal','horizontalalignment','left');
        regfun=['k=',num2str(round(b1(2),2)),', R^2=',num2str(round(stats1(1),2))];
        text(xxlmin+(xxlmax-xxlmin)/1.6,ylmax-(ylmax-ylmin)/9,regfun, ...
            'FontSize',fsize-1,'Color',clr(3,:),'FontAngle','normal','horizontalalignment','left');
        % Legend
        if(ir==1&&ic==1)
            leg1=legend([H1,H2],'50N - 56N','44N - 50N');
            set(leg1,'position',[0.40,0.94,0.2,0.07],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        end
        hold off;
    end
end
print figure
print(fig,'-djpeg','-r600',[outpath,'TimeSeries_LUDTwinsprNorSou']); 
box off;

%% North MIddle South
fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,16,12]);

fsize=6;

nrp=nspec;
ncp=3;
rrs=0.07; heig=0.13; intr=0.02;
ccs=0.06; widd=0.26; intc=0.07;
for ir=1:nrp
    for ic=1:ncp
        ispec=ir;
        irank=(ir-1)*ncp+ic;
        irpos=rrs+(heig+intr)*(nrp-ir);
        icpos=ccs+(widd+intc)*(ic-1);
        xxlmin=yrs-4; xxlmax=yre+4;
        xxmin=yrs-1; xxmax=yre+1; xxint=10;
        
        if (ic==1)
            VVave=LUDup(ispec,:,1);   VV25p=LUDup(ispec,:,2);   VV75p=LUDup(ispec,:,3);
            VVavem=LUDmidd(ispec,:,1);VV25pm=LUDmidd(ispec,:,2); VV75pm=LUDmidd(ispec,:,3);
            VVaves=LUDdown(ispec,:,1);VV25ps=LUDdown(ispec,:,2);   VV75ps=LUDdown(ispec,:,3);
            ylmin=-30; ylmax=38; ylint=10;
        elseif(ic==2)
            VVave=Tup_win(ispec,:,1); VV25p=Tup_win(ispec,:,2); VV75p=Tup_win(ispec,:,3);
            VVavem=Tmidd_win(ispec,:,1); VV25pm=Tmidd_win(ispec,:,2); VV75pm=Tmidd_win(ispec,:,3);
            VVaves=Tdown_win(ispec,:,1); VV25ps=Tdown_win(ispec,:,2); VV75ps=Tdown_win(ispec,:,3);
            ylmin=-6; ylmax=7; ylint=2;
        elseif(ic==3)
            VVave=Tup_spr(ispec,:,1); VV25p=Tup_spr(ispec,:,2); VV75p=Tup_spr(ispec,:,3);
            VVavem=Tmidd_spr(ispec,:,1); VV25pm=Tmidd_spr(ispec,:,2); VV75pm=Tmidd_spr(ispec,:,3);
            VVaves=Tdown_spr(ispec,:,1); VV25ps=Tdown_spr(ispec,:,2); VV75ps=Tdown_spr(ispec,:,3);
            ylmin=-6; ylmax=7; ylint=2;
        end
        % Regression
        Xreg=[ones(size(YR')),YR'];
        Yreg=VVave';
        [b,bint,r,rint,stats]=regress(Yreg,Xreg);
        Yest=b(2)*YR(:)+b(1);
        Yreg=VVavem';
        [b1,bint1,r1,rint1,stats1]=regress(Yreg,Xreg);
        Yestm=b1(2)*YR(:)+b1(1);
        Yreg=VVaves';
        [b2,bint2,r2,rint2,stats2]=regress(Yreg,Xreg);
        Yests=b1(2)*YR(:)+b1(1);
        
        subplot(nrp,ncp,irank);
        xlim([xxlmin  xxlmax]);ylim([ylmin ylmax]);
        set(gca,'XTick',xxmin:xxint:xxmax,'TickLength',[0.015;0.025]);
        set(gca,'YTick',ylmin:ylint:ylmax,'TickLength',[0.015;0.025]);
        if (ir==nrp)
            set(gca,'XTickLabel',xxmin:xxint:xxmax,'fontsize',fsize);
        else
            set(gca,'XTickLabel','','fontsize',fsize);
        end
        set(gca,'YTickLabel',ylmin:ylint:ylmax,'fontsize',fsize,'YColor','k');
        
        set(gca,'Position',[icpos,irpos,widd,heig]);
        
        patch([YR,fliplr(YR)],[VV25p,fliplr(VV75p)], ...
            clr(1,:),'FaceAlpha',Alph,'EdgeColor',clr(1,:),'EdgeAlpha',Alph);
        patch([YR,fliplr(YR)],[VV25pm,fliplr(VV75pm)], ...
            clr(2,:),'FaceAlpha',Alph,'EdgeColor',clr(2,:),'EdgeAlpha',Alph);
        patch([YR,fliplr(YR)],[VV25ps,fliplr(VV75ps)], ...
            clr(3,:),'FaceAlpha',Alph,'EdgeColor',clr(3,:),'EdgeAlpha',Alph);
        H1=line(YR,VVave,'color',clr(1,:),'linestyle','-','LineWidth',0.6);
        H2=line(YR,VVavem,'color',clr(2,:),'linestyle','-','LineWidth',0.6);
        H3=line(YR,VVaves,'color',clr(3,:),'linestyle','-','LineWidth',0.6);
        H4=line(YR,Yest,'color',clr(1,:),'linestyle','--','LineWidth',0.4);
        H5=line(YR,Yestm,'color',clr(2,:),'linestyle','--','LineWidth',0.4);
        H6=line(YR,Yests,'color',clr(3,:),'linestyle','--','LineWidth',0.4);
        box on;
        hold off;
        
        if (ir==4&&ic==1)
            ylabel('Mean LUD anomaly (day)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/7, (ylmin+ylmax)/2]);
        elseif ((ir==4&&ic==2))
            ylabel('Mean winter temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/8, (ylmin+ylmax)/2]);
        elseif ((ir==4&&ic==3))
            ylabel('Mean spring temperature anomaly (^oC)','FontSize',fsize,'position', ...
                [xxlmin-(xxlmax-xxlmin)/8, (ylmin+ylmax)/2]);
        end

        if (ir==nrp&&ic==2)
           xlabel('Year','position',[(xxlmax+xxlmin)/2, ylmin-(ylmax-ylmin)/3], ...
                    'FontSize',fsize);
        end
        
        % Title
        text(xxlmin+(xxlmax-xxlmin)/20,ylmax-(ylmax-ylmin)/9,TT{irank}, ...
            'FontSize',fsize,'FontWeight','bold','horizontalalignment','left');
        text(xxlmin+(xxlmax-xxlmin)/7,ylmax-(ylmax-ylmin)/9,specname{ispec}, ...
            'FontSize',fsize,'FontAngle','italic','horizontalalignment','left');
%         regfun=['Y = ',num2str(round(b(2),2)),'X + ',num2str(round(b(1),1)), ...
%             'R^2 = ',num2str(round(stats(1),2))];
        regfun=['k=',num2str(round(b(2),2)),', R^2=',num2str(round(stats(1),2)),';'];
        text(xxlmin+(xxlmax-xxlmin)/4,ylmax-(ylmax-ylmin)/9,regfun, ...
            'FontSize',fsize-1,'Color',clr(1,:),'FontAngle','normal','horizontalalignment','left');
        regfun=['k=',num2str(round(b1(2),2)),', R^2=',num2str(round(stats1(1),2))];
        text(xxlmin+(xxlmax-xxlmin)/1.6,ylmax-(ylmax-ylmin)/9,regfun, ...
            'FontSize',fsize-1,'Color',clr(2,:),'FontAngle','normal','horizontalalignment','left');
        regfun=['k=',num2str(round(b2(2),2)),', R^2=',num2str(round(stats2(1),2))];
        text(xxlmin+(xxlmax-xxlmin)/4,ylmax-(ylmax-ylmin)/4,regfun, ...
            'FontSize',fsize-1,'Color',clr(3,:),'FontAngle','normal','horizontalalignment','left');
        %Legend
        if(ir==1&&ic==1)
            leg1=legend([H1,H2,H3],'52N - 56N','48N - 52N','44N - 48N');
            set(leg1,'position',[0.40,0.94,0.2,0.07],'Orientation','horizontal','FontSize',fsize);
            set(leg1,'box','off');
        end
        hold off;
    end
end
print figure
print(fig,'-djpeg','-r600',[outpath,'TimeSeries_LUDTwinsprNorMIDSou']); 
box off;

close all;