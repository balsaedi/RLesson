#' Display Menu of Available Lessons
#'
#' Opens a Shiny app showing all available lessons with descriptions
#' and allows the user to select and launch a lesson. The menu also tracks
#' lesson completion progress and allows users to mark lessons as completed.
#'
#' @return Returns the ID of the selected lesson (invisibly)
#' @importFrom stats setNames
#' @export
#'
#' @examples
#' \dontrun{
#' lesson_menu()
#' }
lesson_menu <- function() {
  # Ensure required packages are loaded
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("shiny package is required for this function")
  }

  # Get lesson data
  lesson_info <- get_lesson_data()

  ui <- shiny::fluidPage(
    shiny::titlePanel("R Lessons Menu"),

    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::h3("Select a Lesson"),
        shiny::selectInput("lesson", "Choose a Lesson:",
                           choices = setNames(lesson_info$id, lesson_info$title),
                           selected = lesson_info$id[1]),
        shiny::br(),
        shiny::actionButton("launch", "Launch Selected Lesson",
                            class = "btn-primary"),
        shiny::hr(),
        shiny::h4("Lesson Progress"),
        shiny::p("Track your progress through the modules:"),
        shiny::uiOutput("progressChecklist")
      ),

      shiny::mainPanel(
        shiny::h2(shiny::textOutput("selectedTitle")),
        shiny::h4("Description:"),
        shiny::p(shiny::textOutput("selectedDescription")),
        shiny::hr(),
        shiny::h4("All Available Lessons:"),
        shiny::tableOutput("lessonsTable")
      )
    )
  )

  server <- function(input, output, session) {
    # Get saved progress from options
    completed_lessons <- shiny::reactive({
      progress <- getOption("RLesson.progress")
      if (is.null(progress)) {
        return(character(0))
      }
      return(progress)
    })

    # Display lesson information
    output$selectedTitle <- shiny::renderText({
      idx <- match(input$lesson, lesson_info$id)
      lesson_info$title[idx]
    })

    output$selectedDescription <- shiny::renderText({
      idx <- match(input$lesson, lesson_info$id)
      lesson_info$description[idx]
    })

    # Create table of all lessons
    output$lessonsTable <- shiny::renderTable({
      progress_markers <- ifelse(lesson_info$id %in% completed_lessons(), "\u2713", "")


      data.frame(
        "Module" = lesson_info$title,
        "Description" = lesson_info$description,
        "Completed" = progress_markers,
        check.names = FALSE
      )
    })

    # Generate progress checklist
    output$progressChecklist <- shiny::renderUI({
      progress <- completed_lessons()

      checkboxes <- lapply(1:nrow(lesson_info), function(i) {
        is_completed <- lesson_info$id[i] %in% progress
        shiny::checkboxInput(
          paste0("check_", lesson_info$id[i]),
          lesson_info$title[i],
          value = is_completed
        )
      })

      # Return the list of checkboxes wrapped in a div
      shiny::div(checkboxes)
    })

    # Handle launch button
    shiny::observeEvent(input$launch, {
      selected_lesson <- input$lesson
      shiny::stopApp(selected_lesson)
    })

    # Save progress when checkboxes are toggled
    shiny::observe({
      checked_lessons <- character(0)

      for (i in 1:nrow(lesson_info)) {
        checkbox_id <- paste0("check_", lesson_info$id[i])
        if (!is.null(input[[checkbox_id]]) && input[[checkbox_id]]) {
          checked_lessons <- c(checked_lessons, lesson_info$id[i])
        }
      }

      options(RLesson.progress = checked_lessons)
    })
  }

  selected_lesson <- shiny::runApp(shiny::shinyApp(ui, server))

  if (!is.null(selected_lesson)) {
    # Launch the selected lesson
    launch_lesson(selected_lesson)
  }
}
