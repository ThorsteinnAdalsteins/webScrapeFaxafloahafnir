fScrape.Faxafloahafnir.ship.urls <- function( 
  url = paste0('https://www.faxafloahafnir.is/en/')
){
  
  try(
    
    page <- read_html(url),
    
    ship.names <- page %>% 
      rvest::html_node(xpath = '//*[@id="enShipTable3"]/table') %>%
      html_table() %>% as_tibble(),
      
    marine.traffic.url <- page %>% 
      rvest::html_node(xpath = '//*[@id="enShipTable3"]/table/tbody') %>%
      html_nodes('tr') %>% html_nodes('a') %>%
      html_attr('href'),
  
    name.refs <- cbind(
      ship.names %>% select(Name), 
      marine.traffic.url),
    
    the.table <- unique(name.refs)
  )
  
  the.table  <- as_tibble(the.table)
  class(the.table) <- c(class(the.table), 'faxafloahafnir.marine_traffic.urls')
  
  return(the.table)
}
