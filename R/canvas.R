################################ Main Canvas ###############################

#' drawer main canvas workbench compinent
#' @description use this function on Shiny UI or R markdown to create the
#' image editing area.
#'
#' @param canvasID string, an unique HTML ID
#' @param title string, title of the canvas
#' @param height string, css value of initial height of the canvas, like "100vh"
#' for full height current window, "50vh" for half.
#' @param width string, css value of initial width of the canvas
#' @param on_start `TRUE` or a CSS selector. See details
#' @param logo_src string, link of an image you want to display as logo on the
#' top left
#' @param log_link string, a link, when the logo is clicked, where should it jump to
#' @param rmarkdown bool, are you using inside R markdown? If yes, drawer will copy
#' all image icons that required by the canvas to current directory to `./drawer/img/...`
#'
#' @return a HTML component to be added to a Shiny app or document
#' @details
#' ### outside Shiny or Rmarkdown
#' **If you are not working in Shiny or R markdown, you need to add the**
#' **required full "Bootstrap3" javascript and CSS + latest "jquery" dependencies by yourself.**
#'
#' ### height and width
#' There are two options for canvas height and width:
#' - dynamic CSS units like "100vh" (viewpoint height), "100vw" (view point width),
#' or "100%" for both. This kind of units adapt to all kinds of user screen settings.
#'
#' - fixed unit, `px` (pixels). This does not change across users, but fixes
#' the `on_start` problem (read below).
#'
#' ### height
#' - `height`, css style `vh` is safer than `%` is not safe, unless the parent
#' has some defined height, "%" will work. Otherwise, if the parent height is "auto"
#' or not defined, and you choose "100%", canvas will still have 0 height.
#'
#' Width usually does not have this problem. As long as an element is displayed,
#' it has some width.
#'
#'
#' ### `on_start`
#' This argument specify if you want to initiate the canvas when the document is loaded.
#' If `TRUE`, then when the document loading is done, start the canvas. The problem
#' is if you set the height to be "vh" (view height) units and if the canvas is
#' hidden, like in a different tab and not displayed on start, the view height is
#' 0, because it is hidden on another tab (display property is `none`), so it
#' will cause the canvas cannot be initiated properly.
#'
#' The solution is to bind the initiation with a clicking event, like on a tab or a button.
#' For example, make a button on the second tab and bind `on_start` to that button:
#' `on_start = "#buttonID"`. Then when users click on that button, canvas initiate.
#' Remember this is a Jquery CSS selector, which means you need to append "#" in
#' front your button ID.
#'
#' If you want to do it automatically, like clicking on a certain tab, some CSS
#' knowledge may required. For example, in Shiny, you can use [shiny::tabsetPanel]
#' to create a tab panel.
#'
#' ```r
#' tabsetPanel(id = "tabs",
#'     tabPanel("Tab A", value = "A", ...),
#'     tabPanel("Tab B", value = "B", ...),
#'     ...
#' )
#'
#' ````
#' Then, bind to it `canvas(on_start = '#tabs li a[data-value="B"]', ...)`.
#' This means we are selecting the element with ID "tabs", which is the main tabsetPanel
#' ID, then a list item (`li`) which is the tab titles you see on UI, and finally, the
#' link jump to tab B, (`a[data-value="B"]`). See examples for a real case.
#'
#' Another way to fix it is by given the `height` and `width` a fixed pixel unit:
#'
#' ```r
#' canvas(
#'     canvasID = "canvas_f",
#'     height = "900px",
#'     width = "1500px"
#' )
#' ```
#'
#' ### Upload your own image to canvas
#' You can drag your own images to the canvas.
#' Support major image formats, like "jpg", "png", "svg", "gif", "webp", "bmp".
#' Moving images like
#' "gif", "webp" will be animated on left side preview, but will not move on canvas.
#' @export
#'
#' @examples
#' # basic usage
#' if(interactive()){
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     h3("Try to drag pictures locally to canvas"),
#'     canvas("canvas_a")
#'   )
#'
#'   server <- function(input, output, session) {
#'
#'   }
#'
#'   shinyApp(ui, server)
#' }
#'
#' # multiple canvas on a page
#' if(interactive()){
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     h3("multiple canvas on a page"),
#'     p("They are independent"),
#'     p("Dragging from one canvas to another is not supported currently"),
#'     column(6, canvas("canvas_left")),
#'     column(6, canvas("canvas_right"))
#'   )
#'
#'   server <- function(input, output, session) {
#'
#'   }
#'
#'   shinyApp(ui, server)
#' }
#'
#' # with capture buttons buttons
#' if(interactive()){
#'   library(shiny)
#'   library(ggplot2)
#'   ui <- fluidPage(
#'     fluidRow(
#'       id = "new_row",
#'       column(
#'         6,
#'         h3("this is a title"),
#'         column(6, tags$label("plot 1"), plotOutput("plot_1")),
#'         column(6, tags$label("plot 2"), plotOutput("plot_2")),
#'       ),
#'       column(
#'         6,
#'         h2("To canvas buttons"),
#'         h4("pure button with `toCanvasBtn`"),
#'         toCanvasBtn(
#'           dom = "plot_1",
#'           label = "capture plot 1",
#'           canvasID = "canvas_b"
#'         ), br(),
#'         toCanvasBtn(
#'           dom = "capture_button",
#'           label = "capture this button itself",
#'           canvasID = "canvas_b",
#'           id = "capture_button"
#'         ), br(),
#'         toCanvasBtn(
#'           dom = "#new_row .col-sm-6:first-of-type",
#'           label = "complex selector to select left column",
#'           canvasID = "canvas_b",
#'           isID = FALSE
#'         ), br(),
#'         h4("button text input for any part of document with `toCanvasBtn`"),
#'         toCanvasTextBtn(
#'           label = "try #plot_2 to for plot 2 or other selector",
#'           canvasID = "canvas_b",
#'           text_value = "#plot_2"
#'         )
#'       )
#'     ),
#'     canvas("canvas_b")
#'   )
#'
#'   server <- function(input, output, session) {
#'     output$plot_1 <- renderPlot({
#'       ggplot(mpg, aes(cty, hwy)) +
#'         geom_count(col="tomato3", show.legend=F)
#'     })
#'     output$plot_2 <- renderPlot({
#'       ggplot(mpg, aes(cty, hwy)) +
#'         geom_point()
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
#'
#' # start canvas as hidden, initiate later in tab panels
#' if(interactive()){
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     tabsetPanel(
#'       id = "tabs",
#'       tabPanel(
#'         "Home page",
#'         value = "tab_1",
#'         h4("Content on home page ...."),
#'         p("Canvas is hidden on start, go to other tabs")
#'       ),
#'       tabPanel(
#'         "Canvas C",
#'         value = "tab_2",
#'         markdown(
#'           '
#'           # canvas hidden on start
#'           In this example, you will see if the canvas is hidden,
#'           not on the first tab in a `tabsetPanel`, or other similar
#'           UI where you do not see canvas on start. Then, the canvas
#'           cannot be initiate properly using the default height value (100vh).
#'           Using the dynamic computed CSS height like "100%", or "100vh" with "hidden"
#'           (display = none) elements give the height of `0` on start.
#'           So, you **should not see the canvas** on this tab, but a broken
#'           structure and no canvas grid.
#'
#'           To fix it, either give it a fixed `height` and `width` pixel unit, like
#'
#'           - `height = "800px"`, `width = "1500px"`
#'
#'           or bind the initiation event to a click of a button, the tab title or
#'           any other element you specify with the `on_start` argument. See the
#'           example code and watch how we do it in "canvas D-F".
#'           '
#'         ),
#'         canvas(canvasID = "canvas_c",)
#'       ),
#'       tabPanel(
#'         "Canvas D",
#'         value = "tab_3",
#'         h4("Initiate canvas by a button"),
#'         actionButton("start_canvas", "Start Canvas C"),
#'         canvas(
#'           canvasID = "canvas_d",
#'           on_start = "#start_canvas"
#'         )
#'       ),
#'       tabPanel(
#'         "Canvas E",
#'         value = "tab_4",
#'         h4("Initiate canvas by clicking tab title"),
#'         p("Canvas initiate when first time users come to this tab"),
#'         canvas(
#'           canvasID = "canvas_e",
#'           on_start = "#tabs li a[data-value='tab_4']"
#'         )
#'       ),
#'       tabPanel(
#'         "Canvas F",
#'         value = "tab_5",
#'         h4("Initiate canvas with fixed height and width"),
#'         canvas(
#'           canvasID = "canvas_f",
#'           height = "800px",
#'           width = "1500px"
#'         )
#'       )
#'     )
#'   )
#'
#'   server <- function(input, output, session) {
#'
#'   }
#'
#'   shinyApp(ui, server)
#' }
canvas = function(
  canvasID,
  title = "drawer",
  height = "100vh",
  width = "100%",
  logo_src = "drawer/img/drawer.png",
  log_link = "https://github.com/lz100/drawer",
  on_start = TRUE,
  rmarkdown = FALSE
  ) {

  stopifnot(is.character(canvasID) && length(canvasID) == 1)
  stopifnot(is.character(title) && length(title) == 1)
  stopifnot(is.character(height) && length(height) == 1)
  stopifnot(is.character(width) && length(width) == 1)
  stopifnot(is.character(logo_src) && length(width) == 1)
  stopifnot(is.character(log_link) && length(width) == 1)
  stopifnot(is.logical(rmarkdown) && length(rmarkdown) == 1)
  stopifnot(length(on_start) == 1)

  container_height <- if(stringr::str_ends(height, "px")) stringr::str_remove(height, "px") else "\"default\""
  container_width <- if(stringr::str_ends(width, "px")) stringr::str_remove(width, "px") else "\"default\""

  if(rmarkdown) {
    drawer_img_folder <- file.path(getwd(), "drawer")
    dir.create(drawer_img_folder, recursive = TRUE, showWarnings = FALSE)
    file.copy(
      system.file("assets", "img", package = "drawer"),
      drawer_img_folder,
      overwrite = TRUE,
      recursive = TRUE
    )
  }

  div(
    class = "drawer",
    div(
      class = "canvas-box",
      id = canvasID,
      style = paste0(
        "height: ", height, "; ",
        "width: ", width, "; ",
        'display:', if(isTRUE(on_start)) "block; " else "none; "
      ),
      div(
        id = paste0("canvas-banner-", canvasID),
        class = "canvas-banner",
        div(
          class = "banner-items",
          tags$a(
            href = log_link,
            class = "drawer-logo",
            target = "_blank",
            tags$img(src = "drawer/img/drawer.png"),
            tags$span(title)
          ),
        ),
        div(class = "vr"),
        #<li role="separator"  class="divider"></li>
        div(
          class = "banner-items",
          HTML('
        <div class="dropdown item">
          <button class="btn btn-default dropdown-toggle" type="button" id="drop-file" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            File
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" aria-labelledby="drop-file">
            <li class="dropdown-submenu">
              <div class="check-box"></div>
              <a href="#">Save as...</a>
              <ul class="dropdown-menu">
               <li ><a href="#"', paste0('onclick=Drawer["', canvasID, '"].saveAsImg()'), '>png</a></li>
               <li ><a href="#"', paste0('onclick=Drawer["', canvasID, '"].saveAsImg(false)'), '>jpg</a></li>
               <li ><a href="#"', paste0('onclick=Drawer["', canvasID, '"].saveAsSvg()'), '>svg (coming soon...)</a></li>
              </ul>
            </li>
          </ul>
        </div>
        ')
        ),
        div(
          class = "banner-items",
          HTML('
        <div class="dropdown item">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            View
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu dropdown-state" aria-labelledby="dropdownMenu1">
            <li check=true opt-id="grid"><div class="check-box"><i class="fa fa-check"></i></div><a href="#">Grid line</a></li>
            <li check=true opt-id="frame" ><div class="check-box"><i class="fa fa-check"></i></div><a href="#">Frame box</a></li>
            <li check=true opt-id="boundBox" ><div class="check-box"><i class="fa fa-check"></i></div><a href="#">Object bound box</a></li>
            <li check=true opt-id="objInfo" ><div class="check-box"><i class="fa fa-check"></i></div><a href="#">Object info on select</a></li>
          </ul>
        </div>
        ')#<li role="separator"  class="divider"></li>
        ),
        div(
          class = "banner-items",
          HTML('
        <div class="dropdown item">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            Canvas
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu dropdown-state" aria-labelledby="dropdownMenu1" style="min-width: 170px;">
            <li check=true opt-id="limitMove" ><div class="check-box"><i class="fa fa-check"></i></div><a href="#">Limit objects inside grid</a></li>
          </ul>
        </div>
        ')
        ),
        div(
          class = "banner-items",
          HTML('
        <div class="dropdown item">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            Help
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
            <li ><div class="check-box"></div><a href="#" type="button" data-toggle="modal"', paste0('data-target="#', canvasID, "-shortcut-modal\""), '>Keyboard shortcuts</a></li>
            <li ><div class="check-box"></div><a href="#" type="button" data-toggle="modal"', paste0('data-target="#', canvasID, "-help-modal\""), '>About the canvas</a></li>
          </ul>
        </div>
        ')#<li role="separator"  class="divider"></li>
        ),
        div(class = "vr"),
        bannerBtn(
          paste0("canvas-undo-", canvasID),
          tags$i(tags$img(src = "drawer/img/undo.png", width=15, height=15)),
          tip = "undo Ctrl+z",
          onclick = paste0('Drawer["', canvasID, '"].undo()'),
          disabled = ""
        ),
        bannerBtn(
          paste0("canvas-redo-", canvasID),
          tags$i(tags$img(src = "drawer/img/redo.png", width=15, height=15)),
          tip = "redo Ctrl+shift+z",
          onclick = paste0('Drawer["', canvasID, '"].redo()'),
          disabled = ""
        ),
        bannerBtn(
          paste0("canvas-front-", canvasID),
          tags$i(tags$img(src = "drawer/img/tofront.png", width=15, height=15)),
          tip = "bring to front",
          onclick = paste0('Drawer["', canvasID, '"].toFront()')
        ),
        bannerBtn(
          paste0("canvas-forward-", canvasID),
          tags$i(tags$img(src = "drawer/img/forward.png", width=15, height=15)),
          tip = "move forward",
          onclick = paste0('Drawer["', canvasID, '"].toForward()')
        ),
        bannerBtn(
          paste0("canvas-backward-", canvasID),
          tags$i(tags$img(src = "drawer/img/backward.png", width=15, height=15)),
          tip = "move backward",
          onclick = paste0('Drawer["', canvasID, '"].toBackward()')
        ),
        bannerBtn(
          paste0("canvas-back-", canvasID),
          tags$i(tags$img(src = "drawer/img/toback.png", width=15, height=15)),
          tip = "bring to back",
          onclick = paste0('Drawer["', canvasID, '"].toBack()')
        ),
        bannerBtn(
          paste0("canvas-del-", canvasID),
          icon("trash"),
          tip = "delete (del)",
          onclick = paste0('Drawer["', canvasID, '"].delItem()')
        ),
        div(class = "vr"),
        div(
          class = "banner-items",
          tags$select(
            id = paste0("canvas-opacity-", canvasID),
            class = "form-control",
            `data-toggle` = 'tooltip',
            `data-placement` = 'left',
            title = "object opacity",
            onclick = paste0('Drawer["', canvasID, '"].changeOpacity($("#canvas-opacity-', canvasID , '").val())'),
            tags$option("100%", value = 1),
            tags$option("90%", value = 0.9),
            tags$option("80%", value = 0.8),
            tags$option("70%", value = 0.7),
            tags$option("60%", value = 0.6),
            tags$option("50%", value = 0.5),
            tags$option("40%", value = 0.4),
            tags$option("30%", value = 0.3),
            tags$option("20%", value = 0.2),
            tags$option("10%", value = 0.1),
            tags$option("0%", value = 0)
          )
        )
      ),
      div(
        class = "canvas-body",
        style = paste0('height: calc(', height, ' - 42px);'),
        div(
          id = paste0("canvas-left-", canvasID),
          class ="split split-horizontal canvas-left",
          bsplus::bs_accordion(id = paste0("tool-box-", canvasID)) %>%
            bsplus::bs_set_opts(panel_type = "info") %>%
            bsplus::bs_append(
              "Images/ Plots",
              div(
                id = paste0("img-box-", canvasID),
                class = 'canvas-img-box',
                tags$img(draggable="true", src="data:image/png;base64,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", width="125", height="125"),
              )
            ) %>%
            bsplus::bs_append(
              "Text",
              div(
                id = paste0("text-", canvasID),
                class = 'sidebar',
                bannerBtn(
                  paste0("canvas-itext-", canvasID),
                  div_style = "width: 100%",
                  btn_style = "width: 100%",
                  label = "New iText",
                  icon("i-cursor"),
                  tip = "Create new text",
                  onclick = paste0('Drawer["', canvasID, '"].newItext()')
                ),
                tags$hr(),
                bannerBtn(
                  paste0("canvas-bold-", canvasID),
                  icon("bold"),
                  tip = "Bold ctrl+b",
                  onclick = paste0('Drawer["', canvasID, '"].itextBold()')
                ),
                bannerBtn(
                  paste0("canvas-italic-", canvasID),
                  icon("italic"),
                  tip = "italic ctrl+i",
                  onclick = paste0('Drawer["', canvasID, '"].itextItalic()')
                ),
                bannerBtn(
                  paste0("canvas-underline-", canvasID),
                  icon("underline"),
                  tip = "underline",
                  onclick = paste0('Drawer["', canvasID, '"].itextUnderline()')
                ),
                bannerBtn(
                  paste0("canvas-linethrough-", canvasID),
                  icon("strikethrough"),
                  tip = "Linethrough",
                  onclick = paste0('Drawer["', canvasID, '"].itextLinethrough()')
                ),
                bannerBtn(
                  paste0("canvas-superscript-", canvasID),
                  icon("superscript"),
                  tip = "superscript ctrl+.",
                  onclick = paste0('Drawer["', canvasID, '"].itextSuperScript()')
                ),
                bannerBtn(
                  paste0("canvas-subscript-", canvasID),
                  icon("subscript"),
                  tip = "subscript ctrl+,",
                  onclick = paste0('Drawer["', canvasID, '"].itextSubScript()')
                ),
                bannerBtn(
                  paste0("canvas-removeformat-", canvasID),
                  icon("remove-format"),
                  tip = "remove script Ctrl+shift+.",
                  onclick = paste0('Drawer["', canvasID, '"].itextRemoveFormat()')
                ),
                tags$hr(),
                div(
                  class = "banner-items color-picker",
                  tags$input(id = paste0("canvas-text-fill-", canvasID), value = "black"),
                  tags$p("Text Fill color", style='display: inline;'),

                ),
                div(
                  class = "banner-items color-picker",
                  tags$input(id = paste0("canvas-text-bg-", canvasID), value = "white"),
                  tags$p("Text background color", style='display: inline;'),

                )
              )
            )
        ),
        div(
          id = paste0("canvas-container-", canvasID),
          tabindex="-1",
          class ="split split-horizontal canvas-container",
          tags$canvas(id=paste0("canvas-f-", canvasID), class = "canvas-canvas"),
          tags$canvas(id=paste0("canvas-b-", canvasID), class = "canvas-canvas")
        ),
        if(isTRUE(on_start)){
          tags$script(glue(.open = "@{", .close = "}@",
            '\n
            $(function(){
               Drawer.@{canvasID}@ = new drawer(
                 "@{canvasID}@",
                  @{container_height}@,
                  @{container_width}@
               );
            });
            \n'
          ))
        } else {
          tags$script(glue(.open = "@{", .close = "}@",
            '\n
            $("@{on_start}@").on("click", function(){
              if (!Drawer.canvasInit.@{canvasID}@){
                $("#@{canvasID}@").show();
                setTimeout(function() {
                  Drawer.@{canvasID}@ = new drawer(
                    "@{canvasID}@",
                    @{container_height}@,
                    @{container_width}@
                  );
                  Drawer.canvasInit.@{canvasID}@ = true;
                }, 1000)
              }
            });
            \n'
          ))
        }
      )
    ),
    div(
      id = paste0(canvasID, "-progress"),
      class = "progress-container",
      tags$label(""),
      div(
        class = "progress",
        div(
          class="progress-bar", role="progressbar", `aria-valuenow`="70",
          `aria-valuemin`="0", `aria-valuemax`="100", style="width:70%"
        )
      )
    ),
    bsModal(
      id = paste0(canvasID, "-shortcut"),
      title = "Keyboard shortcuts",
      size = "large",
      div(
        id = paste0(canvasID, "-shortcut-table"),
        tags$table(
          tags$tr(tags$th("Description"), tags$th("Shortcut"), tags$th("Note")),
          tags$tr(tags$td('Zoom in/out'),  tags$td('Mouse wheel'), tags$td('')),
          tags$tr(tags$td('Panning'),  tags$td('Alt+mouse hold left click and dragging'), tags$td('')),
          tags$tr(tags$td('Remove object'),  tags$td('del'), tags$td('')),
          tags$tr(tags$td('Copy'),  tags$td('Ctrl+c'), tags$td('')),
          tags$tr(tags$td('Cut'),  tags$td('Ctrl+x'), tags$td('')),
          tags$tr(tags$td('Paste'),  tags$td('Ctrl+v'), tags$td('')),
          tags$tr(tags$td('undo'),  tags$td('Ctrl+z'), tags$td('')),
          tags$tr(tags$td('redo'),  tags$td('Ctrl+shift+z'), tags$td('')),
          tags$tr(tags$td('Select multiple objects'),  tags$td('Hold shift + left clicks'), tags$td('')),
          tags$tr(tags$td('bold'),  tags$td('Ctrl+b'), tags$td('')),
          tags$tr(tags$td('italic'),  tags$td('Ctrl+i'), tags$td('')),
          tags$tr(tags$td('superscript'),  tags$td('Ctrl+.'), tags$td('Only works in text editing mode')),
          tags$tr(tags$td('subscript'),  tags$td('Ctrl+,'), tags$td('Only works in text editing mode')),
          tags$tr(tags$td('renmove script'),  tags$td('Ctrl + shift + .'), tags$td('Only works in text editing mode'))
        ),
        tags$label("*Use Command key instead of Ctrl on Mac")
      ),
      tags$script(paste0(
        '
      var shortcutTableShown = false;
      $("#', canvasID, '-shortcut-modal").on("show", function(){
        if(shortcutTableShown === false){
          $(".datatables.html-widget").trigger("shown");
          shortcutTableShown = true;
        }
      })
      '
      ))
    ),
    bsModal(
      id = paste0(canvasID, "-help"),
      title = "About the canvas",
      p("drawer V0.1"),
      p("This canvas is developed by Le Zhang and other contributors under GPL-3 License")
    ),
    drawerDepend()
  )
}
