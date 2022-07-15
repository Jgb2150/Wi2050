$title SDG Egypt Model with Demographics with Simplified Output
$stitle Last Updated: April 27, 2022

************
* Settings *
************

$ontext
This section contains the set declaration and imported parameters(to be added).
$offtext

*Set Declaration
*****************

*Define the years 2022-2030 as well as the starting and ending year
Set     t /2022*2050/;
Sets    tstart(t)       First Period tstart(t)
        tend(t)         Last Period tend(t)
        ;
        tstart(t) = yes$(ord(t) eq 1);
        tend(t) = yes$(ord(t) eq card(t));

*Define education levels: no schooling (nos), primary(ps), lower secondary(ls), upper secondary(us), tertiary(ts)       

Set     e /nos,ps,ls,us,ts/;
Alias   (e,ea);

*Define gender
Set     g /male,female/;

*Define survival rates by gender for [target country] and high-income country             
Set     surv /megypt,fegypt,mhic,fhic/;

*Define fertility rates for [target country] and high-income country
Set     fer /egypt,hic/;

$ontext
Define economic sectors:
agriculture (ag)
mining (mine)
construction (con)
power (pow)
manufacturing (man)
real estate (re)
non-traded services (sern)
traded services (sert)
education (ed)
health care (heal)
public administration (pub)
*secn: nontradable sectors
$offtext

Set     sec /ag, mine, con, pow, man, re, sern, sert, ed, heal, pub/;
*Tradable sectors (sect): agriculture, mining, manufacturing, traded services
Set     sect(sec) /ag, mine, man, sert/;
*Non-tradable sectors (secn): construction, power, real estate, non-traded services, education, health care, public admin
Set     secn(sec) /con, pow, re, sern, ed, heal, pub/;

*Define age elements from 1-100
Set     a /1*100/;
Sets    a1(a)       Age 1 (for births)
        aw(a)       Working age between 12 and 65
        af2049(a)   Age between 20 and 49
        an(a)       No schooling age
        ap(a)       Primary age
        als(a)      Lower secondary age 
        af(a)       Fertile age between 15 and 49
        aus(a)      Upper secondary age
        ater(a)     Tertiary age
        as(a)       School age between 12 and 23
        asc(a);
        
a1(a) = yes$(ord(a) eq 1);
an(a) = yes$(ord(a) eq 6);
ap(a) = yes$(ord(a) ge 7 and ord(a) le 12);
als(a) = yes$(ord(a) ge 13 and ord(a) le 15);
aus(a) = yes$(ord(a) ge 16 and ord(a) le 18);
ater(a) = yes$(ord(a) ge 19 and ord(a) le 22);
as(a) = yes$(ord(a) ge 6 and ord(a) le 23);
asc(a) = yes$(ord(a) ge 7 and ord(a) le 22);
aw(a) = yes$(ord(a) ge 12 and ord(a) le 65);
af2049(a) = yes$(ord(a) ge 20 and ord(a) le 49);
af(a) = yes$(ord(a) ge 15 and ord(a) le 49);

Alias   (as,aa);

*Define low and high debt scenarios
Set     scen /low , high/;

* Parameter Declaration
***********************

Parameter   debtgdps(scen,t)    Debt to GDP ratio by scenario and year
            conpcs(scen,t)
            kffs(scen,t)        Capital to produce energy with fossil fuels by scenario and year
            kres(scen,t)        Capital to produce energy with renewables by scenario and year
            kfs(scen,t)         Infrastructure capital stock by scenario and year?
            wages(scen,e,t)     Wages by scenario education level and year
            ktots(scen,t)       Total capital by scenario and year
            mpks(scen,t)        Marginal product of capital by scenario sector and year
            conpcs(scen,t)
            qs(scen,t)
            qpcs(scen,t)
            ks(scen,t)
            edcostgdps(scen,t)
            invs(scen,t)        Investment by scenario and year
            schoolshs(scen,t)
            schoolyrs(scen,t)
            tfrts(scen,t)
            tfrs(scen,t)
            poptots(scen,t)
            edcosts(scen,t)
            enrollrates(scen,t)
            schoolshs(scen,t)
            birthrates(scen,t)
            fertshs(scen);

