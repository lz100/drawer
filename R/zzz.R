
#' @importFrom glue glue glue_collapse
#' @importFrom magrittr %>%
#' @importFrom assertthat not_empty assert_that
NULL

#' Add online content
#' @noRd
#'
.onLoad <- function(...) {
    shiny::addResourcePath('drawr', system.file("assets", package = "drawR"))
}
