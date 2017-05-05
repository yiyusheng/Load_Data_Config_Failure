# Data load function
# Date: 2016-08-23 11:32
# Author: york

# F1. deduplicate failure list by time
# preserve the first failure in a time slide with more than one failures 
dedupTime <- function(data.flist,dayDup,attr){
  data.flist <- data.flist[order(data.flist[[attr]],data.flist$f_time),]
  data.flist[[attr]] <- as.character(data.flist[[attr]])
  delset <- numeric()
  
  pSvrid <- data.flist[[attr]][1]
  pFtime <- data.flist$f_time[1]
  for (i in 2:nrow(data.flist)){
    curSvrid <- data.flist[[attr]][i]
    curFtime <- data.flist$f_time[i]
    if (curSvrid == pSvrid & 
        as.numeric(difftime(curFtime,pFtime,tz = 'UTC',units = 'days')) > dayDup){
      pFtime <- curFtime
      next
    } else if(curSvrid == pSvrid & 
              as.numeric(difftime(curFtime,pFtime,tz = 'UTC',units = 'days')) <= dayDup){
      delset <- c(delset,i)
    } else if(curSvrid != pSvrid){
      pFtime <- curFtime
      pSvrid <- curSvrid
      next
    }
  }
  data.flist <- data.flist[-delset,]
  data.flist <- factorX(data.flist)
  return(data.flist)
}

# F2. check if svrid is a virtual machine
check_vm <- function(arr){
  return(grepl('-vm|-VM',arr))
}

# F3. check if ftype_d1/ftype_d2 contains '硬盘故障'. Yes indicates a replacement of bad disk drive.
check_disk_replacement <- function(df,valid = 1){
  flag_valid_item <- grepl('硬盘故障',df$ftype_d1)|grepl('硬盘故障',df$ftype_d2)
  x <- ifelse(valid == 1,df <- factorX(df[flag_valid_item,]),df <- factorX(df[!flag_valid_item,]))
  return(df)
}

# F4. revise ftype for f2013
revise_ftype <- function(df){
  df$ftype[df$ftype == '硬盘故障（有冗余） '] <- '硬盘故障（有冗余）'
  return(df)
}

# F5. filter item with invalid ip
filter_ip <- function(df){
  reg_ip <- "^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$"
  flag_valid_ip <- grepl(reg_ip,df$ip)
  df <- factorX(df[flag_valid_ip,])
  return(df)
}