$offOrder

Parameter   bed(sec,e)  Production function coefficients on labor by sector and education; 
Parameter   bk          Prod. func. coeff. on business capital stock (plant and equipment);
            bk = .25;
Parameter   bkf         Prod. func. coeff. on infrastructure capital; 
            bkf = .10;
Parameter   ben         Prod. func. coeff. on power;
            ben = .05;
Parameter   blab        Prod. func. coeff. on labor;
            blab = 1-bk-bkf-ben;

Parameter   k0          Initial capital stock (2022);
            k0 = 20;
parameter   kf0         Initial infrastructure capital stock;
            kf0 = 3;

Scalar      ek          Demand for capital stock
            costff      Cost of fossil fuel generation
            costre      Cost of renewable energy generation
            dep         Depreciation
            r           Interest rate
            kff0        Initial capital to produce fossil fuel energy
            kre0        Initial capital to produce renewable energy
            aff         Percentage of fossil fuel capital required as input to produce energy
            taxlim      Tax limit
            min0        Production of mining sector in 2022 at time 0
            land0       Production of land in 2022 at time 0
            tfp1
            phi;

            ek = .10;
            costff = 1;
            costre = 3;
            dep = .05;
            r = .05;
            kff0 = 10;
            kre0 = 1;
            aff = .25;
            taxlim = .5;
            min0 = 10;
            land0 = 20;
            tfp1 = 1;
            phi = .20;


*discount factor

Parameter   disc(t)     Discount factor;
            disc(t) = 1/(1+r)**(ord(t)-1);

Parameter   debtqlim    Define maximum debt to GDP ratio;

*Initial state parameters loaded from GDX
Parameter   popg0(a,g)      Initial population by age and gender
            fert0(a,fer)    Initial fertility by age
            surv0(a,surv)   Initial survival rates by age
            w0(a,a,g)       Initial working age population by age and gender
            s0(a,g)         Initial school achievement by age and gender
            ferthic0(a,fer) Initial high-income country fertility by age
            tfp(sec)        Total fertility of population?;

$CALL GDXXRW egyptdatainput.xlsx Index=Index!a1 trace=3
$GDXIN egyptdatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6
$GDXIN

            fert0(a,"hic") = ferthic0(a,"hic");

Display     popg0,fert0,surv0,w0,s0,ferthic0;

Parameter   tfr0(fer)       Initial total fertility rate;
            tfr0(fer) = sum(af,fert0(af,fer));
Parameter   survive0(a,g)   Initial survival rate by age and gender;
            survive0(a,"female") = surv0(a,"fegypt");
            survive0(a,"male") = surv0(a,"megypt");
Parameter   survivehi0(a,g) Initial high-income survival rate by age and gender;
            survivehi0(a,"female") = surv0(a,"fhic");
            survivehi0(a,"male") = surv0(a,"mhic");
Parameter   lfep(e,t),poptotp(t),schooltotp(t),lfp(t);

Scalar      fertsh;

Parameter   years(e)
            /nos 0
            ps 6
            ls 9
            us 12
            ts 16/;

