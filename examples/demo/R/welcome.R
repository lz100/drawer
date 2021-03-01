
# UI
uiWelcome <- function(id) {
  ns <- NS(id)
  fluidRow(
    h1("drawer", class = "text-center text-primary text-bold"),
    tags$img(src = "https://github.com/lz100/drawer/blob/master/img/drawer.png?raw=true",
             class = "home-logo"),
    column(
      12, class = "text-main desc-table",
    markdown(
    '
    ### About the package
    {drawer} is an interactive image editing tool that can be added as part of
    the HTML in Shiny, R markdown or any type of HTML document. Often times,
    plots, photos are embedded in the web application/file. {drawer} can take
    a screenshot of these image-like, or any part of the HTML document and send
    to an image editing space called "canvas" to allow users immediately edit
    the screenshot(s) within the same document. Users can quickly combine,
    compare different screenshots, upload their own images and maybe make a
    scientific figure.

    In this demo, different ways to use the {drawer} canvas are shown in different
    tabs. You can browse them from the left sidebar.

    ### Features
    - {drawer} is built with 99% javascript + HTML + CSS, there is **no need to have a Shiny server** or any other
      types of server in the back-end. That\'s why you can use it in any HTML document.
      **All you need is a modern web browser**, like Chrome or Firefox (IE will not work).
    - Shiny and R markdown compatible.
    - Screenshot any element in the page and edit in canvas or download it *png* or *jpg*
    - Drag and upload your own images.
    - As simple as a [single HTML document](https://github.com/lz100/drawer/blob/master/examples/rmd_demo/drawer_independent.html)
      (download this file and open it in your browser).

    ### Other demos
    |type|link|
    |---|---|
    |Pure HTML|[hosted online](https://systempipe.org/sps/dev/drawer/drawer_independent.html)|
    |Pure HTML (github)|[download and open in your browser](https://github.com/lz100/drawer/blob/master/examples/rmd_demo/drawer_independent.html)|
    |Shiny|[shinyapp.io](https://lezhang.shinyapps.io/drawer)|
    |R markdown|[syspipe.org](https://systempipe.org/sps/dev/drawer/drawer_rmd_demo.html)|

    <br>

    For more details, read the documents on [our website](https://systempipe.org/sps/dev/ui/).

    <p class="text-primary">If you <b >like</b> this package, remember to give us a
    <a href="https://github.com/lz100/drawer"> star<i class="fa fa-star text-red"></i> on github.</a>
    </p>

    <br>
    <h3 class="text-center">Other packages in systemPipeShiny</h3>
    <br>

    | Package | Description | Documents | Demo |
    | --- | --- | --- | --- |
    |<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/sps_small.png?raw=true" align="right" height="30" width="30"/>[systemPipeShiny](https://github.com/systemPipeR/systemPipeShiny) | SPS main package |[website](https://systempipe.org/sps/)|[demo](https://tgirke.shinyapps.io/systemPipeShiny/)|
    |<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/spscomps.png?raw=true" align="right" height="30" width="30" />[spsComps](https://github.com/lz100/spsComps) | SPS UI and server components |[website](https://systempipe.org/sps/dev/spscomps/)|[demo](https://lezhang.shinyapps.io/spsComps)|
    |<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/spsutil.png?raw=true" align="right" height="30" width="30" />[spsUtil](https://github.com/lz100/spsUtil) | SPS utility functions |[website](https://systempipe.org/sps/dev/spsutil/)|NA|
    |<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/drawer.png?raw=true" align="right" height="30" width="30" />[drawer](https://github.com/lz100/drawer) | SPS interactive image editing tool |[website](https://systempipe.org/sps/dev/drawer/)|[demo](https://lezhang.shinyapps.io/drawer)|

    ### History
    {drawer} originally is part of systemPipeShiny (SPS) functionality, the "Canvas" tab.
    To use it, you must install the whole SPS and can use only under SPS framework.
    To benefit more people with their own work, like their own Shiny apps, we separate
    the "Canvas" feature as an independent package {drawer}.
    ')
    )

  )
}

# Server
serverWelcome <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

    }
  )
}
