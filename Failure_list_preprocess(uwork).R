# failure list duplication, statistic failure times, extract first failure time
rm(list = ls());setwd('~/Code/R/Load_Data_Config_Failure');source('~/rhead')
require(data.table)
####################################
# 1. read data
#[uwork]
data.flA <- read.csv(file.path(dir_datatext,'uwork_20120101-20131210.csv'))
names(data.flA) <- c('id','svrid','ip','ftype','ori_ftype',
                    'ftime','ftype_d1','ftype_d2','ftype_d')
data.flA$finfo <- 'unknown'
data.flA$ftime <- as.p(data.flA$ftime)

#[201406-201409]
data.flB <- read.csv(file.path(dir_datatext,'故障单精简_06-09.csv'))
names(data.flB) <- c('id','svrid','ip','ftype',
                     'idc','dev_class_name','dev_class_id','dept_id',
                     'ftime','finfo','ftype_d1','ftype_d2')
data.flB$ftime <- as.p(data.flB$ftime)

#[2014]
# readC <- fread(file.path(dir_datatext,'硬盘故障单140101_141231A.txt'),
#                   sep = '~',header = F,encoding = 'UTF-8')
# tenc_fail_record_parse <- function(str){
#   s <- strsplit(str,split = '\t')[[1]]
#   len <- length(s)
#   if (len != 10){
#     s1 <- character(10)
#     s1[1:5] <- s[1:5]
#     s1[6] <- paste(s[6:(len-4)],sep='',collapse = '')
#     s1[7:10] <- s[(len-3):len]
#     s <- s1
#   }
#   s
# }
# tmp <- sapply(1:nrow(readC),function(i)tenc_fail_record_parse(readC[i]$V1))
# data.flC <- data.frame(t(tmp[,2:nrow(readC)]))
# names(data.flC) <- tmp[,1]
load(file.path(dir_data,'failRecord2014.Rda'))
data.flC <- failRecordA
names(data.flC) <- c('extractDate','id','svrid','finfo',
                     'ftype','hday','tag','ftime','ip','svrid1')
data.flC$ftype_d1 <- factor('硬盘故障;')
data.flC$ftype_d2 <- factor('硬盘故障;')

# 2. merge failure record
col_need <- c('svrid','ip','ftype','ftime','ftype_d1','ftype_d2','finfo')
data.flA <- data.flA[,col_need]
data.flB <- data.flB[,col_need]
data.flC <- data.flC[,col_need]
data.flA$group <- 'uwork2013';f2013 <- data.flA
data.flB$group <- 'uwork1406-1409';f2014_06_09 <- data.flB
data.flC$group <- 'uwork2014';f2014 <- data.flC
save(f2013,file = file.path(dir_data,'uwork2013.Rda'))
save(f2014_06_09,file = file.path(dir_data,'uwork2014_06_09.Rda'))
save(f2014,file = file.path(dir_data,'uwork2014.Rda'))

# data.fl <- rbind(data.flA,data.flB,data.flC)
# We remove data.flB which is included in data.flC
data.fl <- rbind(data.flA,data.flC)

# 2. del space
data.fl$ftype <- as.character(data.fl$ftype)
data.fl$ftype[data.fl$ftype == '硬盘故障（有冗余） '] <- '硬盘故障（有冗余）'
data.fl$ftype <- factor(data.fl$ftype)

# 3. add class
data.fl$class <- -1
ftlist <- c('硬盘故障（有冗余）','硬盘故障（有冗余，槽位未知）',
            '硬盘故障（无冗余）','硬盘故障（无冗余，在线换盘）',
            '硬盘即将故障（有冗余）','操作系统硬盘故障（无冗余）')
data.fl$class[(data.fl$ftype_d1 == '硬盘故障;' | data.fl$ftype_d2 == '硬盘故障;')] <- 7


# 4. delete item without ip
data.fl_order <- data.fl[with(data.fl,order(ip,ftime)),]
data.fl_order <- data.fl_order[data.fl_order$ip!='',]           # delete item without ip
data.fl_order$ip <- factor(data.fl_order$ip)                    # reconstruct factor of ip

# 5. filter wrong ip
regexp.ip <- "^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$"
idx.ip_reg <- grepl(regexp.ip,data.fl_order$ip)
data.fl_order <- data.fl_order[idx.ip_reg,]

# 6. save
data.flist <- data.fl_order
rownames(data.flist) <- NULL
data.bad <- subset(data.flist,class!=-1)
save(data.flist,data.bad,file = file.path(dir_data,'flist(uwork[2012-2014]).Rda'))