Positive variables  lfe(e,t)        Labor force as a function of education and year
                    schoolsh(t)     Share of population in school
                    schooltsa(t)
                    q(t)            Output as a function of year
                    qpc(t)          Output per capita as a function of year
                    gdp(t)          GDP as a function of year
                    gdpt(t)         GDP t(?) as a function of year
                    gdptpc(t)       GDP per capita t(?) as a function of year
                    emp(t)          Employment as a function of year
                    hc(t)
                    k(t)
                    con(t)          Consumption as a function of year
                    tx(t)           Taxes as a function of year
                    conpc(t)        Consumption per capita as a function of year
                    mpk(t)          Marginal product of capital as a function of year
                    land(t)         Land as a function of year
                    min(t)          Minerals as a function of year
                    edcost(t)
                    edcostgdp(t)
                    ktot(t)         Total capital as a function of year
                    qpc(t)
                    efflabor(a,t)
                    efflabtot(t)
                    scgdp(t)
                    kff(t)          Capital stock for fossil fuel energy production by year
                    kre(t)          Capital stock for renewable energy production by year
                    he(t)
                    en(t)           Energy as a function of year
                    entot(t)        Total energy as a function of year
                    enh(t)          Housing energy as a function of year
                    enhpc(t)        Housing energy per capita as a function of year
                    invff(t)        Investment in fossil fuels as a function of year
                    invre(t)        Investment in renewable energy as a function of year
                    ff(t)           Fossil fuels by year
                    invf(t)         Investment for capital infrastructure as a function of year
                    kh(t)           Capital for housing as a function of year
                    invh(t)         Capital for housing as a function of year
                    hspc(t)         Housing per capita as a function of year
                    kf(t)           Infrastructure capital as a function of year
                    ktot(t)         Total capital as a function of year
                    lqp(t)
                    lsub(t)
                    gov(t)          Government expenditure(?) as a function of year
                    gdptot(t)       Total GDP as a function of year
                    pn(t)           Price of non-tradeables as a function of year
                    debt(t)         Debt level as a function of year
                    debtgdp(t)      Debt-GDP ratio as a function of year
                    cont12(t)
                    govgdp(t)       Government expenditure as % of GDP as a function of year
                    reserve(t)      Reserve levels as a function of year 
                    edcost(t)
                    hlcost(t)
                    control(t)
                    healthpc(t)
                    hlcostgdp(t)
                    lfe(e,t)        Labor force as a function of education and year (repeated)
                    schoolpop(t)    Total school population as a function of year
                    schooltsa(t)    School age as a function of year
                    cont(a,t)       Continuation rate as a function of age and year
                    s(a,g,t)        Schooling as a function of age gender and year
                    leave(a,a,g,t)  School dropout rate as a function of two age elements gender and year
                    neet(a,a,t)     Not in education employment or training as a func of two age elements and year
                    school(e,t)     School enrollment at level e as a function of year
                    schooltot(t)    Total school enrollment as a function of year
                    schoolc(t)      School completion as a function of year
                    ps(t)           Primary school as a function of year
                    ls(t)           Lower secondary as a function of year
                    us(t)           Upper secondary as a function of year
                    ts(t)           Tertiary as a function of year
                    lse(t)          Lower secondary enrollment as a function of year
                    use(t)          Upper secondary enrollment as a function of year
                    tse(t)          Tertiary enrollment as a function of year
                    eattain(a,t)    Educational attainment as a function of age and year
                    w(a,a,g,t)      Working population as a function of two age elements gender and year
                    worka(a,t)      Working age as a function of age and time
                    pop(a,g,t)      Age and gender-specific population as a function of year
                    poptot(t)       Total population as a function of year
                    noa(t)          No school attainment as a function of year
                    pa(t)           Primary attainment as a function of year
                    lsa(t)          Lower secondary attainment as a function of year
                    usa(t)          Upper secondary attainment as a function of year
                    tsa(t)          Tertiary attainment as a function of year
                    lf(t)           Total labor force as a function of year
                    h(t)            Housing(?) as a function of year
                    birth(t)        Birth rate as a function of year
                    fert(a,a,t)     Fertility as a function of two age elements and year
                    inv(t)          Investment as a function of year
                    schoolyr(t)
                    cinv(t)
                    cinvff(t)
                    cinvf(t)
                    cinvre(t)
                    debt(t)         Debt level as a function of year
                    debtgdp(t)      Debt-GDP ratio as a function of year
                    schoolage(t)    School age as a function of year (?)
                    enrollrate(t)   School enrollment rate as a function of year (?)
                    birthrate(t)    Birthrate as a function of year (?)
                    fbyage(a,t)
                    tfr(t)          Total fertility rate as a function of year (?)
                    invfgdp(t)
                    pubgdp(t)
                    outlaygdp(t)
                    edunitcost(t)   Unit cost of education as a function of year (?)
                    hlunitcost(t)
                    gcost(t);

