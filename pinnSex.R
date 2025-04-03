#' @title Determine sex based on Tm thresholds
#' @description Determines sex based on Tm thresholds.
#' 
#' @param x either a filename of an Excel (.xlsx) file or data frame created 
#'   from the file
#' @param tm.x,tm.y two-element vectors giving the thresholds for Tm values for
#'   x and y chromosomes.
#' 
#' @author Eric Archer \email{eric.archer@@noaa.gov}
#' 
#' @export
#' 
pinnSex <- function(x, tm.x = c(82, 85), tm.y = c(87, 90)) {
  df <- if(is.character(x)) {
    gdata::read.xls(
      xls = x, 
      na.strings = c("N/A", ""), 
      stringsAsFactors = FALSE
    )
  } else if(is.data.frame(x)) {
    x
  } else {
    stop("'x' must be a filename or data.frame")
  }
  
  cols <- grep("Tm.Product.", colnames(df))[1:2]
  df$sex.call <- sapply(1:nrow(df), function(i) {
    tm <- sort(unlist(df[i, cols], use.names = FALSE), na.last = TRUE)
    has.x <- swfscMisc::isBetween(tm[1], tm.x[1], tm.x[2])
    has.y <- swfscMisc::isBetween(tm[2], tm.y[1], tm.y[2])
    if(has.x & !has.y) return("F")
    if(has.x & has.y) return("M")
    return("failed")
  })
  df
}
