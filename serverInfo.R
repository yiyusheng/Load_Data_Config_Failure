#@@@ merge failure record, disk configuration and server configuration

rm(list = ls())
source('head.R')

###################################################################################
# 1. read cmdb and generate disk information
cmdb <- read.csv(file.path(dir_data,'cmdb1104_allattr.csv'))
cmdb$use_time <- as.POSIXct(cmdb$use_time,tz = 'UTC')
select.col <- c('svr_id','ip','svr_asset_id','dev_class_id',
                'model_name','cpu','memory','dept_id','use_time','raid')

# 2. remove the duplicated svrid
cmdb <- subsetX(cmdb,svr_sn != 'CF3CGY1')

# 3. save
save(cmdb,file = file.path(dir_dataCF,'serverInfo.Rda'))
