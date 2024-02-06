z****************
cd"C:\Users\dessi\OneDrive - Universidad de Las Américas\Septimo semestre\Investigación\Stata"
use "ENEMDU 2019" 

*Si se quiere unir base del 2019 con 2021

*append using "ENEMDU 2021"
append using "ENEMDU 2021"

****************************
*Pruebas de significancia estadistica - ENEMDU
****************

set more off
net from http://dasp.ecn.ulaval.ca/modules/DASP_V2.3/dasp
net install dasp_p1, force
net install dasp_p2, force
net install dasp_p3, force
net install dasp_p4, force
*********************
*Storage type (de string a byte)

***************************

destring p06 p07 p08 p09 p10a p10b p11 p12a p12b p15  p15ab cod_inf p20 p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33 p34 p35 p36 p37 p38 p39 p40 p41 p42 p42a p43 p44a p44b p44c p44d p44e p44f p44g p44h p44i p44j p44k p45 p46 p47a p47b p48 p49 p50 p51a p51b p51c p52 p53 p54 p54a p55 p56a p56b p57 p58 p59 p60a p60b p60c p60d p60e p60f p60g p60h p60j p60k p61b1 p63 p64a p64b p65 p66 p67 p68a p68b p69 p70a p70b p71a p71b p72a p72b p73a p73b  p74a  p74b p75 p76 p77 p78 sd01 sd021 sd022 sd023 sd024 sd025 sd026 sd027 sd028 sd029 sd0210 sd0211 sd03  nnivins ingrl secemp grupo1 rama1 dominio pobreza epobreza , replace
* Cambia las comas por punto
destring ingpc , replace dpcomma
destring fexp , replace dpcomma


*******************************
*Diseño de muestra
****************************
*Con el prefijo svy: sus errores estándares sean calculados con Taylor tomando en cuenta todas las características del diseño muestral, 
*donde el identificador de cada UPM es la variable upm,
* el factor de expansión corresponde a la variable fexp;
* la variable que identifica los estratos es estratos y el método de cálculo de los errores estándar es mediante la linealización de Taylor con la opción linearized. Finalmente, la opción singleunit (certainty)especifica cómo manejar los estratos con una unidad de muestreo. "certainty" hace que los estratos con conglomerados individuales sean tratados como unidades de certeza, es decir estas unidades no contribuyen para el cálculo del 	error estándar. 

svyset upm [iw=fexp], strata (estrato) vce(linearized) singleunit(certainty)

*si se realiza una estimación de la media del ingreso per cápita, con los errores estándar Linealizados de Taylor, el proceso es el siguiente:
svy: mean ingpc

*Para dividir la media en subgrupos (área, por ejemplo) 
svy: mean ingpc , over (area)

*tabla de frecuencias, con errores estándar, del ingreso percápita por área con su coeficiente de variación
estat cv

////////////////////////////////////////////////////////////////////////

*Generar variable dummy de la edad.
gen edad_trabajo =. 
replace edad_trabajo=1 if p03>17 & p03<66
replace edad_trabajo=0 if p03<18 | p03>65

*Generar variable solo con el año y no el mes
gen anio1 = periodo
tostring anio1, replace
gen anio3 = substr(anio1,1,4)

*General variable solo con el código de la ciudad
gen ciud1 = ciudad
tostring ciud1, replace
gen ciud2 = substr(ciud1,1,4)

*Generar variable dummy de la ciudad.
gen dmq =. 
replace dmq=1 if ciud2=="1701"
replace dmq=0 if ciud2!="1701"

set scheme s2color 
grstyle init
grstyle color background white
grstyle color major_grid dimgray
grstyle linewidth major_grid thin


set scheme s2color 
grstyle init
grstyle set imesh, horizontal minor


set scheme s1color

