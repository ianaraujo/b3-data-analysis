library(tidyverse)
library(magrittr)
library(rvest)

url <- "https://www.fundamentus.com.br/detalhes.php"

generate_url <- function(base_url, c) {
  string <- glue::glue('{url}?papel={c}')
  return(string |> as.character())
}

html <- rvest::read_html(url)

lista_cdg <- html %>%
  rvest::html_element("table") %>% rvest::html_table() %>%
  dplyr::pull(Papel)

lista_urls <- purrr::map_chr(lista_cdg, ~ generate_url(url, c = .x))

# ...

html_idx <- rvest::read_html(lista_urls[1])

table_idx <- html_idx %>% rvest::html_elements(".w728") %>% rvest::html_table()

table_idx <- table_idx[[3]][-1, 3:ncol(table_idx[[3]])]

df_idx <- tibble(idx = c(table_idx$X3, table_idx$X5), 
                 value = c(table_idx$X4, table_idx$X6))

df_idx$idx <- str_remove(df_idx$idx, "[[:punct:]]")

# Limpeza dos dados antes de transformar em pivot_longer
                         
                         