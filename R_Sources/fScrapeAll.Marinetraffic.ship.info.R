fScrapeAll.Marinetraffic.ship.info <- function(urls){
  
  this.list <- lapply(urls, fScrapeAll.Marinetraffic.ship.info)
  df <- do.call(rbind, this.list)
  return(df)
}
