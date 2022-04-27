$title SDG Financing Model with Tax Limits
$stitle Last Updated: April 20, 2022

************
* Settings *
************

$ontext
This section contains the set declaration and imported parameters(to be added).
$offtext

*Set Declaration
*****************

*Define the years 2022-2030 as well as the starting and ending year
Set     t /2022*2030/;              
Sets    tstart(t)       First Period tstart(t)
        tend(t)         Last Period tend(t)
        ;
*Define education levels: primary(ps), lower secondary(ls), upper secondary(us), tertiary(ts)       
Set     e /ps,ls,us,ts/;
*Define gender             
Set     g /male,female/;

*Define survival rates by gender for [target country] and high-income country             
Set     surv /mdrc,fdrc,mhic,fhic/;  
*Define fertility rates for [target country] and high-income country
Set     fer /drc,hic/;              
    
$ontext
Define economic sectors: 
subsistence(sub)
agriculture(ag)
mining(mine)
construction(con)
power(pow)
manufacturing(man)
traded professional services(prof)
real estate(re)
non-traded services(sern)
traded services(sert)
education(ed)
health care(heal)
public administration(pub)
$offText
Set     sec /sub, ag, mine, con, pow, man, prof, re, sern, sert, ed, heal, pub/;
*Tradable sectors: subsistence, agriculture, mining, manufacturing, traded professional services, traded services
Set     sect(sec) /sub, ag, mine, man, prof, sert/;
*Non-traded sectors: construction, power, real estate, non-traded services, education, health, public administration
Set     secn(sec) /con, pow, re, sern, ed, heal, pub/;

*Define age elements from 1-100
Set     a /1*100/;
Sets    a1(a)       Age 1 (for births)
        aw(a)       Working age between 12 and 65
        af2049(a)   Age between 20 and 49
        ap(a)       Primary age
        als(a)      Lower secondary age
        af(a)       Fertile age between 15 and 49
        aus(a)      Upper secondary age
        ater(a)     Tertiary age
        as(a)       School age between 12 and 23
        ;

*Define scenarios for tax limits and no tax limits
Set     scen /lim,nolim/;

* Parameter Declaration
***********************

Parameter   gdptots(scen,t)     Total GDP by scenario and year
            debtgdps(scen,t)    Debt to GDP ratio by scenario and year
            contrpcs(scen,t)    Consumption of traded sectors per capita by scenario and year
            kffs(scen,t)        Capital to produce energy with fossil fuels by scenario and year
            kres(scen,t)        Capital to produce energy with renewables by scenario and year
            kfs(scen,t)         Infrastructure capital stock by scenario and year?
            wages(scen,e,t)     Wages by scenario education level and year
            ktots(scen,t)       Total capital by scenario and year
            mpks(scen,sec,t)    Marginal product of capital by scenario sector and year
            entots(scen,t)      Total energy by scenario and year
            gdpts(scen,t)       GDP of traded sectors by scenario and year
            contrs(scen,t)      Consumption of traded sectors by scenario and year
            qs(scen,sec,t)      Output by sector scenario and year
            pas(scen,t)         Primary age students by scenario and year
            lsas(scen,t)        Lower secondary age students by scenario and year
            usas(scen,t)        Upper secondary age students by scenario and year
            tsas(scen,t)        Tertiary age students by scenario and year
            ks(scen,sec,t)      Capital stock by sector scenario and year
            edgdps(scen,t)      Output of education sector by scenario and year
            healgdps(scen,t)    Output of health sector by scenario and year
            invs(scen,sec,t)    Investment by sector scenario and year
            govgdps(scen,t)     Govt expenditure to GDP ratio by scenario and year
            schools(scen,e,t)   Schooling?
            ;

$offOrder

