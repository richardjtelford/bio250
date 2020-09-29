#' Render a lecture
#' 
#' 
#' @examples 
#' \donttest{
#' render_lecture()
#' }
#' @export
#' 

render_lecture <- function(){
  available <- list.dirs(path = file.path(find.package("Bio250"), "lectures"), recursive = FALSE)
  choice <- menu(basename(available))
  rmd <- list.files(path = available[choice], pattern = "*.Rmd$", full.names = TRUE)
#  rmarkdown::render(rmd)
  usethis::edit_file(rmd)
}
