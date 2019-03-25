fClean.raw.Faxafloahafnir.Landingside <- function(raw.table){
  if(!('faxafloahafnir.raw' %in% class(raw.table))){
    stop('Taflan er ekki sótt með réttu falli')
    }
  
  fix.table <- raw.table %>% 
    mutate(
      Location = str_replace(.$Location, ' at | to ', '/'),
      Time = dmy_hm(Time)
      )
  
  fix.table <- fix.table %>% 
    separate(
      col = Location, 
      sep = '/', 
      into = c('Action', 'Location'),
      remove = TRUE, 
      fill = 'right')
  
  fix.table <- fix.table %>% 
    mutate(
      pk = str_c(
        Name %>% toupper()%>% trimws(),
        Action %>% str_sub(end = 1),
        year(Time), 
        month(Time),
        day(Time), sep = ':'
        )
      )
    
  class(fix.table) <- c(class(fix.table), 'faxafloahafnir.clean')
  
  return(fix.table)
   
}