Parameter   bed(sec,e)  Production function coefficients on labor by sector and education
            bk(sec)     Production function coeff. on business capital stock(plant & equipment)by sec.
            /sub  0.01
            ag   0.20
            mine 0.25
            pow  0.10
            con  0.25
            man  0.25
            prof 0.2
            re   0.8
            ed   0.2
            heal 0.2
            sert 0.1
            sern 0.1
            pub  0.1/
            bkf(sec)    Production function coeff. on infrastructure capital;
            bkf(sec) = .10;
Parameter   ben(sec)    Production function coeff. on power;
            ben(sec) = .05;
Parameter   bland(sec)  Production function coeff. on land
            /sub .30
            ag   .30
            mine .1
            pow  .1
            con  .05
            man  .05
            prof .05
            re   .05
            sert .05
            sern .05
            ed   .05
            heal .05
            pub  .05/;
Parameter  bmin(sec)    Production function coeff. on minerals
            /sub  0.0
            ag   0.0
            mine 0.2
            pow  0.0
            con  0.0
            man  0.0
            prof 0.0
            re   0.0
            sert 0.0
            sern 0.0
            heal 0.0
            ed   0.0
            pub  0.0/;
Parameter   blab(sec)   Coeff. on labor is remainder after subtract share for land minerals capital infra and energy
            blab(sec) = 1-bland(sec)-bmin(sec)-bk(sec)-bkf(sec)-ben(sec);

Parameter   k0(sec)     2022 initial capital share by sector
            /sub   0.1
            ag    1.0
            mine  1.0
            pow   0.5
            man   1.0
            con   1.0
            prof  0.1
            re    0.5
            sert  0.5
            sern  0.5
            heal  0.5
            ed    0.5
            pub   0.2/;

Parameter   kf0(sec)    2022 initial infrastructure capital share;
            kf0(sec) = (1/6)*sum(sec,k0(sec));
            
Scalar      ek          Demand for capital stock
            costff      Cost of fossil fuel generation
            costre      Cost of renewable energy generation
            hc          ?
            dep         Depreciation
            r           Interest rate
            kff0        Initial capital to produce fossil fuel energy
            kre0        Initial capital to produce renewable energy
            aff         Percentage of fossil fuel capital required as input to produce energy
            taxlim      Tax limit
            min0        Production of mining sector in 2022 at time 0
            landrural0  Production of rural land in 2022 at time 0;
            ek = .10;
            costff = 1;
            costre = 3;
            hc = .002;
            dep = .05;
            r = .05;
            kff0 = .5;
            kre0 = 0;
            aff = .20;
            taxlim = .5;
            min0 = 10;
            landrural0 = 50;

Parameter   pi(sec)     Total Factor Productivity
            /sub   .2
            ag     1
            mine   1
            con    1
            pow    1
            man    2
            prof   3
            re     1
            sert   1
            sern   1
            ed     1
            heal   1
            pub    1 /;
            
Parameter   disc(t)     Discount factor defined by interest rate and target year;
            disc(t) = 1/(1+r)**(ord(t)-1);
            
Parameter   debtqlim    Define maximum debt to GDP ratio;

*Initial state parameters loaded from GDX
Parameter   popg0(a,g)      Initial population by age and gender
            fert0(a,fer)    Initial fertility by age
            surv0(a,surv)   Initial survival rates by age
            w0(a,a,g)       Initial working age population by age and gender
            s0(a,g)         Initial school achievement by age and gender
            ferthic0(a,fer) Initial high-income country fertility by age

$CALL GDXXRW drcdatainput.xlsx Index=Index!a1 trace=3
$GDXIN drcdatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6 bed=D7
$GDXIN

display popg0,fert0,surv0,w0,s0,ferthic0,bed;

Parameter   bled(e,sec) Coeff. on labor by sector times coefficient on labor by sector and education (why?);
            bled(e,sec) = blab(sec)*bed(sec,e);
            
*Confirm that sum of coefficients in Cobb-Douglas production function equals one for each sector
Parameter   bltot(sec)  Total sum of coefficients by sector;
            bltot(sec) = sum(e,bled(e,sec)) + ben(sec) + bk(sec) + bkf(sec) + bland(sec);
