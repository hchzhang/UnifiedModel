clear all
clc

[phen,species]=xlsread('D:\Phenology\Data\Phen_40yr_2019.xlsx'); %,'F2:K373079'
[nrow,ncol]=size(phen);
ele=xlsread('D:\Phenology\Data\Elevation_pepid.xlsx','A2:B4588');
tempath='D:\Phenology\Data\Climate\';
precpath='G:\Materials\DATA\Phenology\Europe\process\Climate_data\Prec\';
radpath='G:\Materials\DATA\Phenology\Europe\process\Climate_data\RadiaShort\';
yrstart=1950; yrend=2019;nyear=yrend-yrstart+1; nday=366;

output=fopen('D:\Phenology\Data\Phen_40yr_sim.asc','w');
fprintf(output,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t', ...
    'Country','species','specID','LON','LAT','ALT','PEPID','SSID','BBCH','YEAR','DAY');
fprintf(output,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t', ...
    'MAT','aveSpringTem','aveWintSprTem','aveWinTem','aveSummTem','AnnualPrec(mm)', ...
    'WinPrec(mm)','SprPrec(mm)','SummPrec(mm)');
fprintf(output,'%s\t%s\t%s\t%s\t', ...
    'AnnualRad(W/m2)','WinRad(W/m2)','SprRad(W/m2)','SummRad(W/m2)');
fprintf(output,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'aveT_10day','aveT_5day','GDD0','GDD5','ACCT0','ACCT5','CD0','CD5','CD0-5','CU0','CU5');

% site=xlsread('D:\Phenology\Data\SiteNo.xlsx','B2:B2944');  %% Site ID of meteorological data

siteout=fopen('D:\Phenology\Data\SiteNo.asc','w');
fprintf(siteout,'%s\t%s\n','No','PEP_ID');
PEPID=phen(:,6);
PEPID=sort(squeeze(PEPID));
ipep=0;
npepid=0;
site(1,1)=0;
for ii=1:nrow
    if (ipep~=PEPID(ii))
        npepid=npepid+1;
        ipep=PEPID(ii);
        site(npepid,1)=ipep;
        fprintf(siteout,'%d\t%d\n',npepid,ipep); 
    end
end
fclose(siteout);
[nsite,ncolsite]=size(site);

temp0=zeros(nsite,nyear,nday);
prec0=zeros(nsite,nyear,nday);
rad0=zeros(nsite,nyear,nday);
for j=1:nsite
    tempori=dlmread([tempath,num2str(site(j,1)),'id_avetem.asc'],'',1,0);
    precori=dlmread([precpath,num2str(site(j,1)),'id_prec.asc'],'',1,0);
    radori=dlmread([radpath,num2str(site(j,1)),'id_radiashort.asc'],'',1,0);
    [nrm,ncm]=size(tempori);
    for i=1:nrm
        iyr=floor(tempori(i,1))-1949;
        iday=floor(tempori(i,2));
        temp=tempori(i,3);
        prec=precori(i,3);
        rad=radori(i,3);
        temp0(j,iyr,iday)=temp;
        prec0(j,iyr,iday)=prec;
        rad0(j,iyr,iday)=rad;
    end %i=1:nrm
end %j=1:nsite


