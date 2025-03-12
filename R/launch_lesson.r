#' Launch a Specific Lesson
#'
#' Opens a specific lesson tutorial in a web browser. This function validates
#' the lesson ID, finds the appropriate RMarkdown file, and launches it as
#' an interactive learnr tutorial.
#'
#' @param lesson_id The ID of the lesson to launch (e.g., "module1-environment")
#' @return None (launches a tutorial in a browser window)
#' @export
#'
#' @examples
#' \dontrun{
#' launch_lesson("module1-environment")
#' launch_lesson("module4-vectors")
#' }
launch_lesson <- function(lesson_id) {
  # Ensure required packages are loaded
  if (!requireNamespace("learnr", quietly = TRUE)) {
    stop("learnr package is required for this function")
  }

  # Get lesson data
  lesson_info <- get_lesson_data()

  # Validate lesson_id
  if (!lesson_id %in% lesson_info$id) {
    stop("Invalid lesson_id. Use lesson_menu() to see available lessons.")
  }

  # Get the path for the requested lesson
  idx <- match(lesson_id, lesson_info$id)
  lesson_path <- system.file(lesson_info$path[idx], package = "RLesson")

  if (lesson_path == "") {
    stop("Lesson file not found. The package may be corrupt or the lesson was not installed correctly.")
  }

  # Launch the tutorial
  learnr::run_tutorial(
    name = lesson_id,
    package = "RLesson"
  )

  # Mark this lesson as completed in the progress tracking
  progress <- getOption("RLesson.progress", character(0))
  if (!lesson_id %in% progress) {
    progress <- c(progress, lesson_id)
    options(RLesson.progress = progress)
  }
}