Display     bltot,bled;

Parameter   tfr0(fer)       Initial total fertility rate
            survive0(a,g)   Initial survival rate by age and gender
            survivehi0(a,g) Initial high-income survival rate by age and gender;
            tfr0(fer) = sum(af,fert0(af,fer));
            survive0(a,"female") = surv0(a,"fdrc");
            survive0(a,"male") = surv0(a,"mdrc");
            survivehi0(a,"female") = surv0(a,"fhic");
            survivehi0(a,"male") = surv0(a,"mhic");

Alias       (e,ea)
            (as,aa);

* Subset definition
*********************

tstart(t) =     yes$(ord(t) eq 1);
tend(t) =       yes$(ord(t) eq card(t));
a1(a) =         yes$(ord(a) eq 1);
ap(a) =         yes$(ord(a) ge 6 and ord(a) le 12);
als(a) =        yes$(ord(a) ge 13 and ord(a) le 15);
aus(a) =        yes$(ord(a) ge 16 and ord(a) le 18);
ater(a) =       yes$(ord(a) ge 19 and ord(a) le 22);
as(a) =         yes$(ord(a) ge 12 and ord(a) le 23);
aw(a) =         yes$(ord(a) ge 12 and ord(a) le 65);
af2049(a) =     yes$(ord(a) ge 20 and ord(a) le 49);
af(a) =         yes$(ord(a) ge 15 and ord(a) le 49);

*Variable declaration
*********************

Positive Variables  lfe(e,t)        Labor force as a function of education and year
                    schoolpop(t)    Total school population as a function of year
                    schooltsa(t)    School age as a function of year
                    q(sec,t)        Output as a function of sector and year
                    qpc(t)          Output per capita as a function of year
                    gdp(t)          GDP as a function of year
                    gdptpc(t)       GDP per capita as a function of year
                    emp(sec,t)      Employment as a function of sector and year
                    k(sec,t)        Capital as a function of sector and year
                    contr(t)        Consumption of tradeables as a function of year
                    contrpc(t)      Consumption of tradeables per capita as a function of year
                    tx(t)           Taxes as a function of year
                    schoolcgdp(t)   
                    connt(t)        Consumption of non-tradeables as a function of year
                    conntpc(t)      Consumption of non-tradeables per capita as a function of year
                    lsec(e,sec,t)   Labor by sector as a function of education level and year
                    mpk(sec,t)      Marginal product of capital as a function of sector and year
                    land(sec,t)     Land as a function of sector and year
                    min(sec,t)      Minerals output(?) as a function of sector and year
                    scgdp(t)        
                    kff(t)          Capital stock for fossil fuel energy production by year
                    kre(t)          Capital stock for renewable energy production by year
                    he(t)           
                    en(sec,t)       Energy as a function of sector and year
                    entot(t)        Total energy as a function of year
                    enh(t)          Housing energy as a function of year
                    enhpc(t)        Housing energy per capita as a function of year
                    invff(t)        Investment in fossil fuels as a function of year
                    invre(t)        Investment in renewable energy as a function of year
                    ff(t)           Fossil fuels by year
                    invf(t)         Investment for capital infrastructure as a function of year
                    kh(t)           Capital for housing as a function of year
                    invh(t)         Investment in housing as a function of year
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
                    w(a,a,g,t)      Working population as a func of two age elements gender and year
                    worka(a,t)      Working age as a function of age and time
                    pop(a,g,t)      Age and gender-specific population by year
                    poptot(t)       Total population by year
                    pa(t)           Primary attainment by year
                    lsa(t)          Lower secondary attainment by year
                    usa(t)          Upper secondary attainment by year
                    tsa(t)          Tertiary attainment by year
                    lf(t)           Total labor force by year
                    h(t)            housing?
                    birth(t)        Birth rate as a function of year
                    fert(a,a,t)     Fertility as a function of two age elements and year
                    inv(sec,t)      Investment by sector as a function of year
                    ngdp(sec,t)     Nominal GDP by sector as a function of year
                    pgdp(sec,t)     Price GDP per sector as a function of year
                    ngdptot(t)      Total nominal GDP by year
                    edgdp(t)        Education contribution to GDP by year
                    healgdp(t)      Health contribution to GDP by year;

