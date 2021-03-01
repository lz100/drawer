# SPS add HTML dependency functions

drawerDepend <- function() {
  tagList(
    htmltools::htmlDependency(
      name = "dom-to-image",
      version = "10-06-2017",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/dom-to-image.min.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "spectrum",
      version = "1.8.1",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/spectrum1.8.1.js",
      stylesheet = "css/spectrum1.8.1.css",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "toastr",
      version = "2.1.1",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/toastr.min.js",
      stylesheet = "css/toastr.min.css",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "fabric",
      version = "4.2.0",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/fabric.min.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "fabric-history",
      version = "0.2",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/drawer_fabric-history.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "split",
      version = "1.6.0",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/split1.6.0.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "FileSaver",
      version = "2.0.4",
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = "js/FileSaver.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "drawer",
      version = packageVersion("drawer"),
      package = "drawer",
      src = c(href = "drawer", file = "assets"),
      script = list(
        "js/drawer_drag_upload.js",
        "js/drawer_to_canvas_btn.js",
        "js/drawer_other.js",
        "js/drawer.js" # always load the main file the last
        ),
      stylesheet = "css/drawer.css",
      all_files = FALSE
    )
  )
}
