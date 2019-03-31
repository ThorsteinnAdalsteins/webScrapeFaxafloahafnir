
rm(list = ls())
source('./R_Sources/__init__.R')
require(lubridate)

## framleiðsluvörur þessarar skriftu
db.komur.brottfarir <- dget('./_GognUt/faxafloahafnir.komur.brottfarir.dput')
db.mt.urls <- dget('./_GognUt/marine.traffic.urls.dput' )
db.mt.vessel.info <- dget('./_GognUt/marine-traffic.ship.info.dput')

## ###############################################################################
##  Fyrsta verkefni
## ###############################################################################
##  1) Sækja komur og brottfarir af vefsíðunni
##    - hreinsa gögn og geyma
##  2) Útbúa aðferð til að geyma bara breytingar án þess að tapa eldri færslum
##
## ###############################################################################

raw.table <- fScrape.Faxafloahafnir.Ladingsite()
cleaned.table <- fClean.raw.Faxafloahafnir.Landingside(raw.table)

db.komur.brottfarir <- fUpdate.db.file(
  cleaned.table, './_GognUt/faxafloahafnir.komur.brottfarir.dput'
)

# taka til
rm(raw.table, cleaned.table)

# hér geta komið inn villur, þar sem komur og brottfarir skipa geta hnikast til um einn til tvo daga.
# það væri því gagnlegt að skoða hvort að skipið sé að fara tvisvar úr höfn, en það er sennilega of flókið í fyrstu umferð



## ##################################################
## næsta verkefni
## ##################################################
##  1) Sækja vefhlekki á Marine Traffic síðu fyrir skip
##    -- Geyma lista af þessum hlekkjum
##    -- Halda utan um uppfærslur
##  2) sækja upplýsingar um skip úr Marine Traffic
##    -- fá sérstaklega fána skipsins
##    -- merkja við í lista ef búið er að fara á slóðina
##       til þess að það sé ekki farið of oft inn á slóðir
##  3) Hreinsa gögnin og geyma breytingar
##
## ##################################################
mt.urls <- fScrape.Faxafloahafnir.ship.urls()
db.mt.urls <- fUpdate.db.file( mt.urls, './_GognUt/marine.traffic.urls.dput' )

# Sæli url sem eru ný (visited == FALSE)
mt.urls.left <- db.mt.urls %>% filter(!visited) %>% select(marine.traffic.url)

# fer inn á mt og sæki gögnin
mt.table.raw <- fScrapeAll.Marinetraffic.ship.info(
  mt.urls.left$marine.traffic.url,
  db.fyrir.urls = './_GognUt/marine.traffic.urls.dput'
  )
mt.urls.db <- dget('./_GognUt/marine.traffic.urls.dput')
mt.urls.left <- mt.urls.db %>% filter(!visited) %>% select(marine.traffic.url)

# hreinsa gögnin

## hér er eitthvað týnt
marine_traffic.clean <- fClean.raw.marine_traffic.table(mt.table.raw)

mt.vessel.info.db <- fUpdate.db.file(
  marine_traffic.clean, 
  './_GognUt/marine-traffic.ship.info.dput'
  )

# taka til
rm(mt.urls, mt.urls.left, mt.table.raw, marine_traffic.clean)

db.mt.vessel.info %>% view()


# exporta gögnum
db.komur.brottfarir <- dget('./_GognUt/faxafloahafnir.komur.brottfarir.dput')
write.csv(db.komur.brottfarir, './_GognUt/faxafloahafnir_komur_brottfarir.csv',
          row.names = FALSE)
# óþarfi db.mt.urls <- dget('./_GognUt/marine.traffic.urls.dput' )
db.mt.vessel.info <- dget('./_GognUt/marine-traffic.ship.info.dput')
write.csv(db.mt.vessel.info, './_GognUt/faxafloahafnir_skip.csv', row.names = FALSE)

## #############################################################################
##  Næsta verkefni
## #############################################################################
##  1) Tengjast inn á data.world
##  2) Geyma gögnin þar inni