
header <- dashboardHeader(
  title = "drawer"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Welcome", tabName = "welcome", icon = icon("star")),
    menuItem("Basic", tabName = "basic", icon = icon("minus")),
    menuItem("Multiple", tabName = "multi", icon = icon("align-justify")),
    menuItem("Capture buttons", tabName = "btns", icon = icon("square")),
    menuItem("Start as hidden", tabName = "hide", icon = icon("eye-slash"))
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(href = "demo.css", rel = "stylesheet"),
    tags$link(href = "https://github.com/lz100/drawer/blob/master/img/drawer.png?raw=true", rel = "icon"),
  ),
  tabItems(
    tabItem(tabName = "welcome", uiWelcome("welcome")),
    tabItem(tabName = "basic", uiBasic("basic")),
    tabItem(tabName = "multi", uiMulti("multi")),
    tabItem(tabName = "btns", uiBtns("btns")),
    tabItem(tabName = "hide", uiHide("hide"))
  )
)


ui <- dashboardPage(
  header = header,
  sidebar = sidebar,
  body =  body,
  title = "drawer Demo"
)