Variable            util            Main utility variable
                    ut(t)           Utility by year
                    wage(e,t)       Wage as a function of education level and time
                    debt(t)         Debt level by year (is this always positive?)
                    debtgdp(t)      Debt-GDP ratio by year (is this always positive?)
                    nx(t)           Net exports by year;

*Model equations
***************
               
Equations           eq1(a,g,t)      Secondary school pop by age and gender at t+1
                    eq2(g,t)        Population by gender and year starting secondary at age 12
                    eq3(a,g,t)      Models population survival each year by age and gender
                    eq4(a,a,t)      Fertility dependent on age and education level
                    eq5(t)          Expected births per year
                    eq6(a,g,t)      Equalizes gender ratio at birth
                    eq7(t)          Primary school enrollment assuming universal enrollment
                    eq8(t)          Total population of lower secondary age
                    eq9(t)          Total population of upper secondary age
                    eq10(t)         Total population of tertiary age
                    eq11(t)         Lower secondary enrollment rate
                    eq12(t)         Upper secondary enrollment rate
                    eq13(t)         Tertiary enrollment rate
                    eq14(t)         Total population in schooling
                    eq15(a,a,g,t)   Total dropouts per year as age-dependent dropout rate by school pop per year
                    eq16(a,a,g,t)   Working population at time t+1
                    eq17(a,g,t)     Age 12 working population equals 0
                    eq18(a,t)       Working age defined by school age and age of fertility
                    eq19(a,t)       Educational attainment by age and time
                    eq20(t)         Total labor force summed by educational attainment per year
                    eq21(t)         Primary attainment in year t as sum of attainment for 12 13 and 14 year olds
                    eq22(t)         LS attainment in year t as sum of attainment for 15 16 and 17 year olds
                    eq23(t)         US attainment as sum of attainment for 18 19 20 and 21 year olds
                    eq24(t)         TER attainment as sum of attainment for 22 year olds
                    eq25(t)         Total population summation at time t
                    eq26(t)         Total population enrolled in primary at time t
                    eq27(t)         Total population enrolled in lower secondary at time t
                    eq28(t)         Total population enrolled in upper secondary at time t
                    eq29(t)         Total population enrolled in tertiary at time t
                    eq30(t)         Primary-educated labor force at time t
                    eq31(t)         LS-educated labor force at time t
                    eq32(t)         US-educated labor force at time t
                    eq33(t)         TER-educated labor force at time t
                    eq34(t)         Percentage of total population in school at time t
                    
                    eq36(as,g)      Education for school-age people in 2022 
                    eq37(a,g)       Population in 2022
                    eq38(a,a,g)     Worker population in 2022
                    eq39(t)         Sets continuation rate = 1 at age 12
                    eq40(t)         Sets continuation rate = 1 at age 13
                    eq41(t)         Sets continuation rate = 1 at age 14 but 15 skipped
                    eq42(t)         Sets continuation rate = 1 at age 16
                    eq43(t)         Sets continuation rate = 1 at age 17 but 18 skipped
                    eq44(t)         Sets continuation rate = 1 at age 19
                    eq45(t)         Sets continuation rate = 1 at age 20
                    eq46(t)         Sets continuation rate = 1 at age 21
                    
                    utilt(t)        Utility function by year
                    utility         Total utility summed and discounted over time
                    laborfc(e,t)    Defines labor function with education and time parameters
                    output(sec,t)   Defines Cobb-Douglas style output func with mineral land power capital labor
                    outputpc(t)     Total GDP per capita at time t
                    ewage(e,t)      Wage by education and time t given as marginal cost of labor
                    gdptrade(t)     GDP from trading goods and services at time t
                    employ(sec,t)   Sums employment in sectors over education for time t
                    kstart(sec,t)   Initial capital stock for each sector at t0
                    kfstart(t)      Initial infrastructure capital stock
                    kffstart(t)     Initial capital stock for energy from fossil fuels given as 0
                    krestart(t)     Initial capital stock for energy from renewables given as 0
                    knext(sec,t)    Motion of capital: next period equals current + invest - depreciate
                    ktotal(t)       Sum of capital in all sectors at time t
                    kfnext(t)       Motion of infrastructure capital
                    kffnext(t)      Motion of fossil fuel capital
                    krenext(t)      Motion of renewable capital
                    construct(t)    Sets construction output =  investment in renewables at time t
                    ntservices(t)   Output of non-tradeables = consumption of non-tradeables
                    kfend(t)        Infrastructure capital at end setting depreciation=investment
                    energy(t)       Capital in the power sector is the sum of fossil and renewable capital
                    energyd(t)      Total power at time t is energy produced by each sector + household energy
                    ffuel(t)        FF energy generated as product of FF capital and FF capital intensity
                    dstart(t)       Initial debt at t0 given as 0
                    tbalance(t)     GDP solved for net exports
                    totdebt(t)      Debt incurred from foreign trade?
                    debttogdp(t)    Debt-GDP ratio calculation
                    debtlimit(t)    Defines the debt-GDP ratio limit
                    conend(t)       Defines end output of constraint scenario
                    conlim(t)       Consumption limit under debt constraint scenario?
                    consumetrpc(t)  Consumption per capita in tradeable sectors
                    publicad(t)     Public administration set as 5% of total GDP
                    health(t)       Health needs set at .5% of total population for time t?
                    schooling(t)    Schooling level set as 5% of sum of education level for time t?
                    consumentpc(t)  Consumption per capita in nontradeable sectors
                    govbudget(t)    Government budget set as health_education contribution to nominal GDP at t
                    grossproduct(t) GDP set as sum of value added per sector for time t
                    housepc(t)      Housing per capita as real estate sector divided by population
                    pricent(t)      Price of nontraded goods as 20% share of traded over nontraded goods per capita?
                    kend(sec,t)     Capital at end by sector setting final investment = depreciation
                    kffend(t)       FF capital at end
                    kreend(t)       RE capital at end
                    educgdp(t)      Contribution of education to GDP as share of total nominal GDP
                    governgdp(t)    Govt budget as share of GDP at time t
                    taxmax(t)       Maximum tax generated from share of govt GDP set as tax limit
                    marginalpk(sec,t)   Marginal product of capital given as capital production over total capital
                    energyhpc(t)    Energy to housing per capita
                    landtorural(t)  Total land in rural sector at time t
                    mintot(t)       Total production in mineral sector at time t
                    nomgdp(sec,t)   Nominal GDP as sum of wages by education and sector over sector-specific blab
                    pricegdp(sec,t) Price GDP per sector as nominal GDP divided by sector output
                    nomgdptot(t)    Total nominal GDP
                    healthgdp(t)    Contribution of health to GDP as share of total nominal GDP;
                    
