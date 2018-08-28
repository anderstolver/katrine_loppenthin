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
    + Total søvntid (i timer): [TST](R/TST_num.md)
    + Søvneffektivitet (i %): [sleep_effi](R/sleep_effi.md)
    + Sleep-onset (i timer): [SO](R/SO_num.md)
    + Søvnlatenstid (i timer): [sleep_latency](R/sleep_latency_num.md)
    + REMlatenstid (i timer): [REM_latency](R/REM_latency_num.md)
    + Antal opvågninger: [WASO](R/WASO.md)
    + Antal arousals: [Arous](R/Arous.md)
    + Wake after sleep-onset (i timer): [wake_time](R/wake_time_num.md)
    + Stadie 1 søvn (i %): [N1](R/N1.md)
    + Stadie 2 søvn (i %): [N2](R/N2.md)
    + Stadie 3 søvn (i %): [N3](R/N3.md)

* 2. PSQI
    + Sleep quality: [psqi1](R/psqi1.md)
    + Sleep latency: [psqi2](R/psqi2.md)
    + Sleep duration: [psqi3](R/psqi3.md)
    + Sleep efficiency: [psqi4](R/psqi4.md)
    + Sleep disturbances: [psqi5](R/psqi5.md)
    + Using sleep medication: [psqi6](R/psqi6.md)
    + Daytime dysfunction: [psqi7](R/psqi7.md)
    + Global PSQI: [psqi_total](R/psqi_total.md)
* 3. ESS
    + Epworth sleepiness scale: [ess_total](R/ess_total.md)

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
