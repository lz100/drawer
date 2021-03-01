
# UI
uiBtns <- function(id) {
  ns <- NS(id)
  fluidRow(
      tabTitle("Work with capture buttons"),
      div(
        class = "text-minor",
        markdown(
          '
          - use `spsCodeBtn` to capture an element (defined by the developer), usually by the HTML `id`
          - use `toCanvasTextBtn` to capture any element (defined by the user input).
            Note: it uses CSS selector, a little difference is you need to add "#"
            before the `id`, like "#my_id".
          '
        )
      ),
      spsCodeBtn(
        id = ns("code"), show_span = TRUE,
        '
        library(shiny)
        library(ggplot2)
        ui <- fluidPage(
          fluidRow(
            id = "new_row",
            column(
              6,
              h3("this is a title"),
              column(6, tags$label("plot 1"), plotOutput("plot_1")),
              column(6, tags$label("plot 2"), plotOutput("plot_2")),
            ),
            column(
              6,
              h2("To canvas buttons"),
              h4("pure button with `toCanvasBtn`"),
              toCanvasBtn(
                dom = "plot_1",
                label = "capture plot 1",
                canvasID = "canvas_b"
              ), br(),
              toCanvasBtn(
                dom = "capture_button",
                label = "capture this button itself",
                canvasID = "canvas_b",
                id = "capture_button"
              ), br(),
              toCanvasBtn(
                dom = "#new_row .col-sm-6:first-of-type",
                label = "complex selector to select left column",
                canvasID = "canvas_b",
                isID = FALSE
              ), br(),
              h4("button text input for any part of document with `toCanvasBtn`"),
              toCanvasTextBtn(
                label = "try #plot_2 to for plot 2 or other selector",
                canvasID = "canvas_b",
                text_value = "#plot_2"
              )
            )
          ),
          canvas("canvas_b")
        )

        server <- function(input, output, session) {
          output$plot_1 <- renderPlot({
            ggplot(mpg, aes(cty, hwy)) +
              geom_count(col="tomato3", show.legend=F)
          })
          output$plot_2 <- renderPlot({
            ggplot(mpg, aes(cty, hwy)) +
              geom_point()
          })
        }
        '
      ), spsHr(),
      fluidRow(
        id = ns("new_row"),
        column(
          6,
          h3("this is a title"),
          column(6, tags$label("plot 1"), plotOutput("plot_1")),
          column(6, tags$label("plot 2"), plotOutput("plot_2")),
        ),
        column(
          6,
          h2("To canvas buttons"),
          h4("pure button with `toCanvasBtn`"),
          toCanvasBtn(
            dom = "plot_1",
            label = "capture plot 1",
            canvasID = "canvas_b"
          ), br(),
          toCanvasBtn(
            dom = ns("capture_button"),
            label = "capture this button itself",
            canvasID = "canvas_b",
            id = ns("capture_button")
          ), br(),
          toCanvasBtn(
            dom = "#btns-new_row .col-sm-6:first-of-type",
            label = "complex selector to select left column",
            canvasID = "canvas_b",
            isID = FALSE
          ), br(),
          h4("button text input for any part of document with `toCanvasBtn`"),
          toCanvasTextBtn(
            label = "try #plot_2 to for plot 2 or other selector",
            canvasID = "canvas_b",
            text_value = "#plot_2"
          )
        )
      ),
      canvas("canvas_b", on_start = 'li [href=\'#shiny-tab-btns\']')
  )
}

# Server
serverBtns <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}
