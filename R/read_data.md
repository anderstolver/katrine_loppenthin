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

Note that `.` and blanks have been used to indicate  missing values ...


```r
data_follow_psqi <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 1)
data_follow_ess <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 2)
data_follow_bristol <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 3)
data_follow_fys_akt <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 4)
data_follow_dep <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 5)
data_follow_fys_funk <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 6)
data_follow_eq_5d <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 7)
```

Remove columns 21+22 for `data_follow_psqi`.


```r
data_follow_psqi <- data_follow_psqi[, -c(21, 22)]
```

## 1. Anamnese (Baseline + follow up)


```r
data_base_anamnese <- read_excel(path  = "../data/Anamnese_baseline_followup.xls", sheet = 1)
data_follow_anamnese <- read_excel(path  = "../data/Anamnese_baseline_followup.xls", sheet = 2)
```

Renaming variables according to key provided by Kathrine (see file `Variabeloversigt`).


```r
data_base_anamnese <- plyr::rename(data_base_anamnese
             , replace = c("age" = "Age", "tend_joi" = "Tend_joi"
                           , "job" = "Job", "smoking" = "Smoking") )
data_follow_anamnese <- plyr::rename(data_follow_anamnese
             , replace = c("tend_joi" = "Tend_joi"
                           , "Koffein" = "koffein") )
names(data_base_anamnese)
```

```
##  [1] "Baseline"     "ID-NR"        "Sex"          "Age"         
##  [5] "Swol_joi"     "Tend_joi"     "DAS"          "HGB"         
##  [9] "CRP"          "Disease_dura" "Comobid"      "Educa"       
## [13] "Job"          "Live_alone"   "Smoking"      "alcohol"     
## [17] "koffein"
```

```r
names(data_follow_anamnese)
```

```
## [1] "Follow-up" "ID-nr"     "Swol_joi"  "Tend_joi"  "DAS"       "HGB"      
## [7] "CRP"       "koffein"
```


## S-dagbog (Baseline + follow up)

# Construction of new variables

## 2. PSQI

Consult `scoringsmanual til PSQI.pdf`

### Check for invalid data entries and correct errors


```r
apply(data_base_psqi[, -1], 2, unique)
```

```
## $SP2_Spg_1_BA
##  [1] "23.30" "23.00" "24.00" "23.45" "22.30" "22.00" "21.30" "23.15"
##  [9] "01.00" "02.00" "01.30" "22.15" "21.00"
## 
## $SP2_Spg_2_BA
##  [1] "30"   "12.5" "45"   "75"   NA     "22.5" "6.5"  "5"    "20"   "25"  
## [11] "60"   "10"   "15"   "35"   "12"   "40"  
## 
## $SP2_Spg_3_BA
##  [1] "07.00" "08.30" "07.45" "07.30" "06.15" "09.00" "06.30" "08.00"
##  [9] "06.55" "06.00" "07.15" "05.30" "09.30" "06.10" "5.30"  "6.30" 
## [17] "7.00" 
## 
## $SP2_Spg_4_BA
##  [1] "7"     "6"     "5.5"   NA      "6.5"   "5"     "7.5"   "4.5"  
##  [9] "2"     "3.5"   "07.00"
## 
## $SP2_Spg_5A_BA
## [1] " 1" " 2" NA   " 0" " 3"
## 
## $SP2_Spg_5B_BA
## [1] "3" "2" "1"
## 
## $SP2_Spg_5C_BA
## [1] "3" "2" "1" "0"
## 
## $SP2_Spg_5D_BA
## [1] "0" "1" "3" "2"
## 
## $SP2_Spg_5E_BA
## [1] "2" "0" "1" "3"
## 
## $SP2_Spg_5F_BA
## [1] "0" "1" "2"
## 
## $SP2_Spg_5G_BA
## [1] "3" "1" "2" "0"
## 
## $SP2_Spg_5H_BA
## [1] "0" "1" "3"
## 
## $SP2_Spg_5I_BA
## [1] "1" "2" "0" "3"
## 
## $SP2_Spg_5J_svar_BA
## [1] " 1" NA   " 2" " 0" " 3"
## 
## $SP2_Spg_5J_BA
## [1] "0" "1" "2" "3"
## 
## $SP2_Spg_6_BA
## [1] "1" "0" "2" "3"
## 
## $SP2_Spg_7_BA
## [1] "0" "1" "2" "3"
## 
## $SP2_Spg_8_BA
## [1] "0" "1" "2" "3"
## 
## $SP2_Spg_9_BA
## [1] "1" "3" "2" "0"
```


```r
apply(data_follow_psqi[, -1], 2, unique)
```

```
## $SP2_Spg_1_FU
##  [1] "23.00"  "22.30"  "22.45"  "00.15"  "23.30"  "22.00"  "21.30" 
##  [8] NA       "00.00"  "01.00"  "0.875"  "0.9375" "23"    
## 
## $SP2_Spg_2_FU
##  [1] "5"    "10"   "30"   "17.5" "7.5"  "2"    "15"   "35"   "40"   NA    
## [11] "105"  "20"   "50"   "12.5" "45"  
## 
## $SP2_Spg_3_FU
##  [1] "07.00" "08.00" "06.30" "07.15" "06.15" "06.20" "7"     "07.30"
##  [9] "06.45" "6"     NA      "08.15" "05.50" "05.00" "06.00" "60.00"
## [17] "6.15"  "6.30"  "8.30" 
## 
## $SP2_Spg_4_FU
##  [1] "7"   "8"   "6"   "9"   "6.5" "5"   "5.5" NA    "3"   "7.5" "3.5"
## 
## $SP2_Spg_5A_FU
## [1] " 1" " 2" " 0" " 3" NA  
## 
## $SP2_Spg_5B_FU
## [1] " 1" " 2" " 3" NA   " 0"
## 
## $SP2_Spg_5C_FU
## [1] " 1" " 2" " 3" NA   " 0"
## 
## $SP2_Spg_5D_FU
## [1] " 2" " 0" " 1" " 3" NA  
## 
## $SP2_Spg_5E_FU
## [1] " 1" " 0" " 2" " 3" NA  
## 
## $SP2_Spg_5F_FU
## [1] " 2" " 0" " 1" NA  
## 
## $SP2_Spg_5G_FU
## [1] " 1" " 3" " 2" " 0" NA  
## 
## $SP2_Spg_5H_FU
## [1] " 1" " 0" " 2" NA  
## 
## $SP2_Spg_5I_FU
## [1] " 1" " 2" " 3" " 0" NA  
## 
## $SP2_Spg_5J_svar_FU
## [1] " 1" NA   " 3" " 2" " 0"
## 
## $SP2_Spg_5J_FU
## [1] " 1" " 0" " 2" NA   " 3"
## 
## $SP2_Spg_6_FU
## [1] " 0" " 1" " 3" NA  
## 
## $SP2_Spg_7_FU
## [1] " 0" " 1" " 2" NA   " 3"
## 
## $SP2_Spg_8_FU
## [1] " 1" " 0" " 2" NA   " 3"
## 
## $SP2_Spg_9_FU
## [1] " 3" " 2" " 0" " 1" NA
```

