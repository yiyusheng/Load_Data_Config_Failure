#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Filename: loadData.R
#
# Description: load data from disk_fault_list_140101_141231_clear and link it with the other table to merge table of svrid and table of id from ym together
# failRecordA/B is the fail record identifying server with svrid. disk_fault_list_140101-141231_clear is the one with svrnum
#
# Copyright (c) 2016, Yusheng Yi <yiyusheng.hust@gmail.com>
#
# Version 1.0
#
# Initial created: 2016-12-19 17:49:43
#
# Last   modified: 2016-12-19 20:17:43
#
#
rm(list = ls());setwd('~/Code/R/Load_Data_Config_Failure');source('~/rhead')
source('~/Code/R/Load_Data_Config_Failure/loadFunc.R')

load(file.path(dir_data,'uwork2014_06_09.Rda'))
load(file.path(dir_dataCF,'uwork2015.Rda'))

dayS <- as.p('2014-06-01');dayE <- as.p('2014-10-01')

FR1406 <- factorX(f2014_06_09[!check_vm(f2014_06_09$svrid),])
FR1406 <- check_disk_replacement(FR1406,valid = 1)
FR1406 <- subsetX(FR1406,ftime > dayS & ftime <= dayE)

FR15 <- subsetX(f2015, ftime > dayS & ftime <= dayE);names(FR15)[1] <- 'svrnum'
FR15M <- merge(FR15,FR1406,by = c('ftime','finfo','ftype'))
FR15MD <- factorX(FR15M[duplicated(FR15M[,c('ftime','finfo','ftype')]),])
FR15M <- subsetX(FR15M,!(svrid %in% FR15MD$svrid) & !(svrnum %in% FR15MD$svrnum))

save(FR15M,file = file.path(dir_data,'merge_svrnum_svrid_1406_1409.Rda'))
