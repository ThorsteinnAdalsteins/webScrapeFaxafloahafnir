source('./R_Sources/__init__.R')

# project: 
#  1) get the main table
#  2) clean the main table - slightly
#     -- build a pk
#  3) check if the pk exists in a db file (dput) and update/insert new entries into the file

raw.table <- fScrape.Faxafloahafnir.Ladingsite()
cleaned.table <- fClean.raw.Faxafloahafnir.Landingside(raw.table)

db.komur.brottfarir <- fUpdate.db.file(
  cleaned.table, './_GognUt/faxafloahafnir.komur.brottfarir.dput'
)

# hér geta komið inn villur, þar sem komur og brottfarir skipa geta hnikast til um einn til tvo daga.
# það væri því gagnlegt að skoða hvort að skipið sé að fara tvisvar úr höfn, en það er sennilega of flókið í fyrstu umferð

# til að sækja gögn sem eru komin
db.old <- fGet.db.komur.brottfarir()


# næstu verkefni
## 1) sækja upplýsingar um skip úr Marine Traffic
##   -- fá sérstaklega fána skipsins
##   
mt.urls <- fScrape.Faxafloahafnir.ship.urls()
mt.urls.db <- fUpdate.db.file( mt.urls, './_GognUt/marine.traffic.urls.dput' )

# processing the urls that are new:

mt.urls.left <- mt.urls.db %>% filter(!visited) %>% select(marine.traffic.url)
# mt.urls.db <- dget('./_GognUt/marine.traffic.urls.dput' )

if(length(mt.urls.left)!= 0){
  b.list <- lapply(mt.urls.left, fScrape.Marinetraffic.ship.info)
  
  for(i in seq(mt.urls.left)){
    mt.urls.db <- fSet.marine.traffic.site.as.visited(mt.urls.left[i], mt.urls.db)
  }
  dput(mt.urls.db, './_GognUt/marine.traffic.urls.dput')
  
}

# hreinsun á mt útkomunni

a.list <- b.list[sapply(b.list, function(x){all(class(x) != 'logical')})]
a.table <- do.call(rbind, a.list)

a.table <- a.table %>% select(-vessel_pk) %>%
  rename(pk = page) %>%
  mutate(measures = str_replace_all(measures, '\\s', '.'))

s.table <- spread(a.table, key = measures, value = values) %>% view()

class(s.table) <- c(class(s.table), 'marine-traffic.ship.info')

##

ship.info <- fUpdate.db.file(
  s.table, './_GognUt/marine-traffic.ship.info.dput'
)