Variable            util            Main utility variable
                    ut(t)           Utility by year
                    wage(e,t)       Wage as a function of education level and time
                    nx(t)           Net exports by year
                    test            Test variable (?);           

Equations           eq1(a,g,t)      Secondary school pop by age and gender at t+1
                    eq2(g,t)        Population by gender and year starting primary school at age 6 (?)
                    eq3(a,g,t)      Population survival each year by age and gender
                    eq4(a,a,t)      Fertility dependent on age and education level
                    eq5(t)          Expected births per year
                    eq6(a,g,t)      Equalizes gender ratio at birth
                    eq7(t)          Primary school enrollment assuming universal enrollment
                    eq8(t)          Total population of lower secondary age
                    eq9(t)          Total population of upper secondary age
                    eq10(t)         Total population of tertiary education age
                    eq11(t)         Lower secondary enrollment rate
                    eq12(t)         Upper secondary enrollment rate
                    eq13(t)         Tertiary education enrollment rate
                    eq14(t)         Total population in school (primary lower sec upper sec tertiary)
                    eq15(a,a,g,t)   Total dropouts per year as age-dependent dropout rate by school pop per year starting at grade 6 secondary school(?)
                    eq16(a,a,g,t)   Working population at time t+1 starting at grade 6 secondary school(?)
                    eq17(a,g,t)     Age 12 working population equals 0    
*eq18(a,t)
                    eq19(a,t)       Educational attainment by age and time
                    eq19a(t)
                    eq19b(t)
                    eq19c(t)
                    eq19d(t)
                    eq19e(t)
                    eq20(t)         Total labor force summed by educational attainment per year
                    eq21a(t)        No school attainment in year t as sum of attainment for 1 to 5 year olds
                    eq21(t)         Primary attainment in year t as sum of attainment for 12 13 and 14 year olds
                    eq22(t)         Lower sec attainment in year t as sum of attainment for 15 16 and 17 year olds
                    eq23(t)         Upper sec attainment as sum of attainment for 18 19 20 and 21 year olds
                    eq24(t)         Tertiary attainment as sum of attainment for 22 year olds
                    eq25(t)         Total population summation at time t
                    eq26(t)         Total population enrolled in primary at time t
                    eq27(t)         Total population enrolled in lower secondary at time t
                    eq28(t)         Total population enrolled in upper secondary at time t
                    eq29(t)         Total population enrolled in tertiary at time t
                    eq30a(t)        Labor force with no schooling at time t
                    eq30(t)         Primary-educated labor force at time t
                    eq31(t)         Lower sec educated labor force at time t
                    eq32(t)         Upper sec educated labor force at time t
                    eq33(t)         Tertiary educated labor force at time t
                    eq34(t)         Percentage of total population in school at time t
                    eq36(a,g)       Education for school-aged people in 2022
                    eq37(a,g)       Population in 2022
                    eq38(a,a,g)     Worker population in 2022
                    eq39(t)         Set continuation rate = 0.95 at age 12
                    eq40(t)         Set continuation rate = 1 at age 13
                    eq41(t)         Set continuation rate = 1 at age 14
                    eq42(t)         Set continuation rate = 1 at age 16
                    eq43(t)         Set continuation rate = 1 at age 17
                    eq44(t)         Set continuation rate = 1 at age 19
                    eq45(t)         Set continuation rate = 1 at age 20
                    eq46(t)         Set continuation rate = 1 at age 21
                    eq47(t)         Set continuation rate = 1 at age 15
                    eq48(t)         Set continuation rate = 0.5 at age 18
                    eq49(t)         Set continuation rate = 0 at age 22 
                    eq50
                    eq51(t)
                    eq52(a,t)
                    eq53(t)
                    eq54(t)
                    eq30a(t)
                    eq55(t)         Set continuation rate = 1 at age 7
                    eq56(t)         Set continuation rate = 1 at age 8
                    eq57(t)         Set continuation rate = 1 at age 9
                    eq58(t)         Set continuation rate = 1 at age 10
                    eq59(t)         Set continuation rate = 1 at age 11
                    eq60(t)         Set continuation rate = 1 at age 6
                    eq61(t)         
                    eq62(t)
                    eq63(t)
                    eq64(a,t)
                    eq65(t);


