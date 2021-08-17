% Model: Seq_CHday_GDD0
% stD= November 1st; Tbase=0 ¡æ
% Parameter: F0-thermal accumualtion, C0-chilling accumualtion

clear;
global BESTX BESTF ICALL PX PF

% ifunc=input('Enter the function number (1<=ifunc<=6): ');
% ngs=input('Enter the number of complexes (def: ngs=2): ');
ifunc=9;
ngs=10;
if isempty(ngs); ngs=2; end

%
if ifunc==9
     bl=[0.00 0.000 -5.00 -3.0 -3.00 0.000 -0.10 0.000 -120.0]; 
     bu=[0.05 0.050 20.00 0.00 20.00 150.0 0.000 50.00 60.000]; 
     x0=[0.01 0.005 0.000 -1.0 10.00 10.00 -0.01 20.00 00.000];
    % x(1): Chillingunit=1/(1+exp(x(1)*(tem-x(3))^2+x(2)*(tem-x(3))))
    % x(2): Chillingunit=1/(1+exp(x(1)*(tem-x(3))^2+x(2)*(tem-x(3))))
    % x(3): Chillingunit=1/(1+exp(x(1)*(tem-x(3))^2+x(2)*(tem-x(3))))
    % x(4): Forcingunit=1/(1+exp(x(4)*(tem-x(5))))
    % x(5): Forcingunit=1/(1+exp(x(4)*(tem-x(5))))
    % x(6): GDD0=x(6)*exp(x(7)*CHILtot);
    % x(7): GDD0=x(6)*exp(x(7)*CHILtot);
    % x(8): Chilling Threshold
    % x(9): Start data of total chilling for calculating forcing threshold
end


maxn=1000000;
kstop=100;
pcento=0.001;
peps=0.001;
iseed=-1;
iniflg=1;

%%%% Read meteorological data and phenology data
nyear=70; nday=366;nss=7000;
datapath='D:\Phenology\Data\param_est\mod_yr4_4\'; % out path
phenpath='D:\Phenology\Data\phen_ss\No_mod4_4\'; %% phenology data
site=xlsread('D:\Phenology\Data\SiteNo.xlsx','B2:B2945');  %% Site ID of meteorological data
ele=xlsread('D:\Phenology\Data\Elevation_pepid.xlsx','A2:B4588');  %% Elevation of temperature data
[nsite,ncolsite]=size(site);
mete0=zeros(nsite,nyear,nday);  %% pass original meteorological data to a 3-d variable --- mete
mete=zeros(nyear,nday);

for j=1:nsite
    meteori=dlmread(['D:\Phenology\Data\Climate\',num2str(site(j,1)),'id_avetem.asc'],'',1,0);
    [nrm,ncm]=size(meteori);
    for i=1:nrm
        iyr=floor(meteori(i,1))-1949;
        iday=floor(meteori(i,2));
        tem=meteori(i,3);
        mete0(j,iyr,iday)=tem;
    end %i=1:nrm
end %j=1:nsite
%%%% End read meteorological data and phenology data
%%
%%% Start for each plant species or species-site
outfile=fopen([datapath,'U2_StartDay.asc'],'w');
fprintf(outfile,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'SpeciesID','Ac','Bc','Cc','Bf','Cf','w','k','C_threshold','time_C','SD_sim-obs'); %F=cEXP(dC)
for iid=1:nss
    idss=iid; %idss: id number of a plant species or site-species
    phen=dlmread([phenpath,num2str(idss),'ssid.asc'],'',1,0);
    ipep=find(ele(:,1)==phen(1,2));
    isite=find(site(:,1)==phen(1,2));
    elev=ele(ipep,2);
    mete(:,:)=mete0(isite,:,:)-(phen(1,7)-elev)*0.0065;
   [bestx,bestf] = sceua(x0,bl,bu,maxn,kstop,pcento,peps,ngs,iseed,iniflg,idss,nsite,site,mete,phen);

    [nrowsd,ncolsd]=size(BESTF(:,1));
    for i=nrowsd
        fprintf (outfile,'%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', ...
            idss,BESTX(i,1:ifunc),BESTF(i,1));
    end %i=1:nrowsd
%   clear BESTF BESTX ICALL PF PX
    clc
end %for iid=1:24
fclose(outfile);
return;
