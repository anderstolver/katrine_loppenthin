---
title: "Template - results - numerical outcomes"
author: "Anders Tolver"
date: "2018"
output: 
  html_document:
    toc: TRUE
    keep_md: TRUE
    code_folding: hide
params:
  var_name: "psqi_total"
---





# Code / comments

This template generates output for numerical/continuous outcome.

The following are computed

## Summary measures

For each combination of assessment time and randomization group we compute

* number of observations (excluding missing data!)
* mean
* standard deviation
* median
* interquantile range (given by 25 % and 75 % quantiles)

For each randomization group summary measures are also computed for changes over time (baseline to follow up).

## Model based estimates

A linear mixed model with fixed effects of time, randomization group and their interaction as well as random effect of subject/ID_NUM is used to extract

* mean estimate for alle combinations of group and time
* within group changes over time
* comparison of within group changes over time across the two groups

The tables produced extract

* estimates
* standard error on estimates
* P-value (for testing if estimate equals to zero)
* lower and upper 95 % confidence interval for estimate

## Source Code


```r
sum_na <- function(x){sum(!is.na(x))}
my_funs <- funs(n = sum_na, mean = round(mean(., na.rm = T), digits = 4), sd = round(sd(., na.rm = T), digits = 4), median = median(., na.rm = T), q25 = quantile(., probs = 0.25, na.rm = T), q75 = quantile(., probs = 0.75, na.rm = T))

print_num <- function(varname, df = data_full){
    group_by(df, time, Randomisering) %>% 
    select(time, Randomisering, varname) %>%
    summarize_at(.vars = varname, .funs = my_funs) %>%
    filter(!is.na(Randomisering))
}
```

# Results for variable psqi7

Here given for variable: psqi7


### Raw data


```r
DT::datatable(print_num(params$var_name))
```

<!--html_preserve--><div id="htmlwidget-d06635ba4b6d3f6462da" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-d06635ba4b6d3f6462da">{"x":{"filter":"none","data":[["1","2","3","4"],["baseline","baseline","follow_up","follow_up"],["control","intervention","control","intervention"],[21,16,18,16],[1.9048,1.625,1.7778,1.3125],[1.0443,0.7188,1.0603,0.9465],[2,1.5,2,1],[1,1,1,1],[3,2,3,2]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>time<\/th>\n      <th>Randomisering<\/th>\n      <th>n<\/th>\n      <th>mean<\/th>\n      <th>sd<\/th>\n      <th>median<\/th>\n      <th>q25<\/th>\n      <th>q75<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[3,4,5,6,7,8]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

### Model based 


```r
library(nlme)
form1 <- formula(paste(params$var_name, "~ time * Randomisering"))
mod1 <- lme(form1, random = ~1| ID_NUM, data = data_full, na.action = na.omit)

form2 <- formula(paste(params$var_name, "~ Randomisering + time:Randomisering - 1"))
mod2 <- lme(form2, random = ~1| ID_NUM, data = data_full, na.action = na.omit)

form3 <- formula(paste(params$var_name, "~ time:Randomisering - 1"))
mod3 <- lme(form3, random = ~1| ID_NUM, data = data_full, na.action = na.omit)

tmp_table3 <- round(cbind(summary(mod3)$tTable[1:4, c(1, 2, 5)], intervals(mod3)$fixed[, c(1, 3)]
), digits = 4)[, c(1, 2, 4, 5, 3)]

tmp_table2 <- round(cbind(summary(mod2)$tTable[3:4, c(1, 2, 5)], intervals(mod2)$fixed[3:4, c(1, 3)]
), digits = 4)[, c(1, 2, 4, 5, 3)]

tmp_table1 <- round(c(summary(mod1)$tTable[4, c(1, 2, 5)], intervals(mod1)$fixed[4, c(1, 3)]
), digits = 4)[c(1, 2, 4, 5, 3)]

tmp_tab <- as_tibble(rbind(tmp_table3, tmp_table2, tmp_table1))
tmp_tab <- mutate(tmp_tab, contrast = c("control_base", "control_follow", "intervention_base", "intervention_follow", "control_change", "intervention_change", "group_diff_change"))[c(6, 1:5)]

DT::datatable(tmp_tab)
```

<!--html_preserve--><div id="htmlwidget-e61d30795b416496114d" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-e61d30795b416496114d">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7"],["control_base","control_follow","intervention_base","intervention_follow","control_change","intervention_change","group_diff_change"],[1.9048,1.7433,1.625,1.3125,-0.1615,-0.3125,-0.151],[0.2127,0.217,0.2436,0.2436,0.1171,0.1248,0.1711],[1.471,1.3008,1.1281,0.8156,-0.3997,-0.5664,-0.4996],[2.3385,2.1858,2.1219,1.8094,0.0768,-0.0586,0.1975],[0,0,0,0,0.1772,0.0174,0.384]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>contrast<\/th>\n      <th>Value<\/th>\n      <th>Std.Error<\/th>\n      <th>lower<\/th>\n      <th>upper<\/th>\n      <th>p-value<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3,4,5,6]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

