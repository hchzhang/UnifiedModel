clear all
clc
%
nyr=70;
nday=366;
phen=xlsread('D:\Phenology\Data\Phen_40yr_sim_UnifiedModel.xlsx','F2:O386321');
avephen=xlsread('D:\Phenology\Data\param_est\mod_yr4_4\Phen_ss_param.xlsx','phen_ss_param','F2:I7001');
param=xlsread('D:\Phenology\Data\param_est\mod_yr4_4\Phen_ss_param.xlsx','phen_ss_param','AT2:AX7001');
CH0=xlsread('D:\Phenology\Data\param_est\mod_yr4_4\Phen_ss_param.xlsx','phen_ss_param','BA2:BA7001'); % Chilling accumulation
DC0=xlsread('D:\Phenology\Data\param_est\mod_yr4_4\Phen_ss_param.xlsx','phen_ss_param','BB2:BB7001'); % Day when chilling start
ele=xlsread('D:\Phenology\Data\Elevation_pepid.xlsx','A2:B4588');
tempath='D:\Phenology\Data\Climate\';

site=xlsread('D:\Phenology\Data\SiteNo.xlsx','B2:B2945');  %% Site ID of meteorological data
[nsite,ncolsite]=size(site);
%
mete0=zeros(nsite,nyr,nday);
for j=1:nsite
    meteori=dlmread([tempath,num2str(site(j,1)),'id_avetem.asc'],'',1,0);
    [nrm,ncm]=size(meteori);
    for i=1:nrm
        iyr=floor(meteori(i,1))-1949;
        iday=floor(meteori(i,2));
        tem=meteori(i,3);
        mete0(j,iyr,iday)=tem;
    end %i=1:nrm
end %j=1:nsite
%
output=fopen('D:\Phenology\Data\Sensitivity_trend_UM_LUDobs.asc','w');
fprintf(output,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t', ...
    'ssid','year','aveLOD','MAT','aveSpringTem','aveWintTem','preseason_length', ...
    'preseason_avetem','preseasUM_avetem','aveGDD0','aveGDD5','aveACCT0','aveACCT5','aveCD0', ...
    'aveCD5','aveCD0-5','aveCU0','aveCU5');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_LUD_trend(day/yr)','c_LUD_trend','R2_LUD_trend','p-LUD_trend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_MAT_trend(C/yr)','c_MAT_trend','R2_MAT_trend','p-MAT_trend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_springT_trend(C/yr)','c_springT_trend','R2_springT_trend','p_springT_trend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_winterT_trend(C/yr)','c_winterT_trend','R2_winterT_trend','p_winterT_trend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_preseasonT_trend(C/yr)','c_preseasonT_trend','R2_preseasonT_trend','p_preseasonT_trend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_preseasUMT_trend(C/yr)','c_preseasUMT_trend','R2_preseasUMT_trend','p_preseasUMT_trend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_MAT_sen(day/C)','c_MAT_sen','R2_MAT_sen','p-MAT_sen');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_springT_sen(day/C)','c_springT_sen','R2_springT_sen','p_springT_sen');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_winterT_sen(day/C)','c_winterT_sen','R2_winterT_sen','p_winterT_sen');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_preseasonT_sen(day/C)','c_preseasonT_sen','R2_preseasonT_trend','p_preseasonT_sen');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_preseasUMT_sen(day/C)','c_preseasUMT_sen','R2_preseasUMT_trend','p_preseasUMT_sen');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_k_preT(day/C/yr)','c_trend_k_preT','R2_trend_k_preT','p_trend_k_preT');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_LUD(day/C/yr)','c_trend_preT_LUD','R2_trend_preT_LUD','p_preT_LUD');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CD0(day/C/yr)','c_trend_preT_CD0','R2_trend_preT_CD0','p_preT_CD0');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CD5(day/C/yr)','c_trend_preT_CD5','R2_trend_preT_CD5','p_preT_CD5');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CD05(day/C/yr)','c_trend_preT_CD05','R2_trend_preT_CD05','p_preT_CD05');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_DF(day/C/yr)','c_trend_preT_DF','R2_trend_preT_DF','p_preT_DF');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_FAVE(day/C/yr)','c_trend_preT_FAVE','R2_trend_preT_FAVE','p_preT_FAVE');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_FAVECH(day/C/yr)','c_trend_preT_FAVECH','R2_trend_preT_FAVECH','p_preT_FAVECH');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_DFFAVE(day/C/yr)','c_trend_preT_DFFAVE','R2_trend_preT_DFFAVE','p_preT_DFFAVE');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_DFFAVECH(day/C/yr)','c_trend_preT_DFFAVECH','R2_trend_preT_DFFAVECH','p_preT_DFFAVECH');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHend(day/C/yr)','c_trend_preT_CHend','R2_trend_preT_CHend','p_preT_CHend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHDFFAVE(day/C/yr)','c_trend_preT_CHDFFAVE','R2_trend_preT_CHDFFAVE','p_preT_CHDFFAVE');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHDFFAVECH(day/C/yr)','c_trend_preT_CHDFFAVECH','R2_trend_preT_CHDFFAVECH','p_preT_CHDFFAVECH');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHr(day/C/yr)','c_trend_preT_CHr','R2_trend_preT_CHr','p_preT_CHr');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHtot(day/C/yr)','c_trend_preT_CHtot','R2_trend_preT_CHtot','p_preT_CHtot');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHrCHtot(day/C/yr)','c_trend_preT_CHrCHtot','R2_trend_preT_CHrCHtot','p_preT_CHrCHtot');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preT_CHrCHtotFave(day/C/yr)','c_trend_preT_CHrCHtotFave','R2_trend_preT_CHrCHtotFave','p_preT_CHrCHtotFave');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_CD05(day/C/yr)','c_trend_preUMT_CD05','R2_trend_preUMT_CD05','p_preUMT_CD05');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_DF(day/C/yr)','c_trend_preUMT_DF','R2_trend_preUMT_DF','p_preUMT_DF');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_FAVE(day/C/yr)','c_trend_preUMT_FAVE','R2_trend_preUMT_FAVE','p_preUMT_FAVE');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_CHend(day/C/yr)','c_trend_preUMT_CHend','R2_trend_preUMT_CHend','p_preUMT_CHend');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_DFFAVE(day/C/yr)','c_trend_preUMT_DFFAVE','R2_trend_preUMT_DFFAVE','p_preUMT_DFFAVE');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_CHDFFAVE(day/C/yr)','c_trend_preUMT_CHDFFAVE','R2_trend_preUMT_CHDFFAVE','p_preUMT_CHDFFAVE');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_CHr(day/C/yr)','c_trend_preUMT_CHr','R2_trend_preUMT_CHr','p_preUMT_CHr');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_CHtot(day/C/yr)','c_trend_preUMT_CHtot','R2_trend_preUMT_CHtot','p_preUMT_CHtot');
