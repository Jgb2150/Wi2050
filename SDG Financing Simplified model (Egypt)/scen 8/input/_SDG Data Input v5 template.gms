set a /1*100/
a299(a)
a622(a);
a299(a) = yes$(ord(a) ge 2);
a622(a) = yes$(ord(a) ge 6 and ord(a) le 22);
set ag /0-4,5-9,10-14,15-19,20-24,25-29,30-34,35-39,40-44,45-49,50-54,55-59,60-64,65-69,70-74,75-79,80-84,85-89,90-94,95-99,100+/
agfert /15-19,20-24,25-29,30-34,35-39,40-44,45-49/;
set surv /mlocal, flocal, mhic, fhic/;
set edu /no,ptotal,pc,stotal,sc,ttotal,tc,pop/ ;
set age624 /s0sh,ps,ls,us,ts/;
set educ /6,9,12,15,18,20,22/;
set eda /ps,ls,us,ts/;
set secp /sub, ag, min, man, con, prof, serv/;
alias(a,a1,a2);
set fer /local, hic/;
set g /male, female/;
parameter popg0(a,g), fert0(a), surv0(a,surv), wf0(a,educ), wm0(a,educ);
parameter age5yr(ag,g),asfr(agfert,fer),survival(a,surv),edattainf(a,a,edu),edattainm(a,a,edu),s0shf(a,age624),s0shm(a,age624),bed(secp,eda);


* rawdata.xlsx corresponds to egyptdata.xlsx in previous versions
$CALL GDXXRW .\rawdata\rawdata_%country%.xlsx output=".\auxiliary\rawdata_%country%.gdx" Index=Index!a1 trace=3
$GDXIN ".\auxiliary\rawdata_%country%.gdx"
$LOAD age5yr=D1 asfr=D2 survival=D3 s0shf=D4 s0shm=D5 edattainf=D6 edattainm=D7
$GDXIN

display age5yr,asfr,survival,s0shf,s0shm,edattainf,edattainm;

parameter avag(ag);
avag(ag) = (ord(ag)-1)*5+2;

$offOrder

display avag;

loop(ag,
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+2) = age5yr(ag,g)/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+3) = (age5yr(ag,g)+(1/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+4) = (age5yr(ag,g)+(2/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+5) = (age5yr(ag,g)+(3/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+6) = (age5yr(ag,g)+(4/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;);

popg0("1",g) = popg0("2",g) + (popg0("2",g) - popg0("3",g));

display popg0;

loop(agfert,
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+15) = asfr(agfert,"local")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+16) = asfr(agfert,"local")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+17) = asfr(agfert,"local")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+18) = asfr(agfert,"local")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+19) = asfr(agfert,"local")/1000;);

display fert0;
parameter tfr0;
tfr0 = sum(a,fert0(a));
display tfr0;

parameter ferthic0(a);

loop(agfert,
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+15) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+16) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+17) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+18) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+19) = asfr(agfert,"hic")/1000;);

display ferthic0;
parameter tfrhic0;
tfrhic0 = sum(a,ferthic0(a));
display tfrhic0;

