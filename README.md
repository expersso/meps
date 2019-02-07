
# meps

This package contains a data set of all members of the European
Parliament, for all parliamentary terms (1 through 8).

Please cite as follows:

> Eric Persson (2019). meps: Data set on members of the European
> Parliament. R package version 0.0.0.9000.
> <https://www.github.com/expersso/meps>

## Installation

You can install the development version with:

``` r
devtools::install_github("expersso/meps)
```

## Example

``` r
library(tibble)
library(meps)
head(meps)
#> # A tibble: 6 x 8
#>   id    full_name  pterm pg          np          country  pg_full  np_full 
#>   <chr> <chr>      <int> <chr>       <chr>       <chr>    <list>   <list>  
#> 1 1802  Victor AB~     1 Socialist ~ Parti ouvr~ Luxembo~ <tibble~ <tibble~
#> 2 1802  Victor AB~     2 Socialist ~ Parti ouvr~ Luxembo~ <tibble~ <tibble~
#> 3 1427  Gordon J.~     1 Socialist ~ Labour Par~ United ~ <tibble~ <tibble~
#> 4 1427  Gordon J.~     2 Socialist ~ Labour Par~ United ~ <tibble~ <tibble~
#> 5 1427  Gordon J.~     3 Socialist ~ Labour Par~ United ~ <tibble~ <tibble~
#> 6 1427  Gordon J.~     4 Group of t~ Labour Par~ United ~ <tibble~ <tibble~
```

Note that the last two columns are lists of data frames, and may not
print properly without the `tibble` package. See the documentation
`help(meps)` for explanations of what information these columns contain.
