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
data_follow_psqi <- read_excel(path  = "../data/Follow-up data.xls", skip = 1
                   , sheet = 1)
data_follow_ess <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
                   , sheet = 2)
data_follow_bristol <- read_excel(path  = "../data/Follow-up data.xls", skip = 1, na = "."
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

## PSQI

Consult `scoringsmanual til PSQI.pdf`


```r
data_base_psqi
```

```
## # A tibble: 38 x 20
##       ID_NUM SP2_Spg_1_BA SP2_Spg_2_BA SP2_Spg_3_BA SP2_Spg_4_BA
##        <chr>        <chr>        <chr>        <chr>        <chr>
##  1 01-180613        23.30           30        07.00            7
##  2 02-210613        23.00         12.5        08.30            6
##  3 03-280613        24.00           45        07.00            6
##  4 04-280613        23.45           75        07.45            6
##  5 05-280613        24.00         <NA>        07.30          5.5
##  6 06-030713        23.00         22.5        06.15            7
##  7 07-090713        24.00          6.5        06.15         <NA>
##  8 08-240713        22.30            5        07.00          5.5
##  9 09-240713        22.30           20        06.15          6.5
## 10 10-240713        23.00           25        07.30            5
## # ... with 28 more rows, and 15 more variables: SP2_Spg_5A_BA <dbl>,
## #   SP2_Spg_5B_BA <dbl>, SP2_Spg_5C_BA <dbl>, SP2_Spg_5D_BA <dbl>,
## #   SP2_Spg_5E_BA <dbl>, SP2_Spg_5F_BA <dbl>, SP2_Spg_5G_BA <dbl>,
## #   SP2_Spg_5H_BA <dbl>, SP2_Spg_5I_BA <dbl>, SP2_Spg_5J_svar_BA <dbl>,
## #   SP2_Spg_5J_BA <dbl>, SP2_Spg_6_BA <dbl>, SP2_Spg_7_BA <dbl>,
## #   SP2_Spg_8_BA <dbl>, SP2_Spg_9_BA <dbl>
```

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

