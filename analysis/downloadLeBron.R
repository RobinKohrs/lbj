library(here)
library(tidyverse)
library(glue)
library(rvest)
library(rajudas)


years = 2004:2023


# download data -----------------------------------------------------------
data = map(years, function(y){
  print(y)
  url = glue("https://www.basketball-reference.com/players/j/jamesle01/gamelog/{y}")

  data = rvest::read_html(url) %>%
    html_element("#pgl_basic") %>%
    html_table() %>%
    janitor::clean_names()

  path = makePath(here(glue("output/seasons/{y}.csv")))

  write_csv(data, path)

  data


})


df = bind_rows(data)

dfClean = df[grepl("[0-9]", df$pts), ] %>%
  mutate(
    pts = as.numeric(pts)
  )


write_csv(dfClean, here("output/lbj.csv"))