#### Question 1

Change 24:00 to 00:00 and correct some obvious errors


```r
data_base_psqi$SP2_Spg_1_BA <- with(data_base_psqi, replace(SP2_Spg_1_BA, SP2_Spg_1_BA == "24.00", "00.00"))
data_base_psqi$SP2_Spg_1_BA
```

```
##  [1] "23.30" "23.00" "00.00" "23.45" "00.00" "23.00" "00.00" "22.30"
##  [9] "22.30" "23.00" "22.30" "22.00" "21.30" "23.00" "23.30" "23.30"
## [17] "23.00" "23.30" "23.15" "01.00" "23.30" "22.30" "23.30" "22.30"
## [25] "00.00" "22.30" "02.00" "22.00" "01.30" "22.00" "22.15" "23.00"
## [33] "01.00" "00.00" "21.00" "22.30" "22.30" "00.00"
```

Grundet inkonsistent brug af `.` eller `:` har der indsneget sig nogle fejl i indlæsning af data som rettes her (se Excel-ark)


```r
data_follow_psqi$SP2_Spg_1_FU <- with(data_follow_psqi, replace(SP2_Spg_1_FU, SP2_Spg_1_FU == "23", "23.00"))
data_follow_psqi$SP2_Spg_1_FU <- with(data_follow_psqi, replace(SP2_Spg_1_FU, SP2_Spg_1_FU == "0.875", "21.00"))
data_follow_psqi$SP2_Spg_1_FU <- with(data_follow_psqi, replace(SP2_Spg_1_FU, SP2_Spg_1_FU == "0.9375", "22.30"))
data_follow_psqi$SP2_Spg_1_FU
```

```
##  [1] "23.00" "23.00" "22.30" "22.45" "00.15" "22.30" "23.30" "22.30"
##  [9] "22.00" "23.30" "22.30" "21.30" "22.00" "22.30" "23.00" "23.30"
## [17] "22.30" "23.30" "23.30" NA      "23.30" "22.30" "00.00" "22.30"
## [25] "23.30" "23.30" "01.00" "23.30" "00.00" "22.00" "22.00" "23.00"
## [33] NA      NA      "21.00" "22.30" "23.00" "23.00"
```

#### Question 3


```r
data_base_psqi$SP2_Spg_3_BA <- with(data_base_psqi, replace(SP2_Spg_3_BA, SP2_Spg_3_BA =="5.30", "05.30"))
data_base_psqi$SP2_Spg_3_BA <- with(data_base_psqi, replace(SP2_Spg_3_BA, SP2_Spg_3_BA =="6.30", "06.30"))
data_base_psqi$SP2_Spg_3_BA <- with(data_base_psqi, replace(SP2_Spg_3_BA, SP2_Spg_3_BA =="7.00", "07.00"))
data_base_psqi$SP2_Spg_3_BA
```

```
##  [1] "07.00" "08.30" "07.00" "07.45" "07.30" "06.15" "06.15" "07.00"
##  [9] "06.15" "07.30" "07.00" "09.00" "06.30" "06.30" "08.00" "06.55"
## [17] "06.00" "07.30" "07.15" "08.00" "08.00" "06.30" "07.30" "07.30"
## [25] "07.00" "07.15" "05.30" "06.15" "09.30" "06.00" "06.10" "07.00"
## [33] "07.00" "08.00" "05.30" "06.30" "07.00" "06.30"
```


```r
data_follow_psqi$SP2_Spg_3_FU <- with(data_follow_psqi, replace(SP2_Spg_3_FU, SP2_Spg_3_FU =="7", "07.00"))
data_follow_psqi$SP2_Spg_3_FU <- with(data_follow_psqi, replace(SP2_Spg_3_FU, SP2_Spg_3_FU =="6.15", "06.15"))
data_follow_psqi$SP2_Spg_3_FU <- with(data_follow_psqi, replace(SP2_Spg_3_FU, SP2_Spg_3_FU =="6.30", "06.30"))
data_follow_psqi$SP2_Spg_3_FU <- with(data_follow_psqi, replace(SP2_Spg_3_FU, SP2_Spg_3_FU =="8.30", "08.30"))
data_follow_psqi$SP2_Spg_3_FU <- with(data_follow_psqi, replace(SP2_Spg_3_FU, SP2_Spg_3_FU =="60.00", "06.00"))
data_follow_psqi$SP2_Spg_3_FU <- with(data_follow_psqi, replace(SP2_Spg_3_FU, SP2_Spg_3_FU =="6", "06.00"))

data_follow_psqi$SP2_Spg_3_FU
```

```
##  [1] "07.00" "08.00" "06.30" "07.00" "07.15" "06.15" "06.30" "07.00"
##  [9] "06.20" "07.00" "07.00" "07.00" "06.20" "07.00" "07.30" "06.45"
## [17] "06.00" "07.30" "07.15" NA      "08.15" "06.30" "07.00" "07.30"
## [25] "05.50" "08.00" "05.00" "06.30" "08.00" "06.00" "06.00" "06.00"
## [33] NA      NA      "05.50" "06.15" "06.30" "08.30"
```

#### Question 4


```r
data_base_psqi$SP2_Spg_4_BA <- with(data_base_psqi, replace(SP2_Spg_4_BA, SP2_Spg_4_BA =="07.00", "7"))
```

#### Change time format of questions 1,3


```r
data_base_psqi <- mutate(data_base_psqi, SP2_Spg_1_time_BA = parse_time(gsub("\\.", ":", SP2_Spg_1_BA), format = "%H:%M"), SP2_Spg_3_time_BA = parse_time(gsub("\\.", ":", SP2_Spg_3_BA), format = "%H:%M"), psqi4_in_bed = SP2_Spg_3_time_BA - SP2_Spg_1_time_BA )
```

```
## Warning: package 'bindrcpp' was built under R version 3.3.2
```

```r
data_base_psqi$psqi4_in_bed
```

```
## Time differences in secs
##  [1] -59400 -52200  25200 -57600  27000 -60300  22500 -55800 -58500 -55800
## [11] -55800 -46800 -54000 -59400 -55800 -59700 -61200 -57600 -57600  25200
## [21] -55800 -57600 -57600 -54000  25200 -54900  12600 -56700  28800 -57600
## [31] -57900 -57600  21600  28800 -55800 -57600 -55800  23400
```


```r
data_follow_psqi <- mutate(data_follow_psqi, SP2_Spg_1_time_FU = parse_time(gsub("\\.", ":", SP2_Spg_1_FU), format = "%H:%M"), SP2_Spg_3_time_FU = parse_time(gsub("\\.", ":", SP2_Spg_3_FU), format = "%H:%M"), psqi4_in_bed = SP2_Spg_3_time_FU - SP2_Spg_1_time_FU )
data_follow_psqi$psqi4_in_bed
```

