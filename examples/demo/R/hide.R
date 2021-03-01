
# UI
uiHide <- function(id) {
  ns <- NS(id)
  fluidRow(
      tabTitle("canvas hidden on start"),
      div(
        class = "text-minor",
        markdown(
          '
          In the following example (Canvas C-F), you will see if the canvas is hidden,
          not on the first tab in a `tabsetPanel`, or other similar
          UI where you do not see canvas on start. Then, the canvas
          cannot be initiate properly using the default height value (100vh).
          Using the dynamic computed CSS height like "100%", or "100vh" with "hidden"
          (display = none) elements give the height of `0` on start.
          So, you **should not see the canvas** on this "Canvas C", but a broken
          structure and no canvas grid.

          To fix it, either give it a fixed `height` and `width` pixel unit, like

          - `height = "800px"`, `width = "1500px"`

          or bind the initiation event to a click of a button, the tab title or
          any other element you specify with the `on_start` argument. See the
          example code and watch how we do it in "canvas D-F".
          '
        )
      ),
      spsCodeBtn(
        id = ns("code"), show_span = TRUE,
        '
        library(shiny)

        ui <- fluidPage(
          tabsetPanel(
            id = "tabs",
            tabPanel(
              "Home page",
              value = "tab_1",
              h4("Content on home page ...."),
              p("Canvas is hidden on start, go to other tabs")
            ),
            tabPanel(
              "Canvas C",
              value = "tab_2",
              canvas(canvasID = "canvas_c")
            ),
            tabPanel(
              "Canvas D",
              value = "tab_3",
              h4("Initiate canvas by a button"),
              actionButton("start_canvas", "Start Canvas C"),
              canvas(
                canvasID = "canvas_d",
                on_start = "#start_canvas"
              )
            ),
            tabPanel(
              "Canvas E",
              value = "tab_4",
              h4("Initiate canvas by clicking tab title"),
              p("Canvas initiate when first time users come to this tab"),
              canvas(
                canvasID = "canvas_e",
                on_start = "#tabs li a[data-value=\'tab_4\']"
              )
            ),
            tabPanel(
              "Canvas F",
              value = "tab_5",
              h4("Initiate canvas with fixed height and width"),
              canvas(
                canvasID = "canvas_f",
                height = "800px",
                width = "1500px"
              )
            )
          )
        )

        server <- function(input, output, session) {

        }
        '
      ), spsHr(),
      tabsetPanel(
        id = "tabs",
        tabPanel(
          "Home page",
          value = "tab_1",
          h4("Content on home page ...."),
          p("Canvas is hidden on start, go to other tabs")
        ),
        tabPanel(
          "Canvas C",
          value = "tab_2",
          canvas(canvasID = "canvas_c")
        ),
        tabPanel(
          "Canvas D",
          value = "tab_3",
          h4("Initiate canvas by a button"),
          actionButton("start_canvas", "Start Canvas C"),
          canvas(
            canvasID = "canvas_d",
            on_start = "#start_canvas"
          )
        ),
        tabPanel(
          "Canvas E",
          value = "tab_4",
          h4("Initiate canvas by clicking tab title"),
          p("Canvas initiate when first time users come to this tab"),
          canvas(
            canvasID = "canvas_e",
            on_start = "#tabs li a[data-value='tab_4']"
          )
        ),
        tabPanel(
          "Canvas F",
          value = "tab_5",
          h4("Initiate canvas with fixed height and width"),
          canvas(
            canvasID = "canvas_f",
            height = "800px",
            width = "1500px"
          )
        )
      )
  )
}

# Server
serverHide <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}
