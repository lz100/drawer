

server <- function(input, output, session) {


  serverWelcome("welcome")
  serverBasic("basic")
  serverMulti("multi")
  serverBtns("btns")
  serverHide("hide")

  output$plot_1 <- renderPlot({
    ggplot(mpg, aes(cty, hwy)) +
      geom_count(col="tomato3", show.legend=F)
  })
  output$plot_2 <- renderPlot({
    ggplot(mpg, aes(cty, hwy)) +
      geom_point()
  })
}