fprintf(output,'%s\t%s\t%s\t%s\t', 'k_trend_preUMT_CHrCHtot(day/C/yr)','c_trend_preT_CHrCHtot','R2_trend_preUMT_CHrCHtot','p_preUMT_CHrCHtot');
fprintf(output,'%s\t%s\t%s\t%s\n', 'k_trend_preUMT_CHrCHtotFave(day/C/yr)','c_trend_preUMT_CHrCHtotFave','R2_trend_preUMT_CHrCHtotFave','p_preUMT_CHrCHtotFave');

output1=fopen('D:\Phenology\Data\Temperature_SiteYr_perseason_UM.asc','w');
fprintf(output1,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'ssid','year','aveLOD','MAT','aveSpringTem','aveWintTem','preseason_length', ...
    'preseason_avetem','preseasUM_avetem','aveGDD0','aveGDD5','aveACCT0','aveACCT5','aveCD0', ...
    'aveCD5','aveCD0-5','aveCU0','aveCU5');
output2=fopen('D:\Phenology\Data\TemSensitivity_Series_perseason_UM.asc','w');
fprintf(output2,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t', ...
    'ssid','year','aveLOD','MAT','aveSpringTem','aveWintTem','preseason_length', ...
    'preseason_avetem','preseasUM_avetem','aveGDD0','aveGDD5','aveACCT0','aveACCT5','aveCD0', ...
    'aveCD5','aveCD0-5','aveCU0','aveCU5','ForcingDuration','Ave_forcingrate', ...
    'Ave_forcingrateCH','Ave_Chillrate','Ave_CHillTot');
fprintf(output2,'%s\t%s\t%s\t%s\t', 'k_preseasonT_trend(C/yr)','c_preseasonT_trend','R2_preseasonT_trend','p_preseasonT_trend');
fprintf(output2,'%s\t%s\t%s\t%s\n', 'k_preseasUMT_trend(C/yr)','c_preseasUMT_trend','R2_preseasUMT_trend','p_preseasUMT_trend');
%% Initialization
[nrow,ncol]=size(phen);
nstep=24;
dayinterval=5;
isampst=1;
ssid=phen(isampst,3);
nsamp=0;
subterm=15;
substep=1;
nssid=length(avephen(:,1));
% Average dormancy release day
CHEAVE=zeros(nssid+1,1);
chend0=phen(1,3);
subCHE(1:100)=0;
iss=0;
for ii=1:nrow
    if (chend0==phen(ii,3))
        iss=iss+1;
        subCHE(iss)=phen(ii,9);
    else
        CHEAVE(chend0)=mean(subCHE(1:iss));
        iss=1;
        chend0=phen(ii,3);
        subCHE(iss)=phen(ii,9);
    end
