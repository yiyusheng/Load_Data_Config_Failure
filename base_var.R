###### VARIABLES ######
dirName <- 'Load_Data_Config_Failure'
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7","#CC6666", "#9999CC", "#66CC99","#000000")
attrNameAll <- c('util','rps','iopsr','wps','iopsw');attrNameDis <- attrNameAll[c(2,4,1)]
attrNameExtend <- c('util','rps','wps',paste('iopsr_',1:24,sep=''),paste('iopsw_',1:24,sep=''))
dir_code <- paste(dir_c,dirName,sep='')
dir_data <- paste(dir_d,dirName,sep='')

if (osFlag){
  source('D:/Git/R_libs_user/R_custom_lib.R')
}else{
  dir_datatext <- file.path(dir_data,'csv_txt')
  source('~/Code/R/R_libs_user/R_custom_lib.R')
  # options('width' = 150)
}

###### PACKAGES ######
require('scales')
require('grid')
require('ggplot2')
require('reshape2')
require('plyr')