```
## Time differences in secs
##  [1] -57600 -54000 -57600 -56700  25200 -58500 -61200 -55800 -56400 -59400
## [11] -55800 -52200 -56400 -55800 -55800 -60300 -59400 -57600 -58500     NA
## [21] -54900 -57600  25200 -54000 -63600 -55800  14400 -61200  28800 -57600
## [31] -57600 -61200     NA     NA -54600 -58500 -59400 -52200
```

## PSQI - component scores (Baseline)

### Component 1: Subjective sleep quality


```r
data_base_psqi <- mutate(data_base_psqi, psqi1 = SP2_Spg_6_BA)
```

### Component 2: Sleep latency

Check carefully conversion to numerical score ....


```r
data_base_psqi$SP2_Spg_2_BA_num <- cut(as.numeric(data_base_psqi$SP2_Spg_2_BA), breaks = c(0, 15, 30, 60, Inf)
    , labels = c(0, 1, 2, 3))
data_base_psqi <- mutate(data_base_psqi, psqi2_tmp = parse_integer(SP2_Spg_2_BA_num) + SP2_Spg_5A_BA)
data_base_psqi <- mutate(data_base_psqi, psqi2 = parse_integer(cut(psqi2_tmp, breaks = c(0, 2, 4, 6, Inf), labels = c(0, 1, 2, 3))))
with(data_base_psqi, table(psqi2, psqi2_tmp))
```

```
##      psqi2_tmp
## psqi2  0  1  2  3  4  5  6
##     0  0  2 10  0  0  0  0
##     1  0  0  0  1 10  0  0
##     2  0  0  0  0  0  7  1
```

### Component 3: Sleep duration

Check carefully conversion to numerical score ....


```r
data_base_psqi <- mutate(data_base_psqi, psqi3 = parse_integer(cut(parse_double(data_base_psqi$SP2_Spg_4_BA), breaks = c(-Inf, 5, 6, 7, Inf)
    , labels = c(3, 2, 1, 0))))
table(data_base_psqi$psqi3, data_base_psqi$SP2_Spg_4_BA )
```

```
##    
##      2 3.5 4.5  5 5.5  6 6.5  7 7.5
##   0  0   0   0  0   0  0   0  0   4
##   1  0   0   0  0   0  0   3  4   0
##   2  0   0   0  0   3 15   0  0   0
##   3  1   1   1  5   0  0   0  0   0
```

### Component 4: Habitual sleep efficiency

Be very careful with conversion to time differences (bedtime after midnat causes some problems) ...


```r
data_base_psqi <- mutate(data_base_psqi, psqi4_in_bed = 3600*24*(psqi4_in_bed < 0) + psqi4_in_bed
       , psqi4_sleep_eff = 100 * 3600 * parse_double(SP2_Spg_4_BA) / parse_double(psqi4_in_bed)
       , psqi4 = parse_integer(cut(psqi4_sleep_eff, breaks = c(0, 65, 75, 85, Inf), right = FALSE, labels = c(3, 2, 1, 0))))

summary(data_base_psqi$psqi4_sleep_eff)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   22.22   69.47   80.90   76.36   85.71  100.00       1
```


### Component 5: Sleep disturbances

Check carefully conversion ...


```r
choose_vars <- paste("SP2_Spg_5", LETTERS[2:10], "_BA", sep = "")
choose_vars
```

```
## [1] "SP2_Spg_5B_BA" "SP2_Spg_5C_BA" "SP2_Spg_5D_BA" "SP2_Spg_5E_BA"
## [5] "SP2_Spg_5F_BA" "SP2_Spg_5G_BA" "SP2_Spg_5H_BA" "SP2_Spg_5I_BA"
## [9] "SP2_Spg_5J_BA"
```

```r
data_base_psqi$psqi5_tmp <- apply(select(data_base_psqi, choose_vars), 1, sum)
data_base_psqi <- mutate(data_base_psqi, psqi5 = parse_integer(cut(psqi5_tmp, breaks = c(-Inf, 0, 9, 18, 27, Inf)
                                                     , labels = c(-1, 0, 1, 2, 3))))
table(data_base_psqi$psqi5_tmp, data_base_psqi$psqi5)
```

```
##     
##      0 1 2
##   2  1 0 0
##   3  1 0 0
##   4  1 0 0
##   5  2 0 0
##   6  2 0 0
##   7  1 0 0
##   8  2 0 0
##   9  2 0 0
##   10 0 2 0
##   11 0 7 0
##   12 0 3 0
##   13 0 3 0
##   15 0 1 0
##   16 0 4 0
##   17 0 1 0
##   18 0 2 0
##   19 0 0 2
##   20 0 0 1
```

### Component 6: Use of sleeping medication


```r
data_base_psqi <- mutate(data_base_psqi, psqi6 = data_base_psqi$SP2_Spg_7_BA)
```

### Component 7: Daytime dysfunction


```r
data_base_psqi <- mutate(data_base_psqi, psqi7_tmp = SP2_Spg_8_BA + SP2_Spg_9_BA
       , psqi7 = parse_integer(cut(psqi7_tmp, breaks = c(-Inf, 0, 2, 4, 6, Inf), labels = 0:4)))
with(data_base_psqi, table(psqi7, psqi7_tmp))
```

```
##      psqi7_tmp
## psqi7  0  1  2  3  4  5  6
##     0  2  0  0  0  0  0  0
##     1  0  7  7  0  0  0  0
##     2  0  0  0  5  6  0  0
##     3  0  0  0  0  0 10  1
```

### Global PSQI


```r
data_base_psqi$psqi_total <- apply(select(data_base_psqi, num_range(prefix = "psqi", range = 1:7)), 1, sum)
```

## PSQI - component scores (Follow up)

### Component 1: Subjective sleep quality


```r
data_follow_psqi <- mutate(data_follow_psqi, psqi1 = SP2_Spg_6_FU)
```

### Component 2: Sleep latency

Check carefully conversion to numerical score ....


```r
data_follow_psqi$SP2_Spg_2_FU_num <- parse_integer(cut(as.numeric(data_follow_psqi$SP2_Spg_2_FU), breaks = c( 0, 15, 30, 60, Inf)
    , labels = c(0, 1, 2, 3)))
data_follow_psqi <- mutate(data_follow_psqi, psqi2_tmp = SP2_Spg_2_FU_num + SP2_Spg_5A_FU)
data_follow_psqi <- mutate(data_follow_psqi, psqi2 = parse_integer(cut(psqi2_tmp, breaks = c(-Inf, 0, 2, 4, 6)
                                                         , labels = 0:3)))
data_follow_psqi$psqi2_tmp
```

```
##  [1]  1  1  3  2  3  2  1  1  1  3  5  4  1  1  5  2  3  0  0 NA  4  2  3
## [24] NA  1  2  5  0  2  1  5  0 NA NA  1  3  3  0
```

```r
data_follow_psqi$psqi2
```

```
##  [1]  1  1  2  1  2  1  1  1  1  2  3  2  1  1  3  1  2  0  0 NA  2  1  2
## [24] NA  1  1  3  0  1  1  3  0 NA NA  1  2  2  0
```

