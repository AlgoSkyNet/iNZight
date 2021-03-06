##' An image icon that works as a button.
##'
##' Creates an image that works as a button, and has mouseover icon effects
##' and a 'tooltip' that appears in the status bar.
##' @title iNZight Image Button
##' @param stock.id the icon to use
##' @param filename the image location 
##' @param old_cursor the cursor before mouseover
##' @param tooltip a list with items `tooltip` and `widget`
##' @param ... additional arguments passed to `gimage`
##' @return a gimage with extra effects
##' @author Tom Elliott
##' @export
gimagebutton <- function(stock.id = NULL, filename, old_cursor = NULL, tooltip = NULL,
                         ...) {
    img <- if (is.null(stock.id)) gimage(filename = filename, ...)
           else gimage(stock.id = stock.id, ...)

    tooltip(img) <- tooltip
    
    hover <- gdkCursorNew("GDK_HAND1")
    addHandler(img, "enter-notify-event", handler=function(h, ...) {
        getToolkitWidget(h$obj)$getWindow()$setCursor(hover)
        ## set the status ...
        # if (!is.null(tooltip)) svalue(tooltip$widget) <- tooltip$tooltip
        TRUE
    })
    addHandler(img, "leave-notify-event", handler=function(h, ...) {
        getToolkitWidget(h$obj)$getWindow()$setCursor(old_cursor)
        # if (!is.null(tooltip)) svalue(tooltip$widget) <- ""
        TRUE
    })
    img
}
