fScrape.Faxafloahafnir.ship.urls <- function( 
  url = 'https://www.faxafloahafnir.is/en/'
){
  
    page <- read_html(url)
    
    ship.names <- page %>% 
      rvest::html_node(xpath = '//*[@id="enShipTable3"]/table') %>%
      html_table() %>% as_tibble()
      
    marine.traffic.url <- page %>% 
      rvest::html_node(xpath = '//*[@id="enShipTable3"]/table/tbody') %>%
      html_nodes('tr') %>% html_nodes('a') %>%
      html_attr('href')
  
    name.refs <- cbind(
      ship.names %>% select(Name), 
      marine.traffic.url)
    
    the.table <- unique(name.refs)
  
  the.table  <- as_tibble(the.table)
  
  the.table <- the.table %>%
    mutate(
      Name = as.character(Name),
      marine.traffic.url = as.character(marine.traffic.url),
      pk = Name %>% toupper %>% trimws()
      )
    
  class(the.table) <- c(class(the.table), 'faxafloahafnir.marine_traffic.urls')
  
  the.table$visited = FALSE
  return(the.table)
}
