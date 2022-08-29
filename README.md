
# meps

This package contains a data set of all members of the European
Parliament, for all parliamentary terms (1 through 8).

Please cite as follows:

> Nicolò Fraccaroli, Alessandro Giovannini, Jean-François Jamet, Eric
> Persson, Ideology and monetary policy. The role of political parties’
> stances in the European Central \> Bank’s parliamentary hearings,
> European Journal of Political Economy, 2022, 102207, ISSN 0176-2680,
> <https://doi.org/10.1016/j.ejpoleco.2022.102207>.

## Installation

You can install the development version with:

``` r
devtools::install_github("expersso/meps")
```

## Example

``` r
library(tibble)
library(meps)
head(meps)
#> # A tibble: 6 x 8
#>   id    full_name      pterm pg           np          country  pg_full  np_full 
#>   <chr> <chr>          <int> <chr>        <chr>       <chr>    <list>   <list>  
#> 1 1802  Victor ABENS       1 Socialist G~ Parti ouvr~ Luxembo~ <tibble~ <tibble~
#> 2 1802  Victor ABENS       2 Socialist G~ Parti ouvr~ Luxembo~ <tibble~ <tibble~
#> 3 1427  Gordon J. ADAM     1 Socialist G~ Labour Par~ United ~ <tibble~ <tibble~
#> 4 1427  Gordon J. ADAM     2 Socialist G~ Labour Par~ United ~ <tibble~ <tibble~
#> 5 1427  Gordon J. ADAM     3 Socialist G~ Labour Par~ United ~ <tibble~ <tibble~
#> 6 1427  Gordon J. ADAM     4 Group of th~ Labour Par~ United ~ <tibble~ <tibble~
```

Note that the last two columns are lists of data frames, and may not
print properly without the `tibble` package. See the documentation
`?meps::meps` for explanations of what information these columns
contain.