```r
with(data_follow_psqi, table(psqi2, psqi2_tmp))
```

```
##      psqi2_tmp
## psqi2  0  1  2  3  4  5
##     0  5  0  0  0  0  0
##     1  0 10  6  0  0  0
##     2  0  0  0  7  2  0
##     3  0  0  0  0  0  4
```

### Component 3: Sleep duration

Check carefully conversion to numerical score ....


```r
data_follow_psqi <- mutate(data_follow_psqi, psqi3 = parse_integer(cut(parse_double(data_follow_psqi$SP2_Spg_4_FU), breaks = c(-Inf, 5, 6, 7, Inf)
    , labels = c(3, 2, 1, 0))))
table(data_follow_psqi$psqi3, data_follow_psqi$SP2_Spg_4_FU )
```

```
##    
##      3 3.5  5 5.5  6 6.5  7 7.5  8  9
##   0  0   0  0   0  0   0  0   1  3  1
##   1  0   0  0   0  0   3  7   0  0  0
##   2  0   0  0   2 13   0  0   0  0  0
##   3  1   1  3   0  0   0  0   0  0  0
```

### Component 4: Habitual sleep efficiency

Be very careful with conversion to time differences (bedtime after midnat causes some problems) ...


```r
data_follow_psqi <- mutate(data_follow_psqi, psqi4_in_bed = 3600*24*(psqi4_in_bed < 0) + psqi4_in_bed
       , psqi4_sleep_eff = 100 * 3600 * parse_double(SP2_Spg_4_FU) / parse_double(psqi4_in_bed)
       , psqi4 = parse_integer(cut(psqi4_sleep_eff, breaks = c(0, 65, 75, 85, Inf), right = FALSE, labels = c(3, 2, 1, 0))))
summary(data_follow_psqi$psqi4_sleep_eff)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   39.62   75.00   80.00   79.65   85.71  105.90       3
```

NB: One subject `08-240713` sleeps more hours than he or she stays in bed resulting in sleep efficiency above 100.

### Component 5: Sleep disturbances

Check carefully conversion ...


```r
choose_vars <- paste("SP2_Spg_5", LETTERS[2:10], "_FU", sep = "")
choose_vars
```

```
## [1] "SP2_Spg_5B_FU" "SP2_Spg_5C_FU" "SP2_Spg_5D_FU" "SP2_Spg_5E_FU"
## [5] "SP2_Spg_5F_FU" "SP2_Spg_5G_FU" "SP2_Spg_5H_FU" "SP2_Spg_5I_FU"
## [9] "SP2_Spg_5J_FU"
```

```r
data_follow_psqi$psqi5_tmp <- apply(select(data_follow_psqi, choose_vars), 1, sum)
data_follow_psqi <- mutate(data_follow_psqi, psqi5 = parse_integer(cut(psqi5_tmp, breaks = c(-Inf, 0, 9, 18, 27, Inf)
                                                     , labels = c(-1, 0, 1, 2, 3))))
table(data_follow_psqi$psqi5_tmp, data_follow_psqi$psqi5)
```

```
##     
##      0 1 2
##   3  2 0 0
##   4  2 0 0
##   5  2 0 0
##   6  1 0 0
##   7  4 0 0
##   9  2 0 0
##   10 0 3 0
##   11 0 3 0
##   12 0 2 0
##   13 0 5 0
##   15 0 4 0
##   17 0 2 0
##   18 0 1 0
##   19 0 0 1
```

### Component 6: Use of sleeping medication


```r
data_follow_psqi <- mutate(data_follow_psqi, psqi6 = data_follow_psqi$SP2_Spg_7_FU)
```

### Component 7: Daytime dysfunction


```r
data_follow_psqi <- mutate(data_follow_psqi, psqi7_tmp = SP2_Spg_8_FU + SP2_Spg_9_FU
       , psqi7 = parse_integer(cut(psqi7_tmp, breaks = c(-Inf, 0, 2, 4, 6, Inf), labels = 0:4)))
with(data_follow_psqi, table(psqi7, psqi7_tmp))
```

```
##      psqi7_tmp
## psqi7 0 1 2 3 4 5
##     0 5 0 0 0 0 0
##     1 0 5 8 0 0 0
##     2 0 0 0 2 6 0
##     3 0 0 0 0 0 9
```

### Global PSQI


```r
data_follow_psqi$psqi_total <- apply(select(data_follow_psqi, num_range(prefix = "psqi", range = 1:7)), 1, sum)
```

### Overview of component scores from PSQI



```r
select(data_follow_psqi, num_range("psqi", 1:7) )
```

```
## # A tibble: 38 x 7
##    psqi1 psqi2 psqi3 psqi4 psqi5 psqi6 psqi7
##    <dbl> <int> <int> <int> <int> <dbl> <int>
##  1     0     1     1     0     1     0     2
##  2     1     1     0     0     0     0     2
##  3     3     2     2     1     1     0     1
##  4     0     1     2     2     1     0     1
##  5     0     2     2     0     1     1     3
##  6     1     1     1     0     0     0     2
##  7     1     1     2     0     1     1     3
##  8     1     1     0     0     1     0     2
##  9     0     1     1     1     0     0     1
## 10     0     2     2     1     2     0     1
## # ... with 28 more rows
```

**How to handle missing answers?**

## 3. Epworth Sleepiness Scale (ESS)

### Check raw data values (baseline + follow up)

All items with take data values 0-3


```r
apply(data_base_ess[, -1], 2, table)
```

```
## $SP3_Spg_1_BA
## 
##  0  1  2  3 
##  9 10 12  7 
## 
## $SP3_Spg_2_BA
## 
##  0  1  2  3 
##  4  9 15 10 
## 
## $SP3_Spg_3_BA
## 
##  0  1  2  3 
## 16 16  5  1 
## 
## $SP3_Spg_4_BA
## 
##  0  1  2  3 
## 12 12  8  6 
## 
## $SP3_Spg_5_BA
## 
##  0  1  2  3 
##  3  3 13 19 
## 
## $SP3_Spg_6_BA
## 
##  0  1  2 
## 31  5  2 
## 
## $SP3_Spg_7_BA
## 
##  0  1  2  3 
## 14 16  7  1 
## 
## $SP3_Spg_8_BA
## 
##  0  1 
## 29  9
```

```r
apply(data_follow_ess[, -1], 2, table)
```

```
## $SP3_Spg_1_FU
## 
##  0  1  2  3 
##  6 13  9  7 
## 
## $SP3_Spg_2_FU
## 
##  0  1  2  3 
##  6  8 13  8 
## 
## $SP3_Spg_3_FU
## 
##  0  1  2 
## 17 15  2 
## 
## $SP3_Spg_4_FU
## 
##  0  1  2  3 
## 13  8  9  5 
## 
## $SP3_Spg_5_FU
## 
##  0  1  2  3 
##  3  3 14 14 
## 
## $SP3_Spg_6_FU
## 
##  0  1  2 
## 27  7  1 
## 
## $SP3_Spg_7_FU
## 
##  0  1  2  3 
## 19  7  4  5 
## 
## $SP3_Spg_8_FU
## 
##  0  1  2 
## 27  7  1
```

