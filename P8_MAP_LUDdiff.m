% 
clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\Prediction\mod_yr4_4\';
inpath1='D:\Phenology\Data\param_est\mod_yr4_4\';

nsamp=6989;
latn=56; lats=44; lonw=2; lone=21;
res=0.25;
nlat=(latn-lats)/res;
nlon=(lone-lonw)/res;
latmap=latn:-res:lats;
lonmap=lonw:res:lone;

SS=[0,1176,1593,2742,5668,6162,6989];
nspec=6; % 6 species + ALL
nvar=4;
nperiod=2;

DD90s=zeros(nsamp,nvar);
sigDD90s=zeros(nsamp,nvar);
DD10s=zeros(nsamp,nvar);
sigDD10s=zeros(nsamp,nvar);

DD90s(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','E2:E6990');
sigDD90s(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','CS2:CS6990');
DD90s(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','G2:G6990');
sigDD90s(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','CR2:CR6990');
DD90s(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','F2:F6990');
sigDD90s(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','CT2:CT6990');
DD90s(:,4)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','H2:H6990');
sigDD90s(:,4)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','CX2:CX6990');

DD10s(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','Q2:Q6990');
sigDD10s(:,1)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','DM2:DM6990');
DD10s(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','S2:S6990');
sigDD10s(:,2)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','DL2:DL6990');
DD10s(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','R2:R6990');
sigDD10s(:,3)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','DN2:DN6990');
DD10s(:,4)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','T2:T6990');
sigDD10s(:,4)=xlsread([inpath,'U2_StartDay_80s_aveDurations.xlsx'],'Result','DR2:DR6990');
LALO=xlsread([inpath1,'Phen_ss_param.xlsx'],'Phen_ss_param','B2:C6990');

country=shaperead('H:\Materials\MAP\Shapefile\cntry00\cntry00.shp');
LIM10s(1:nvar,1)=max(DD10s);
LIM10s(1:nvar,2)=min(DD10s);

%%
color=xlsread('D:\Materials\Program\MATLAB\Color_ZHC.xlsx','sheet1','AI1:AK12');
color=color(:,:)./255.0;
% MAPcolor(:,:,1)=color;
nctry=30;

fsize=6;
xs=0.06; xsize=0.205; xint=0.015;
ys=0.21; ysize=0.35; yint=0.026;

specname={'Ah','Ag','Bp','Fs','Fe','Qr'};
figrank={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
varname={'?D_{df0}','?D_{TA0}','?D_{FD}','?LUD'};
pername0='Change from 1951-1979';
pername={'to 1980-1999','to 2000-2019'};

DDMAP=zeros(nlat,nlon);
MAP=zeros(nlat,nlon);
NN=zeros(nlat,nlon);

fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,16,9]);

for ipr=1:nperiod
    if (ipr==1)
        DD=DD90s; sigDD=sigDD90s;
    elseif (ipr==2)
        DD=DD10s; sigDD=sigDD10s;
    end
    %
    LIM(1:nvar,1)=max(DD);
    LIM(1:nvar,2)=min(DD);
    for ivar=1:nvar
        iplot=ivar+(ipr-1)*nvar;
        nlevel=13;
        level=[-999 -10 -8 -6 -4 -2 -0.1 0.1 2 4 6 8 10 999];
                
        DDMAP(:,:)=0;
        NN(:,:)=0;
        for isp=1:nsamp
            ir=ceil((latn-LALO(isp,2))/res);
            ic=ceil((LALO(isp,1)-lonw)/res);
            if(ir>0 && ir<=nlat && ic>0 && ic<=nlon)
                NN(ir,ic)=NN(ir,ic)+1;
                if (sigDD(isp,ivar)<=0.1)
                    DDMAP(ir,ic)=DDMAP(ir,ic)+DD(isp,ivar);
                end
            end
        end
        for ir=1:nlat
            for ic=1:nlon
                if (NN(ir,ic)>0)
                    DDMAP(ir,ic)=DDMAP(ir,ic)/NN(ir,ic);
                else
                    DDMAP(ir,ic)=NaN;
                end
            end
        end
        
        MAP(:,:)=NaN;
        for il=1:nlevel
            MAP(DDMAP>level(il) & DDMAP<=level(il+1))=il;
        end
        MAP(1:nlevel,1)=1:nlevel; 
        % Just tomake sure the colorbar for different subplots same
        
        levmax=max(max(MAP));
        levmin=min(min(MAP));
        %
        nlev=levmax-levmin+1;
        lev=level(levmin:levmax+1);
        MAPcolor=[color(1:6,:);[0.8, 0.8, 0.8];color(7:12,:)];
        
        
        subplot (nperiod,nvar,iplot);
        PP=[xs+(ivar-1)*(xsize+xint),ys+(nperiod-ipr)*(ysize+yint),xsize,ysize];
        
        % plot country boudries
        for ictry=1:nctry
            plot(country(ictry).X,country(ictry).Y,'--k','LineWidth',0.05);
            hold on;
        end
          
        latint=2; lonint=2;
        xlim([lonw+2-0.5  lone+0.5]);ylim([lats-0.5 latn+0.5]);
        set(gca,'XTick',lonw+2:latint:lone,'TickLength',[0.020;0.025]);
        set(gca,'YTick',lats:lonint:latn,'TickLength',[0.020;0.025]);
        if (ivar==1)
            set(gca,'YTickLabel',lats:lonint:latn,'fontsize',fsize);
        else
            set(gca,'YTickLabel','','fontsize',fsize);
        end
        if(ipr==nperiod)
            set(gca,'XTickLabel',lonw+2:latint:lone,'fontsize',fsize);
        else
            set(gca,'XTickLabel','','fontsize',fsize);
        end
        
        set(gca,'Position',PP(:));
        grid on;
        set(gca,'Gridlinestyle','none','GridColor',[100.0/255.0,100.0/255.0,100.0/255.0],'GridAlpha',0.5,'LineWidth',0.3);
        hold on;
        
        coast = load('Coast');
        h=geoshow(coast.lat,coast.long,'DisplayType','Polygon', 'FaceColor', 'none','LineWidth',0.1); % 'FaceColor', 1.0*[1.0,1.0,1.0]
  
        imagesc(lonmap,latmap,MAP,'alphadata',~isnan(MAP));
        box on;
        
        % Title
        text(lonw+2,latn-0.5,figrank(iplot),'FontSize',fsize+2,'FontWeight','bold','horizontalalignment','left');
        % TickLabel
        if (ipr==1 && ivar==1)
            text(lonw+2-4.3,lats-3.5,'Latitude (^o, N)','FontSize',fsize+1,'VerticalAlignment','middle','Rotation',90);
        end
        if (ipr==nperiod && ivar==floor(nvar/2))
            text(lone+1.6,lats-2.5,'Longitude(^o)','FontSize',fsize+1,'horizontalalignment','center');
        end
        % Period
        if (ivar==nvar)
            text(lone+2.5,(lats+latn)/2-6.2,pername0,'FontSize',fsize+2,'FontWeight','normal', ...
                'VerticalAlignment','middle','Rotation',90);
            text(lone+5,(lats+latn)/2-3.8,pername(ipr),'FontSize',fsize+2,'FontWeight','normal', ...
                'VerticalAlignment','middle','Rotation',90);
        end
        % Variable name
        if (ipr==1)
            text((lonw+2+lone)/2,latn+2,varname(ivar),'FontSize',fsize+3,'FontWeight','bold', ...
                'horizontalalignment','center');
        end
        
        % Colorbar
        if (ipr==nperiod && ivar==3)
            colormap(MAPcolor);
            hc1=colorbar('location','SouthOutside');
            set(hc1,'xTick',0.98:0.93:13,'xTickLabel',{'',level(2:6),'<0','>0',level(9:13),''},'fontsize',fsize+2);
            hc1.Position=[0.17,0.095,0.7,0.02];
            text(lonw+2,lats-7.4,'Change in day (day)','FontSize',fsize+3,'horizontalalignment','center','Rotation',0);
            % colormap(color);
        end
        clear MAPcolor;
        
        hold off;
    end
end
    

print figure
print(fig,'-dtiff','-r300',[outpath,'MAPs_CH_FOR_LUD_changes']);
box off;
% close;


