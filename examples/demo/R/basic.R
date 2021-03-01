
# UI
uiBasic <- function(id) {
  ns <- NS(id)
  fluidRow(
      tabTitle("Basic usage"),
      div(
        class = "text-minor",
        markdown(
          '
          - Use `canvas` to create a the canvas working area.
          - Try to drag an image locally to the canvas.
          '
        )
      ),
      spsCodeBtn(
        id = ns("code"), show_span = TRUE,
        '
        library(shiny)

        ui <- fluidPage(
          h3("Try to drag pictures locally to canvas"),
          canvas("canvas_a")
        )

        server <- function(input, output, session) {

        }

        shinyApp(ui, server)
        '
      ),
      canvas("canvas_a", on_start = 'li [href=\'#shiny-tab-basic\']')
  )
}

# Server
serverBasic <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}
