% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/private_printCaA.R
\name{prCaSetRownames}
\alias{prCaSetRownames}
\title{Sets the rownames of the reordered_groups}
\usage{
prCaSetRownames(reordered_groups, var_order, rowname.fn, use_labels, ds)
}
\arguments{
\item{reordered_groups}{The value matrix that needs refrences}

\item{var_order}{The output from the \code{\link{prMapVariable2Name}}}

\item{rowname.fn}{A rowname function for tailoring names}

\item{use_labels}{Whether to use labels or not}

\item{ds}{The model data set}
}
\value{
\code{matrix} Returns the reordered_groups
}
\description{
Sets the rownames of the reordered_groups
}
\seealso{
Other printCrudeAndAdjusted functions: 
\code{\link{prCaAddRefAndStat}()},
\code{\link{prCaAddReference}()},
\code{\link{prCaAddUserReferences}()},
\code{\link{prCaGetImputationCols}()},
\code{\link{prCaGetRowname}()},
\code{\link{prCaGetVnStats}()},
\code{\link{prCaPrepareCrudeAndAdjusted}()},
\code{\link{prCaReorderReferenceDescribe}()},
\code{\link{prCaReorder}()},
\code{\link{prCaSelectAndOrderVars}()}
}
\concept{printCrudeAndAdjusted functions}
\keyword{internal}
