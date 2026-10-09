# HACSim: Haplotype Accumulation Curve Simulator
# Shiny app. Run it with shiny::runApp() from this folder, or deploy the folder as it is.
#
# Layout of this folder
#   app.R               page, theme and server logic (this file)
#   R/01_constants.R    defaults, preloaded species, abstract text
#   R/02_helpers.R      parsing, validation, running HACSim, summarising results
#   R/03_ui_components  inputs and the result panel
#   R/04_ui_pages.R     theme, Home, Tutorial, About and Run Simulation pages
#   www/                stylesheet, script, images, example FASTA alignments

if (!requireNamespace("HACSim", quietly = TRUE)) {
  stop("The HACSim package is required. Install it with install.packages(\"HACSim\").", call. = FALSE)
}

library(shiny)
library(bslib)
library(shinyjs)
library(shinycssloaders)
suppressPackageStartupMessages(library(HACSim))

# Uploaded alignments can be larger than Shiny's 5 MB default.
options(shiny.maxRequestSize = 30 * 1024^2)

# Shiny loads everything in ./R automatically. This only matters if app.R is run some other way.
if (!exists("SPECIES_PRESETS")) {
  for (f in sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) {
    source(f, encoding = "UTF-8")
  }
}

# ---- UI --------------------------------------------------------------------------------------

ui <- bslib::page_navbar(
  title = brand_ui(),
  id = "nav",
  selected = "home",
  theme = hacsim_theme(),
  fillable = FALSE,
  window_title = APP_TITLE,
  lang = "en",
  header = tagList(
    shinyjs::useShinyjs(),
    tags$head(
      tags$meta(name = "description", content = APP_TITLE),
      tags$link(rel = "stylesheet", type = "text/css", href = paste0("hacsim.css?v=", APP_VERSION)),
      tags$script(src = paste0("hacsim.js?v=", APP_VERSION))
    )
  ),
  bslib::nav_spacer(),
  bslib::nav_panel("Home", value = "home", home_page()),
  bslib::nav_panel("Tutorial", value = "tutorial", tutorial_page()),
  bslib::nav_panel("About", value = "about", about_page()),
  bslib::nav_panel(title = tagList(hs_icon("rocket"), "Run Simulation"), value = "run", run_page())
)

# ---- Server ----------------------------------------------------------------------------------

find_preset <- function(label) {
  for (preset in SPECIES_PRESETS) {
    if (identical(preset$label, label)) return(preset)
  }
  SPECIES_PRESETS[[1]]
}

timestamp_label <- function() format(Sys.time(), "%Y%m%d-%H%M%S")

