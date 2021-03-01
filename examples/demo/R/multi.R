
# UI
uiMulti <- function(id) {
  ns <- NS(id)
  fluidRow(
    tabTitle("Multiple canvas on the same page"),
    div(
      class = "text-minor",
      markdown(
        '
          - They are independent
          - Dragging from one canvas to another is not supported currently
          '
      )
    ),
    spsCodeBtn(
      id = ns("code"), show_span = TRUE,
      '
        library(shiny)

        ui <- fluidPage(
          h3("multiple canvas on a page"),
          p("They are independent"),
          p("Dragging from one canvas to another is not supported currently"),
          column(6, canvas("canvas_left")),
          column(6, canvas("canvas_right"))
        )

        server <- function(input, output, session) {

        }

        shinyApp(ui, server)
        '
    ), spsHr(),
    column(6, canvas("canvas_left", on_start = 'li [href=\'#shiny-tab-multi\']')),
    column(6, canvas("canvas_right", on_start = 'li [href=\'#shiny-tab-multi\']'))
  )
}

# Server
serverMulti <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}
