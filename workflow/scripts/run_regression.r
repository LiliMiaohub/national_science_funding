rm(list=ls())
library(fixest)
library(tidyr)
library(ggplot2)
library(dplyr)
library(modelsummary)
library(kableExtra)

args = commandArgs(T)
DATA_PATH = args[1]
OUTPUT = args[2]

data = read.csv(DATA_PATH)

data = subset(data, !(cntry %in% c('China','France','Germany','United States','United Kingdom')))

feols_dome = feols(pub_growth~prvs_year_pubcnt+domestic+foreign|cntry+year,data=data)

feols_fdi = feols(
    pub_growth~prvs_year_pubcnt+domestic+United.States+United.Kingdom+EU+France+Germany+China+others|cntry+year,
    data=data)

notes = "The P-value is derived from the two-tailed t-test. + p < 0.1, * p < 0.05, ** p < 0.01, *** p < 0.001"
models = list(feols_dome, feols_fdi)
modelsummary(models,
             fmt=2,
             estimate  = "{estimate}{stars} [{conf.low},{conf.high}]",
             statistic=NULL,
             coef_rename=c('pubcnt_prev'='Pub(t-1)','United.Kingdom'='UK','United.States'='USA',
             'domestic'='INV_Domestic','foreign'='INV_Foreign','others'='INV_Rest'),
             gof_map=c('nobs','r.squared','adj.r.squared'),
             notes=notes,
             output='kableExtra')%>%kable_styling(latex_options="scale_down") %>%save_kable(OUTPUT)