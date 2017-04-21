#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Filename: load_d_alarm.R
#
# Description: Read and test d_alarm data which I don't know where and when it comes
#
# Copyright (c) 2017, Yusheng Yi <yiyusheng.hust@gmail.com>
#
# Version 1.0
#
# Initial created: 2017-04-19 20:30:26
#
# Last   modified: 2017-04-19 20:30:27
#
#
#

rm(list = ls());setwd('~/Code/R/Load_Data_Config_Failure/');source('~/rhead')
DT <- read.table(file.path(dir_datatext,'d_alarm_34_140701_141130.txt'),sep = '\t',header = F,fill = T)
names(DT) <- c('fid','ip','ftag','eventdescription','time1','time2',
               'col1','devid','col2','col3','col4','pos_info',
               'svrid1','svrid','svrid2','sn','col7')

col_known <- c('fid','ip','ftag','eventdescription','failed_time','recovery_time','devid','svrid','sn')
col_unknown <- setdiff(names(DT),col_known)
DT_known <- DT[,col_known];DT_unknown <- DT[,col_unknown]

DT_known$failed_time <- modify_unformat_time(DT_known$failed_time)
DT_known$recovery_time <- modify_unformat_time(DT_known$recovery_time)

save(DT_known,DT_unknown,file = file.path(dir_data,'load_d_alarm.Rda'))