Count number of missing values 


```r
apply(data_base_ess[, 1 + 1:8], 2, function(z){sum(is.na(z))})
```

```
## SP3_Spg_1_BA SP3_Spg_2_BA SP3_Spg_3_BA SP3_Spg_4_BA SP3_Spg_5_BA 
##            0            0            0            0            0 
## SP3_Spg_6_BA SP3_Spg_7_BA SP3_Spg_8_BA 
##            0            0            0
```

```r
apply(data_follow_ess[, 1 + 1:8], 2, function(z){sum(is.na(z))})
```

```
## SP3_Spg_1_FU SP3_Spg_2_FU SP3_Spg_3_FU SP3_Spg_4_FU SP3_Spg_5_FU 
##            3            3            4            3            4 
## SP3_Spg_6_FU SP3_Spg_7_FU SP3_Spg_8_FU 
##            3            3            3
```

### Compute ESS sum score


```r
data_base_ess$total <- apply(data_base_ess[, 1 + 1:8], 1, sum)
data_follow_ess$total <- apply(data_follow_ess[, 1 + 1:8], 1, sum)

summary(data_base_ess$total)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   6.000   8.000   8.842  11.750  19.000
```

```r
summary(data_follow_ess$total)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   1.000   5.000   7.000   8.212  11.000  18.000       5
```


## 4. Bristol (BRAF)

### Check  raw data values (baseline)

Range of `SP4_Spg_1_BA` should be 0-10


```r
table(data_base_bristol[, 1 + 1])
```

```
## 
## 0 1 2 3 4 5 6 7 8 9 
## 1 2 2 8 1 2 4 6 8 3
```

Range of `SP4_Spg_2_BA` should be 0-7


```r
table(data_base_bristol[, 1 + 2])
```

```
## 
##  0  1  2  3  4  5  6  7 
##  1  4  4  3  3  3  1 19
```

Range of `SP4_Spg_3_BA` should be 0-2


```r
table(data_base_bristol[, 1 + 3])
```

```
## 
##  0  1  2 
## 15 19  4
```

Range of `SP4_Spg_5_BA- SP4_Spg_20_BA` should be 0-3


```r
raw_tab <- apply(data_base_bristol[, 1 + 4:20], 2, table)
raw_tab
```

```
## $SP4_Spg_4_BA
## 
##  0  1  2  3 
##  5 17 13  3 
## 
## $SP4_Spg_5_BA
## 
##  0  1  2 
## 26 10  2 
## 
## $SP4_Spg_6_BA
## 
##  0  1  2 
## 31  6  1 
## 
## $SP4_Spg_7_BA
## 
##  0  1  2  3 
## 10 16 11  1 
## 
## $SP4_Spg_8_BA
## 
##  0  1  2  3 
## 10 17 10  1 
## 
## $SP4_Spg_9_BA
## 
##  0  1  2  3 
## 11 19  6  2 
## 
## $SP4_Spg_10_BA
## 
##  0  1  2 
## 10 20  8 
## 
## $SP4_Spg_11_BA
## 
##  0  1  2 
## 24 10  4 
## 
## $SP4_Spg_12_BA
## 
##  0  1  2  3 
## 10 13 12  3 
## 
## $SP4_Spg_13_BA
## 
##  0  1  2  3 
## 10 20  7  1 
## 
## $SP4_Spg_14_BA
## 
##  0  1  2 
##  9 24  5 
## 
## $SP4_Spg_15_BA
## 
##  0  1  2  3 
## 10 19  7  2 
## 
## $SP4_Spg_16_BA
## 
##  0  1  2 
## 16 21  1 
## 
## $SP4_Spg_17_BA
## 
##  0  1  2 
## 13 20  5 
## 
## $SP4_Spg_18_BA
## 
##  0  1  2 
## 28  5  5 
## 
## $SP4_Spg_19_BA
## 
##  0  1  2  3 
## 14 13  8  3 
## 
## $SP4_Spg_20_BA
## 
##  0  1  2  3 
## 18 15  4  1
```

### Check  raw data values (follow up)

Range of `SP4_Spg_1_BA` should be 0-10


```r
table(data_follow_bristol[, 1 + 1])
```

```
## 
## 0 1 2 3 4 5 6 7 8 9 
## 1 1 4 3 4 3 6 7 5 1
```

Range of `SP4_Spg_2_BA` should be 0-7


```r
table(data_follow_bristol[, 1 + 2])
```

```
## 
##  0  1  2  3  4  5  7 
##  1  5  4  5  4  3 13
```

Range of `SP4_Spg_3_BA` should be 0-2


```r
table(data_follow_bristol[, 1 + 3])
```

```
## 
##  0  1  2 
## 10 21  4
```

Range of `SP4_Spg_5_BA- SP4_Spg_20_BA` should be 0-3


```r
raw_tab <- apply(data_follow_bristol[, 1 + 4:20], 2, table)
raw_tab
```

```
## $SP4_Spg_4_FU
## 
##  0  1  2  3 
##  4 18 10  2 
## 
## $SP4_Spg_5_FU
## 
##  0  1 
## 24 11 
## 
## $SP4_Spg_6_FU
## 
##  0  1 
## 29  6 
## 
## $SP4_Spg_7_FU
## 
##  0  1  2 
## 10 18  7 
## 
## $SP4_Spg_8_FU
## 
##  0  1  2  3 
## 15 17  2  1 
## 
## $SP4_Spg_9_FU
## 
##  0  1  2 
## 16 17  2 
## 
## $SP4_Spg_10_FU
## 
##  0  1  2 
## 20  9  6 
## 
## $SP4_Spg_11_FU
## 
##  0  1 
## 24 11 
## 
## $SP4_Spg_12_FU
## 
##  0  1  2 
##  7 16 12 
## 
## $SP4_Spg_13_FU
## 
##  0  1  2  3 
##  9 19  5  2 
## 
## $SP4_Spg_14_FU
## 
##  0  1  2  3 
## 16 15  3  1 
## 
## $SP4_Spg_15_FU
## 
##  0  1  2  3 
## 12 16  5  2 
## 
## $SP4_Spg_16_FU
## 
##  0  1 
## 18 17 
## 
## $SP4_Spg_17_FU
## 
##  0  1  2 
## 16 15  4 
## 
## $SP4_Spg_18_FU
## 
##  0  1 
## 28  7 
## 
## $SP4_Spg_19_FU
## 
##  0  1  2 
## 15 16  4 
## 
## $SP4_Spg_20_FU
## 
##  0  1  2  3 
## 16 15  3  1
```

Be careful how to handle NAs ...

Tabulate number of NAs



### Compute sum scores from BRAF


