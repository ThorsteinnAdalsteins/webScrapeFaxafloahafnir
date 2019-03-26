fSet.marine.traffic.site.as.visited <- function(urls, db, set.to = TRUE){
  # changes the flag "visited" in the db-dataframe from False to True
  this.class <- class(db)
  
  # þarf breyti yfir í data.frame til að geta notað einfaldari for-lúppu
  db <- as.data.frame(db)
  for(i in seq(urls)){
    db$visited[ db$marine.traffic.url == urls[i]] <- set.to
  }
  
  db <- as_tibble(db)
  class(db) <- this.class
  
  return(db)
}

