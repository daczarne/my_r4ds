###################
#### FUNCTIONS ####
###################


# When to write a function ------------------------------------------------

df <- tibble::tibble(
      a = rnorm(10),
      b = rnorm(10),
      c = rnorm(10),
      d = rnorm(10)
)
df$a <- (df$a - min(df$a, na.rm = TRUE)) /
      (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /
      (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) /
      (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) /
      (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))


rescale01 <- function(x) {
      rng <- range(x, na.rm = TRUE)
      (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(0, 5, 10))

# Functions are for humans and computers ----------------------------------



# Conditional execution ---------------------------------------------------

?`if`

has_name <- function(x) {
      nms <- names(x)
      if (is.null(nms)) {
            rep(FALSE, length(x))
      } else {
            !is.na(nms) & nms != ""
      }
}

## Conditions


# Function arguments ------------------------------------------------------


# Return Values -----------------------------------------------------------




#########################
#### END OF PROGRAMM ####
#########################