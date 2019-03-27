fClean.raw.marine_traffic.table <- function(raw.table){
  
  if(!("marine-traffic.raw" %in% class(raw.table))){stop('Hrátaflan er ekki af þekktri tegund')}
  
  a.table <- raw.table %>%
    mutate(measures = str_replace_all(measures, '\\s', '.'))
  
  a.table <- a.table %>% 
    mutate(values = replace(values, which(values == '-'), NA))%>%
    mutate(values = replace(values, which(values == 'N/a'), NA))
  
  s.table <- spread(a.table, key = measures, value = values)
  
  s.table <- s.table %>% 
    mutate(
      Deadweight = Deadweight %>% str_extract('[:digit:]*') %>% as.numeric(),
      Gross.Tonnage = as.numeric(Gross.Tonnage)
      ) %>%
    rename(Deadweight.tonn = Deadweight)
  
  s.table <- s.table %>% 
    mutate(
      Length.Overall.x.Breadth.Extreme =
        Length.Overall.x.Breadth.Extreme %>% str_replace(' × ', '/')
      )
  
  s.table <- s.table %>% tidyr::separate(
    col = Length.Overall.x.Breadth.Extreme,
    into = c('Length.Overall.m', 'Breadth.Extreme.m'),
    sep = '/'
  ) %>% 
    mutate(Length.Overall.m = Length.Overall.m %>% str_replace('m', '') %>% as.numeric(),
           Breadth.Extreme.m = Breadth.Extreme.m %>% str_replace('m', '') %>% as.numeric())
  
  class(s.table) <- c(class(s.table), 'marine-traffic.ship.info',
                      fill = 'left')
  
  return(s.table)
}
