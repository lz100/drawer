# SPS add HTML dependency functions

drawrDepend <- function() {
  tagList(
    htmltools::htmlDependency(
      name = "dom-to-image",
      version = "10-06-2017",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/dom-to-image.min.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "spectrum",
      version = "1.8.1",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/spectrum1.8.1.js",
      stylesheet = "css/spectrum1.8.1.css",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "toastr",
      version = "2.1.1",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/toastr.min.js",
      stylesheet = "css/toastr.min.css",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "fabric",
      version = "4.2.0",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/fabric.min.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "fabric-history",
      version = "0.2",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/drawr_fabric-history.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "split",
      version = "1.6.0",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/split1.6.0.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "FileSaver",
      version = "2.0.4",
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = "js/FileSaver.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "drawR",
      version = packageVersion("drawR"),
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      script = list(
        "js/drawr_drag_upload.js",
        "js/drawr_to_canvas_btn.js",
        "js/drawr_other.js",
        "js/drawr.js" # always load the main file the last
        ),
      stylesheet = "css/drawr.css",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "drawR",
      version = packageVersion("drawR"),
      package = "drawR",
      src = c(href = "drawr", file = "assets"),
      attachment = "",
      all_files = TRUE
    ),
  )
}