eq1(as+1,g,t+1)..  s(as+1,g,t+1) =e= cont(as,t)*s(as,g,t);
eq2(g,t+1)..  s("7",g,t+1) =e= pop("6",g,t);
eq3(a+1,g,t+1)..  pop(a+1,g,t+1) =e= pop(a,g,t)*survive0(a,g);
eq4(af,as,t)..  fert(af,as,t) =e= w(af,as,"female",t)*fert0(af,"egypt")$(ord(as) lt 12) + w(af,as,"female",t)*(fertsh*fert0(af,"egypt")+(1-fertsh)*fert0(af,"hic"))$(ord(as) ge 12);
eq5(t)..   birth(t) =e= sum(af,sum(as,fert(af,as,t)));
eq63(t)..  birthrate(t) =e= birth(t)/poptot(t);
eq64(af,t)..  fbyage(af,t) =e= sum(as,w(af,as,"female",t));
eq65(t)..  tfr(t) =e= sum(af,sum(as,fert(af,as,t)/fbyage(af,t)));
eq6(a1,g,t+1)..   pop(a1,g,t+1) =e= 0.5*birth(t);
eq7(t)..  ps(t) =e=  sum(ap,sum(g,pop(ap,g,t)));
eq8(t)..  ls(t) =e=  sum(als,sum(g,s(als,g,t)));
eq9(t)..  us(t) =e=  sum(aus,sum(g,s(aus,g,t)));
eq10(t)..  ts(t) =e=  sum(ater,sum(g,s(ater,g,t)));
eq61(t)..  schoolage(t) =e= sum(asc,sum(g,pop(asc,g,t)));
eq62(t)..  enrollrate(t) =e= schooltot(t)/schoolage(t);
eq11(t).. lse(t) =e= ls(t)/(.0001+sum(als,sum(g,pop(als,g,t))));
eq12(t).. use(t) =e= us(t)/(.0001+sum(aus,sum(g,pop(aus,g,t))));
eq13(t).. tse(t) =e= ts(t)/(.0001+sum(ater,sum(g,pop(ater,g,t))));
eq14(t).. schooltot(t) =e= ps(t) + ls(t) + us(t) + ts(t);
eq15(aw,as,g,t).. leave(aw,as,g,t) =e= (1-cont(as,t))*s(as,g,t)$(ord(aw)+6 eq ord(as));
eq16(aw+1,as,g,t+1).. w(aw+1,as,g,t+1) =e= w(aw,as,g,t)$(ord(aw)+6 ge ord(as)) + leave(aw,as,g,t)$(ord(aw)+6 eq ord(as)) + 0$(ord(aw)+6 lt ord(as));;
eq17(as,g,t+1).. w("12",as,g,t+1) =e= 0;
*eq18(af,t).. worka(af,t) =e= sum(as,sum(g,w(af,as,g,t)));
eq19(as,t).. eattain(as,t) =e= sum(aw,sum(g,w(aw,as,g,t)));
eq19a(t).. eattain("1",t) =e= 0;
eq19b(t).. eattain("2",t) =e= 0;
eq19c(t).. eattain("3",t) =e= 0;
eq19d(t).. eattain("4",t) =e= 0;
eq19e(t).. eattain("5",t) =e= 0;
eq20(t).. lf(t) =e= sum(as,eattain(as,t));
eq21a(t).. noa(t) =e= sum(as$(ord(as) ge 1 and ord(as) le 5),eattain(as,t));
eq21(t).. pa(t) =e= eattain("12",t) + eattain("13",t) + eattain("14",t) ;
eq22(t)..  lsa(t) =e= eattain("15",t)+eattain("16",t)+eattain("17",t);
eq23(t)..  usa(t) =e= eattain("18",t)+eattain("19",t)+eattain("20",t)+eattain("21",t);
eq24(t)..  tsa(t) =e= eattain("22",t);
eq25(t)..  poptot(t) =e= sum(a,sum(g,pop(a,g,t)));
eq26(t).. school("ps",t) =e= ps(t);
eq27(t).. school("ls",t) =e= ls(t);
eq28(t).. school("us",t) =e= us(t);
eq29(t).. school("ts",t) =e= ts(t);
eq30a(t).. lfe("nos",t) =e= noa(t);
eq30(t).. lfe("ps",t) =e= pa(t);
eq31(t).. lfe("ls",t) =e= lsa(t);
eq32(t).. lfe("us",t) =e= usa(t);
eq33(t).. lfe("ts",t) =e= tsa(t);
eq34(t).. schoolsh(t) =e= schooltot(t)/poptot(t);
eq36(as,g).. s(as,g,"2022") =e= s0(as,g);
eq37(a,g).. pop(a,g,"2022") =e= popg0(a,g);
eq38(aw,as,g).. w(aw,as,g,"2022") =e= w0(aw,as,g);
eq39(t).. cont("12",t) =e= 0.95;
eq40(t).. cont("13",t) =e= 1;
eq41(t).. cont("14",t) =e= 1;
eq42(t).. cont("16",t) =e= 1;
eq43(t).. cont("17",t) =e= 1;
eq44(t).. cont("19",t) =e= 1;
eq45(t).. cont("20",t) =e= 1;
eq46(t).. cont("21",t) =e= 1;
eq47(t).. cont("15",t) =e= 1;
eq48(t).. cont("18",t) =e= 0.5;
eq49(t).. cont("22",t) =e= 0;
eq50.. test =e= sum(t,control(t)*control(t));
eq51(t).. schoolyr(t) =e= sum(a,eattain(a,t)*(ord(a)-6))/sum(a,.000001+eattain(a,t));
eq52(as,t).. efflabor(as,t) =e= exp(.1*ord(as))*eattain(as,t);
eq53(t).. efflabtot(t) =e= sum(as,efflabor(as,t));
eq54(t).. hc(t) =e= efflabtot(t)/(.00001+lf(t));
eq55(t).. cont("7",t) =e= 1;
eq56(t).. cont("8",t) =e= 1;
eq57(t).. cont("9",t) =e= 1;
eq58(t).. cont("10",t) =e= 1;
eq59(t).. cont("11",t) =e= 1;
eq60(t).. cont("6",t) =e= 1;

