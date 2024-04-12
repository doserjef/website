ggRGB <- function(x, r, g, b){
  names(x)[r] <- 'r'
  names(x)[g] <- 'g'
  names(x)[b] <- 'b'
  ##as.data.frame(x, xy=TRUE) %>% rowwise() %>%
  ##    transmute(x, y, values = ifelse(is.na(r), NA, rgb(r, g, b, maxColorValue=255)))
  a <- as.data.frame(x, xy=TRUE)
  values  <- apply(a, 1, function(x){ifelse(is.na(x[2+r]), 0, rgb(x[2+r], x[2+g], x[2+b], maxColorValue=255))})
  cbind(a[,1:2], values)
}

colorize <- function(x, color) {
  if (knitr::is_latex_output()) {
    sprintf("\\textcolor{%s}{%s}", color, x)
  } else if (knitr::is_html_output()) {
    sprintf("<span style='color: %s;'>%s</span>", color,
            x)
  } else x
}