loop(ag,
survival(a,"mlocal")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"mlocal")*(survival(a+4,"mlocal")/survival(a-1,"mlocal"))**(1/5);
survival(a,"mlocal")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"mlocal")*(survival(a+3,"mlocal")/survival(a-2,"mlocal"))**(2/5);
survival(a,"mlocal")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"mlocal")*(survival(a+2,"mlocal")/survival(a-3,"mlocal"))**(3/5);
survival(a,"mlocal")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"mlocal")*(survival(a+1,"mlocal")/survival(a-4,"mlocal"))**(4/5);
survival(a,"mlocal")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"mlocal")*(survival(a  ,"mlocal")/survival(a-5,"mlocal"))**(5/5);
survival(a,"flocal")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"flocal")*(survival(a+4,"flocal")/survival(a-1,"mlocal"))**(1/5);
survival(a,"flocal")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"flocal")*(survival(a+3,"flocal")/survival(a-2,"mlocal"))**(2/5);
survival(a,"flocal")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"flocal")*(survival(a+2,"flocal")/survival(a-3,"mlocal"))**(3/5);
survival(a,"flocal")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"flocal")*(survival(a+1,"flocal")/survival(a-4,"mlocal"))**(4/5);
survival(a,"flocal")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"flocal")*(survival(a  ,"flocal")/survival(a-5,"mlocal"))**(5/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"mhic")*(survival(a+4,"mhic")/survival(a-1,"mhic"))**(1/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"mhic")*(survival(a+3,"mhic")/survival(a-2,"mhic"))**(2/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"mhic")*(survival(a+2,"mhic")/survival(a-3,"mhic"))**(3/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"mhic")*(survival(a+1,"mhic")/survival(a-4,"mhic"))**(4/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"mhic")* (survival(a,"mhic")/survival(a-5,"mhic"))**(5/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"fhic")*(survival(a+4,"fhic")/survival(a-1,"fhic"))**(1/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"fhic")*(survival(a+3,"fhic")/survival(a-2,"fhic"))**(2/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"fhic")*(survival(a+2,"fhic")/survival(a-3,"fhic"))**(3/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"fhic")*(survival(a+1,"fhic")/survival(a-4,"fhic"))**(4/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"fhic")*(survival(a  ,"fhic")/survival(a-5,"fhic"))**(5/5););

survival("2","fhic") = survival("1","fhic")*(survival("5","fhic")/survival("1","fhic"))**(1/4);
survival("3","fhic") = survival("1","fhic")*(survival("5","fhic")/survival("1","fhic"))**(2/4);
survival("4","fhic") = survival("1","fhic")*(survival("5","fhic")/survival("1","fhic"))**(3/4);
survival("2","mhic") = survival("1","mhic")*(survival("5","mhic")/survival("1","mhic"))**(1/4);
survival("3","mhic") = survival("1","mhic")*(survival("5","mhic")/survival("1","mhic"))**(2/4);
survival("4","mhic") = survival("1","mhic")*(survival("5","mhic")/survival("1","mhic"))**(3/4);
survival("2","flocal") = survival("1","flocal")*(survival("5","flocal")/survival("1","flocal"))**(1/4);
survival("3","flocal") = survival("1","flocal")*(survival("5","flocal")/survival("1","flocal"))**(2/4);
survival("4","flocal") = survival("1","flocal")*(survival("5","flocal")/survival("1","flocal"))**(3/4);
survival("2","mlocal") = survival("1","mlocal")*(survival("5","mlocal")/survival("1","mlocal"))**(1/4);
survival("3","mlocal") = survival("1","mlocal")*(survival("5","mlocal")/survival("1","mlocal"))**(2/4);
survival("4","mlocal") = survival("1","mlocal")*(survival("5","mlocal")/survival("1","mlocal"))**(3/4);

display survival;

surv0(a299,surv) = survival(a299+1,surv)/survival(a299,surv);

surv0("1",surv) = survival("1",surv)/100000;

display surv0;

display edattainf, edattainm;

wf0(a,"12")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"ps");
wf0(a,"15")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"ls");
wf0(a,"18")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"us");
wf0(a,"22")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"ts");
wf0(a,"6")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","no");
wf0(a,"6")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","no");
wf0(a,"6")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","no");
wf0(a,"6")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","no");
wf0(a,"9")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","ptotal") - edattainf("25","34","pc");
wf0(a,"9")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","ptotal") - edattainf("35","44","pc");
wf0(a,"9")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","ptotal") - edattainf("45","54","pc");
wf0(a,"9")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","ptotal") - edattainf("55","64","pc");
wf0(a,"12")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","pc");
wf0(a,"12")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","pc");
wf0(a,"12")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","pc");
wf0(a,"12")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","pc");
wf0(a,"15")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","stotal")-edattainf("25","34","sc");
wf0(a,"15")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","stotal")-edattainf("35","44","sc");
wf0(a,"15")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","stotal")-edattainf("45","54","sc");
wf0(a,"15")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","stotal")-edattainf("55","64","sc");
wf0(a,"18")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","sc");
wf0(a,"18")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","sc");
wf0(a,"18")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","sc");
wf0(a,"18")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","sc");
wf0(a,"20")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","ttotal")-edattainf("25","34","tc");
wf0(a,"20")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","ttotal")-edattainf("35","44","tc");
wf0(a,"20")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","ttotal")-edattainf("45","54","tc");
wf0(a,"20")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","ttotal")-edattainf("55","64","tc");
wf0(a,"22")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","tc");
wf0(a,"22")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","tc");
wf0(a,"22")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","tc");
wf0(a,"22")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","tc");