Model   demo using /all/;

*eattain.lo(a,t) = .00001;

Equations   utilt(t)
            utility
            output(t)
            outputpc(t)
            ewage(e,t)
            kstart(t)
            kfstart(t)
            kffstart(t)
            krestart(t)
            knext(t)
            kfnext(t)
            kffnext(t)
            krenext(t)
            kfend(t)
            energy(t)
            ffuel(t)
            conlim(t)
            education(t)
            edugdp(t)
            dstart(t)
            tbalance(t)
            totdebt(t)
            debttogdp(t)
            debtlimit(t)
            conend(t)
            consumetrpc(t)
            kend(t)
            kffend(t)
            kreend(t)
            ktotal(t)
            costk(t)
            costkre(t)
            costkff(t)
            costkf(t)
            health(t)
            govcost(t)
            hlgdp(t)
            pubadgdp(t)
            infgdp(t)
            poutlay(t)
            educationuc(t)
            healthuc(t),
*taxmax(t),
            marginalpk(t);

*output(t)..           q(t) =e= tfp1*en(t)**ben*kf(t)**bkf*k(t)**bk*prod(e,lfep(e,t)**bled(e));
output(t)..           q(t) =e= tfp1*en(t)**ben*kf(t)**bkf*k(t)**bk*efflabtot(t)**blab;
outputpc(t)..         qpc(t) =e= q(t)/poptotp(t);
*ewage(e,t)..          wage(e,t) =e= bled(e)*q(t)/lfep(e,t);
ewage(e,t)..          wage(e,t) =e= blab*q(t)/efflabtot(t)*exp(.1*years(e));
marginalpk(t)..       mpk(t) =e= bk*q(t)/k(t);

