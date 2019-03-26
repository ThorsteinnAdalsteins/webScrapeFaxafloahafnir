

fUpdate.db.file <- function(
  cleaned.table, db.filename
){
  # uppfærir geymsluskrá og bætir nýmum línum inn. 
  # ef skráin er ekki til er ný skrá geymd
  # fallir skilar nýju skránni
  known.dbs <- c('faxafloahafnir.marine_traffic.urls', 
                 'faxafloahafnir.clean',
                 'marine-traffic.ship.info')
  
  if(length(dplyr::intersect(
    class(cleaned.table), known.dbs)) == 0){
    stop('Taflan er ekki sótt með réttu falli')
  }
  
  if(!file.exists(db.filename)){
    
    dput(cleaned.table, db.filename)
    return(cleaned.table)
    
  } else {
    
    this.dput <- dget(db.filename)
    
    new.pks <- dplyr::setdiff(cleaned.table$pk, this.dput$pk)
    if(length(new.pks) != 0){
      
      this.dput <- rbind(
        this.dput, cleaned.table %>% filter(pk %in% new.pks)
      )
      
      dput(this.dput, db.filename)
      return(this.dput)
      
    }
    
    return(this.dput)
  }
}