wm0(a,"12")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"ps");
wm0(a,"15")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"ls");
wm0(a,"18")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"us");
wm0(a,"22")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"ts");
wm0(a,"6")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","no");
wm0(a,"6")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","no");
wm0(a,"6")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","no");
wm0(a,"6")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","no");
wm0(a,"9")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","ptotal") - edattainm("25","34","pc");
wm0(a,"9")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","ptotal") - edattainm("35","44","pc");
wm0(a,"9")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","ptotal") - edattainm("45","54","pc");
wm0(a,"9")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","ptotal") - edattainm("55","64","pc");
wm0(a,"12")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","pc");
wm0(a,"12")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","pc");
wm0(a,"12")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","pc");
wm0(a,"12")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","pc");
wm0(a,"15")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","stotal")-edattainm("25","34","sc");
wm0(a,"15")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","stotal")-edattainm("35","44","sc");
wm0(a,"15")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","stotal")-edattainm("45","54","sc");
wm0(a,"15")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","stotal")-edattainm("55","64","sc");
wm0(a,"18")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","sc");
wm0(a,"18")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","sc");
wm0(a,"18")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","sc");
wm0(a,"18")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","sc");
wm0(a,"20")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","ttotal")-edattainm("25","34","tc");
wm0(a,"20")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","ttotal")-edattainm("35","44","tc");
wm0(a,"20")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","ttotal")-edattainm("45","54","tc");
wm0(a,"20")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","ttotal")-edattainm("55","64","tc");
wm0(a,"22")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","tc");
wm0(a,"22")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","tc");
wm0(a,"22")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","tc");
wm0(a,"22")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","tc");


display wf0,wm0;
parameter w0(a,educ,g);
w0(a,educ,"female") = wf0(a,educ)*.01*popg0(a,"female");
w0(a,educ,"male") = wm0(a,educ)*.01*popg0(a,"male");

display w0;

parameter s0(a,g);
s0(a,"female") = popg0(a,"female")*s0shf(a,"s0sh")*.01;
s0(a,"male") = popg0(a,"male")*s0shm(a,"s0sh")*.01;

display s0;

* dataloader.gdx corresponds to egyptdatainput.gdx in previous versions
execute_unload '.\auxiliary\datainput_%country%.gdx' popg0,fert0,ferthic0,surv0,w0,s0;

$onEcho > .\auxiliary\loadersetting.txt
par=popg0 rng=popg0!A1
par=fert0 rng=fert0!A2 rdim=1
text="local" rng=fert0!B1
par=ferthic0 rng=ferthic0!A2 rdim=1
text="hic" rng=ferthic0!B1
par=surv0 rng=surv0!A1
par=w0 rng=w0!A1
par=s0 rng=s0!A1
text="Dim" rng=index!D1 text="Rdim" rng=index!E1
text="par" rng=index!A2 text="D1" rng=index!B2 text="popg0!A1" rng=index!C2 text="2" rng=index!D2 text="1" rng=index!E2
text="par" rng=index!A3 text="D2" rng=index!B3 text="fert0!A1" rng=index!C3 text="2" rng=index!D3 text="1" rng=index!E3
text="par" rng=index!A4 text="D3" rng=index!B4 text="surv0!A1" rng=index!C4 text="2" rng=index!D4 text="1" rng=index!E4
text="par" rng=index!A5 text="D4" rng=index!B5 text="w0!A1" rng=index!C5 text="3" rng=index!D5 text="2" rng=index!E5
text="par" rng=index!A6 text="D5" rng=index!B6 text="s0!A1" rng=index!C6 text="2" rng=index!D6 text="1" rng=index!E6
text="par" rng=index!A7 text="D6" rng=index!B7 text="ferthic0!A1" rng=index!C7 text="2" rng=index!D7 text="1" rng=index!E7
$offEcho
execute 'gdxxrw .\auxiliary\datainput_%country%.gdx output=.\auxiliary\datainput_%country%.xlsx @.\auxiliary\loadersetting.txt';