server <- function(input, output, session) {

  # The progress switch is always on: HACSim only prints its report and plots when it is.
  shinyjs::disable("progress_bar")

  # Each session writes its plots to its own folder, so people running at the same time never see
  # each other's results (the original app shared one www/Rplots.pdf between everyone).
  out_dir <- tempfile("hacsim_")
  dir.create(out_dir, recursive = TRUE)
  res_prefix <- paste0("hacsim-", substr(session$token, 1, 12))
  shiny::addResourcePath(res_prefix, out_dir)
  session$onSessionEnded(function() {
    try(shiny::removeResourcePath(res_prefix), silent = TRUE)
    unlink(out_dir, recursive = TRUE)
  })
  run_count <- 0

  cleared <- reactiveVal(FALSE)
  fasta_cleared <- reactiveVal(FALSE)

  # Collect every input into the list that validate_params() and run_simulation() expect.
  read_inputs <- function() {
    common <- list(
      perms = input$perms,
      p = input$p,
      conf.level = input$conf.level,
      num.iters = if (is_blank_number(input$num.iters)) NULL else input$num.iters
    )

    if (identical(input$sim_type, "hypothetical")) {
      c(common, list(
        mode = "hypothetical", label = "Hypothetical species",
        N = input$N, Hstar = input$Hstar, probs = parse_probs(input$probs),
        subsample = isTRUE(input$subsampleseqs_2), prop = input$prop_2
      ))
    } else if (isTRUE(input$Id015)) {
      preset <- find_preset(input$Id008)
      c(common, list(
        mode = "real_preset", label = preset$label,
        N = input[[paste0("N_load_", preset$id)]],
        Hstar = input[[paste0("Hstar_load_", preset$id)]],
        probs = parse_probs(input[[paste0("probs_load_", preset$id)]]),
        subsample = isTRUE(input$subsampleseqs), prop = input$prop
      ))
    } else {
      f <- if (isTRUE(fasta_cleared())) NULL else input$fastafile
      c(common, list(
        mode = "real_upload", label = if (is.null(f)) "Uploaded FASTA file" else f$name,
        fasta_path = if (is.null(f)) NULL else f$datapath,
        fasta_name = if (is.null(f)) NULL else f$name,
        subsample = isTRUE(input$subsampleseqs), prop = input$prop
      ))
    }
  }

  # ---- Run -----------------------------------------------------------------------------------

  # The outputs below all read sim(), so the spinner shows while this runs and it runs only once.
  sim <- eventReactive(input$run, {
    a <- read_inputs()
    problems <- validate_params(a)

    if (length(problems) > 0) {
      showNotification("The simulation was not run. See the Result Panel for details.",
                       type = "error", duration = 6)
      list(ok = FALSE,
           title = "The simulation was not run. Fix the following, then click Run again.",
           errors = problems)
    } else {
      run_count <<- run_count + 1
      pdf_file <- sprintf("hacsim_%03d.pdf", run_count)
      res <- withProgress(
        message = "Running HACSim",
        detail = "Many permutations or rare haplotypes can take several minutes.",
        value = NULL,
        {
          run_simulation(a, file.path(out_dir, pdf_file))
        }
      )
      if (isTRUE(res$ok)) res$pdf_file <- pdf_file
      res
    }
  })

  observeEvent(input$run, {
    cleared(FALSE)
    session$sendCustomMessage("hs-scroll", "#hs-results")
  })

  # Refresh clears the Result Panel between simulations.
  observeEvent(input$refresh, {
    cleared(TRUE)
  })

  output$status <- renderUI({
    if (isTRUE(cleared()) || is.null(input$run) || input$run < 1) {
      idle_hint_ui()
    } else {
      res <- sim()
      if (isTRUE(res$ok)) result_status_ui(res) else error_alert_ui(res$title, res$errors)
    }
  })

  output$text <- renderText({
    if (isTRUE(cleared())) {
      ""
    } else {
      res <- sim()
      if (isTRUE(res$ok)) paste(res$log, collapse = "\n") else ""
    }
  })

  output$pdfview <- renderUI({
    if (isTRUE(cleared())) {
      NULL
    } else {
      res <- sim()
      if (isTRUE(res$ok) && !is.null(res$pdf_file)) {
        pdf_view_ui(paste0(res_prefix, "/", res$pdf_file))
      } else {
        NULL
      }
    }
  })

  # ---- Downloads -----------------------------------------------------------------------------

  output$dl_pdf <- downloadHandler(
    filename = function() paste0("HACSim_plots_", timestamp_label(), ".pdf"),
    content = function(file) {
      res <- shiny::isolate(sim())
      file.copy(file.path(out_dir, res$pdf_file), file, overwrite = TRUE)
    },
    contentType = "application/pdf"
  )

  output$dl_csv <- downloadHandler(
    filename = function() paste0("HACSim_results_", timestamp_label(), ".csv"),
    content = function(file) {
      res <- shiny::isolate(sim())
      tab <- if (!is.null(res$summary)) res$summary$table else NULL
      if (is.null(tab)) tab <- data.frame()
      utils::write.csv(tab, file, row.names = FALSE)
    },
    contentType = "text/csv"
  )

  output$dl_log <- downloadHandler(
    filename = function() paste0("HACSim_report_", timestamp_label(), ".txt"),
    content = function(file) {
      res <- shiny::isolate(sim())
      writeLines(res$log, file)
    },
    contentType = "text/plain"
  )

  # ---- Inputs --------------------------------------------------------------------------------

  # With preloaded examples there are no sequences to subsample, only haplotype labels.
  observeEvent(input$Id015, {
    labels <- isTRUE(input$Id015)
    updateCheckboxInput(
      session, "subsampleseqs",
      label = if (labels) "Subsample haplotype labels" else "Subsample DNA sequences"
    )
    updateNumericInput(
      session, "prop",
      label = if (labels) {
        "Proportion of haplotype labels to subsample (prop.haps)"
      } else {
        "Proportion of DNA sequences to subsample (prop.seqs)"
      }
    )
  }, ignoreInit = TRUE)

  observeEvent(input$fastafile, {
    fasta_cleared(FALSE)
  })

  # Reset puts every input back to its default value.
  observeEvent(input$reset, {
    updateNumericInput(session, "perms", value = DEFAULTS$perms)
    updateNumericInput(session, "p", value = DEFAULTS$p)
    updateNumericInput(session, "conf.level", value = DEFAULTS$conf.level)
    updateNumericInput(session, "num.iters", value = DEFAULTS$num.iters)

    bslib::nav_select("sim_type", "real", session = session)
    fasta_cleared(TRUE)
    shinyjs::reset("fastafile")
    updateCheckboxInput(session, "Id015", value = FALSE)
    updateSelectInput(session, "Id008", selected = DEFAULTS$species)
    for (preset in SPECIES_PRESETS) {
      updateNumericInput(session, paste0("N_load_", preset$id), value = preset$N)
      updateNumericInput(session, paste0("Hstar_load_", preset$id), value = preset$Hstar)
      updateTextInput(session, paste0("probs_load_", preset$id), value = preset$probs)
    }
    updateCheckboxInput(session, "subsampleseqs", value = FALSE)
    updateNumericInput(session, "prop", value = DEFAULTS$prop)

    updateNumericInput(session, "N", value = DEFAULTS$N)
    updateNumericInput(session, "Hstar", value = DEFAULTS$Hstar)
    updateTextInput(session, "probs", value = DEFAULTS$probs)
    updateCheckboxInput(session, "subsampleseqs_2", value = FALSE)
    updateNumericInput(session, "prop_2", value = DEFAULTS$prop_2)
  })
}

shinyApp(ui = ui, server = server)
