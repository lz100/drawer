# only load things if you are working in Rstudio

if(interactive() && Sys.getenv("RSTUDIO", "") == "1"){
  cat("Welcome to {drawer} package source code development.\n")
  (function(){
    if(length(find.package("devtools", quiet = TRUE)) == 0) return(cat("package {devtools} is required but not installed\n"))
    if(length(find.package("roxygen2", quiet = TRUE)) == 0) return(cat("package {roxygen2} is required but not installed\n"))
    if(length(find.package("pkgdown", quiet = TRUE)) == 0) cat("package {pkgdown} is recommended but not installed\n")
    cat("Load package functions...\n")
    devtools::load_all()
    demo <- file.path("examples", "demo")
    if (dir.exists(demo)){
      cat('To build the example demo:\n setwd("',
          normalizePath(demo), '")', sep = "")
    }
    cat("Load package functions...\n")
    devtools::load_all()
    demo <- file.path("examples", "demo")
    if (dir.exists(demo)){
        cat('To build the example demo:\n setwd("',
            normalizePath(demo), '")', sep = "")
    }
  })()
} else if (interactive()) {
    cat("It is recommended to use Rstudio to develop this package.\n")
}


