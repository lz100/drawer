
# UI
uiXx <- function(id) {
  ns <- NS(id)
  fluidRow(
      tabTitle(""),
  )
}

# Server
serverXx <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}
