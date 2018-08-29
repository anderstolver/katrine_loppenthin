### KBL - JR sleep ###
######################

# This document contains source code for generating all results.
# For each variable an .html-file is created. Links must be
# added manually to the file README.rmd

# Numerical variables #
#######################

# list of numerical variables

num_vars <- c("sleep_effi", "SO_num", "sleep_latency_num", "wake_time_num", "TST_num", "REM_latency_num",
              "WASO", "Arous", "N1", "N2", "N3"
              , paste("psqi", 1:7, sep = ""), "psqi_total", "ess_total")
file_names <- paste(num_vars,".html", sep = "")

# knit with variable name as parameter

for(i in seq_along(num_vars)){
  rmarkdown::render("summaries.Rmd", output_file = file_names[i]
, params = list(var_name = num_vars[i]))
}


