set t /2022*2050/
tstart(t)
tend(t);
tstart(t) = yes$(ord(t) eq 1);
tend(t) = yes$(ord(t) eq card(t));

*set e is education: primary, p; lower secondary, ls; upper secondary, us; tertiary, t;

set e /nos,ps,ls,us,ts/;
alias(e,ea);

set g /male,female/;
set surv /megypt,fegypt,mhic,fhic/;
set fer /egypt,hic/;

*Sectors: subsistence, agriculture, mining, construction, power, manufacturing
* professional services (traded), real estate, non-traded services, traded services, education, health care, public administration
*sect: tradable sectors
*secn: nontradable sectors

set sec /ag, mine, con, pow, man, re, sern, sert, ed, heal, pub/
sect(sec) /ag, mine, man, sert/
secn(sec) /con, pow, re, sern, ed, heal, pub/;

*sets and subsets for age

set a /1*100/
a1(a), aw(a), af2049(a), an(a), ap(a), als(a), af(a), aus(a), ater(a), as(a), asc(a);
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

alias(as,aa);

set scen /low , high/;

parameter debtgdps(scen,t),conpcs(scen,t), kffs(scen,t),kres(scen,t), kfs(scen,t), wages(scen,e,t),ktots(scen,t),mpks(scen,t),conpcs(scen,t), qs(scen,t), qpcs(scen,t),ks(scen,t), edcostgdps(scen,t),
invs(scen,t),schoolshs(scen,t),schoolyrs(scen,t), tfrts(scen,t),tfrs(scen,t),poptots(scen,t),edcosts(scen,t),enrollrates(scen,t),schoolshs(scen,t),birthrates(scen,t),fertshs(scen);


$offOrder





parameter bk, bkf, ben, k0, kf0, debtqlim, ek, costff, costre, dep, r, kff0, kre0, aff, taxlim, min0, land0, tfp1, phi, fertsh;

$CALL GDXXRW mydatainput.xlsx Index=Index!a1 trace=3
$GDXIN mydatainput.gdx
$LOAD  bk bkf ben k0 kf0 debtqlim ek costff costre dep r kff0 kre0 aff taxlim min0 land0 tfp1 phi fertsh
$GDXIN

parameter blab;
blab = 1-bk-bkf-ben;



*discount factor

parameter disc(t);
disc(t) = 1/(1+r)**(ord(t)-1);


display bk, bkf, ben, k0, kf0, debtqlim, ek, costff, costre, dep, r, kff0, kre0, aff, taxlim, min0, land0, tfp1, phi, fertsh;



parameter popg0(a,g),fert0(a,fer),surv0(a,surv),w0(a,a,g),s0(a,g),ferthic0(a,fer),tfp(sec);

$CALL GDXXRW egyptdatainput.xlsx Index=Index!a1 trace=3
$GDXIN egyptdatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6
$GDXIN

fert0(a,"hic") = ferthic0(a,"hic");

display popg0,fert0,surv0,w0,s0,ferthic0;






parameter tfr0(fer);
tfr0(fer) = sum(af,fert0(af,fer));
parameter survive0(a,g);
survive0(a,"female") = surv0(a,"fegypt");
survive0(a,"male") = surv0(a,"megypt");
parameter survivehi0(a,g);
survivehi0(a,"female") = surv0(a,"fhic");
survivehi0(a,"male") = surv0(a,"mhic");

parameter lfep(e,t),poptotp(t),schooltotp(t),lfp(t);

scalar fertsh;

parameter years(e)
/nos 0
 ps 6
 ls 9
 us 12
 ts 16/;

