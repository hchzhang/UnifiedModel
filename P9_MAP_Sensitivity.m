% 
clc;
clear all;

outpath='D:\Phenology\Result\Plot\';
inpath='D:\Phenology\Data\';
inpath1='D:\Phenology\Data\param_est\mod_yr4_4\';

nsamp=6989;
latn=56; lats=44; lonw=2; lone=21;
res=0.25;
nlat=(latn-lats)/res;
nlon=(lone-lonw)/res;
latmap=latn:-res:lats;
lonmap=lonw:res:lone;

SS=[0,1176,1593,2742,5668,6162,6989];
nvar=4;

senMAT=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','AQ2:AQ6990');
sigMAT=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','AT2:AT6990');
senSPR=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','AU2:AU6990');
sigSPR=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','AX2:AX6990');
senWIN=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','AY2:AY6990');
sigWIN=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','BB2:BB6990');
senPRE=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','BC2:BC6990');
sigPRE=xlsread([inpath,'Sensitivity_trend_UM.xlsx'],'Sensitivity_trend_UM','BF2:BF6990');
LALO=xlsread([inpath1,'Phen_ss_param.xlsx'],'Phen_ss_param','B2:C6990');

country=shaperead('H:\Materials\MAP\Shapefile\cntry00\cntry00.shp');

%%
color=xlsread('D:\Materials\Program\MATLAB\Color_ZHC.xlsx','sheet1','AI1:AK7');
color=color(:,:)./255.0;
% MAPcolor(:,:,1)=color;
nctry=30;

fsize=6;
xs=0.10; xsize=0.43; xint=0.03;
ys=0.21; ysize=0.33; yint=0.07;

specname={'Ah','Ag','Bp','Fs','Fe','Qr'};
figrank={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
varname={'S_T_{\_MAT}  (-4.5±2.1)','S_T_{\_spring}  (-3.1±1.4)', ...
    'S_T_{\_winter}  (-1.4±0.7)','S_T_{\_Preseason}  (-3.5±1.1)'};

DDMAP=zeros(nlat,nlon);
MAP=zeros(nlat,nlon);
NN=zeros(nlat,nlon);

fig=figure;hold on;
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[5,5,8,10]);

nlevel=8;
level=[-999 -6.0 -4.0 -3.0 -2.0 -1.0 -0.1 999];

nr=2; nc=2;
for irow=1:nr
    for icol=1:nc
        iplot=icol+(irow-1)*nr;
        if (iplot==1)
            DD=senMAT;
            DDsig=sigMAT;
        elseif (iplot==2)
            DD=senSPR;
            DDsig=sigSPR;
        elseif (iplot==3)
            DD=senWIN;
            DDsig=sigWIN;
        elseif (iplot==4)
            DD=senPRE;
            DDsig=sigPRE;
        end
                
        DDMAP(:,:)=0;
        NN(:,:)=0;
        for isp=1:nsamp
            ir=ceil((latn-LALO(isp,2))/res);
            ic=ceil((LALO(isp,1)-lonw)/res);
            if(ir>0 && ir<=nlat && ic>0 && ic<=nlon)
                NN(ir,ic)=NN(ir,ic)+1;
                if (DDsig(isp)<=0.05)
                    DDMAP(ir,ic)=DDMAP(ir,ic)+DD(isp);
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
        for il=1:nlevel-1
            MAP(DDMAP>level(il) & DDMAP<=level(il+1))=il-1;
        end
        MAP(DDMAP>-0.1&DDMAP<=0.1)=nlevel-2;
        MAP(DDMAP>0.1)=nlevel-1;
        MAP(1:nlevel,1)=1:nlevel; 
        % Just tomake sure the colorbar for different subplots same
        
        levmax=max(max(MAP));
        levmin=min(min(MAP));
        %
        nlev=levmax-levmin+1;
        MAPcolor=[color(levmin+1:levmax-2,:);0.8*[1,1,1];color(levmax-1:levmax-1,:)];
        
        
        subplot (nr,nc,iplot);
        PP=[xs+(icol-1)*(xsize+xint),ys+(nr-irow)*(ysize+yint),xsize,ysize];
        
        % plot country boudries
        for ictry=1:nctry
            plot(country(ictry).X,country(ictry).Y,'--k','LineWidth',0.05);
            hold on;
        end
          
        latint=2; lonint=2;
        xlim([lonw+2-0.5  lone+0.5]);ylim([lats-0.5 latn+0.5]);
        set(gca,'XTick',lonw+2:latint:lone,'TickLength',[0.020;0.025]);
        set(gca,'YTick',lats:lonint:latn,'TickLength',[0.020;0.025]);
        if (icol==1)
            set(gca,'YTickLabel',lats:lonint:latn,'fontsize',fsize);
        else
            set(gca,'YTickLabel','','fontsize',fsize);
        end
        if(irow==nr)
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
        text(lonw+2,latn+2,figrank(iplot),'FontSize',fsize+2,'FontWeight','bold','horizontalalignment','left');
        text(lonw+5,latn+2,varname(iplot),'FontSize',fsize+1.5,'FontWeight','Normal', ...
                'horizontalalignment','left');
        % TickLabel
        if (irow==1 && icol==1)
            text(lonw+2-4.2,lats-4.5,'Latitude (^o, N)','FontSize',fsize+0.5,'VerticalAlignment','middle','Rotation',90);
        end
        if (irow==nr && icol==1)
            text(lone+1.6,lats-2.5,'Longitude(^o)','FontSize',fsize+0.5,'horizontalalignment','center');
        end
                 
        % Colorbar
        if (irow==nr && icol==nc)
            colormap(MAPcolor);
            hc1=colorbar('location','SouthOutside');
            pleg=1:1:8;
%             pleg=[pleg,6.5,7,8];
            set(hc1,'xTick',pleg,'xTickLabel',{level(2:nlevel-2),'<0','>0',''},'fontsize',fsize+1.5);
            hc1.Position=[0.12,0.10,0.82,0.01];
            text(lonw+2-1.6,lats-7.4,'Temperature sensitivity (day ^oC^{-1})','FontSize',fsize+1.5,'horizontalalignment','center','Rotation',0);
            % colormap(color);
        end
        clear MAPcolor;
        
        hold off;
    end
end
    

print figure
print(fig,'-dtiff','-r300',[outpath,'MAPs_Sensitivity_preseasonREG']);
box off;
% close;


