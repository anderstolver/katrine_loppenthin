---
title: "Kathrine Bjerre Løppenthin - søvnprojekt"
author: "Anders Tolver"
date: "14 Jun 2018"
output: 
  html_document:
    keep_md: TRUE
---



Denne fil giver overblik over arbejdet med Kathrine Bjerre Løppenthins søvnprojekt.

* [Log-fil over hele projektet](Log.md) : indeholder (egne) mødereferater samt timeregnskab 

* [Read in and tidy up data](R/import_data.md): indlæser og renser data - gemmer pæne datasæt der benyttes ved statistiske analyser



# Analyseresultater (numeriske variable)

* PSG
    + Total søvntid (i timer): [TST](R/TST_num.html)
    + Søvneffektivitet (i %): [sleep_effi](R/sleep_effi.html)
    + Sleep-onset (i timer): [SO](R/SO_num.html)
    + Søvnlatenstid (i timer): [sleep_latency](R/sleep_latency_num.html)
    + REMlatenstid (i timer): [REM_latency](R/REM_latency_num.html)
    + Antal opvågninger: [WASO](R/WASO.html)
    + Antal arousals: [Arous](R/Arous.html)
    + Wake after sleep-onset (i timer): [wake_time](R/wake_time_num.html)
    + Stadie 1 søvn (i %): [N1](R/N1.html)
    + Stadie 2 søvn (i %): [N2](R/N2.html)
    + Stadie 3 søvn (i %): [N3](R/N3.html)

* 2. PSQI
    + Sleep quality: [psqi1](R/psqi1.html)
    + Sleep latency: [psqi2](R/psqi2.html)
    + Sleep duration: [psqi3](R/psqi3.html)
    + Sleep efficiency: [psqi4](R/psqi4.html)
    + Sleep disturbances: [psqi5](R/psqi5.html)
    + Using sleep medication: [psqi6](R/psqi6.html)
    + Daytime dysfunction: [psqi7](R/psqi7.html)
    + Global PSQI: [psqi_total](R/psqi_total.html)
* 3. ESS
    + Epworth sleepiness scale: [ess_total](R/ess_total.html)

# Analyseresultater (kategoriske/ordinale variable)

* PSG
    + Tabeller
    
# Om arbejdsprocessen (henvendt til Anders)

Denne fil (`readme.rmd`) opdateres med links til dokumenter, der indeholder output fra statistiske analyser.

Vær særlig opmærksom på at *committe* ændringer i følgende filer

* `readme.rmd`, `readme.md`
* `read_data.rmd`, `read_data.rmd`
*  væsentlige ændringer i dokumenter der indeholder analyseresultater
* 
