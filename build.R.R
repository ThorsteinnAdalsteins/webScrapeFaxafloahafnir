
source('./R_Sources/__init__.R')


# project: 
#  1) get the main table
#  2) clean the main table - slightly
#     -- build a pk
#  3) check if the pk exists in a db file (dput) and update/insert new entries into the file

raw.table <- fScrape.Faxafloahafnir.Ladingsite()
cleaned.table <- fClean.raw.Faxafloahafnir.Landingside(raw.table)
db <- fUpdate.db.komur.brottfarir(cleaned.table)

# hér geta komið inn villur, þar sem komur og brottfarir skipa geta hnikast til um einn til tvo daga.
# það væri því gagnlegt að skoða hvort að skipið sé að fara tvisvar úr höfn, en það er sennilega of flókið í fyrstu umferð

# til að sækja gögn sem eru komin
db <- fGet.db.komur.brottfarir()


# næstu verkefni
## 1) sækja upplýsingar um skip úr Marine Traffic
##   -- fá sérstaklega fána skipsins
##   
