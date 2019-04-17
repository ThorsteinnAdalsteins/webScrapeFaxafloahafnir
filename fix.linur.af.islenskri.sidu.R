
# hér urðu mér á mistök, þar sem ég sótti óvart íslensku síðuna í stað ensku síðuna
# við þetta komu of margar línur inn í grunninn minn+
# ég þarf því a 1) þýða íslensku línurnar
#               2) reikna nýjan lykil
#               3) fjarlægja auka línur
#               4) skrifa nýjan grunn

db.komur.brottfarir 


# Bý til vörpun á milli íslensku og ensku titlanna sem hafa áhrif á pk
action.ISEN <- tibble(
  IS = c('Kemur', 'Færsla', 'Fer'),
  EN = c('Arrives', 'Shifts', 'Departs'),
  key = c('A', 'S', 'D')
  )

type.ISEN <- tibble(
  IS = c('flutningaskip', 'fiskiskip', 'tankskip', 'rannsóknar- og eftirlitsskip', 
         'farþegaskip', 'Önnur skip', 'herskip'),
  EN = c('Cargo ship', 'Fishing ship', 'Tankship', 'Research survey vessel',
         'Passenger ship', 'Other ship', 'Navy ship'),
  key = c('C', 'F', 'T', 'R', 'P', 'O', 'N')
)

# skipti grunninum í íslenska og enska útgáfu
db.en <- db.komur.brottfarir[-which(db.komur.brottfarir$Action %in% action.ISEN$IS),]
db.is <- db.komur.brottfarir[which(db.komur.brottfarir$Action %in% action.ISEN$IS),]

# þýði íslenka hlutann
db.isen <- db.is %>% 
  # sæki þýðingar
  inner_join(action.ISEN, by=c('Action'='IS')) %>%
  # vel dálka og ýti út íslensku action
  select(Name, Type, Action = EN, Location,
         Time, BT, pk) %>%
  # sæki þýðingar
  inner_join(type.ISEN, by = c('Type'='IS')) %>%
  select(Name, Type = EN, Action, Location,
         Time, BT, pk) %>%
  # reikna nýjan pk
  mutate(
    pk = str_c(
      Name %>% toupper()%>% trimws(),
      Action %>% str_sub(end = 1),
      year(Time), 
      month(Time),
      day(Time), sep = ':' ))


tvofaldar.linur <- db.isen[-which(db.isen$pk %in% db.en$pk),]

# bæti nýjum línum inn
db.enen <- rbind(db.en, db.isen[-tvofaldar.linur,])

# geymi grunninn upp á nýtt
db.komur.brottfarir <- fUpdate.db.file(
  db.enen, './_GognUt/faxafloahafnir.komur.brottfarir.dput'
)

