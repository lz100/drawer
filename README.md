# drawer <img src="https://github.com/lz100/drawer/blob/master/img/drawer.png?raw=true" align="right" height="139" />

{drawer} is an interactive image editing tool that can be added as part of the HTML in Shiny,
R markdown or any type of HTML document. Often times, plots, photos are embedded
in the web application/file. {drawer} can take screenshots of these image-like elements, or 
any part of the HTML document and send to an image editing space called "canvas" to allow users 
immediately edit the screenshot(s) within the same document. Users can quickly 
combine, compare different screenshots, upload their own images 
and maybe make a scientific figure. 

## Features 

- {drawer} is built with 99% javascript + HTML + CSS, there is **no need to have a Shiny server** or any other 
types of server in the back-end. That's why you can use it in any HTML document. 
**All you need is a modern web browser**, like Chrome or Firefox (IE will not work).
- Shiny and R markdown compatible.
- Screenshot any element in the page and edit in canvas or download it *png* or *jpg*
- Drag and upload your own images.


## Demo
|type|link|
|---|---|
|Pure HTML|[hosted online](https://systempipe.org/sps/dev/drawer/drawer_independent.html)|
|Pure HTML (github)|[download and open in your browser](https://github.com/lz100/drawer/blob/master/examples/rmd_demo/drawer_independent.html)|
|Shiny|[shinyapp.io](https://lezhang.shinyapps.io/drawer)|
|R markdown|[syspipe.org](https://systempipe.org/sps/dev/drawer/drawer_rmd_demo.html)|


## Install

Install release version from CRAN:

```r
install.packages("drawer")
```

Develop version:

```r
if (!requireNamespace("drawer", quietly=TRUE))
    remotes::install_github("lz100/drawer")
```

## User manual 

Read details of drawer on [our website](https://systempipe.org/sps/canvas/).

## About drawer
{drawer} is originally part of systemPipeShiny (SPS), the SPS Canvas functionality.
However, one cannot use it outside SPS framework and installing the whole SPS framework
is heavy. To benefit more people in their own apps/documents, we provide {drawer} as 
a separate package. 

## Other packages in systemPipeShiny

| Package | Description | Documents | Demo |
| --- | --- | --- | --- |
|<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/sps_small.png?raw=true" align="right" height="25" />[systemPipeShiny](https://github.com/systemPipeR/systemPipeShiny) | SPS main package |[website](https://systempipe.org/sps/)|[demo](https://tgirke.shinyapps.io/systemPipeShiny/)|
|<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/spscomps.png?raw=true" align="right" height="25" />[spsComps](https://github.com/lz100/spsComps) | SPS UI and server components |[website](https://systempipe.org/sps/dev/spscomps/)|[demo](https://lezhang.shinyapps.io/spsComps)|
|<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/spsutil.png?raw=true" align="right" height="25" />[spsUtil](https://github.com/lz100/spsUtil) | SPS utility functions |[website](https://systempipe.org/sps/dev/spsutil/)|NA|
|<img src="https://github.com/systemPipeR/systemPipeR.github.io/blob/main/static/images/drawer.png?raw=true" align="right" height="25" />[drawer](https://github.com/lz100/drawer) | SPS interactive image editing tool |[website](https://systempipe.org/sps/dev/drawer/)|[demo](https://lezhang.shinyapps.io/drawer)|