eq1(as+1,g,t+1)..  s(as+1,g,t+1) =e= cont(as,t)*s(as,g,t);
eq2(g,t+1)..  s("12",g,t+1) =e= cont12(t)*pop("11",g,t);
eq3(a+1,g,t+1)..  pop(a+1,g,t+1) =e= pop(a,g,t)*survive0(a,g);
eq4(af,as,t)..  fert(af,as,t) =e= w(af,as,"female",t)*fert0(af,"drc")$(ord(as) lt 6) + w(af,as,"female",t)*fert0(af,"hic")$(ord(as) ge 6);
eq5(t)..   birth(t) =e= sum(af,sum(as,fert(af,as,t)));
eq6(a1,g,t+1)..   pop(a1,g,t+1) =e= 0.5*birth(t);
eq7(t)..  ps(t) =e=  sum(ap,sum(g,pop(ap,g,t)));
eq8(t)..  ls(t) =e=  sum(als,sum(g,s(als,g,t)));
eq9(t)..  us(t) =e=  sum(aus,sum(g,s(aus,g,t)));
eq10(t)..  ts(t) =e=  sum(ater,sum(g,s(ater,g,t)));
eq11(t).. lse(t) =e= ls(t)/(sum(als,sum(g,pop(als,g,t))));
eq12(t).. use(t) =e= us(t)/(sum(aus,sum(g,pop(aus,g,t))));
eq13(t).. tse(t) =e= ts(t)/(sum(ater,sum(g,pop(ater,g,t))));
eq14(t).. schooltot(t) =e= ps(t) + ls(t) + us(t) + ts(t);
eq15(aw,as,g,t).. leave(aw,as,g,t) =e= (1-cont(as,t))*s(as,g,t)$(ord(aw) eq ord(as));
eq16(aw+1,as,g,t+1).. w(aw+1,as,g,t+1) =e= w(aw,as,g,t)$(ord(aw) ge ord(as)) + leave(aw,as,g,t)$(ord(aw) eq ord(as)) + 0$(ord(aw) lt ord(as));;
eq17(as,g,t+1).. w("12",as,g,t+1) =e= 0;
eq18(af,t).. worka(af,t) =e= sum(as,sum(g,w(af,as,g,t)));
eq19(as,t).. eattain(as,t) =e= sum(aw,sum(g,w(aw,as,g,t)));
eq20(t).. lf(t) =e= sum(as,eattain(as,t));
eq21(t).. pa(t) =e= eattain("12",t) + eattain("13",t) + eattain("14",t) ;
eq22(t)..  lsa(t) =e= eattain("15",t)+eattain("16",t)+eattain("17",t);
eq23(t)..  usa(t) =e= eattain("18",t)+eattain("19",t)+eattain("20",t)+eattain("21",t);
eq24(t)..  tsa(t) =e= eattain("22",t);
eq25(t)..  poptot(t) =e= sum(a,sum(g,pop(a,g,t)));
eq26(t).. school("ps",t) =e= ps(t);
eq27(t).. school("ls",t) =e= ls(t);
eq28(t).. school("us",t) =e= us(t);
eq29(t).. school("ts",t) =e= ts(t);
eq30(t).. lfe("ps",t) =e= pa(t);
eq31(t).. lfe("ls",t) =e= lsa(t);
eq32(t).. lfe("us",t) =e= usa(t);
eq33(t).. lfe("ts",t) =e= tsa(t);
eq34(t).. schoolpop(t) =e= schooltot(t)/poptot(t);
eq36(as,g).. s(as,g,"2022") =e= s0(as,g);
eq37(a,g).. pop(a,g,"2022") =e= popg0(a,g);
eq38(aw,as,g).. w(aw,as,g,"2022") =e= w0(aw,as,g);
eq39(t).. cont("12",t) =e= 1;
eq40(t).. cont("13",t) =e= 1;
eq41(t).. cont("14",t) =e= 1;
eq42(t).. cont("16",t) =e= 1;
eq43(t).. cont("17",t) =e= 1;
eq44(t).. cont("19",t) =e= 1;
eq45(t).. cont("20",t) =e= 1;
eq46(t).. cont("21",t) =e= 1;

