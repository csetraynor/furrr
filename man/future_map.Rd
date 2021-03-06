% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/future_map.R, R/future_walk.R
\name{future_map}
\alias{future_map}
\alias{future_map_chr}
\alias{future_map_dbl}
\alias{future_map_int}
\alias{future_map_lgl}
\alias{future_map_dfr}
\alias{future_map_dfc}
\alias{future_map_if}
\alias{future_map_at}
\alias{future_walk}
\title{Apply a function to each element of a vector via futures}
\usage{
future_map(.x, .f, ..., .progress = FALSE, .options = future_options())

future_map_chr(.x, .f, ..., .progress = FALSE, .options = future_options())

future_map_dbl(.x, .f, ..., .progress = FALSE, .options = future_options())

future_map_int(.x, .f, ..., .progress = FALSE, .options = future_options())

future_map_lgl(.x, .f, ..., .progress = FALSE, .options = future_options())

future_map_dfr(.x, .f, ..., .id = NULL, .progress = FALSE,
  .options = future_options())

future_map_dfc(.x, .f, ..., .progress = FALSE, .options = future_options())

future_map_if(.x, .p, .f, ..., .progress = FALSE,
  .options = future_options())

future_map_at(.x, .at, .f, ..., .progress = FALSE,
  .options = future_options())

future_walk(.x, .f, ..., .progress = FALSE, .options = future_options())
}
\arguments{
\item{.x}{A list or atomic vector.}

\item{.f}{A function, formula, or atomic vector.

If a \strong{function}, it is used as is.

If a \strong{formula}, e.g. \code{~ .x + 2}, it is converted to a function. There
are three ways to refer to the arguments:
\itemize{
\item For a single argument function, use \code{.}
\item For a two argument function, use \code{.x} and \code{.y}
\item For more arguments, use \code{..1}, \code{..2}, \code{..3} etc
}

This syntax allows you to create very compact anonymous functions.

If \strong{character vector}, \strong{numeric vector}, or \strong{list}, it
is converted to an extractor function. Character vectors index by name
and numeric vectors index by position; use a list to index by position
and name at different levels. Within a list, wrap strings in \code{\link[=get-attr]{get-attr()}}
to extract named attributes. If a component is not present, the value of
\code{.default} will be returned.}

\item{...}{Additional arguments passed on to \code{.f}.}

\item{.progress}{A logical, for whether or not to print a progress bar for
multiprocess, multisession, and multicore plans.}

\item{.options}{The \code{future} specific options to use with the workers. This must
be the result from a call to \code{\link[=future_options]{future_options()}}.}

\item{.id}{If not \code{NULL} a variable with this name will be created
giving either the name or the index of the data frame.}

\item{.p}{A single predicate function, a formula describing such a
predicate function, or a logical vector of the same length as \code{.x}.
Alternatively, if the elements of \code{.x} are themselves lists of
objects, a string indicating the name of a logical element in the
inner lists. Only those elements where \code{.p} evaluates to
\code{TRUE} will be modified.}

\item{.at}{A character vector of names or a numeric vector of
positions. Only those elements corresponding to \code{.at} will be
modified.}
}
\value{
All functions return a vector the same length as \code{.x}.

\code{\link[=future_map]{future_map()}} returns a list, \code{\link[=future_map_lgl]{future_map_lgl()}} a logical vector,
\code{\link[=future_map_int]{future_map_int()}} an integer vector, \code{\link[=future_map_dbl]{future_map_dbl()}} a double vector,
and \code{\link[=future_map_chr]{future_map_chr()}} a character vector.
The output of \code{.f} will be automatically typed upwards,
e.g. logical -> integer -> double -> character.
}
\description{
These functions work exactly the same as \code{\link[purrr:map]{purrr::map()}} functions, but allow
you to run the map in parallel. The documentation is
adapted from both \code{purrr::map()}, and \code{future.apply::future_lapply()},
so look there for more details.
}
\examples{

library(furrr)
library(dplyr) # for the pipe

\donttest{
plan(multiprocess)
}

1:10 \%>\%
  future_map(rnorm, n = 10) \%>\%
  future_map_dbl(mean)

# If each element of the output is a data frame, use
# future_map_dfr to row-bind them together:
mtcars \%>\%
  split(.$cyl) \%>\%
  future_map(~ lm(mpg ~ wt, data = .x)) \%>\%
  future_map_dfr(~ as.data.frame(t(as.matrix(coef(.)))))

# You can be explicit about what gets exported to the workers

# To see this, use multisession (NOT multicore if on a Mac as the forked workers
# still have access to this environment)
\donttest{
plan(multisession)
}
x <- 1
y <- 2

# This will fail, y is not exported (no black magic occurs)
# future_map(1, ~y, .options = future_options(globals = "x"))

# y is exported
future_map(1, ~y, .options = future_options(globals = "y"))


}
