

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
#'
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
  label = "To canvas",
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
      onclick=paste0('toCanvas("', dom, '", "', canvasID, '");
                      if(toastr) toastr.info("Sceenshot sent", "", {positionClass: "toast-bottom-right", timeOut: 2000});
                           '),
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
