function f=functnphen(nopt,x,idss,nsite,site,mete,phen)
%

SpecID = idss; % Target plant species
SD=0;
days=-122;
daye=210;
duration=daye-days;

[nrowphen,ncolphen]=size(phen);
for ir=1:nrowphen
    if (phen(ir,3)==SpecID)
        GDD0=0.0;
        GDD=0.0;
        CHIL=0.0;
        CHILtot=0.0;
        d1=1;
        simd=999; % Initialization of the simulated data
        flag0=0;
        flag1=0;  % flag for chilling, flag1=1 means chilling is enough
        flag2=0;  % flag for thermal accumulation, flag2=1 means thermal is enough
        iyr=phen(ir,4)-1949;
        if (mod(phen(ir,4)-1,4)==0) % leap year
            annday=366;
        elseif (mod(phen(ir,4)-1,4)>0) %  normal year
            annday=365;
        end
        TEM=[mete(iyr-1,annday+days+1:annday),mete(iyr,1:daye)];
        dayeff=max(1,ceil(x(9)-days));
        flag0=1;
        
        if (flag0==1)
            for iday=dayeff:duration
                if(flag1==0)
                    CHIL=CHIL+max(0,1.0/(1.0+exp(x(1)*(TEM(iday)-x(3)).^2+x(2)*(TEM(iday)-x(3)))));
                end
                CHILtot=CHILtot+max(0,1.0/(1.0+exp(x(1)*(TEM(iday)-x(3)).^2+x(2)*(TEM(iday)-x(3)))));
                
                if (CHIL>=x(8)&&flag1==0)
                    d1=iday;
                    flag1=1;
                end
                %
                if (flag1==1)
                    GDD0=x(6)*exp(x(7)*CHILtot);
                    GDD=GDD+max(0,1.0/(1.0+exp(x(4)*(TEM(iday)-x(5)))));
                    if (GDD>=GDD0)
                        simd=iday+days;
                        flag2=1;
                        break;
                    end
                end
            end % for iday=dayeff:duration
        else
            simd=999; flag2=1;
        end
        SD=SD+(simd-phen(ir,6))*(simd-phen(ir,6));
    end % (phen(ir,1)==SpecID)
end % for ir=1:nrowphen
f=sqrt(SD);
return
