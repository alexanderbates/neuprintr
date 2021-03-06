#' @title Find out what some information about your neuPrint server
#'
#' @description  Get summary information about the datasets hosted by the neuPrint server in which you are interested
#' @param conn optional, a neuprintr connection object, which also specifies the neuPrint server see \code{?neuprint_login}.
#' If NULL, your defaults set in your R.profile or R.environ are used.
#' @param ... methods passed to \code{neuprint_login}
#' @seealso \code{\link{neuprint_login}}
#' @export
#' @rdname neuprint_info
neuprint_datasets <- function(conn = NULL, ...){
  neuprint_fetch(path = 'api/dbmeta/datasets', conn = conn, ...)
}

#' @export
#' @rdname neuprint_info
neuprint_database <- function(conn = NULL, ...){
  neuprint_fetch(path = 'api/dbmeta/database', conn = conn, ...)
}

#' @export
#' @rdname neuprint_info
neuprint_available <- function(conn = NULL, ...){
  av = neuprint_fetch(path = 'api/available', conn = conn, ...)
  do.call(rbind,av)
}

#' @export
#' @rdname neuprint_info
neuprint_version <- function(conn = NULL, ...){
  neuprint_fetch(path = 'api/version', conn = conn, ...)
}

#' @title Get a vector of all the ROIs in a specified dataset
#'
#' @description  Get summary information about the datasets hosted by the neuPrint server in which you are interested
#' @param dataset optional, a dataset you want to query. If NULL, the default specified by your R environ file is used. See \code{neuprint_login} for details.
#' @param conn optional, a neuprintr connection object, which also specifies the neuPrint server see \code{?neuprint_login}.
#' If NULL, your defaults set in your R.profile or R.environ are used.
#' @param ... methods passed to \code{neuprint_login}
#' @seealso \code{\link{neuprint_login}}, \code{\link{neuprint_datasets}}
#' @export
#' @rdname neuprint_ROIs
neuprint_ROIs <- function(dataset = NULL, conn = NULL, ...){
  if(is.null(dataset)){ # Get a default dataset if none specified
    dataset = unlist(getenvoroption("dataset"))
  }
  ds = neuprint_datasets(conn=conn, ...)
  rois = unlist(ds[[dataset]])
  rois[grepl("ROI",names(rois))]
}