laborfc(e,t)..        lfe(e,t) =e= sum(sec,lsec(e,sec,t));
output(sec,t)..       q(sec,t) =e= pi(sec)*min(sec,t)**bmin(sec)*land(sec,t)**bland(sec)*en(sec,t)**ben(sec)*kf(t)**bkf(sec)*k(sec,t)**bk(sec)*prod(e,lsec(e,sec,t)**bled(e,sec));
employ(sec,t)..       emp(sec,t) =e= sum(e,lsec(e,sec,t));
landtotrural(t)..     sum(sec,land(sec,t)) =e= landrural0;
mintot(t)..           sum(sec,min(sec,t)) =e= min0;
outputpc(t)..         gdptpc(t) =e= gdpt(t)/poptot(t);
gdptrade(t)..         gdpt(t) =e= sum(sect,q(sect,t));
ewage(e,t)..          wage(e,t) =e= bled(e,"man")*q("man",t)/lsec(e,"man",t);
marginalpk(sec,t)..   mpk(sec,t) =e= (bk(sec)*q(sec,t)/k(sec,t));

kstart(sec,tstart)..  k(sec,tstart) =e= k0(sec);
dstart(tstart)..      debt(tstart) =e= 0;
kffstart(tstart)..    kff(tstart) =e= kff0;
krestart(tstart)..    kre(tstart) =e= kre0;
kfstart(tstart)..     kf(tstart) =e= kf0;
knext(sec,t+1)..      k(sec,t+1) =e= k(sec,t)*(1-dep) + inv(sec,t);
ktotal(t)..           ktot(t) =e= sum(sec,k(sec,t));
kffnext(t+1)..        kff(t+1) =e= kff(t)*(1-dep) + invff(t)/costff;
krenext(t+1)..        kre(t+1) =e= kre(t)*(1-dep) + invre(t)/costre;
kfnext(t+1)..         kf(t+1) =e= kf(t)*(1-dep) + invf(t);
construct(t)..        q("con",t) =e= inv("re",t);
ntservices(t)..       q("sern",t) =e= connt(t);
energy(t)..           k("pow",t) =e= kff(t) + kre(t);
ffuel(t)..            ff(t) =e= aff*kff(t);
energyd(t)..          q("pow",t) =e= sum(sec,en(sec,t)) + enh(t);
tbalance(t)..         nx(t) =e= gdpt(t) - sum(sec,inv(sec,t)) - invf(t) - contr(t) - invff(t) - invre(t) - ff(t);
totdebt(t+1)..        debt(t+1) =e= (1+r)*debt(t) - nx(t);
debttogdp(t)..        debtgdp(t) =e= debt(t)/gdpt(t);
debtlimit(t)..        debtgdp(t) =l= debtqlim;
conend(tend)..        contr(tend) =e= gdpt(tend) - sum(sec,inv(sec,tend)) - invf(tend) - invff(tend) - invre(tend) - r*debt(tend) - ff(tend);
conlim(t)..           contr(t) =l= gdpt(t) - r*debt(t) - ff(t);
kend(sec,tend)..      k(sec,tend)*dep =e= inv(sec,tend);
kffend(tend)..        kff(tend)*dep =e= invff(tend);
kreend(tend)..        kre(tend)*dep =e= invre(tend);
kfend(tend)..         kf(tend)*dep =e= invf(tend);
consumetrpc(t)..      contrpc(t) =e= contr(t)/poptot(t);
consumentpc(t)..      conntpc(t) =e= connt(t)/poptot(t);
govbudget(t)..        gov(t) =e= ngdp("heal",t)+ngdp("ed",t);
governgdp(t)..        govgdp(t) =e= gov(t)/gdptot(t);
taxmax(t)..           govgdp(t) =l= taxlim;
grossproduct(t)..     gdptot(t) =e= sum(sec,q(sec,t));
publicad(t)..         q("pub",t) =e= .05*gdptot(t);
health(t)..           q("heal",t) =e= .005*poptot(t);
schooling(t)..        q("ed",t) =e= .05*sum(e,school(e,t));
educgdp(t)..          edgdp(t) =e= ngdp("ed",t)/ngdptot(t);
healthgdp(t)..        healgdp(t) =e= ngdp("heal",t)/ngdptot(t);
housepc(t)..          hspc(t) =e= q("re",t)/poptot(t);
pricent(t)..          pn(t) =e= .2*(contrpc(t)/conntpc(t));
energyhpc(t)..        enhpc(t) =e= enh(t)/poptot(t);
nomgdp(sec,t)..       ngdp(sec,t) =e= sum(e,wage(e,t)*lsec(e,sec,t))/(.001+blab(sec));
nomgdptot(t)..        ngdptot(t) =e= sum(sec,ngdp(sec,t));
pricegdp(sec,t)..     pgdp(sec,t) =e= ngdp(sec,t)/q(sec,t);
utilt(t)..            ut(t) =e= log(contrpc(t))+.2*log(conntpc(t))+.10*log(hspc(t))+.01*log(enhpc(t));
utility..             util =e= sum(t,disc(t)* ut(t)) + (1/r)*sum(tend,disc(tend)*ut(tend));