kstart(tstart)..      k(tstart) =e= k0;
dstart(tstart)..      debt(tstart) =e= 0;
kffstart(tstart)..    kff(tstart) =e= kff0;
krestart(tstart)..    kre(tstart) =e= kre0;
kfstart(tstart)..     kf(tstart) =e= kf0;
knext(t+1)..          k(t+1) =e= k(t)*(1-dep) + inv(t);
kffnext(t+1)..        kff(t+1) =e= kff(t)*(1-dep) + invff(t);
krenext(t+1)..        kre(t+1) =e= kre(t)*(1-dep) + invre(t);
kfnext(t+1)..         kf(t+1) =e= kf(t)*(1-dep) + invf(t);
energy(t)..           en(t) =e= kff(t) + kre(t);
ffuel(t)..            ff(t) =e= aff*kff(t);
costkff(t)..          cinvff(t) =e= costff*invff(t)*(1+phi*(invff(t)/kff(t)));
costkre(t)..          cinvre(t) =e= costre*invre(t)*(1+phi*(invre(t)/kre(t)));
costkf(t)..           cinvf(t) =e= invf(t)*(1+phi*(invf(t)/kf(t)));
costk(t)..            cinv(t) =e= inv(t)*(1+phi*(inv(t)/k(t)));
tbalance(t)..         nx(t) =e= q(t) - cinv(t) - cinvf(t) - con(t) - hlcost(t) - edcost(t) - gcost(t) - cinvff(t) - cinvre(t) - ff(t);
totdebt(t+1)..        debt(t+1) =e= (1+r)*debt(t) - nx(t);
debttogdp(t)..        debtgdp(t) =e= debt(t)/q(t);
debtlimit(t)..        debtgdp(t) =l= debtqlim;
conlim(t)..           con(t) =l= q(t) - dep*(k(t)+kf(t)+kre(t)+kff(t)) - r*debt(t) - (edcostgdp(t)+hlcostgdp(t)+pubgdp(t))*q(t) -ff(t);
conend(tend)..        con(tend) =e= q(tend) - cinv(tend) - cinvf(tend) - cinvff(tend) - cinvre(tend) - r*debt(tend) - (pubgdp(tend)+edcostgdp(tend)+hlcostgdp(tend))*q(tend)-ff(tend);
kend(tend)..          k(tend)*dep =e= inv(tend);
kffend(tend)..        kff(tend)*dep =e= invff(tend);
kreend(tend)..        kre(tend)*dep =e= invre(tend);
kfend(tend)..         kf(tend)*dep =e= invf(tend);
ktotal(t)..           ktot(t) =e= k(t) + kf(t) + kff(t) + kre(t);
consumetrpc(t)..      conpc(t) =e= con(t)/poptotp(t);
educationuc(t)..      edunitcost(t) =e= 2*((1/10)*wage("ts",t)+(1/10)*wage("us",t))/qpc(t);
healthuc(t)..         hlunitcost(t) =e= 2*((1/50)*wage("ts",t)+(1/50)*wage("us",t))/qpc(t);
education(t)..        edcost(t) =e= edunitcost(t)*schooltot(t);
health(t)..           hlcost(t) =e= hlunitcost(t)*poptot(t);
govcost(t)..          gcost(t) =e= 0.10*q(t);
edugdp(t)..           edcostgdp(t) =e= edcost(t)/q(t);
hlgdp(t)..            hlcostgdp(t) =e= hlcost(t)/q(t);
poutlay(t)..          outlaygdp(t) =e= edcostgdp(t) + hlcostgdp(t) + pubgdp(t) + invfgdp(t);
pubadgdp(t)..         pubgdp(t) =e= .10;
infgdp(t)..           invfgdp(t) =e= cinvf(t)/q(t);
utilt(t)..            ut(t) =e= log(conpc(t));
utility..             util =e= sum(t,disc(t)* ut(t)) + (1/r)*sum(tend,disc(tend)*ut(tend));

