#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Filename: load_num_model.R
#
# Description: load num_model and convert it to Rda
#
# Copyright (c) 2017, Yusheng Yi <yiyusheng.hust@gmail.com>
#
# Version 1.0
#
# Initial created: 2017-05-23 11:31:18
#
# Last   modified: 2017-05-23 11:31:19
#
#
#

rm(list = ls());setwd('~/Code/R/Load_Data_Config_Failure');source('~/rhead')
num_model <- read.csv(file.path(dir_datatext,'num_model.csv'))
save(num_model,file = file.path(dir_data,'num_model.Rda'))