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
#  rmarkdown::render(rmd, output_dir = getwd(), output_file = paste0(basename(available)[choice], ".html"))
  fs::file_show(rmd)
}
