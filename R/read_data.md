# Read data and tidy up data
Anders Tolver  
21 Mar 2018  



# Read in data

Kathrine Bjerre Løppenthin provided the following data files for the project


```r
list.files(path = "../data")
```

```
## [1] "Anamnese_baseline_followup.xls"       
## [2] "Baseline data.xls"                    
## [3] "Follow-up data.xls"                   
## [4] "Intervention og kontrol.xlsx"         
## [5] "Kopi af Indtast s\303\270vndagbog.xls"
## [6] "Variabeloversigt JR-Sleep.doc"        
## [7] "watt-max test_baseline_follow-up.xls"
```

## Randomisation list


```r
data_rand_list <- read_excel(path  = "../data/Intervention og kontrol.xlsx"
                   , sheet = 1)
```

## Baseline data

Excel file containing 9 sheets. 

First (=anamnese) and last (=Søvndagbog) sheets are  empty?

Use instead files `Anamnese_baseline_followup.xls` and `Kopi af Indtast søvndagbog.xls`.


```r
data_base_anamnese <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 1)
data_base_psqi <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 2)
data_base_ess <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 3)
data_base_bristol <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 4)
data_base_fys_akt <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 5)
data_base_dep <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 6)
data_base_fys_funk <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 7)
data_base_eq_5d <- read_excel(path  = "../data/Baseline data.xls", skip = 1
                   , sheet = 8)
```

## Follow up


```r
data_follow_psqi <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 1)
data_follow_ess <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 2)
data_follow_bristol <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 3)
data_follow_fys_akt <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 4)
data_follow_dep <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 5)
data_follow_fys_funk <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 6)
data_follow_eq5d <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 7)
```

## Anamnese (Baseline + follow up)

## S-dagbog (Baseline + follow up)
