
fScrape.Marinetraffic.ship.info <- function(url){
 
  tryCatch(
      {
        message("This is the 'try' part")
        page <- read_html(url) 
        
        
        bit.measures <- page %>%
          rvest::html_node(
            xpath = '/html/body/main/div/div/div[1]/div[6]/div[1]/div[1]/div'
          )%>%
          html_nodes('span') %>% html_text()
        
        bit.m <- bit.measures %>% str_replace_all('\\s+', ' ') %>%
          trimws() %>% str_replace(':', '')
        
        bit.values <- page %>%
          rvest::html_node(
            xpath = '/html/body/main/div/div/div[1]/div[6]/div[1]/div[1]/div'
          ) %>%
          html_nodes('b') %>% html_text()
        bit.v <- bit.values %>% trimws()
        
        the.table <- tibble(measures = bit.m,
                            values = bit.v)
        
        ##
        ship.class <- page %>% 
          rvest::html_node(
            xpath = '/html/body/main/div/div/div[1]/div[5]/div/div/div[1]/div[2]/a[2]'
          ) %>%
          html_text()
        
        ship.class <- str_replace_all(ship.class, '\\s+', ' ') %>%
          str_replace('\\n','') %>% trimws()
        
        ## 
        ship.name <- page %>% 
          rvest::html_node(
            xpath = '/html/body/main/div/div/div[1]/div[5]/div/div/div[1]/div[1]/h1'
          ) %>%
          html_text()
        
        the.table <- rbind(the.table, c('Vessel type', ship.class))
        the.table <- rbind(the.table, c('Vessel name', ship.name))
        
        the.table$pk <- url
        
        # simple cleaning
        d.out <- the.table %>% 
          select(pk, measures, values)
        
        class(d.out) <- c(class(d.out), 'marine-traffic.ship-info')
        
        return(d.out)
        
      },
      error = function(cond) {
        message(paste("URL does not seem to exist:", url))
        message("Here's the original error message:")
        message(cond)
        return(NA)
      })

}
