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

# Results for variable TST_num

Here given for variable: TST_num


### Raw data


```r
DT::datatable(print_num(params$var_name))
```

<!--html_preserve--><div id="htmlwidget-e3122510a922c9037035" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-e3122510a922c9037035">{"x":{"filter":"none","data":[["1","2","3","4"],["baseline","baseline","follow_up","follow_up"],["control","intervention","control","intervention"],[18,15,17,15],[6.3407,6.195,6.6034,6.7427],[0.8554,1.0427,0.9891,0.9793],[6.23333333333334,6,6.675,6.88333333333333],[5.63541666666667,5.35833333333333,6.175,5.96666666666667],[7.00833333333333,7.19583333333333,7.15,7.24083333333333]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>time<\/th>\n      <th>Randomisering<\/th>\n      <th>n<\/th>\n      <th>mean<\/th>\n      <th>sd<\/th>\n      <th>median<\/th>\n      <th>q25<\/th>\n      <th>q75<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[3,4,5,6,7,8]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

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

<!--html_preserve--><div id="htmlwidget-7a519c962286973a9fa8" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-7a519c962286973a9fa8">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7"],["control_base","control_follow","intervention_base","intervention_follow","control_change","intervention_change","group_diff_change"],[6.3407,6.6106,6.195,6.7427,0.2698,0.5477,0.2778],[0.2273,0.2337,0.249,0.249,0.2969,0.3197,0.4363],[5.8759,6.1326,5.6858,6.2334,-0.3357,-0.1044,-0.6132],[6.8056,7.0885,6.7042,7.2519,0.8753,1.1998,1.1689],[0,0,0,0,0.3704,0.0967,0.5291]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>contrast<\/th>\n      <th>Value<\/th>\n      <th>Std.Error<\/th>\n      <th>lower<\/th>\n      <th>upper<\/th>\n      <th>p-value<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3,4,5,6]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