Model   sdgfinance using /all/;

        poptot.lo(t) = .00001;
        en.lo(t) = .001;
        tsa.lo(t) = .00001;
        pop.lo(a,g,t) = .00000001;
        k.lo(t) = .001;
        kf.lo(t) = .001;
        kff.lo(t) = .001;
        kre.lo(t) = .001;
        conpc.lo(t) = .001;
        q.lo(t) = .0001;
        qpc.lo(t) = .0001;
        enh.lo(t) = .001;
        enhpc.lo(t) = .001;
        kf.lo(t) = .001;
        schooltot.lo(t) = .001;
        schoolage.lo(t) = 001;
        fbyage.lo(a,t) = .001;

Parameter   debtqlim;
            debtqlim = 10;
            r=.05;

Parameter   dlim(scen)
            /low   10
            high 10/;

Parameter   rs(scen)
            /low 0.15
            high 0.05/;

Parameter   taxmaxs(scen)
            /low  0.1
            high 0.4/;

Parameter   fertshs
            /low .5
            high 0/;

            debtqlim = 10;
            r = .05;
            taxlim = .4;
            fertsh = .5;

Solve demo minimizing test using dnlp;
lfep(e,t) = lfe.L(e,t);
lfp(t) = lf.L(t);
poptotp(t) = poptot.L(t);
schooltotp(t) = schooltot.L(t);

Solve sdgfinance maximizing util using dnlp;

Display qpc.L, edcostgdp.L, hlcostgdp.L, invfgdp.L, outlaygdp.L;

$onText

loop(scen,
*debtqlim = dlim(scen);
*r = rs(scen);
*taxlim = taxmaxs(scen);
fertsh = fertshs(scen);
solve demo minimizing test using dnlp;
lfep(e,t) = lfe.L(e,t);
lfp(t) = lf.L(t);
poptotp(t) = poptot.L(t);
schooltotp(t) = schooltot.L(t);
solve sdgfinance maximizing util using dnlp;
schoolyrs(scen,t) = schoolyr.L(t);
ks(scen,t) = k.L(t);
debtgdps(scen,t) = debtgdp.L(t);
kffs(scen,t) = kff.L(t);
kres(scen,t) = kre.L(t);
kfs(scen,t) = kf.L(t);
mpks(scen,t) = mpk.L(t);
ktots(scen,t) = ktot.L(t);
wages(scen,e,t) = wage.L(e,t);
invs(scen,t) = inv.L(t);
qs(scen,t) = q.L(t);
qpcs(scen,t) = qpc.L(t);
conpcs(scen,t) = conpc.L(t);
edcosts(scen,t) = edcost.L(t);
schoolshs(scen,t) = schoolsh.L(t);
edcostgdps(scen,t) = edcostgdp.L(t);
enrollrates(scen,t) = enrollrate.L(t);
birthrates(scen,t) = birthrate.L(t);
poptots(scen,t) = poptot.L(t);
tfrs(scen,t) = tfr.L(t););


display qs,tfrs, ks, mpks, invs, birthrates, poptots,schoolshs, enrollrates,schoolyrs, edcosts, edcostgdps, wages, kffs, kres;


execute_unload 'data.gdx' qpcs, poptots, tfrs;
execute 'gdxxrw data.gdx par=qpcs rng=qpcs!A1 par=poptots rng=poptots!A1 par = tfrs rng=tfrs!A1'

$offText

