
fUpdate.db.komur.brottfarir <- function(
  cleaned.table,
  db.filename = './_GognUt/faxafloahafnir.komur.brottfarir.dput'
){
  
  if(!('faxafloahafnir.clean' %in% class(cleaned.table))){
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