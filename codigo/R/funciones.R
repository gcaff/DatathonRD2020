llenar_NAs <- function(d1,d2,by="country", varname1="aged_65_older", varname2="tot"){
  #browser()
  dd <- d1 %>%
    left_join(d2, by=by) %>%
    mutate(!!varname1 := ifelse(is.na(!!sym(varname1)),
                                !!sym(varname2),
                                !!sym(varname1)))
  dd
}

llenar_NAs(dd,unpop_65)