%%
ssid=0;
ssidold=0;
for i=1:nrow
    ii=find(site==phen(i,6));
    %     tem=dlmread([tempath,num2str(phen(i,6)),'id_avetem.asc'],'',1,0);
    nr=length(ii);
    if (nr>0&&phen(i,9)>1950&&~isnan(temp0(ii,1)))
        if (ssidold~=phen(i,7))
            ssidold=phen(i,7);
            ssid=ssid+1;
        end
        temp=squeeze(temp0(ii,phen(i,9)-1-1949:phen(i,9)-1949,:));
        prec=squeeze(prec0(ii,phen(i,9)-1-1949:phen(i,9)-1949,:));
        rad=squeeze(rad0(ii,phen(i,9)-1-1949:phen(i,9)-1949,:));
        ipep=find(ele(:,1)==phen(i,6));
        elev=ele(ipep,2);
        temp(:,:)=temp(:,:)-(phen(i,5)-elev)*0.0065;
        [nyr,nday]=size(temp);
        avet10=-999;
        avet5=-999;
        GDD0=0;  % Sum of days with mean daily temperature >0
        GDD5=0;  % Sum of days with mean daily temperature >5
        ACCT0=0; % Sum of temperatures higher than 0, sum(Dayi_Tem - 0)
        ACCT5=0; % Sum of temperatures higher than 5, sum(Dayi_Tem - 5)
        CD0=0;   % Sum of days with mean daily temperature <0
        CD5=0;   % Sum of days with mean daily temperature <5
        CU0=0;   % Sum of minus temperatures <0[ sum(0-Dayi_tem)
        CU5=0;   % Sum of minus temperatures <0[ sum(0-Dayi_tem)
        MAT=0;   % Mean annual temperature
        aveTspr=0;
        aveTwin=0;
        aveTwinspr=0;
        
        MAT=(sum(temp(1,phen(i,10):nday-1))+sum(temp(2,1:phen(i,10))))/nday;
        aveTspr=mean(temp(2,60:151));
        aveTwin=(sum(temp(1,nday-31:nday-1))+sum(temp(2,1:59)))/90.0;
        aveTwinspr=(92*aveTspr+aveTwin*90)/(92+90);
        aveTsum=mean(temp(1,152:243));
        totPAnn=sum(prec(1,phen(i,10):nday-1))+sum(prec(2,1:phen(i,10)));
        totPspr=sum(prec(2,60:151));
        totPwin=sum(prec(1,nday-31:nday-1))+sum(prec(2,1:59));
        totPsum=sum(prec(1,152:243));
        radAnn=(sum(rad(1,phen(i,10):nday-1))+sum(rad(2,1:phen(i,10))))/nday;
        radspr=mean(rad(2,60:151));
        radwin=(sum(rad(1,nday-31:nday-1))+sum(rad(2,1:59)))/90.0;
        radsum=mean(rad(1,152:243));
        iday=phen(i,10);
        avet10=mean(temp(2,iday-9:iday));
        avet5=mean(temp(2,iday-4:iday));
        
        for j=305:nday-1
            if(temp(1,j)<0)
                CD0=CD0+1;
                CU0=CU0-temp(1,j);
            end
            if(temp(1,j)<5)
                CD5=CD5+1;
                CU5=CU5+5-temp(1,j);
            end
        end
        %
        for j=1:phen(i,10)
            if(temp(2,j)<0)
                CD0=CD0+1;
                CU0=CU0-temp(2,j);
            end
            if(temp(2,j)<5)
                CD5=CD5+1;
                CU5=CU5+5-temp(2,j);
            end
            if(temp(2,j)>0)
                GDD0=GDD0+1;
                ACCT0=ACCT0+temp(2,j);
            end
            if(temp(2,j)>5)
                GDD5=GDD5+1;
                ACCT5=ACCT5+temp(2,j);
            end
        end
        country=char(species(i+1,3));
        spec=char(species(i+1,1));
        specid=phen(i,1);
        lon=phen(i,3);
        lat=phen(i,4);
        alt=phen(i,5);
        bbch=phen(i,8);
        fprintf(output,'%s\t%s\t%d\t%f\t%f\t%d\t%d\t%d\t%d\t%d\t%d\t', ...
            country,spec,specid,lon,lat,alt,phen(i,6),ssid,bbch,phen(i,9),phen(i,10));
        fprintf(output,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', ...
            MAT,aveTspr,aveTwinspr,aveTwin,aveTsum,totPAnn,totPwin,totPspr,totPsum);
        fprintf(output,'%f\t%f\t%f\t%f\t', ...
            radAnn,radwin,radspr,radsum);
        fprintf(output,'%f\t%f\t%d\t%d\t%f\t%f\t%d\t%d\t%d\t%f\t%f\n', ...
            avet10,avet5,GDD0,GDD5,ACCT0,ACCT5,CD0,CD5,CD5-CD0,CU0,CU5);
    else
        disp('Missing');
    end
    disp(i);
end
fclose('all');