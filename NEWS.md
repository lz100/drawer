# drawer 0.2.0.1

## Minor 

-   Fix Rd files as requested by CRAN.

# drawer 0.2.0.0

## bug fix

-   Now supports use in Shiny modules

-   bound box bug fix

-   fix bug in chrome \> 98 caused drag-drop invoked as upload event

    -   This is fixed by changing the detection method from file length to `setData`/`getData` methods in file data transferring.

# drawer 0.1

------------------------------------------------------------------------

## Major

-   Migrated from systemPipeShiny to this new package.

## New features

-   Copy, cut, paste finally enabled

-   Upload images from local to canvas

    -   Multiple at once supported

    -   One copy will also be added to left sidebar

    -   progress bar indicator

-   add toastr.js dependency for client end messaging

## Bug fix

-   some bug fix