*Results Calculation
********************

Model sdgfinance using /all/;

poptot.lo(t) = .00001;
en.lo(sec,t) = .001;
tsa.lo(t) = .00001;
pop.lo(a,g,t) = .000001;
k.lo(sec,t) = .001;
contrpc.lo(t) = .001;
contr.lo(t) = .001;
conntpc.lo(t) = .001;
connt.lo(t) = .001;
q.lo(sec,t) = .0001;
enh.lo(t) = .001;
enhpc.lo(t) = .001;
lsec.lo(e,sec,t) = .0001;
gdpt.lo(t) = .001;
kh.lo(t) = .001;
hspc.lo(t) = .001;
kf.lo(t) = .001;
cont12.up(t) = 1.0;
cont.up(a,t) = 1.0;
gdptot.lo(t) = .00001;
land.lo(sec,t) = .0001;
ngdptot.lo(t) = .001;

*debtqlim = 20;

*solve sdgfinance maximizing util using dnlp;

Parameter   dlim(scen)  Debt limit by scenario
            /lim  10
            nolim 10/;

Parameter   rs(scen)    
            /lim 0.15
            nolim 0.05/;

Parameter   taxmaxs(scen)
            /lim  0.1
            nolim 0.4/;

Loop(scen,
debtqlim = dlim(scen);
r = rs(scen);
taxlim = taxmaxs(scen);

Solve sdgfinance maximizing util using dnlp;
ks(scen,sec,t) = k.L(sec,t);
debtgdps(scen,t) = debtgdp.L(t);
contrpcs(scen,t) = contrpc.L(t);
gdptots(scen,t) = gdptot.L(t);
kffs(scen,t) = kff.L(t);
kres(scen,t) = kre.L(t);
kfs(scen,t) = kf.L(t);
mpks(scen,sec,t) = mpk.L(sec,t);
ktots(scen,t) = ktot.L(t);
wages(scen,e,t) = wage.L(e,t);
gdpts(scen,t) = gdpt.L(t);
qs(scen,sec,t) = q.L(sec,t);
contrs(scen,t) = contr.L(t);
contrpcs(scen,t) = contrpc.L(t);
pas(scen,t) = pa.L(t);
govgdps(scen,t) = govgdp.L(t);
lsas(scen,t) = lsa.L(t);
usas(scen,t) = usa.L(t);
tsas(scen,t) = tsa.L(t);
schools(scen,e,t) = school.L(e,t);
invs(scen,sec,t) = inv.L(sec,t);
edgdps(scen,t) = edgdp.L(t);
healgdps(scen,t) = healgdp.L(t););


Display pas, lsas, usas, tsas, gdpts, kffs, kres, contrpcs, debtgdps, edgdps, healgdps;

Display mpks, invs;

Display govgdps;

Display schools;

Display q.L,emp.L;

Display ngdp.L, pgdp.L;

*execute_unload 'data.gdx' qpcs, ks, conpcs, births, eduuss;
*execute 'gdxxrw data.gdx par=qpcs rng=qpcs!A1 par=ks rng=ks!A1 par = conpcs rng=conpcs!A1 par = births rng=births!A1 par=eduuss rng=eduss!A1

$onText

display bled,blab,bed;
display q.L,k.L,land.L,min.L,contr.L;
display cont.L;
display pa.L,lsa.L,usa.L,tsa.L;
display lsec.L;

$offText
