% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/private_printCaA.R
\name{prCaGetRowname}
\alias{prCaGetRowname}
\title{Gets the labelled rowname if it exists}
\usage{
prCaGetRowname(vn, use_labels, dataset)
}
\arguments{
\item{vn}{The variable name}

\item{use_labels}{If labels should be used}

\item{dataset}{The dataset}
}
\value{
\code{string} The rowname
}
\description{
Looks for matches inside factors if rowname
contains the name of the column.
}
\seealso{
Other printCrudeAndAdjusted functions: 
\code{\link{prCaAddRefAndStat}()},
\code{\link{prCaAddReference}()},
\code{\link{prCaAddUserReferences}()},
\code{\link{prCaGetImputationCols}()},
\code{\link{prCaGetVnStats}()},
\code{\link{prCaPrepareCrudeAndAdjusted}()},
\code{\link{prCaReorderReferenceDescribe}()},
\code{\link{prCaReorder}()},
\code{\link{prCaSelectAndOrderVars}()},
\code{\link{prCaSetRownames}()}
}
\concept{printCrudeAndAdjusted functions}
\keyword{internal}
