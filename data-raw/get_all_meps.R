library(tidyverse)
library(glue)
library(rvest)
library(lubridate)

# Input: integer denoting parliamentary term
# Output: data frame with MEP names and IDs for that term
make_df_by_leg <- function(term) {

  get_xml_by_leg <- . %>%
    paste0("http://www.europarl.europa.eu/meps/en/directory/xml?leg=", .) %>%
    read_xml() %>%
    as_list() %>%
    .[[1]]

  make_df <-  . %>% transpose %>% as.data.frame(stringsAsFactors = FALSE)

  term %>%
    get_xml_by_leg() %>%
    map_dfr(make_df) %>%
    mutate(pterm = term) %>%
    tbl_df()
}

# Input: Character string of MEPs ID number
# Output: XML object with details of that MEP's last parliamentary term
get_mep_html <- . %>%
  paste0("http://www.europarl.europa.eu/meps/en/", .) %>%
  read_html()

# Input: An XML object representing an MEP's parliamentary term
# Output: A character string of that MEP's name as it appears in the URL
get_url_name <- . %>%
  html_nodes(xpath = "//li[@class='ep_item']//a[contains(@href, 'history')]") %>%
  .[[1]] %>%
  html_attr("href") %>%
  str_replace("^.*/(.*)/history.*", "\\1")

# Input: An ID, url_name, and parliamentary term
# Output: A string representing the URL of the MEP during that parliamentary term
make_mep_uri_by_pterm <- function(id, url_name, pterm) {
  glue("http://www.europarl.europa.eu/meps/en/{id}/{url_name}/history/{pterm}")
}

# Input: A URI, ID, and pterm
# Output: Downloads the URI
download_mep <- function(uri, id, pterm, dir_meps = "data/meps") {
  path <- file.path(dir_meps, glue("{id}_{pterm}.html"))
  download.file(uri, path)
}

# Input: An XML object
# Output: A character string with the MEP's political group details
get_political_groups <- . %>%
  html_nodes("article") %>%
  html_text(TRUE) %>%
  .[1]

# Input: An XML object
# Output: A character string with the MEP's national party details
get_national_parties <- . %>%
  html_nodes("article") %>%
  html_text(TRUE) %>%
  .[2]

# Input: A character string (of political group/national party details)
# Output: A data frame with all details
clean_group <- function(x) {

  # Suppress warnings due to MEP not having role specified
  suppressWarnings(
    tibble(
      text = str_split(x, "[\n\t\r]+") %>% flatten_chr()
    ) %>%
      separate(text, c("period", "party_role"), " : ") %>%
      separate(period, c("from", "to"), " / ") %>%
      separate(party_role, c("party", "role"), " - ") %>%
      mutate(from = dmy(from), to = dmy(to))
  )
}

clean_party <- function(x) {

  tibble(
    text = str_split(x, "[\n\t\r]+") %>% flatten_chr()
  ) %>%
    separate(text, c("period", "party_role"), " : ") %>%
    separate(period, c("from", "to"), " / ") %>%
    mutate(
      from = dmy(from), to = dmy(to),
      country = str_replace(party_role, ".*\\((.*)\\)$", "\\1"),
      party = str_remove(party_role, " \\(.*\\)$")
    ) %>%
    select(from, to, party, country)
}

# IO
path_meps_raw <- "data-raw/meps_raw.rds"
dir_meps <- "data-raw/meps_html/"
parliamentary_terms <- 1:8

if(!file.exists(path_meps_raw)) {
  meps_raw <- parliamentary_terms %>%
    map_dfr(make_df_by_term) %>%
    nest(pterm) %>%
    mutate(main_page = map(id, ~safely(politely(get_mep_html))),
           url_name  = map_chr(main_page, ~get_url_name(.$result))) %>%
    unnest(data, .preserve = main_page) %>%
    mutate(uri = pmap_chr(list(id, url_name, pterm), make_mep_uri_by_pterm))

  write_rds(meps_raw, path_meps_raw)
}

meps_raw <- read_rds(path_meps_raw)

# pwalk(list(meps_raw$uri, meps_raw$id, meps_raw$pterm), download_mep)

meps <- meps_raw %>%
  mutate(
    path = file.path(dir_meps, glue("{id}_{pterm}.html")),
    page = map(path, read_html),
    pg_full = map(page, ~clean_group(get_political_groups(.))),
    np_full = map(page, ~clean_party(get_national_parties(.))),
    pg = map_chr(pg_full, ~.$party[1]),
    np = map_chr(np_full, ~.$party[1]),
    country = map_chr(np_full, ~.$country[1])
  ) %>%
  rename(full_name = fullName) %>%
  select(id, full_name, pterm, pg, np, country, pg_full, np_full)

write_rds(meps, "data-raw/meps.rds")
usethis::use_data(meps, overwrite = TRUE)
