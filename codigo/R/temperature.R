# fuente: Climate Change Knowledge Portal, WB
d_temp <- readxl::read_xlsx("../../data/temperature.xlsx",sheet = 4) # temperatura

d_precip <- readxl::read_xlsx("../../data/temperature.xlsx",sheet = 5) # precipitacion

d_temp <- d_temp %>%
  select(iso = ISO_3DIGIT,
         temperatura = Annual_temp)

d_precip <- d_precip %>%
  select(iso = ISO_3DIGIT,
         precip = Annual_precip)

dd3 <- dd2 %>%
  left_join(d_temp,by="iso") %>%
  left_join(d_precip,by="iso")

dd3 %>%
  write.csv(file = "../../data/otros_indicadores1.csv")