positive variables lfe(e,t), schoolsh(t), schooltsa(t), q(t),qpc(t),gdp(t),gdpt(t),gdptpc(t), emp(t), hc(t),
k(t),con(t), tx(t), conpc(t), mpk(t),land(t),min(t), edcost(t), edcostgdp(t),ktot(t), qpc(t), efflabor(a,t), efflabtot(t),
scgdp(t), kff(t),kre(t), he(t), en(t), entot(t),enh(t), enhpc(t), invff(t), invre(t), ff(t), invf(t), kh(t),invh(t),hspc(t),kf(t),ktot(t),
lqp(t),lsub(t), gov(t),gdptot(t), pn(t), debt(t), debtgdp(t), cont12(t), govgdp(t), reserve(t), edcost(t), hlcost(t),control(t), healthpc(t), hlcostgdp(t),
lfe(e,t), schoolpop(t), schooltsa(t), cont(a,t), s(a,g,t), leave(a,a,g,t),neet(a,a,t), school(e,t), schooltot(t), schoolc(t), ps(t),ls(t),us(t),ts(t),lse(t), use(t), tse(t),
eattain(a,t),w(a,a,g,t),worka(a,t), pop(a,g,t),poptot(t),noa(t), pa(t),lsa(t),usa(t),tsa(t),lf(t),h(t),birth(t), fert(a,a,t), inv(t),schoolyr(t),
cinv(t),cinvff(t),cinvf(t),cinvre(t),debt(t),debtgdp(t), schoolage(t), enrollrate(t), birthrate(t),fbyage(a,t),tfr(t),invfgdp(t),pubgdp(t),outlaygdp(t),
edunitcost(t),hlunitcost(t),gcost(t);

variable util, ut(t), wage(e,t), nx(t),test;



Equations

eq1(a,g,t), eq2(g,t), eq3(a,g,t), eq4(a,a,t), eq5(t), eq6(a,g,t), eq7(t), eq8(t), eq9(t), eq10(t), eq11(t), eq12(t),
eq13(t), eq14(t), eq15(a,a,g,t), eq16(a,a,g,t), eq17(a,g,t),
*eq18(a,t),
eq19(a,t), eq20(t), eq21(t), eq22(t), eq19a(t), eq19b(t),eq19c(t),eq19d(t),eq19e(t),
eq23(t), eq24(t), eq25(t), eq26(t), eq27(t), eq28(t), eq29(t), eq30(t), eq31(t), eq32(t), eq33(t),
eq34(t),
eq36(a,g), eq37(a,g), eq38(a,a,g), eq39(t), eq40(t), eq41(t), eq42(t), eq43(t), eq44(t), eq45(t), eq46(t),
eq47(t),eq48(t),eq49(t),eq50, eq51(t), eq52(a,t), eq53(t),eq54(t),eq30a(t),eq55(t),eq56(t),eq57(t),eq21a(t),eq58(t),eq59(t), eq60(t),
eq61(t),eq62(t),eq63(t),eq64(a,t),eq65(t);


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
eq48(t).. cont("18",t) =e= .5;
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

model demo using /all/;

*eattain.lo(a,t) = .00001;

Equations

utilt(t), utility,  output(t), outputpc(t), ewage(e,t),
kstart(t), kfstart(t), kffstart(t), krestart(t), knext(t), kfnext(t), kffnext(t),
krenext(t),kfend(t), energy(t), ffuel(t), conlim(t), education(t), edugdp(t),
dstart(t), tbalance(t), totdebt(t), debttogdp(t),
debtlimit(t),
conend(t), consumetrpc(t),
kend(t), kffend(t), kreend(t),ktotal(t), costk(t),costkre(t),costkff(t),costkf(t),
health(t),govcost(t),hlgdp(t), pubadgdp(t),infgdp(t),poutlay(t), educationuc(t),healthuc(t),
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

model sdgfinance using /all/;

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



parameter dlim(scen)

/low   10
 high 10/;

parameter rs(scen)

/low 0.15
high 0.05/;

parameter taxmaxs(scen)
/low  0.1
high 0.4/;

parameter fertshs
/low .5
 high 0/;



fertsh = .5;

solve demo minimizing test using dnlp;
lfep(e,t) = lfe.L(e,t);
lfp(t) = lf.L(t);
poptotp(t) = poptot.L(t);
schooltotp(t) = schooltot.L(t);
solve sdgfinance maximizing util using dnlp;
display qpc.L, edcostgdp.L, hlcostgdp.L, invfgdp.L, outlaygdp.L;

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