*Distribución del ingreso  por año, edad, genero
kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000, plot(kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución del ingreso por sexo" "en el Ecuador en 2019", size(medium))  lcolor(pink) xtitle(Ingreso laboral) ytitle(Densidad)  note("{bf:Fuente}: ENEMDU 2019") 

kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000, lcolor( blue) plot(kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución del ingreso por sexo" "en el Ecuador en 2021", size(medium))  lcolor(eltblue) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Fuente}: ENEMDU 2021") 

*Distribución del ingreso  por año, edad, genero, dmq

kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1 , plot(kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución del ingreso por sexo" "del Distrito Metropolitano de Quito en 2019", size(medium) color(black))  lcolor(emerald) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Fuente}: ENEMDU 2019") 

kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1 , ylabel(0(0.0005)0.002) plot(kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución del ingreso por sexo" "del Distrito Metropolitano de Quito en 2021",size(medium) color(black))  lcolor(emerald) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Fuente}: ENEMDU 2021") 



graph combine  g1 g2 g3 g4 ,row(2)


///////////////////GRAFICOS DOCUMENTO NORMAS APA/////////////////////////

kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000, plot(kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("", size(medium))  lcolor(pink) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Ingreso por sexo en el Ecuador (2019)}")  name(g1,replace)

kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000, plot(kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("", size(medium))  lcolor(pink) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Ingreso por sexo en el Ecuador (2021)}")  name(g2,replace)


kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1 , plot(kdensity ingrl if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("", size(medium) color(black))  lcolor(emerald) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Ingreso por sexo en el Distrito Metropolitano de Quito (2019)}", size(vsmall))  name(g3, replace)

kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1 , ylabel(0(0.0005)0.002) plot(kdensity ingrl if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("", size(medium) color(black))  lcolor(emerald) xtitle(Ingreso laboral) ytitle(Densidad) note("{bf:Ingreso por sexo en el Distrito Metropolitano de Quito (2021)}", size(vsmall))  name(g4, replace)

graph combine  g3 g4 ,



/////////////////////////////////////////////////////////////////////////////


*Crear variable agregada salario

local vars p63 p64b p65 p66 p67 p68b p69 p70b p71b p72b 
foreach var of local vars {
    replace `var' =. if `var' ==999999
}

local vars p63 p64b p65 p66 p67  p68b p69 p70b p71b p72b 
foreach var of local vars {
    replace `var' = 0 if `var' ==.
}

gen ing_ag = p63 + p64b + p65 + p66 + p67 + p68b + p69 + p70b + p71b + p72b 

*Distribución del SALARIO AG  por año, edad, genero

kdensity ing_ag if anio3=="2019" & edad_trabajo==1 & p02==2 & ing_ag<2000, plot(kdensity ing_ag if anio3=="2019" & edad_trabajo==1 & p02==1 & ing_ag<2000) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución de ing_ag de las mujeres" "en el Ecuador en el 2019")  lcolor(pink) xtitle(Ingreso laboral) ytitle(Densidad) note("Fuente: ENEMDU 2019") 

kdensity ing_ag if anio3=="2021" & edad_trabajo==1 & p02==2 & ing_ag<2000, plot(kdensity ing_ag if anio3=="2021" & edad_trabajo==1 & p02==1 & ing_ag<2000) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución de ing_ag de las mujeres" "en el Ecuador en el 2021")  lcolor(pink) xtitle(Ingreso laboral) ytitle(Densidad) note("Fuente: ENEMDU 2021") 

*Distribución del SALARIO AGREGADO por año, edad, genero, dmq

kdensity salario_ag if anio3=="2019" & edad_trabajo==1 & p02==2 & salario_ag<2000 & dmq==1 , plot(kdensity salario_ag if anio3=="2019" & edad_trabajo==1 & p02==1 & salario_ag<2000 & dmq==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución del salario_ag de las mujeres" "pertencientes al Distrito Metropolitano de Quito en el 2019", size(12pt) color(black))  lcolor(emerald) xtitle(Ingreso laboral) ytitle(Densidad) note("Fuente: ENEMDU 2019") 

kdensity salario_ag if anio3=="2021" & edad_trabajo==1 & p02==2 & salario_ag<2000 & dmq==1 , plot(kdensity salario_ag if anio3=="2021" & edad_trabajo==1 & p02==1 & salario_ag<2000 & dmq==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Distrubución del salario_ag de las mujeres" "pertencientes al Distrito Metropolitano de Quito en el 2021", size(12pt) color(black))  lcolor(emerald) xtitle(Ingreso laboral) ytitle(Densidad) note("Fuente: ENEMDU 2021") 


twoway (hist p59 if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000) ///
(hist p59 if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000), ///   
legend (order(1 "Mujer" 2 "Hombre"))


hist p59 if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000

hist p59 if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000


////////////////////////////   59  /////////////////////////////////

twoway (hist p59 if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1, discrete color(pink%30)) ///
(hist p59 if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000& dmq==1, discrete color(blue%30)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿Cómo se siente en su trabajo?(2019)") subtitle("1= Contento  2= Poco contento 3= Descontento pero conforme" "4= Totalmente descontento  5= No sabe", size(small)) note("{bf:Fuente}: ENEMDU 2019") name(g591,replace)

twoway (hist p59 if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1, discrete color(pink%30)) ///
(hist p59 if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿Cómo se siente en su trabajo?(2021)") subtitle("1= Contento  2= Poco contento"  "3= Descontento pero conforme"  "4= Totalmente descontento  5= No sabe", size(small)) note("{bf:Fuente}: ENEMDU 2021")name(g592,replace)

graph combine  g591 g592


////////////////////////////   60a  /////////////////////////////////

twoway (hist p60a if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000& dmq==1, discrete color(pink%30) xlabel(1 2) gap(0) width(0.5)) ///
(hist p60a if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)xlabel(1 2) gap(0) width(0.5)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿El descontento es por ingresos bajos?""(2019)") subtitle("1= Si  2= No", size(small)) note("{bf:Fuente}: ENEMDU 2019") name(g60a1,replace)

twoway (hist p60a if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000& dmq==1, discrete color(pink%30) xlabel(1 2) gap(0) width(0.5)) ///
(hist p60a if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)xlabel(1 2) gap(0) width(0.5)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿El descontento es por ingresos bajos?""(2021)") subtitle("1= Si  2= No", size(small)) note("{bf:Fuente}: ENEMDU 2021") name(g60a2,replace)

graph combine  g60a1 g60a2

////////////////////////////   60c  /////////////////////////////////

twoway (hist p60c if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1, discrete color(pink%30) xlabel(1 2) gap(0) width(0.5)) ///
(hist p60c if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)xlabel(1 2) gap(0) width(0.5)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿El descontento es por horarios inconvenientes?""(2019)") subtitle("1= Si  2= No", size(small)) note("{bf:Fuente}: ENEMDU 2019") name(g60c1,replace)

twoway (hist p60c if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1, discrete color(pink%30) xlabel(1 2) gap(0) width(0.5)) ///
(hist p60c if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)xlabel(1 2) gap(0) width(0.5)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿El descontento es por horarios inconvenientes?""(2021)") subtitle("1= Si  2= No", size(small)) note("{bf:Fuente}: ENEMDU 2021") name(g60c2,replace)

graph combine  g60c1 g60c2


///////////////////////////   60d  /////////////////////////////////

twoway (hist p60c if anio3=="2019" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1, discrete color(pink%30) xlabel(1 2) gap(0) width(0.5)) ///
(hist p60c if anio3=="2019" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)xlabel(1 2) gap(0) width(0.5)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿El descontento es por""horarios inconvenientes?(2019)") subtitle("1= Si  2= No", size(small)) note("{bf:Fuente}: ENEMDU 2019") name(g60c1,replace)

twoway (hist p60c if anio3=="2021" & edad_trabajo==1 & p02==2 & ingrl<2000 & dmq==1, discrete color(pink%30) xlabel(1 2) gap(0) width(0.5)) ///
(hist p60c if anio3=="2021" & edad_trabajo==1 & p02==1 & ingrl<2000 & dmq==1, discrete color(blue%30)xlabel(1 2) gap(0) width(0.5)), /// 
legend (order(1 "Mujer" 2 "Hombre"))  title("¿El descontento es por" "horarios inconvenientes?(2021)") subtitle("1= Si  2= No", size(small)) note("{bf:Fuente}: ENEMDU 2021") name(g60c2,replace)

graph combine  g60c1 g60c2


************************CREACION DE QUINTILTES*****************

replace ingrl =. if ingrl==999999

xtile quintil_x = ingrl [pw=fexp] if condact==1, nq(5)


xtile quintil_19 = ingrl [pw=fexp] if condact==1 & anio3=="2019", nq(5)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_19==1, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_19==2, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_19==3, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_19==4, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_19==5, over(p02)



xtile quintil_21 = ingrl [pw=fexp] if condact==1 & anio3=="2021", nq(5)

svy: mean ingrl if anio3=="2021" & edad_trabajo==1 & quintil_21==1, over(p02)

svy: mean ingrl if anio3=="2021" & edad_trabajo==1 & quintil_21==2, over(p02)

svy: mean ingrl if anio3=="2021" & edad_trabajo==1 & quintil_21==3, over(p02)

svy: mean ingrl if anio3=="2021" & edad_trabajo==1 & quintil_21==4, over(p02)

svy: mean ingrl if anio3=="2021" & edad_trabajo==1 & quintil_21==5, over(p02)


******************OCUPACION POR CATEGORIA TABLAS************************

*p42: Empleado de gobierno, privado terciarizado, jornalero, peon
*P43: Con nombramiento, contrato permanen,temporal 

*correr antes la creacion de variables
* quintil=2019
*quintil_21=2021

*Ver si si tome [iw=fexp]
tab p42 quintil [iw=fexp] if p02==2 & anio3=="2019"
tab p42 quintil  if p02==2 & anio3=="2019"

tab p42 quintil, by col nofreq


*Sin %
tab p42 quintil_19 [iw=fexp] if mujer==1 & post==0
tab p42 quintil_19 [iw=fexp] if mujer==0 & post==0

*Con %
tab p42 quintil_19 [iw=fexp] if mujer==1 & post==0, col nofreq
tab p42 quintil_19 [iw=fexp] if mujer==0 & post==0, col nofreq

*Sin %
tab p42 quintil_21 [iw=fexp] if mujer==1 & post==1
tab p42 quintil_21[iw=fexp] if mujer==0 & post==1

*Con %
tab p42 quintil_21 [iw=fexp] if mujer==1 & post==1, col nofreq
tab p42 quintil_21[iw=fexp] if mujer==0 & post==1, col nofreq





***********************CREACION DE VARIABLES************************

*LOGARITMO DEL INGRESO 
gen ln_ingrl = ln(ingrl)

*VARIABLE MUJER P02
gen mujer =.
replace mujer=1 if p02==2
replace mujer=0 if p02==1

* VARIABLE AÑO
gen post =.
replace post=1 if anio3=="2021"
replace post=0 if anio3=="2019"
 
 
 
*VARIABLE EDUCACIÓN PREGUNTAR
 

gen byte sumaeduca= 0 if p10a==1
replace sumaeduca=1 if p10a==3
replace sumaeduca=2 if p10a==4 & p10b==1
replace sumaeduca=3 if p10a==4 & p10b==2
replace sumaeduca=4 if p10a==4 & p10b==3
replace sumaeduca=5 if p10a==4 & p10b==4
replace sumaeduca=6 if p10a==4 & p10b==5
replace sumaeduca=7 if p10a==4 & p10b==6
replace sumaeduca=8 if p10a==6 & p10b==1
replace sumaeduca=9 if p10a==6 & p10b==2
replace sumaeduca=10 if p10a==6 & p10b==3
replace sumaeduca=11 if p10a==6 & p10b==4
replace sumaeduca=12 if p10a==6 & p10b==5
replace sumaeduca=13 if p10a==6 & p10b==6
replace sumaeduca=14 if p10a==8 & p10b==1
replace sumaeduca=15 if p10a==8 & p10b==2
replace sumaeduca=16 if p10a==8 & p10b==3
replace sumaeduca=14 if p10a==9 & p10b==1
replace sumaeduca=15 if p10a==9 & p10b==2
replace sumaeduca=16 if p10a==9 & p10b==3
replace sumaeduca=17 if p10a==9 & p10b==4
replace sumaeduca=18 if p10a==9 & p10b==5
replace sumaeduca=19 if p10a==10 & p10b==1
replace sumaeduca=20 if p10a==10 & p10b==2
replace sumaeduca=21 if p10a==10 & p10b==3
replace sumaeduca=22 if p10a==10 & p10b==4
replace sumaeduca=23 if p10a==10 & p10b==5
replace sumaeduca=1 if p10a==5 & p10b==1
replace sumaeduca=2 if p10a==5 & p10b==2
replace sumaeduca=3 if p10a==5 & p10b==3
replace sumaeduca=4 if p10a==5 & p10b==4
replace sumaeduca=5 if p10a==5 & p10b==5
replace sumaeduca=6 if p10a==5 & p10b==6
replace sumaeduca=7 if p10a==5 & p10b==7
replace sumaeduca=8 if p10a==5 & p10b==8
replace sumaeduca=9 if p10a==5 & p10b==9
replace sumaeduca=10 if p10a==5 & p10b==10
replace sumaeduca=11 if p10a==7 & p10b==1
replace sumaeduca=12 if p10a==7 & p10b==2
replace sumaeduca=13 if p10a==7 & p10b==3
replace sumaeduca=1 if p10a==2 & p10b==1
replace sumaeduca=2 if p10a==2 & p10b==2
replace sumaeduca=3 if p10a==2 & p10b==3
replace sumaeduca=4 if p10a==2 & p10b==4
replace sumaeduca=5 if p10a==2 & p10b==5
replace sumaeduca=6 if p10a==2 & p10b==6
replace sumaeduca=7 if p10a==2 & p10b==7
replace sumaeduca=8 if p10a==2 & p10b==8
replace sumaeduca=9 if p10a==2 & p10b==9
replace sumaeduca=10 if p10a==2 & p10b==10
replace sumaeduca=19 if p10a==9 & p10b==6
replace sumaeduca=20 if p10a==9 & p10b==7
replace sumaeduca=21 if p10a==9 & p10b==8
replace sumaeduca=22 if p10a==9 & p10b==9
replace sumaeduca=23 if p10a==9 & p10b==10

rename sumaeduca edu

*VARIABLE EXPERIENCIA P45
gen exp = p45 if p45<=47

*VARIABLE ESTADO CIVIL
gen casado_u=.
replace casado_u=1 if p06==1 | p06==5
replace casado_u=0 if p06==2 | p06==3 | p06==4 | p06==6

*VARIABLE URBANO 
gen urbano=.
replace urbano=1 if area==1
replace urbano=0 if area==2

*VARIABLE MINORÍAS p15
gen minoria=.
replace minoria=1 if p15==1 | p15==2 | p15==3 | p15==4 | p15==5 | p15==8
replace minoria=0 if p15==6 | p15==7

*VARIABLE S_PUBLICO
gen publico=.
replace publico =1 if p42==1 
replace publico =0 if p42==2 | p42==3 | p42==4 | p42==6 | p42==5 | p42==6 | p42==7 | p42==8 | p42==9 | p42==10

*VARIABLE S_PRIMARIO

gen primario =.
replace primario = 1 if rama1==1 | rama1==2
replace primario = 0 if rama1==3 | rama1==4 | rama1==5 | rama1==6 | rama1==7 | rama1==8 | rama1==9| rama1==10 | rama1==11 | rama1==12 | rama1==13| rama1==14 | rama1==15 | rama1==16 | rama1==17 | rama1==18 | rama1==19 | rama1==20 | rama1==21


*VARIABLE S_SECUNDARIO
gen secundario =.
replace secundario = 1 if rama1==3 | rama1==4 | rama1==5 | rama1==6
replace secundario = 0 if rama1==1 | rama1==2| rama1==7 | rama1==8 | rama1==9| rama1==10 | rama1==11 | rama1==12 | rama1==13| rama1==14 | rama1==15 | rama1==16 | rama1==17 | rama1==18 | rama1==19 | rama1==20 | rama1==21


*VARIABLE S_TERCIACIO

gen terciario =.
replace terciario = 1 if rama1==7 | rama1==8 | rama1==9 | rama1==10 | rama1==11 | rama1==12 | rama1==13 | rama1==14 | rama1==15 | rama1==16 | rama1==17 | rama1==18 | rama1==19 | rama1==20 | rama1==21

replace terciario = 0 if rama1==1 | rama1==2 | rama1==3 | rama1==4 | rama1==5 | rama1==6 


*VARIABLE T_EMP p 47a y p47 b

gen t_emp =.
replace t_emp = 1 if p47a==2
replace t_emp = 0 if p47a==1



*VARIABLE ANTIGUEDAD
gen antiguedad=exp^2



*VARIABLE AFILIADO p61.b1
gen afiliado =.
replace afiliado =1 if p61b1==1 | p61b1==2 | p61b1==3 | p61b1==4
replace afiliado =0 if p61b1==6 | p61b1==5

*Empleo
gen emp_ad =.
replace emp_ad=1 if condact ==1
replace emp_ad=0 if condact !=1




*******************************REGRESIONES****************************

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria publico  secundario terciario t_emp antiguedad afiliado if dmq==1 & emp_ad==0, robust


reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==1 | quintil_21==1 & publico==0 & edad_trabajo==1 & emp_ad==0, robust
estimates store R11


reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==1 | quintil_21==1 & publico==0 & edad_trabajo==1 & emp_ad==1, robust
estimates store R1


reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria  secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==2 | quintil_21==2 & publico==0 & edad_trabajo==1 & emp_ad==1, robust
estimates store R2

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1  & quintil_19==3 | quintil_21==3 & publico==0 & edad_trabajo==1 & emp_ad==1 , robust
estimates store R3

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==4 | quintil_21==4 & publico==0 & edad_trabajo==1 & emp_ad==1, robust
estimates store R4

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==5 | quintil_21==5  & publico==0 & edad_trabajo==1 & emp_ad==1, robust
estimates store R5

esttab R1 R2 R3 R4 R5, se(a2) star(* 0.1 ** 0.05 *** 0.01) stats(r2)


tab p45



*************************TABLAS EXPLICACIÓN****************************

*p42: Empleado de gobierno, privado terciarizado, jornalero, peon
*P43: Con nombramiento, contrato permanen,temporal 

tab p42 quintil [iw=fexp] if mujer==1 & anio3=="2019" & emp_ad==1 & dmq==1 & ln_ingrl!=.

tab p42 quintil [iw=fexp] if mujer==0 & anio3=="2019" & emp_ad==1 & dmq==1 & ln_ingrl!=.


tab p43 quintil [iw=fexp] if mujer==1 & anio3=="2019" & emp_ad==1 & dmq==1 & ln_ingrl!=., col nofreq

tab p43 quintil [iw=fexp] if mujer==0 & anio3=="2019" & emp_ad==1 & dmq==1 & ln_ingrl!=., col nofreq


tab p43 quintil_21 [iw=fexp] if mujer==1 & post==1 & emp_ad==1 & dmq==1 & ln_ingrl!=., col nofreq

tab p43 quintil_21 [iw=fexp] if mujer==0 & post==1 & emp_ad==1 & dmq==1 & ln_ingrl!=., col nofreq


////////// mujer 2019-21

tab p43 quintil_19 [iw=fexp] if mujer==1 & anio3=="2019"  & dmq==1 & ln_ingrl!=., col nofreq

tab p43 quintil_21 [iw=fexp] if mujer==1 & post==1  & dmq==1 & ln_ingrl!=., col nofreq

////////hombres 2019-21

tab p43 quintil_19 [iw=fexp] if mujer==0 & anio3=="2019" & dmq==1 & ln_ingrl!=., col nofreq

tab p43 quintil_21 [iw=fexp] if mujer==0 & post==1 & dmq==1 & ln_ingrl!=., col nofreq


////////// mujer 2019-21

tab p42 quintil_19 [iw=fexp] if mujer==1 & anio3=="2019"  & dmq==1 & ln_ingrl!=., col nofreq

tab p42 quintil_21 [iw=fexp] if mujer==1 & post==1  & dmq==1 & ln_ingrl!=., col nofreq

////////hombres 2019-21

tab p42 quintil_19 [iw=fexp] if mujer==0 & anio3=="2019" & dmq==1 & ln_ingrl!=., col nofreq

tab p42 quintil_21 [iw=fexp] if mujer==0 & post==1 & dmq==1 & ln_ingrl!=., col nofreq


**********************EXPLICACION RESULTADOS***************************

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & ingrl<20000, over(p02)

svy: mean ingrl if anio3=="2021" & edad_trabajo==1 & ingrl<20000, over(p02)

pctile quintil=ingrl, nq(5)

*1. caida general en los salarios
*Flexibilidad laboral
*hombres mas pronunciada

*hombres aceptaron salarios mas bajos al igual que las mujeres pero estas salieron mas a trabajar



svy: mean ingrl if quintil_19==3 & dmq==1 & p43==3, over (mujer) coeflegend
lincom _b[c.ingrl@0bn.mujer]-_b[c.ingrl@1.mujer]

svy: mean ingrl if quintil_21==3 & dmq==1 & p43==3, over (mujer) coeflegend
lincom _b[c.ingrl@0bn.mujer]-_b[c.ingrl@1.mujer]

//////// Q3 CONTRATO TEMPORAL
kdensity ingrl if quintil_19==3 & dmq==1 & mujer==1 & p43==3,  ylabel(0(0.002)0.01)  plot (kdensity ingrl if quintil_19==3 & dmq==1 & mujer==0 & p43==3, lcolor(midblue))  legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Trabajo temporal en el Distrito" "Metropolitano de Quito en Q3 - 2019", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g1e, replace) 

kdensity ingrl if quintil_21==3 & dmq==1 & mujer==1 & p43==3, plot (kdensity ingrl if quintil_21==3 & dmq==1 & mujer==0 & p43==3 , lcolor(midblue)) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Trabajo temporal en el Distrito" "Metropolitano de Quito en Q3 - 2021", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g2e, replace)
graph combine  g1e g2e


graph combine  g1e g2e, row(2)


////////Q3 TRABAJO POR NOMBRAMIENTO
kdensity ingrl if quintil_19==3 & dmq==1 & mujer==1 & p43==1,  ylabel(0(0.002)0.01)  plot (kdensity ingrl if quintil_19==3 & dmq==1 & mujer==0 & p43==1, lcolor(midblue))  legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Trabajo por nombramiento en el Distrito" "Metropolitano de Quito en Q3 - 2019", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g3e, replace) 

kdensity ingrl if quintil_21==3 & dmq==1 & mujer==1 & p43==1, ylabel(0(0.002)0.01) plot (kdensity ingrl if quintil_21==3 & dmq==1 & mujer==0 & p43==1 , lcolor(midblue)) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre")) title("Trabajo por nombramiento en el Distrito" "Metropolitano de Quito en Q3 - 2021", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g4e, replace)

graph combine  g3e g4e

, row(2)


//////// Q4 TRABAJO POR NOMBRAMIENTO
kdensity ingrl if quintil_19==4 & dmq==1 & mujer==1 & p43==1, plot (kdensity ingrl if quintil_19==4 & dmq==1 & mujer==0 & p43==1, lcolor(midblue))  legend(ring(0) pos(5) label(1 "Mujer") label(2 "Hombre")) title("Trabajo por nombramiento en el Distrito" "Metropolitano de Quito en Q4 - 2019", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g5e, replace) 

kdensity ingrl if quintil_21==4 & dmq==1 & mujer==1 & p43==1,  plot (kdensity ingrl if quintil_21==4 & dmq==1 & mujer==0 & p43==1 , lcolor(midblue)) legend(ring(0) pos(5) label(1 "Mujer") label(2 "Hombre")) title("Trabajo por nombramiento en el Distrito" "Metropolitano de Quito en Q4 - 2021", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g6e, replace)

graph combine  g5e g6e
, row(2)

//////// Q4 TRABAJO TEMPORAL
kdensity ingrl if quintil_19==4 & dmq==1 & mujer==1 & p43==3, ylabel(0(0.001)0.005) plot (kdensity ingrl if quintil_19==4 & dmq==1 & mujer==0 & p43==3, lcolor(midblue))  legend(ring(0) pos(5) label(1 "Mujer") label(2 "Hombre")) title("Trabajo temporal en el Distrito" "Metropolitano de Quito en Q4 - 2019", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g7e, replace) 

kdensity ingrl if quintil_21==4 & dmq==1 & mujer==1 & p43==3,  plot (kdensity ingrl if quintil_21==4 & dmq==1 & mujer==0 & p43==3, lcolor(midblue)) legend(ring(0) pos(5) label(1 "Mujer") label(2 "Hombre")) title("Trabajo temporal en el Distrito""Metropolitano de Quito en Q4 - 2021", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g8e, replace)

graph combine  g7e g8e


//////// Q4 EMPLEADO DE GOBIERNO
kdensity ingrl if quintil_19==4 & dmq==1 & mujer==1 & p42==1, ylabel(0(0.001)0.005) plot (kdensity ingrl if quintil_19==4 & dmq==1 & mujer==0 & p42==1, lcolor(midblue))  legend(ring(0) pos(5) label(1 "Mujer") label(2 "Hombre")) title("Empleo de gobierno en el Distrito" "Metropolitano de Quito en Q4 - 2019", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g9e, replace) 

kdensity ingrl if quintil_21==4 & dmq==1 & mujer==1 & p42==1,  plot (kdensity ingrl if quintil_21==4 & dmq==1 & mujer==0 & p42==1, lcolor(midblue)) legend(ring(0) pos(5) label(1 "Mujer") label(2 "Hombre")) title("Empleo de gobierno el Distrito""Metropolitano de Quito en Q4 - 2021", size(medium) color(black))  lcolor(pink)  xtitle(Ingreso laboral) ytitle(Densidad) note("") name(g10e, replace)

graph combine  g9e g10e














//////////////////////////////////////////////////////////////////////////

kdensity ingrl if quintil_19==4 & dmq==1 & mujer==1 & p43==1, plot (kdensity ingrl if quintil_19==4 & dmq==1 & mujer==0 & p43==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre"))

kdensity ingrl if quintil_21==4 & dmq==1 & mujer==1 & p43==1, plot (kdensity ingrl if quintil_21==4 & dmq==1 & mujer==0 & p43==1) legend(ring(0) pos(2) label(1 "Mujer") label(2 "Hombre"))

























sum ln_ingrl mujer post
sum edu exp 
sum casado_u urbano minoria dmq
sum publico primario secundario terciario 
sum t_emp antiguedad afiliado

















xtile quintil_vf = ingrl [pw=fexp] if condact==1, nq(4)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_vf==1, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_vf==2, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_vf==3, over(p02)

svy: mean ingrl if anio3=="2019" & edad_trabajo==1 & quintil_vf==4, over(p02)




*mean 
svy: mean ingpc

gen ciud1 = ciudad
tostring ciud1, replace
gen ciud2 = substr(ciud1,1,4)


*******************************REGRESIONES****************************


reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==1 | quintil_21==1 , robust
estimates store Ra


reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria  secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==2 | quintil_21==2  , robust
estimates store Rb

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1  & quintil_19==3 | quintil_21==3 , robust
estimates store Rc

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==4 | quintil_21==4 , robust
estimates store Rd

reg ln_ingrl i.mujer##i.post edu exp casado urbano minoria   secundario terciario t_emp antiguedad afiliado  [iw=fexp] if dmq==1 & quintil_19==5 | quintil_21==5  , robust
estimates store Re

esttab Ra Rb Rc Rd Re, se(a2) star(* 0.1 ** 0.05 *** 0.01)


tab p45



