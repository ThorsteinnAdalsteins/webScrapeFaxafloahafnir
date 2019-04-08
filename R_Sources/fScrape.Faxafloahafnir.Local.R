fScrape.Faxafloahafnir.Local <- function(
  local.path = './_OnnurGogn', file.no = NA
  ){
  
  files <- list.files(path = local.path, pattern = '.html', full.names = TRUE)
  
  if(is.na(file.no)){file.no = length(files)}
    
  page <- read_html(files[file.no])
    
    ts <- page %>% rvest::html_node(xpath = '//*[@id="enShipTable3"]/table')
    the.table <- ts %>% html_table()

  
  the.table  <- as_tibble(the.table)
  class(the.table) <- c(class(the.table), 'faxafloahafnir.raw')

  return(the.table)
}
