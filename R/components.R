

#' Screenshot a HTML component and send it to canvas
#'
#' @param dom a HTML DOM selector, mostly common is to select the element by ID:
#' e.g. a plot with ID "plot1", to select, use `dom = "plot1"` to select the plot if
#' `isID = TRUE`. If `isID = FALSE`, use `dom = "#plot1"`
#'
#' Other complex selector is supported. First turn `isID = FALSE`, then try things
#' like `dom = ".btn i"` selects an icon inside an element
#' with "btn" class. If more than one element is matched, only the first one will
#' be screenshoted.
#' @param isID bool, `TRUE` if you want to select the `dom` by HTML ID, `FALSE`
#' if the selector is other than ID.
#' @param canvasID string, the ID of canvas. Unlike `dom`, you should not add
#' "#" for `canvasID` even if `isID=FALSE`
#' @param id string, ID for this button, optional
#' @param label label of this button, optional
#' @param color_class bootstrap button color class suffix, usually one of
#' 'default', 'primary', 'info', 'success', 'warning', 'danger'
#' @details This component will not work unless a drawR canvas has been loaded
#' on current document.
#' @return a button
#' @export
#'
#' @examples
#' # see example of "canvas", `?canvas`
toCanvasBtn <-function(
  dom,
  canvasID,
  isID = TRUE,
  id = "",
  label = "To Canvas",
  color_class = "primary"
  ) {
  stopifnot(is.character(dom) && length(dom) == 1)
  stopifnot(is.character(canvasID) && length(canvasID) == 1)
  stopifnot(is.character(id) && length(id) == 1)
  stopifnot(is.character(label) && length(label) == 1)
  stopifnot(is.character(color_class) && length(color_class) == 1)

  dom = if(isID) paste0("#", dom) else dom

  div(
    class="btn-group to-canvas",
    id = id,
    tags$button(
      type="button",
      class=paste0("btn btn-", color_class),
      onclick=paste0('toCanvas("', dom, '", "', canvasID, '")'),
      label
    ),
    tags$button(
      type="button",
      class=paste0("btn btn-", color_class, " dropdown-toggle"),
      `data-toggle`="dropdown",
      `aria-haspopup`="true",
      `aria-expanded`="false",
      tags$span(class="caret"),
      tags$span(class="sr-only", 'Toggle Dropdown')
    ),
    tags$ul(
      class = "dropdown-menu",
      tags$li(tags$a(href = "#", "Save as png", onclick = paste0('toPng("', dom, '")'))),
      tags$li(tags$a(href = "#", "Save as jpg", onclick = paste0('toJpg("', dom, '")')))
      # tags$li(tags$a(href = "#", "Save as svg", onclick = paste0('toSvg("', dom, '")')))
    )
  )
}

#' Screenshot any HTML element to canvas button
#' @description Unlike [toCanvasBtn] only screenshot a defined element, this function
#' can take screenshot of any element you specify in the text box and sent to canvas
#' by using Jquery  selector format.
#' @param canvasID string, the ID of canvas.
#' @param label string, label of the whole group, on the top
#' @param text_value string, nitial value of the text input
#' @param placeholder string, placeholder text of the text input
#' @param btn_label text on the button
#' @param color_class bootstrap button color class suffix, usually one of
#' 'default', 'primary', 'info', 'success', 'warning', 'danger'
#' @param style additional CSS style of the group, like "width: 50%"
#' @param tooltip a tooltip of the group
#' @param placement where should the tooltip go?
#' @export
#' @return a shiny input group
#' @details This component will not work unless a drawR canvas has been loaded
#' on current document.
#'
#' ### Input selector
#' The selector uses Jquery selector.
#'
#' - If you are not familiar with it, just remember
#' the mostly commonly used is the element ID, which is the `inputID`, `ID` arguments
#' in most Shiny components. Jquery selector is almost the same for ID, but requires
#' you to add "#" in front, "#element-ID".
#' - If you have no idea about shiny or HTML selector, right click on the element,
#' and click inspect, you should see the document HTML code in the inspector and
#' the element you want should be highlighted. Find the attribute of "*id*", that's
#' what you need. Again, append "#" in front of that value. Some elements do not
#' have an "id", in this case, you need some advanced selectors. Learn about them by
#' Google "CSS selector".
#' @examples
#' # see the example of `canvas`
toCanvasTextBtn <- function(
  canvasID,
  label = "",
  text_value ="",
  placeholder = "type a selector",
  tooltip = "Screenshot any element to drawR canvas",
  placement = "bottom",
  btn_label = "To Canvas",
  color_class = "primary",
  style = ""
){
  stopifnot(is.character(label) && length(label) == 1)
  stopifnot(is.character(text_value) && length(text_value) == 1)
  stopifnot(is.character(placeholder) && length(placeholder) == 1)
  stopifnot(is.character(tooltip) && length(tooltip) == 1)
  stopifnot(is.character(placement) && length(placement) == 1)
  stopifnot(is.character(btn_label) && length(btn_label) == 1)
  stopifnot(is.character(style) && length(style) == 1)

  div(
    style = style,
    tags$label(label),
    div(
      class = "input-group",
      `data-toggle`="tooltip",
      title = tooltip,
      `data-placement` = placement,
      tags$span(
        class = "form-control to-canvas-text",
        tags$input(
          style = "width: 100%; height: 100%; padding: 5px; border: none;",
          type = "text",
          value = text_value,
          placeholder = placeholder
        )
      ),
      tags$span(
        class="input-group-btn",
        tags$button(
          `for` = canvasID,
          class=paste0("btn to-canvas btn-", color_class),
          btn_label
        )
      )
    )
  )
}

bsModal <- function(id, ..., title="title",
                    size=c('normal', 'large', 'small'),
                    confirmbtn = FALSE,
                    confirmbtn_id = paste0(id, "-confirm"),
                    confirmbtn_text = "confirm"
){
  size <- switch(size[1],
                 'large' = 'modal-lg',
                 'small' = 'modal-sm',
                 ''
  )
  div(
    class="modal fade", id= paste0(id, "-modal"), tabindex="-1", role="dialog",
    `aria-labelledby`=paste0(id, "-modal-title"),
    div(
      class=paste("modal-dialog", size), role="document",
      div(
        class="modal-content",
        div(
          class="modal-header",
          HTML('<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
          '),
          h4(class="modal-title", id=paste0(id, "-modal-title"), title)
        ),
        div(
          class="modal-body", ...
        ),
        div(
          class="modal-footer",
          tags$button(type="button", class="btn btn-default", `data-dismiss`="modal", "Close"),
          if(confirmbtn){
            tags$button(
              class = "btn btn-default action-button btn-primary",
              id = confirmbtn_id,
              type = "button",
              confirmbtn_text
            )
          } else
          {div()}
        )
      )
    )
  )
}

bannerBtn <- function(id, icon, onclick = "",
                      tip = "", `data-placement` = "bottom",
                      `data-toggle` = "tooltip", div_style = "",
                      label = "", btn_style = "",
                      ...){
  div(
    class = "banner-items",
    style = div_style,
    shiny::actionButton(
      id, label = label, class = "item", icon = icon,
      onclick = onclick,
      `data-toggle` = `data-toggle`,
      `data-placement` = `data-placement`,
      title = tip,
      style = btn_style,
      ...
    )
  )
}