```r
get_psqi_phys <- function(x){
  m_score <- c(10, 7, 2, 3)
  na_pos <- is.na(x)
  res <- sum(x, na.rm = T)/sum(m_score[!na_pos]) * sum(m_score)
  if((sum(na_pos) > 1)||(any(is.na(x[1:2])))){res <- NA}
  return(res)
}

data_base_bristol$BRAF_phys <- apply(data_base_bristol[2:5], 1, get_psqi_phys)

get_psqi_other <- function(x){
  m_score <- rep(3, length(x))
  na_pos <- is.na(x)
  res <- sum(x, na.rm = T)/sum(m_score[!na_pos]) * sum(m_score)
  if((sum(na_pos) > 1)){res <- NA}
  return(res)
}

data_base_bristol$BRAF_living <- apply(data_base_bristol[, 1 + 5:11], 1, get_psqi_other)
data_base_bristol$BRAF_cog <- apply(data_base_bristol[, 1 + 12:16], 1, get_psqi_other)
data_base_bristol$BRAF_emo <- apply(data_base_bristol[, 1 + 17:20], 1, get_psqi_other)
data_base_bristol$BRAF_total <- apply(dplyr::select(data_base_bristol, dplyr::contains("BRAF")), 1, sum)

data_follow_bristol$BRAF_phys <- apply(data_follow_bristol[2:5], 1, get_psqi_phys)

get_psqi_other <- function(x){
  m_score <- rep(3, length(x))
  na_pos <- is.na(x)
  res <- sum(x, na.rm = T)/sum(m_score[!na_pos]) * sum(m_score)
  if((sum(na_pos) > 1)){res <- NA}
  return(res)
}

data_follow_bristol$BRAF_living <- apply(data_follow_bristol[, 1 + 5:11], 1, get_psqi_other)
data_follow_bristol$BRAF_cog <- apply(data_follow_bristol[, 1 + 12:16], 1, get_psqi_other)
data_follow_bristol$BRAF_emo <- apply(data_follow_bristol[, 1 + 17:20], 1, get_psqi_other)
data_follow_bristol$BRAF_total <- apply(dplyr::select(data_follow_bristol, dplyr::contains("BRAF")), 1, sum)
```


```r
summary(data_base_bristol$BRAF_phys)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    9.00   14.00   12.54   17.00   20.00       1
```

```r
summary(data_base_bristol$BRAF_living)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   2.250   4.500   5.105   7.000  13.000
```

```r
summary(data_base_bristol$BRAF_cog)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   2.000   5.000   4.711   6.750  10.000
```

```r
summary(data_base_bristol$BRAF_emo)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   1.000   2.500   2.868   5.000   8.000
```

```r
summary(data_base_bristol$BRAF_total)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    2.00   17.00   25.00   25.35   37.00   49.00       1
```

```r
summary(data_follow_bristol$BRAF_phys)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    1.00    7.50   13.00   11.67   16.00   21.00       3
```

```r
summary(data_follow_bristol$BRAF_living)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##     0.0     1.0     4.0     3.6     5.0    10.0       3
```

```r
summary(data_follow_bristol$BRAF_cog)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   1.500   4.000   4.229   6.000  11.000       3
```

```r
summary(data_follow_bristol$BRAF_emo)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##     0.0     0.0     2.0     2.2     4.0     6.0       3
```

```r
summary(data_follow_bristol$BRAF_total)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    3.00   10.00   23.00   21.70   29.50   41.53       3
```

## 5. Fysisik aktivitetsniveau

Remove all comments from baseline questionnaire (col 2 -)


```r
data_base_fys_akt <- data_base_fys_akt[, 1:2]
```

Check raw data values


```r
table(data_base_fys_akt$SP5_Spg_1_BA)
```

```
## 
##  1  2  3 
##  6 21 11
```

```r
table(data_follow_fys_akt$SP5_Spg_1_FU)
```

```
## 
##  .  1  2  3  4 
##  2  3 16 13  3
```


## 6. Center for Epidemiologic studies depression scale

### Check raw data values (baseline)

Range should be 0-3

```r
apply(data_base_dep[, -1], 2, function(z){table(z)})
```

```
## $SP6_Spg_0_BA
## z
##  0  1  2 
## 24 12  1 
## 
## $SP6_Spg_1_BA
## z
##  0  1  2 
## 24 11  3 
## 
## $SP6_Spg_2_BA
## z
##  0  1 
## 23 15 
## 
## $SP6_Spg_3_BA
## z
##  0  1  2  3 
##  5  6 10 17 
## 
## $SP6_Spg_5_BA
## z
##  0  1  2  3 
## 15 16  5  2 
## 
## $SP6_Spg_6_BA
## z
##  0  1 
## 27 11 
## 
## $SP6_Spg_7_BA
## z
##  0  1  2 
## 17 19  2 
## 
## $SP6_Spg_8_BA
## z
##  0  1  2  3 
##  2 10 12 14 
## 
## $SP6_Spg_9_BA
## z
##  0  1  2 
## 36  1  1 
## 
## $SP6_Spg_00_BA
## z
##  0  1  2 
## 33  4  1 
## 
## $SP6_Spg_00_BA__1
## z
##  0  1  2  3 
##  6 17  9  6 
## 
## $SP6_Spg_01_BA
## z
##  0  1  2  3 
##  6 10 11 10 
## 
## $SP6_Spg_02_BA
## z
##  0  1  2 
## 24 11  3 
## 
## $SP6_Spg_03_BA
## z
##  0  1  2  3 
## 27  8  1  1 
## 
## $SP6_Spg_05_BA
## z
##  0  1  3 
## 35  2  1 
## 
## $SP6_Spg_06_BA
## z
##  0  1  2  3 
##  5  6 11 16 
## 
## $SP6_Spg_07_BA
## z
##  0  1 
## 32  6 
## 
## $SP6_Spg_08_BA
## z
##  0  1 
## 20 17 
## 
## $SP6_Spg_09_BA
## z
##  0  1  2 
## 33  4  1 
## 
## $SP6_Spg_10_BA
## z
##  0  1  2 
## 16 14  8
```

### Check raw data values (follow up)

Range should be 0-3

```r
apply(data_follow_dep[, -1], 2, table)
```

