fScrape.Faxafloahafnir.Ladingsite <- function(
  url = 'https://www.faxafloahafnir.is/en/'
  ){
  
    page <- read_html(url)
    
    ts <- page %>% rvest::html_node(xpath = '//*[@id="enShipTable3"]/table')
    the.table <- ts %>% html_table()

  
  the.table  <- as_tibble(the.table)
  class(the.table) <- c(class(the.table), 'faxafloahafnir.raw')

  return(the.table)
}