end
CHEAVE(nssid+1)=CHEAVE(nssid);
%
nss=200;
YY(1:nss,1)=0;    % Year
DD(1:nss,1)=0;    % Day
DDsim(1:nss,1)=0;    % Day
MAT(1:nss,1)=0;   % Mean annual temperature
aveTspring(1:nss,1)=0; % Mean spring temperature
aveTwin(1:nss,1)=0; % Mean winter temperature
avetpreseason(1:nss,1:nstep)=-999; % Preseason determined by the Fu et al., 2015 Nature
avetpreseasUM(1:nss,1)=-999; % Preseason determined by Unified model (dc0)
GDD0(1:nss,1)=0;  % Sum of days with mean daily temperature >0
GDD5(1:nss,1)=0;  % Sum of days with mean daily temperature >5
ACCT0(1:nss,1)=0; % Sum of temperatures higher than 0, sum(Dayi_Tem - 0)
ACCT5(1:nss,1)=0; % Sum of temperatures higher than 5, sum(Dayi_Tem - 5)
CD0(1:nss,1)=0;   % Sum of days with mean daily temperature <0
CD5(1:nss,1)=0;   % Sum of days with mean daily temperature <5
CU0(1:nss,1)=0;   % Sum of minus temperatures <0[ sum(0-Dayi_tem)
CU5(1:nss,1)=0;   % Sum of minus temperatures <0[ sum(0-Dayi_tem)
DF(1:nss,1)=0;    % Duration of forxing stage
CHE(1:nss,1)=0;    % End day of chilling
FAVE(1:nss,1)=0;    % Average daily forcing accumulation from real Chilling end day to LUD
FAVECH(1:nss,1)=0;   % Average daily forcing accumulation average Chilling end day to LUD
CHr(1:nss,1)=0;    % Average daily chilling rate from dc0 to the real Chilling end day
CHtot(1:nss,1)=0;  % Total chilling accumulation from dc0 to LUD
%
for i=isampst:nrow
    if(phen(i,3)==ssid&&i~=nrow)
        nsamp=nsamp+1;
        ii=find(site==phen(i,2));
        tem=squeeze(mete0(ii,phen(i,5)-1-1949:phen(i,5)-1949,:));
        ipep=find(ele(:,1)==phen(i,2));
        elev=ele(ipep,2);
        tem(:,:)=tem(:,:)-(phen(i,1)-elev)*0.0065;
        [nyr,nday]=size(tem);
        FRunit=max(0,1.0./(1.0+exp(param(ssid,4)*(tem(:,:)-param(ssid,5)))));
        CHunit=max(0,1.0./(1.0+exp(param(ssid,1)*(tem(:,:)-param(ssid,3)).^2+param(ssid,2)*(tem(:,:)-param(ssid,3)))));
        
        ilud=6;
        YY(nsamp)=phen(i,5);
        DD(nsamp)=phen(i,ilud);
        CHE(nsamp)=phen(i,9);
        DDsim(nsamp)=phen(i,10);
        DF(nsamp)=phen(i,10)-phen(i,9)+1;
%         FAVE(nsamp)=phen(i,8)/(phen(i,ilud)-phen(i,9));
        irr=find(ssid==avephen(:,1));
        avelud=floor(avephen(irr,4));
        aveche=round(CHEAVE(ssid));
        iCH0=CH0(ssid);
        iDC0=ceil(DC0(ssid));
        if (CHE(nsamp)<=0)
            FAVE(nsamp)=(sum(FRunit(1,nday+CHE(nsamp)-1:nday-1))+sum(FRunit(2,1:DDsim(nsamp))))/(DDsim(nsamp)-CHE(nsamp)+1);
        else
            FAVE(nsamp)=mean(FRunit(2,CHE(nsamp):DDsim(nsamp)));
        end
        %
        if (aveche<=0)
            FAVECH(nsamp)=(sum(FRunit(1,nday+aveche-1:nday-1))+sum(FRunit(2,1:avelud)))/(avelud-aveche+1);
        else
            FAVECH(nsamp)=mean(FRunit(2,aveche:avelud));
        end
        
        if (aveche<=0)
            CHr(nsamp)=sum(CHunit(1,nday+iDC0-1:nday+aveche-1));
        elseif(iDC0>0)
            CHr(nsamp)=sum(CHunit(2,iDC0:aveche));
        elseif(iDC0<=0&&aveche>0)
            CHr(nsamp)=sum(CHunit(1,nday+iDC0-1:nday-1))+sum(CHunit(2,1:aveche));
        end
        CHr(nsamp)= CHr(nsamp)/(aveche-iDC0+1);
        
        if (iDC0<=0)
            CHtot(nsamp)=sum(CHunit(1,nday+iDC0-1:nday-1))+sum(CHunit(2,1:avelud));
        else
            CHtot(nsamp)=sum(CHunit(2,iDC0:avelud));
        end
        
        if (iDC0<=0)
            avetpreseasUM(nsamp)=sum(tem(1,nday+iDC0-1:nday-1))+sum(tem(2,1:avelud));
        else
            avetpreseasUM(nsamp)=sum(tem(2,iDC0:avelud));
        end
        avetpreseasUM(nsamp)=avetpreseasUM(nsamp)/(avelud-iDC0+1);
        
        MAT(nsamp)=(sum(tem(1,avelud:nday-1))+sum(tem(2,1:avelud)))/nday;
        aveTspring(nsamp)=mean(tem(2,60:151));
        % aveTwinspr(nsamp)=(mean(tem(2,32:120))+mean(tem(1,nday-90:nday-1)))/2.0;
        aveTwin(nsamp)=(sum(tem(1,nday-31:nday-1))+sum(tem(2,1:59)))/90.0;
    
        for j=305:nday-1
            if(tem(1,j)<0)
                CD0(nsamp)=CD0(nsamp)+1;
                CU0(nsamp)=CU0(nsamp)-tem(1,j);
            end
            if(tem(1,j)<5)
                CD5(nsamp)=CD5(nsamp)+1;
                CU5(nsamp)=CU5(nsamp)+5-tem(1,j);
            end
        end
        %
        for j=1:avelud
            if(tem(2,j)<0)
                CD0(nsamp)=CD0(nsamp)+1;
                CU0(nsamp)=CU0(nsamp)-tem(2,j);
            end
            if(tem(2,j)<5)
                CD5(nsamp)=CD5(nsamp)+1;
                CU5(nsamp)=CU5(nsamp)+5-tem(2,j);
            end
            if(tem(2,j)>0)
                GDD0(nsamp)=GDD0(nsamp)+1;
                ACCT0(nsamp)=ACCT0(nsamp)+tem(2,j);
            end
            if(tem(2,j)>5)
                GDD5(nsamp)=GDD5(nsamp)+1;
                ACCT5(nsamp)=ACCT5(nsamp)+tem(2,j);
            end
        end
        %
        for j=2:nstep
            if (avelud>=j*dayinterval)
                avetpreseason(nsamp,j)=mean(tem(2,avelud-j*dayinterval+1:avelud));
            else
                avetpreseason(nsamp,j)=(sum(tem(2,1:avelud))+ ...
                sum(tem(1,nday-(j*dayinterval-avelud):nday-1)))/(j*dayinterval);
            end
        end
    else
        % Determine the length of preseason based on r2 of linear
        % regression function
        pp=1.0;
        for j=2:nstep
            TT=avetpreseason(1:nsamp,j);
            CC=DD(1:nsamp);
            [raft,paft] = corrcoef(CC,TT);
            if (paft(2,1)<pp)
                pp=paft(2,1);
                preseason_tem=mean(TT);
                preseason_length=j*dayinterval;
                ipre=j;
            end
        end
        clear CC TT
        % Average value for all observation years
        aveyrs(1:16)=-999;
        aveyrs(1)=mean(YY(1:nsamp));             aveyrs(2)=mean(DD(1:nsamp));
        aveyrs(3)=mean(MAT(1:nsamp));            aveyrs(4)=mean(aveTspring(1:nsamp));
        aveyrs(5)=mean(aveTwin(1:nsamp));        aveyrs(6)=mean(preseason_length);
        aveyrs(7)=mean(avetpreseason(1:nsamp,ipre));   aveyrs(8)=mean(avetpreseasUM(1:nsamp));
        aveyrs(9)=mean(GDD0(1:nsamp));
        aveyrs(10)=mean(GDD5(1:nsamp));          aveyrs(11)=mean(ACCT0(1:nsamp));
        aveyrs(12)=mean(ACCT5(1:nsamp));         aveyrs(13)=mean(CD0(1:nsamp));
        aveyrs(14)=mean(CD5(1:nsamp));           aveyrs(15)=mean(CD5(1:nsamp)-CD0(1:nsamp));
        aveyrs(16)=mean(CU0(1:nsamp));           aveyrs(17)=mean(CU5(1:nsamp));
        %
        for isap=1:nsamp
            fprintf(output1,'%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', ...
                phen(i-1,3),YY(isap),DD(isap),MAT(isap),aveTspring(isap),aveTwin(isap), ...
                preseason_length,avetpreseason(isap,ipre),avetpreseasUM(isap),GDD0(isap),GDD5(isap),ACCT0(isap), ...
                ACCT5(isap),CD0(isap),CD5(isap),CD5(isap)-CD0(isap),CU0(isap),CU5(isap));
        end
        % Change trend during observation period
        coef(14,1:4)=-999;
        AA=[ones(nsamp,1),YY(1:nsamp)];
        BB=DD(1:nsamp);
        [b,bint,r,rint,s]=regress(BB,AA,0.05);
        coef(1,1)=b(2); % k-slope
        coef(1,2)=b(1); % interception
        coef(1,3)=s(1); % r^2
        coef(1,4)=s(3); % p-value
        %
        BB=MAT(1:nsamp);
        [b,bint,r,rint,s]=regress(BB,AA,0.05);
        coef(2,1)=b(2); % k-slope
        coef(2,2)=b(1); % interception
        coef(2,3)=s(1); % r^2
        coef(2,4)=s(3); % p-value
        %
        BB=aveTspring(1:nsamp);
        [b,bint,r,rint,s]=regress(BB,AA,0.05);
        coef(3,1)=b(2); % k-slope
        coef(3,2)=b(1); % interception
        coef(3,3)=s(1); % r^2
        coef(3,4)=s(3); % p-value
        %
        BB=aveTwin(1:nsamp);
        [b,bint,r,rint,s]=regress(BB,AA,0.05);
        coef(4,1)=b(2); % k-slope
        coef(4,2)=b(1); % interception
        coef(4,3)=s(1); % r^2
        coef(4,4)=s(3); % p-value
        %
        BB=avetpreseason(1:nsamp,ipre);
        [b,bint,r,rint,s]=regress(BB,AA,0.05);
        coef(5,1)=b(2); % k-slope
        coef(5,2)=b(1); % interception
        coef(5,3)=s(1); % r^2
        coef(5,4)=s(3); % p-value
        %
        %
        BB=avetpreseasUM(1:nsamp);
        [b,bint,r,rint,s]=regress(BB,AA,0.05);
        coef(6,1)=b(2); % k-slope
        coef(6,2)=b(1); % interception
        coef(6,3)=s(1); % r^2
        coef(6,4)=s(3); % p-value
        %
        clear AA BB
        
        % Sensitivity of LOD to temperature
        AA=DD(1:nsamp);
        BB=[ones(nsamp,1),MAT(1:nsamp)];
        [b,bint,r,rint,s]=regress(AA,BB,0.05);
        coef(7,1)=b(2); % k-slope
        coef(7,2)=b(1); % interception
        coef(7,3)=s(1); % r^2
        coef(7,4)=s(3); % p-value
        %
        BB=[ones(nsamp,1),aveTspring(1:nsamp)];
        [b,bint,r,rint,s]=regress(AA,BB,0.05);
        coef(8,1)=b(2); % k-slope
        coef(8,2)=b(1); % interception
        coef(8,3)=s(1); % r^2
        coef(8,4)=s(3); % p-value
        %
        BB=[ones(nsamp,1),aveTwin(1:nsamp)];
        [b,bint,r,rint,s]=regress(AA,BB,0.05);
        coef(9,1)=b(2); % k-slope
        coef(9,2)=b(1); % interception
        coef(9,3)=s(1); % r^2
        coef(9,4)=s(3); % p-value
        %
        BB=[ones(nsamp,1),avetpreseason(1:nsamp,ipre)];
        [b,bint,r,rint,s]=regress(AA,BB,0.05);
        coef(10,1)=b(2); % k-slope
        coef(10,2)=b(1); % interception
        coef(10,3)=s(1); % r^2
        coef(10,4)=s(3); % p-value
        %
        BB=[ones(nsamp,1),avetpreseasUM(1:nsamp)];
        [b,bint,r,rint,s]=regress(AA,BB,0.05);
        coef(11,1)=b(2); % k-slope
        coef(11,2)=b(1); % interception
        coef(11,3)=s(1); % r^2
        coef(11,4)=s(3); % p-value
        %
        clear AA BB
        
        % Temporal change trend of LOD temperature sensitivity
        nsub=floor((nsamp-subterm)/substep)+1;
        Ymid = zeros(nsub,1);
        DDmid = zeros(nsub,1);
        CHEmid = zeros(nsub,1);
        CH0mid = zeros(nsub,1);
        CH5mid = zeros(nsub,1);
        CH05mid = zeros(nsub,1);
        DFmid = zeros(nsub,1);
        FAVEmid = zeros(nsub,1);
        FAVECHmid = zeros(nsub,1);
        CHrmid = zeros(nsub,1);
        CHtotmid = zeros(nsub,1);
        KK = zeros(nsub,1);
        KKUM = zeros(nsub,1);
        CD05=CD5(:)-CD0(:);
        for ii=1:nsub
            yrs=substep*(ii-1)+1;
            yre=min(nsamp,substep*(ii-1)+subterm);
            subterm_act=yre-yrs+1;
            Ymid(ii)=mean(YY(yrs:yre));
            DDmid(ii)=mean(DD(yrs:yre));
            CHEmid(ii)=mean(CHE(yrs:yre));
            CH0mid(ii)=mean(CD0(yrs:yre));
            CH5mid(ii)=mean(CD5(yrs:yre));
            CH05mid(ii)=mean(CD05(yrs:yre));
            DFmid(ii)=mean(DF(yrs:yre));
            FAVEmid(ii)=mean(FAVE(yrs:yre));
            FAVECHmid(ii)=mean(FAVECH(yrs:yre));
            CHrmid(ii)=mean(CHr(yrs:yre));
            CHtotmid(ii)=mean(CHtot(yrs:yre));
            
            AA=DD(yrs:yre);
            BB=[ones(subterm_act,1),avetpreseason(yrs:yre,ipre)];
            [b,bint,r,rint,s]=regress(AA,BB,0.05);
            KK(ii)=b(2);
            
            AA=DD(yrs:yre);
            BB=[ones(subterm_act,1),avetpreseasUM(yrs:yre)];
            [b1,bint,r,rint,s1]=regress(AA,BB,0.05);
            KKUM(ii)=b1(2);
            
            fprintf(output2,'%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', ...
                phen(i-1,3),mean(YY(yrs:yre)),mean(DD(yrs:yre)),mean(MAT(yrs:yre)),mean(aveTspring(yrs:yre)),mean(aveTwin(yrs:yre)), ...
                preseason_length,mean(avetpreseason(yrs:yre,ipre)),mean(avetpreseasUM(yrs:yre)),mean(GDD0(yrs:yre)),mean(GDD5(yrs:yre)),mean(ACCT0(yrs:yre)), ...
                mean(ACCT5(yrs:yre)),mean(CD0(yrs:yre)),mean(CD5(yrs:yre)),mean(CD05(yrs:yre)),mean(CU0(yrs:yre)),mean(CU5(yrs:yre)), ...
                mean(DF(yrs:yre)),mean(FAVE(yrs:yre)),mean(FAVECH(yrs:yre)),mean(CHr(yrs:yre)),mean(CHtot(yrs:yre)));
            
            fprintf(output2,'%f\t%f\t%f\t%f\t',b(2),b(1),s(1),s(3));
            fprintf(output2,'%f\t%f\t%f\t%f\n',b1(2),b1(1),s1(1),s1(3));
            clear AA BB
        end
        clear CD05
        
        KKm=KK(1:nsub);
        Ymid=[ones(nsub,1),Ymid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(12,1)=b(2); % k-slope
        coef(12,2)=b(1); % interception
        coef(12,3)=s(1); % r^2
        coef(12,4)=s(3); % p-value
        clear Ymid
        Ymid=[ones(nsub,1),DDmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(13,1)=b(2); % k-slope
        coef(13,2)=b(1); % interception
        coef(13,3)=s(1); % r^2
        coef(13,4)=s(3); % p-value
        clear Ymid
        Ymid=[ones(nsub,1),CH0mid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(14,1)=b(2); % k-slope
        coef(14,2)=b(1); % interception
        coef(14,3)=s(1); % r^2
        coef(14,4)=s(3); % p-value
        clear Ymid
        Ymid=[ones(nsub,1),CH5mid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(15,1)=b(2); % k-slope
        coef(15,2)=b(1); % interception
        coef(15,3)=s(1); % r^2
        coef(15,4)=s(3); % p-value
        clear Ymid
        Ymid=[ones(nsub,1),CH05mid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(16,1)=b(2); % k-slope
        coef(16,2)=b(1); % interception
        coef(16,3)=s(1); % r^2
        coef(16,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),DFmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(17,1)=b(2); % k-slope
        coef(17,2)=b(1); % interception
        coef(17,3)=s(1); % r^2
        coef(17,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),FAVEmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(18,1)=b(2); % k-slope
        coef(18,2)=b(1); % interception
        coef(18,3)=s(1); % r^2
        coef(18,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),FAVECHmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(19,1)=b(2); % k-slope
        coef(19,2)=b(1); % interception
        coef(19,3)=s(1); % r^2
        coef(19,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),DFmid(1:nsub),FAVEmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(20,1)=b(2); % k-slope
        coef(20,2)=b(1); % interception
        coef(20,3)=s(1); % r^2
        coef(20,4)=s(3); % p-value
        clear Ymid 
        
        Ymid=[ones(nsub,1),DFmid(1:nsub),FAVECHmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(21,1)=b(2); % k-slope
        coef(21,2)=b(1); % interception
        coef(21,3)=s(1); % r^2
        coef(21,4)=s(3); % p-value
        clear Ymid 
        
        if(std(CHEmid(1:nsub))==0)
            coef(22,1:4)=0;
        else
            Ymid=[ones(nsub,1),CHEmid(1:nsub)];
            [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
            coef(22,1)=b(2); % k-slope
            coef(22,2)=b(1); % interception
            coef(22,3)=s(1); % r^2
            coef(22,4)=s(3); % p-value
            clear Ymid
        end
        
        if(std(CHEmid(1:nsub))==0)
            coef(23,1:4)=0;
        else
            Ymid=[ones(nsub,1),CHEmid(1:nsub),DFmid(1:nsub),FAVEmid(1:nsub)];
            [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
            coef(23,1)=b(2); % k-slope
            coef(23,2)=b(1); % interception
            coef(23,3)=s(1); % r^2
            coef(23,4)=s(3); % p-value
            clear Ymid
        end
        
        if(std(CHEmid(1:nsub))==0)
            coef(24,1:4)=0;
        else
            Ymid=[ones(nsub,1),CHEmid(1:nsub),DFmid(1:nsub),FAVECHmid(1:nsub)];
            [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
            coef(24,1)=b(2); % k-slope
            coef(24,2)=b(1); % interception
            coef(24,3)=s(1); % r^2
            coef(24,4)=s(3); % p-value
            clear Ymid
        end
        
        Ymid=[ones(nsub,1),CHrmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(25,1)=b(2); % k-slope
        coef(25,2)=b(1); % interception
        coef(25,3)=s(1); % r^2
        coef(25,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),CHtotmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(26,1)=b(2); % k-slope
        coef(26,2)=b(1); % interception
        coef(26,3)=s(1); % r^2
        coef(26,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),CHrmid(1:nsub),CHtotmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(27,1)=b(2); % k-slope
        coef(27,2)=b(1); % interception
        coef(27,3)=s(1); % r^2
        coef(27,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),CHrmid(1:nsub),CHtotmid(1:nsub),FAVECHmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(28,1)=b(2); % k-slope
        coef(28,2)=b(1); % interception
        coef(28,3)=s(1); % r^2
        coef(28,4)=s(3); % p-value
        clear Ymid
        
        KKm=KKUM(1:nsub);
        Ymid=[ones(nsub,1),CH05mid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(29,1)=b(2); % k-slope
        coef(29,2)=b(1); % interception
        coef(29,3)=s(1); % r^2
        coef(29,4)=s(3); % p-value
        clear CH05mid
        
        Ymid=[ones(nsub,1),DFmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(30,1)=b(2); % k-slope
        coef(30,2)=b(1); % interception
        coef(30,3)=s(1); % r^2
        coef(30,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),FAVECHmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(31,1)=b(2); % k-slope
        coef(31,2)=b(1); % interception
        coef(31,3)=s(1); % r^2
        coef(31,4)=s(3); % p-value
        clear Ymid
        
        if(std(CHEmid(1:nsub))==0)
            coef(32,1:4)=0;
        else
            Ymid=[ones(nsub,1),CHEmid(1:nsub)];
            [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
            coef(32,1)=b(2); % k-slope
            coef(32,2)=b(1); % interception
            coef(32,3)=s(1); % r^2
            coef(32,4)=s(3); % p-value
            clear Ymid
        end
        
        Ymid=[ones(nsub,1),DFmid(1:nsub),FAVECHmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(33,1)=b(2); % k-slope
        coef(33,2)=b(1); % interception
        coef(33,3)=s(1); % r^2
        coef(33,4)=s(3); % p-value
        clear Ymid
        
        if(std(CHEmid(1:nsub))==0)
            coef(34,1:4)=0;
        else
            Ymid=[ones(nsub,1),CHEmid(1:nsub),DFmid(1:nsub),FAVECHmid(1:nsub)];
            [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
            coef(34,1)=b(2); % k-slope
            coef(34,2)=b(1); % interception
            coef(34,3)=s(1); % r^2
            coef(34,4)=s(3); % p-value
            clear Ymid
        end
        
        Ymid=[ones(nsub,1),CHrmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(35,1)=b(2); % k-slope
        coef(35,2)=b(1); % interception
        coef(35,3)=s(1); % r^2
        coef(35,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),CHtotmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(36,1)=b(2); % k-slope
        coef(36,2)=b(1); % interception
        coef(36,3)=s(1); % r^2
        coef(36,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),CHrmid(1:nsub),CHtotmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(37,1)=b(2); % k-slope
        coef(37,2)=b(1); % interception
        coef(37,3)=s(1); % r^2
        coef(37,4)=s(3); % p-value
        clear Ymid
        
        Ymid=[ones(nsub,1),CHrmid(1:nsub),CHtotmid(1:nsub),FAVECHmid(1:nsub)];
        [b,bint,r,rint,s]=regress(KKm,Ymid,0.05);
        coef(38,1)=b(2); % k-slope
        coef(38,2)=b(1); % interception
        coef(38,3)=s(1); % r^2
        coef(38,4)=s(3); % p-value
        clear Ymid
        
        fprintf(output,'%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', ...
        phen(i-1,3),aveyrs(:));
        for ii=1:37
            fprintf(output,'%f\t%f\t%f\t%f\t',coef(ii,:));
        end
        fprintf(output,'%f\t%f\t%f\t%f\n',coef(38,:));
        
        % ************************************************
%         clear YY DD MAT aveTspring aveTwin avet10 avet5 GDD0 GDD5  ...
%                 ACCT0 ACCT5 CD0 CD5 CD5-CD0 CU0 CU5
        YY(:,1)=0;    % Year
        DD(:,1)=0;    % Day
        MAT(:,1)=0;   % Mean annual temperature
        aveTspring(:,1)=0; % Mean spring temperature
        aveTwin(:,1)=0; % Mean winter temperature
        avetpreseason(:,1:nstep)=-999;
        GDD0(:,1)=0;  % Sum of days with mean daily temperature >0
        GDD5(:,1)=0;  % Sum of days with mean daily temperature >5
        ACCT0(:,1)=0; % Sum of temperatures higher than 0, sum(Dayi_Tem - 0)
        ACCT5(:,1)=0; % Sum of temperatures higher than 5, sum(Dayi_Tem - 5)
        CD0(:,1)=0;   % Sum of days with mean daily temperature <0
        CD5(:,1)=0;   % Sum of days with mean daily temperature <5
        CU0(:,1)=0;   % Sum of minus temperatures <0[ sum(0-Dayi_tem)
        CU5(:,1)=0;   % Sum of minus temperatures <0[ sum(0-Dayi_tem)
        FAVE(:)=0;
        FAVECH(:)=0;
        CHr(:)=0;
        CHtot(:)=0;
        avetpreseasUM(:)=0;
        %
        ssid=phen(i,3);
        nsamp=1;
        ii=find(site==phen(i,2));
        tem=squeeze(mete0(ii,phen(i,5)-1-1949:phen(i,5)-1949,:));
        ipep=find(ele(:,1)==phen(i,2));
        elev=ele(ipep,2);
        tem(:,:)=tem(:,:)-(phen(i,1)-elev)*0.0065;
        [nyr,nday]=size(tem);
    
        YY(nsamp)=phen(i,5);
        DD(nsamp)=phen(i,ilud);
        CHE(nsamp)=phen(i,9);
        DDsim(nsamp)=phen(i,10);
        DF(nsamp)=phen(i,10)-phen(i,9)+1;
        irr=find(phen(i,3)==avephen(:,1));
        avelud=floor(avephen(irr,4));
        aveche=round(CHEAVE(ssid));
        iCH0=CH0(ssid);
        iDC0=ceil(DC0(ssid));
        if (CHE(nsamp)<=0)
            FAVE(nsamp)=(sum(FRunit(1,nday+CHE(nsamp)-1:nday-1))+sum(FRunit(2,1:DDsim(nsamp))))/(DDsim(nsamp)-CHE(nsamp)+1);
        else
            FAVE(nsamp)=mean(FRunit(2,CHE(nsamp):DDsim(nsamp)));
        end
        %
        if (aveche<=0)
            FAVECH(nsamp)=(sum(FRunit(1,nday+aveche-1:nday-1))+sum(FRunit(2,1:avelud)))/(avelud-aveche+1);
        else
            FAVECH(nsamp)=mean(FRunit(2,aveche:avelud));
        end
        
        if (aveche<=0)
            CHr(nsamp)=sum(CHunit(1,nday+iDC0-1:nday+aveche-1));
        elseif(iDC0>0)
            CHr(nsamp)=sum(CHunit(2,iDC0:aveche));
        elseif(iDC0<=0&&aveche>0)
            CHr(nsamp)=sum(CHunit(1,nday+iDC0-1:nday-1))+sum(CHunit(2,1:aveche));
        end
        CHr(nsamp)= CHr(nsamp)/(aveche-iDC0+1);
        
        if (iDC0<=0)
            CHtot(nsamp)=sum(CHunit(1,nday+iDC0-1:nday-1))+sum(CHunit(2,1:avelud));
        else
            CHtot(nsamp)=sum(CHunit(2,iDC0:avelud));
        end
        
        if (iDC0<=0)
            avetpreseasUM(nsamp)=sum(tem(1,nday+iDC0-1:nday-1))+sum(tem(2,1:avelud));
        else
            avetpreseasUM(nsamp)=sum(tem(2,iDC0:avelud));
        end
        avetpreseasUM(nsamp)=avetpreseasUM(nsamp)/(avelud-iDC0+1);
        
        MAT(nsamp)=(sum(tem(1,avelud:nday-1))+sum(tem(2,1:avelud)))/nday;
        aveTspring(nsamp)=mean(tem(2,32:120));
        % aveTwinspr(nsamp)=(mean(tem(2,32:120))+mean(tem(1,nday-90:nday-1)))/2.0;
        aveTwin(nsamp)=(sum(tem(1,nday-60:nday-1))+sum(tem(2,1:31)))/91.0;
    
        for j=305:nday-1
            if(tem(1,j)<0)
                CD0(nsamp)=CD0(nsamp)+1;
                CU0(nsamp)=CU0(nsamp)-tem(1,j);
            end
            if(tem(1,j)<5)
                CD5(nsamp)=CD5(nsamp)+1;
                CU5(nsamp)=CU5(nsamp)+5-tem(1,j);
            end
        end
        %
        for j=1:avelud
            if(tem(2,j)<0)
                CD0(nsamp)=CD0(nsamp)+1;
                CU0(nsamp)=CU0(nsamp)-tem(2,j);
            end
            if(tem(2,j)<5)
                CD5(nsamp)=CD5(nsamp)+1;
                CU5(nsamp)=CU5(nsamp)+5-tem(2,j);
            end
            if(tem(2,j)>0)
                GDD0(nsamp)=GDD0(nsamp)+1;
                ACCT0(nsamp)=ACCT0(nsamp)+tem(2,j);
            end
            if(tem(2,j)>5)
                GDD5(nsamp)=GDD5(nsamp)+1;
                ACCT5(nsamp)=ACCT5(nsamp)+tem(2,j);
            end
        end
        %
        for j=2:nstep
            if (avelud>=j*dayinterval)
                avetpreseason(nsamp,j)=mean(tem(2,avelud-j*dayinterval+1:avelud));
            else
                avetpreseason(nsamp,j)=(sum(tem(2,1:avelud))+ ...
                sum(tem(1,nday-(j*dayinterval-avelud):nday-1)))/(j*dayinterval);
            end
        end
    end
    disp(i);
end
%
fclose('all');
%