```
## $SP6_Spg_0_FU
## 
##  0  1  2 
## 23  9  2 
## 
## $SP6_Spg_1_FU
## 
##  0  1  2 
## 22  7  4 
## 
## $SP6_Spg_2_FU
## 
##  0  1  2 
## 23  7  4 
## 
## $SP6_Spg_3_FU
## 
##  0  1  2  3 
## 10  5  6 14 
## 
## $SP6_Spg_5_FU
## 
##  0  1  2  3 
## 17 14  3  1 
## 
## $SP6_Spg_6_FU
## 
##  0  1  2  3 
## 18 14  2  1 
## 
## $SP6_Spg_7_FU
## 
##  0  1  2  3 
## 17 12  3  2 
## 
## $SP6_Spg_8_FU
## 
##  0  1  2  3 
##  5  7 12 11 
## 
## $SP6_Spg_9_FU
## 
##  0  1  2 
## 33  1  1 
## 
## $SP6_Spg_00_FU
## 
##  0  1  2  3 
## 30  3  1  1 
## 
## $SP6_Spg_00_FU__1
## 
##  0  1  2  3 
## 11 14  5  4 
## 
## $SP6_Spg_01_FU
## 
##  0  1  2  3 
##  4  8 14  9 
## 
## $SP6_Spg_02_FU
## 
##  0  1  2  3 
## 26  4  4  1 
## 
## $SP6_Spg_03_FU
## 
##  0  1  2  3 
## 23 10  1  1 
## 
## $SP6_Spg_05_FU
## 
##  0  1  2  3 
## 27  5  1  1 
## 
## $SP6_Spg_06_FU
## 
##  0  1  2  3 
##  3  5 12 15 
## 
## $SP6_Spg_07_FU
## 
##  0  1  2 
## 27  7  1 
## 
## $SP6_Spg_08_FU
## 
##  0  1  2 
## 21 12  2 
## 
## $SP6_Spg_09_FU
## 
##  0  1 
## 30  5 
## 
## $SP6_Spg_10_FU
## 
##  0  1  2  3 
## 16 13  4  1
```
### Compute sum scores from CES-D


```r
data_base_dep$CES_D_total <- apply(data_base_dep[, -1], 1, sum)
data_follow_dep$CES_D_total <- apply(data_follow_dep[, -1], 1, sum)
```


## 7. Fysisk funktion i det daglige (HAQ)

Ignore scoring for aids/devices so far i.e. consider only items 1-20


```r
names(data_base_fys_funk)
```

```
##  [1] "ID_NUM"                   "SP7_Spg_1_BA"            
##  [3] "SP7_Spg_2_BA"             "SP7_Spg_3_BA"            
##  [5] "SP7_Spg_4_BA"             "SP7_Spg_5_BA"            
##  [7] "SP7_Spg_6_BA"             "SP7_Spg_7_BA"            
##  [9] "SP7_Spg_8_BA"             "SP7_Spg_9_BA"            
## [11] "SP7_Spg_10_BA"            "SP7_Spg_11_BA"           
## [13] "SP7_Spg_12_BA"            "SP7_Spg_13_BA"           
## [15] "SP7_Spg_14_BA"            "SP7_Spg_15_BA"           
## [17] "SP7_Spg_16_BA"            "SP7_Spg_17_BA"           
## [19] "SP7_Spg_18_BA"            "SP7_Spg_19_BA"           
## [21] "SP7_Spg_20_BA"            "Sp7_stok_BA"             
## [23] "Sp7_dressing_BA"          "Sp7_krykstok_BA"         
## [25] "Sp7_specielstol_BA"       "Sp7_gangstativ_BA"       
## [27] "Sp7_toiletsaede_BA"       "Sp7_korestol_BA"         
## [29] "Sp7_badestol_BA"          "Sp7_kokken_BA"           
## [31] "Sp7_badevarelse_BA"       "Sp7_spiseredskaber_BA"   
## [33] "Sp7_langskaftede_BA"      "Sp7_andre_BA"            
## [35] "Sp7_ikke_hjalpemidler_BA" "Sp7_spg_21_BA"           
## [37] "Sp7_spg_22_BA"            "Sp7_spg_23_BA"
```

### Baseline (HAQ)

Check raw data values (allowed range: 0 - 3)


```r
apply(data_base_fys_funk[, 1 + 1:20], 2, table)
```

```
## $SP7_Spg_1_BA
## 
##  0  1 
## 28 10 
## 
## $SP7_Spg_2_BA
## 
##  0  1 
## 29  8 
## 
## $SP7_Spg_3_BA
## 
##  0  1 
## 29  9 
## 
## $SP7_Spg_4_BA
## 
##  0  1 
## 27 11 
## 
## $SP7_Spg_5_BA
## 
##  0  1  2 
## 24 10  4 
## 
## $SP7_Spg_6_BA
## 
##  0  1  2 
## 33  4  1 
## 
## $SP7_Spg_7_BA
## 
##  0  1  2  3 12 
## 13 14  9  1  1 
## 
## $SP7_Spg_8_BA
## 
##  0  1 
## 32  6 
## 
## $SP7_Spg_9_BA
## 
##  0  1 
## 29  9 
## 
## $SP7_Spg_10_BA
## 
##  0  1 
## 26 12 
## 
## $SP7_Spg_11_BA
## 
##  0  1  2  3 
## 24  2  2  5 
## 
## $SP7_Spg_12_BA
## 
##  0  1 
## 31  7 
## 
## $SP7_Spg_13_BA
## 
##  0  1  2  3 
## 12 18  5  3 
## 
## $SP7_Spg_14_BA
## 
##  0  1 
## 24 14 
## 
## $SP7_Spg_15_BA
## 
##  0  1 
## 29  9 
## 
## $SP7_Spg_16_BA
## 
##  0  1  2  3 
## 15 18  4  1 
## 
## $SP7_Spg_17_BA
## 
##  0  1  2 
## 27 10  1 
## 
## $SP7_Spg_18_BA
## 
##  0  1  2 
## 22 12  3 
## 
## $SP7_Spg_19_BA
## 
##  0  1  2 
## 26 11  1 
## 
## $SP7_Spg_20_BA
## 
##  0  1  2  3 
## 15 12 10  1
```

Correct / change invalid entry `12` in item 7

**Confirm method for computing alternative HAQ-DI score**


```r
data_base_fys_funk$haq1 <- apply(data_base_fys_funk[, 1 + 1:2], 1, max, na.rm = T)
data_base_fys_funk$haq2 <- apply(data_base_fys_funk[, 1 + 3:4], 1, max, na.rm = T)
data_base_fys_funk$haq3 <- apply(data_base_fys_funk[, 1 + 5:7], 1, max, na.rm = T)
data_base_fys_funk$haq4 <- apply(data_base_fys_funk[, 1 + 8:9], 1, max, na.rm = T)
data_base_fys_funk$haq5 <- apply(data_base_fys_funk[, 1 + 10:12], 1, max, na.rm = T)
data_base_fys_funk$haq6 <- apply(data_base_fys_funk[, 1 + 13:14], 1, max, na.rm = T)
data_base_fys_funk$haq7 <- apply(data_base_fys_funk[, 1 + 15:17], 1, max, na.rm = T)
data_base_fys_funk$haq8 <- apply(data_base_fys_funk[, 1 + 18:20], 1, max, na.rm = T)
data_base_fys_funk$haq_NA <- apply(select(data_base_fys_funk, num_range(prefix = "haq", range = 1:8)), 1, function(z){sum(!is.na(z))})

data_base_fys_funk$haq_total <- apply(select(data_base_fys_funk, num_range(prefix = "haq", range = 1:8)), 1, mean)

data_base_fys_funk$haq_total <- replace(data_base_fys_funk$haq_total, data_base_fys_funk$haq_NA < 6, NA)
```

Check scores for each of eight categories


```r
apply(select(data_base_fys_funk, num_range(prefix = "haq", range = 1:8)), 2, table)
```

