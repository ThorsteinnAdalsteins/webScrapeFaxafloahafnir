
fScrapeAll.Marinetraffic.ship.info <- function(
  urls, 
  db.fyrir.urls = './_GognUt/marine.traffic.urls2.dput'
){
  
  if(class(urls) != 'character'){stop('urls þarf að vera character vektor')}
  if(length(urls) == 0){stop('urls var tómur')}  
  
  if(!file.exists(db.fyrir.urls)){
    stop('Gátlistinn fyrir mt.url fannst ekki')
  } else {
    urls.db <- dget(db.fyrir.urls)
  } 
  if(!("faxafloahafnir.marine_traffic.urls" %in% class(urls.db))){
    stop('Tékklistinn fyrir mt.url er af rangri tegund')
  }
  
  # sæki upplýsingarnar
  b.list <- lapply(urls, fScrape.Marinetraffic.ship.info)
  # hreinsa út ónýtar línur
  b.list <- b.list[sapply(b.list, function(x){all(class(x) != 'logical')})]
  # bind í eina töflu
  b.table <- do.call(rbind, b.list)
  
  # geng frá gátlistanum og skrifa aftur á diskinn
  
  message('Uppfæri gögnin í: ', db.fyrir.urls, ', muna að sækja skjalið aftur')
  for(i in seq(urls)){
    urls.db <- fSet.marine.traffic.site.as.visited(urls[i], urls.db, set.to = TRUE)
  }
  dput(urls.db, db.fyrir.urls)
  
  return(b.table)
}
