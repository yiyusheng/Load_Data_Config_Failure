#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Filename: load_use_time_2015.R
#
# Description: Load use time from server_first_use_time_140701_150630.csv. It is the modified use time from yemao
#
# Copyright (c) 2017, Yusheng Yi <yiyusheng.hust@gmail.com>
#
# Version 1.0
#
# Initial created: 2017-04-19 21:30:19
#
# Last   modified: 2017-04-19 21:30:20
#
#
#
rm(list = ls());setwd('~/Code/R/Load_Data_Config_Failure/');source('~/rhead')
DT <- read.table(file.path(dir_datatext,'server_first_use_time_140701_150630.csv'),sep = ',',header = T,fill = T)
DT$firstusetime <- as.p(DT$firstusetime)
save(DT,file = file.path(dir_data,'load_use_time_2015.Rda'))