```
## $haq1
## 
##  0  1 
## 27 11 
## 
## $haq2
## 
##  0  1 
## 25 13 
## 
## $haq3
## 
##  0  1  2  3 12 
## 13 14  9  1  1 
## 
## $haq4
## 
##  0  1 
## 29  9 
## 
## $haq5
## 
##  0  1  2  3 
## 23  8  2  5 
## 
## $haq6
## 
##  0  1  2  3 
## 11 19  5  3 
## 
## $haq7
## 
##  0  1  2  3 
## 13 20  4  1 
## 
## $haq8
## 
##  0  1  2  3 
## 13 14 10  1
```

### Follow up (HAQ)

Check raw data values (allowed range: 0 - 3)


```r
apply(data_follow_fys_funk[, 1 + 1:20], 2, table)
```

```
## $SP7_Spg_1_FU
## 
##  0  1 
## 23 12 
## 
## $SP7_Spg_2_FU
## 
##  0  1 
## 28  7 
## 
## $SP7_Spg_3_FU
## 
##  0  1 
## 28  7 
## 
## $SP7_Spg_4_FU
## 
##  0  1 
## 27  8 
## 
## $SP7_Spg_5_FU
## 
##  0  1  2 
## 22 10  3 
## 
## $SP7_Spg_6_FU
## 
##  0  1  2 
## 28  6  1 
## 
## $SP7_Spg_7_FU
## 
##  0  1  2  3 
## 13 18  3  1 
## 
## $SP7_Spg_8_FU
## 
##  0  1 
## 31  4 
## 
## $SP7_Spg_9_FU
## 
##  0  1 
## 29  6 
## 
## $SP7_Spg_10_FU
## 
##  0  1 
## 24 11 
## 
## $SP7_Spg_11_FU
## 
##  0  1  2  3 
## 22  4  1  5 
## 
## $SP7_Spg_12_FU
## 
##  0  1 
## 29  6 
## 
## $SP7_Spg_13_FU
## 
##  0  1  2  3 
## 12 19  2  2 
## 
## $SP7_Spg_14_FU
## 
##  0  1 
## 24 11 
## 
## $SP7_Spg_15_FU
## 
##  0  1  2 
## 28  6  1 
## 
## $SP7_Spg_16_FU
## 
##  0  1  2 
## 16 16  3 
## 
## $SP7_Spg_17_FU
## 
##  0  1  2 
## 27  7  1 
## 
## $SP7_Spg_18_FU
## 
##  0  1  2 
## 21  9  5 
## 
## $SP7_Spg_19_FU
## 
##  0  1  2 
## 26  8  1 
## 
## $SP7_Spg_20_FU
## 
##  0  1  2  3 
## 14 13  7  1
```

**Confirm method for computing alternative HAQ-DI score**

Technical note:

With `na.rm = T` then `max` function returns `-Inf` for an empty vector. A user modified version returning `NA` for an empty vector is used here.


```r
my_max <- function(x, ...){
  if(all(is.na(x))){
    return(NA)
  }
  else{
    return(max(x, ...))
  }
  
}

data_follow_fys_funk$haq1 <- apply(data_follow_fys_funk[, 1 + 1:2], 1, my_max, na.rm = T)
data_follow_fys_funk$haq2 <- apply(data_follow_fys_funk[, 1 + 3:4], 1, my_max, na.rm = T)
data_follow_fys_funk$haq3 <- apply(data_follow_fys_funk[, 1 + 5:7], 1, my_max, na.rm = T)
data_follow_fys_funk$haq4 <- apply(data_follow_fys_funk[, 1 + 8:9], 1, my_max, na.rm = T)
data_follow_fys_funk$haq5 <- apply(data_follow_fys_funk[, 1 + 10:12], 1, my_max, na.rm = T)
data_follow_fys_funk$haq6 <- apply(data_follow_fys_funk[, 1 + 13:14], 1, my_max, na.rm = T)
data_follow_fys_funk$haq7 <- apply(data_follow_fys_funk[, 1 + 15:17], 1, my_max, na.rm = T)
data_follow_fys_funk$haq8 <- apply(data_follow_fys_funk[, 1 + 18:20], 1, my_max, na.rm = T)
data_follow_fys_funk$haq_NA <- apply(select(data_follow_fys_funk, num_range(prefix = "haq", range = 1:8)), 1, function(z){sum(!is.na(z))})

data_follow_fys_funk$haq_total <- apply(select(data_follow_fys_funk, num_range(prefix = "haq", range = 1:8)), 1, mean)

data_follow_fys_funk$haq_total <- replace(data_follow_fys_funk$haq_total, data_follow_fys_funk$haq_NA < 6, NA)
```

Check scores for each of eight categories


```r
apply(select(data_follow_fys_funk, num_range(prefix = "haq", range = 1:8)), 2, table)
```

```
## $haq1
## 
##  0  1 
## 23 12 
## 
## $haq2
## 
##  0  1 
## 26  9 
## 
## $haq3
## 
##  0  1  2  3 
## 11 18  5  1 
## 
## $haq4
## 
##  0  1 
## 29  6 
## 
## $haq5
## 
##  0  1  2  3 
## 19 10  1  5 
## 
## $haq6
## 
##  0  1  2  3 
## 11 20  2  2 
## 
## $haq7
## 
##  0  1  2 
## 16 15  4 
## 
## $haq8
## 
##  0  1  2  3 
## 14 13  7  1
```



## 8. EQ-5D Helbredsspørgeskema

Check raw data values (items 1-5)


```r
apply(data_base_eq_5d[, -c(1, 7)], 2, table)
```

```
## $SP8_Spg_1_BA
## 
##  1  2  3 
## 24 12  2 
## 
## $SP8_Spg_2_BA
## 
##  1  2 
## 27 11 
## 
## $SP8_Spg_3_BA
## 
##  1  2  3 
## 16 16  6 
## 
## $SP8_Spg_4_BA
## 
##  1  2  3  4 
##  6 20 11  1 
## 
## $SP8_Spg_5_BA
## 
##  1  2 
## 29  9
```

```r
apply(data_follow_eq_5d[, -c(1, 7)], 2, table)
```

```
## $SP8_Spg_1_FU
## 
##  1  2  3 
## 27  4  4 
## 
## $SP8_Spg_2_FU
## 
##  1  2  3 
## 26  6  3 
## 
## $SP8_Spg_3_FU
## 
##  1  2  3  4 
## 18 10  5  2 
## 
## $SP8_Spg_4_FU
## 
##  1  2  3  4 
##  6 17 11  1 
## 
## $SP8_Spg_5_FU
## 
##  1  2  3 
## 23 11  1
```

Check raw data values (items 6)


```r
summary(data_base_eq_5d$SP8_Spg_6_BA)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   30.00   56.25   75.00   71.42   83.75  100.00
```

```r
summary(data_follow_eq_5d$SP8_Spg_6_FU)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   20.00   60.00   75.00   69.71   86.50   99.00       3
```

## 9. Søvndagbog

# Export cleaned data


