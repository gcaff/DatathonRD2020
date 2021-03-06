# Código para importar y concatenar otras variables e indicadores

library(readr)

rm(list=ls())

d <- read.csv("../../data/DATA_RETO_2.csv")

# num airports
airports <- read_table("../../data/otros_indicadores/cia_num_airports.txt", col_names = F)

airports <- airports[,2:3]
colnames(airports) <- c("country","n_airports")

dd <- d %>%
  left_join(airports, by="country")

# aeropuertos por millon de habitantes
dd1 <- dd %>%
  select(country,country_code,iso,n_airports,population) %>%
  mutate(airports_per_pop = 1e6*n_airports/population) %>% #num airports por millon de hab
  select(-population)

# tourism
tourism <- read.csv("../../data/otros_indicadores/tourism_num_arrivals.csv",skip = 4)

tourism <- tourism[,c(2,62:63)]

colnames(tourism) <- c("iso","tourism_2017","tourism_2018")

dd2 <- dd1 %>%
  left_join(tourism,by="iso") 

# temperatura y precipitacion

d_temp <- readxl::read_xlsx("../../data/otros_indicadores/temperature.xlsx",sheet = 4) # temperatura

d_precip <- readxl::read_xlsx("../../data/otros_indicadores/temperature.xlsx",sheet = 5) # precipitacion

d_temp <- d_temp %>%
  select(iso = ISO_3DIGIT,
         temperatura = Annual_temp)

d_precip <- d_precip %>%
  select(iso = ISO_3DIGIT,
         precip = Annual_precip)

dd3 <- dd2 %>%
  left_join(d_temp,by="iso") %>%
  left_join(d_precip,by="iso")

# porcentaje poblacion rural
pob_rural <- readxl::read_xlsx("../../data/otros_indicadores/porcentaje_poblacion_rural.xlsx",sheet = 1)

pob_rural <- pob_rural %>%
  select(iso=`Country Code`,
         PERC_POBLACION_RURAL)

dd4 <- dd3 %>%
  left_join(pob_rural, by="iso")

# prison pop
prison <- readxl::read_xlsx("../../data/otros_indicadores/prison_pop.xlsx",sheet = 1)

prison <- prison[18:nrow(prison),2:3] #contar a partir del primer pais

colnames(prison) <- c("country","prison_pop")

dd5 <- dd4 %>%
  left_join(prison, by="country")

# health & education statistics (WorldBank)
datosWB <- readxl::read_xlsx("../../data/otros_indicadores/datosWB1.xlsx",sheet = 1)

datosWB[datosWB == ".."] <- NA # reemplazar .. por NAs

datosWB$indicador <- coalesce(!!!datosWB[14:5]) # hacer coalesce escogiendo el indicador del ultimo anio

datosWB <- datosWB %>%
  select(iso=`Country Code`,
         name=`Series Name`,
         indicador)

datosWB$name[datosWB$name == "GDP per capita, PPP (current international $)"] <- "gdp_per_capita_ppp"
datosWB$name[datosWB$name == "Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population)"] <- "extreme_poverty"
datosWB$name[datosWB$name == "Mortality from CVD, cancer, diabetes or CRD between exact ages 30 and 70 (%)"] <- "non_transm_mortality"
datosWB$name[datosWB$name == "Diabetes prevalence (% of population ages 20 to 79)"] <- "diabetes"
datosWB$name[datosWB$name == "Current health expenditure (% of GDP)"] <- "expend_health_tot"
datosWB$name[datosWB$name == "Domestic general government health expenditure (% of GDP)"] <- "expend__health_public"
datosWB$name[datosWB$name == "Prevalence of HIV, total (% of population ages 15-49)"] <- "HIV"
datosWB$name[datosWB$name == "Incidence of tuberculosis (per 100,000 people)"] <- "tuberculosis"
datosWB$name[datosWB$name == "Physicians (per 1,000 people)"] <- "num_physicians"
datosWB$name[datosWB$name == "Literacy rate, adult total (% of people ages 15 and above)"] <- "lit_rate"

datosWB <- datosWB %>%
  filter(!(name %in% c("extreme_poverty"))) %>%
  spread(key=name,value = indicador)

dd6 <- dd5 %>%
  left_join(datosWB, by="iso")

# ciudades
cities <- readxl::read_xlsx("../../data/otros_indicadores/worldcities.xlsx",sheet = 1)

# ciudades con mas de 100,000 hab
cities1 <- cities %>%
  filter(population > 1e5) %>%
  group_by(iso3) %>%
  count() %>%
  rename(n_cities_1=n)

# ciudades con mas de 1,000,000 hab
cities2 <- cities %>%
  filter(population > 1e6) %>%
  group_by(iso3) %>%
  count() %>%
  rename(n_cities_2=n)

# ciudades con mas de 5,000,000 hab
cities3 <- cities %>%
  filter(population > 5e6) %>%
  group_by(iso3) %>%
  count() %>%
  rename(n_cities_3=n)

# ciudades con mas de 10,000,000 hab
cities4 <- cities %>%
  filter(population > 1e7) %>%
  group_by(iso3) %>%
  count() %>%
  rename(n_cities_4=n)

# concatenar
cities <- cities1 %>%
  left_join(cities2,by="iso3") %>%
  left_join(cities3,by="iso3") %>%
  left_join(cities4,by="iso3") %>%
  rename(iso=iso3)

cities[is.na(cities)] <- 0
  
dd7 <- dd6 %>%
  left_join(cities, by="iso")

dd7 %>%
  write.csv(file = "../../data/otros_indicadores/otros_indicadores.csv",
            row.names = F)

#193 us
#187 turkey
#96 italy
#173 spain
#39 china
#98 japan

# # estandarizar
# dx <- d
# dx$population <- log(dx$population)
# dx$cumulative_cases <- log(dx$cumulative_cases)
# dx$gdp_per_capita <- log(dx$gdp_per_capita)
# 
# dx <- (dx[,-(1:6)]-colMeans(dx[,-(1:6)],na.rm = T))/apply(dx[,-(1:6)],2,function(x) sd(x,na.rm = T))
# 
# dx <- dx[c(39,96,98,173,187,193),-34]
# tdx <- t(dx)
# 
# pairs(tdx)
# 
# tdx[,c(4,6)]

  
