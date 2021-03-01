
#' @importFrom glue glue glue_collapse
#' @importFrom magrittr %>%
#' @importFrom utils packageVersion
#' @importFrom htmltools div HTML h1 h2 h3 h4 h5 tags tagList p
#' @importFrom shiny icon
NULL

#' Add online content
#' @noRd
#'
.onLoad <- function(...) {
    shiny::addResourcePath('drawer', system.file("assets", package = "drawer"))
}
