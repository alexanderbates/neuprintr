#' @title Get the annotated positions in space for somata
#'
#' @description  For some datasets, somata positions have been mapped to pixels within a soma volume in the image data. If your bodyids contain such an annotated pixel, you can retrieve its position.
#' @inheritParams neuprint_read_neurons
#' @return a data frame of X,Y,Z coordinates, a row for each bodyid supplied
#' @seealso \code{\link{neuprint_fetch_custom}}, \code{\link{neuprint_get_synapses}}, \code{\link{neuprint_read_neurons}}
#' @export
#' @rdname neuprint_assign_connectors
neuprint_locate_soma <- function(bodyids, dataset = NULL, all_segments = TRUE, conn = NULL, ...){
  if(is.null(dataset)){ # Get a default dataset if none specified
    dataset = unlist(getenvoroption("dataset"))
  }
  all_segments = ifelse(all_segments,"Segment","Neuron")
  cypher = sprintf("WITH %s AS bodyIds UNWIND bodyIds AS bodyId MATCH (n:`%s-%s`) WHERE n.bodyId=bodyId RETURN n.bodyId AS bodyId, n.somaLocation AS soma",
                   jsonlite::toJSON(bodyids),
                   dataset,
                   all_segments)
  nc = neuprint_fetch_custom(cypher=cypher, conn = conn, ...)
  for(i in 1:length(nc$data)){
    if(is.null(nc$data[[i]][[2]]$coordinates)){
      nc$data[[i]][[2]]$coordinates = list(NA,NA,NA)
    }
  }
  coordinates = do.call(rbind,lapply(nc$data,function(x) cbind(x[[1]],rbind(x[[2]]$coordinates))))
  coordinates = as.data.frame(t(apply(coordinates,1,function(r) unlist(r))))
  colnames(coordinates) = c("bodyid","X","Y","Z")
  coordinates
}
