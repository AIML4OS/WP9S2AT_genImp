library(data.table)

# missing completely at randwom
mcar <- function(dat, miss_var, rate_missing = 0.01){
  dat <- copy(dat)
  n_missing <- round(nrow(dat)*rate_missing)
  true_var <- paste0(miss_var,"_TRUE")
  dat[,c(true_var):=get(miss_var)]
  dat[sample(.N,n_missing),c(miss_var):=NA]
  
  return(dat)
}

# missing at random
mar <- function(dat, miss_var, tab_list, rate_missing = 0.01, power=1){
  
  dat <- copy(dat)
  
  n_missing <- round(nrow(dat)*rate_missing)
  
  miss_var_tab <- miss_var
  
  tab_list_dependency <- tab_list[names(tab_list)!=miss_var_tab]
  tab_list_vars <- lapply(tab_list_dependency,`[[`,1)
  
  missing_dependency <- do.call(CJ,tab_list_vars)
  missing_dependency[,non_res_ratio:=1]
  for(i in names(tab_list_dependency)){
    missing_dependency[tab_list_dependency[[i]],non_res_ratio:= non_res_ratio*non_res, on=c(i)]
  }
  missing_dependency[,summary(non_res_ratio)]
  
  dat[missing_dependency,non_res_ratio:=non_res_ratio,on=c(names(tab_list_vars))]
  dat[is.na(non_res_ratio)]
  dat[,summary(non_res_ratio)]
  dat[,non_res_ratio:=non_res_ratio^power]
  dat[,miss_prob:=1/.N*non_res_ratio,by=c(names(tab_list_vars))]
  
  true_var <- paste0(miss_var,"_TRUE")
  dat[,c(true_var):=get(miss_var)]
  dat[wrswoR::sample_int_R(.N,n_missing,prob = miss_prob),c(miss_var):=NA]
  
  return(dat)
}

# missing not at random
mnar <- function(dat, miss_var, tab_list, rate_missing = 0.01, power=4){
  
  dat <- copy(dat)
  
  n_missing <- round(nrow(dat)*rate_missing)
  
  miss_var_tab <- miss_var

  missing_dependency <- tab_list[names(tab_list)==miss_var_tab][[1]]
  
  dat[missing_dependency,non_res_ratio:=non_res,on=c(miss_var_tab)]
  
  dat[is.na(non_res_ratio)]
  dat[,summary(non_res_ratio)]
  dat[,non_res_ratio:=non_res_ratio^power]
  dat[,miss_prob:=1/.N*non_res_ratio,by=c(miss_var_tab)]
  dat[,summary(non_res_ratio)]
  
  true_var <- paste0(miss_var,"_TRUE")
  dat[,c(true_var):=get(miss_var)]
  dat[wrswoR::sample_int_R(.N,n_missing,prob = miss_prob),c(miss_var):=NA]
  return(dat)
}