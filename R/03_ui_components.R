# UI building blocks for the "Run Simulation" page and the result panel.
# Every input id from the original app is kept (perms, p, conf.level, num.iters, progress_bar, reset,
# Id015, Id008, N_load_*, Hstar_load_*, probs_load_*, subsampleseqs, prop, N, Hstar, probs,
# subsampleseqs_2, prop_2, run, refresh) so existing notes and bookmarks still make sense.
# Two ids changed on purpose: the Real/Hypothetical switch is now the segmented control `sim_type`,
# and the new FASTA upload is `fastafile` (the original code already reset an input with that id).

# Font Awesome icon that can never stop the app from starting if a name is unknown.
hs_icon <- function(name) {
  tryCatch(shiny::icon(name), error = function(e) NULL)
}

field_help <- function(...) {
  div(class = "form-text", ...)
}

# ---- Main interface --------------------------------------------------------------------------

main_interface_ui <- function() {
  div(
    class = "hs-form",
    div(
      class = "hs-grid-2",
      div(
        numericInput("perms", "Number of permutations (perms)",
                     value = DEFAULTS$perms, min = 2, step = 1, width = "100%"),
        field_help("More permutations give smoother, more precise curves but take longer to run.")
      ),
      div(
        numericInput("p", "Proportion of haplotypes to recover (p)",
                     value = DEFAULTS$p, min = 0, max = 1, step = 0.01, width = "100%"),
        field_help("The share of the species' haplotypes you want to capture, from 0 to 1.")
      ),
      div(
        numericInput("conf.level", "Desired confidence level (conf.level)",
                     value = DEFAULTS$conf.level, min = 0.01, max = 0.99, step = 0.01, width = "100%"),
        field_help("Used for the accumulation curve and for the confidence intervals.")
      ),
      div(
        numericInput("num.iters", "Number of iterations to run (num.iters)",
                     value = DEFAULTS$num.iters, min = 1, max = 1, width = "100%"),
        field_help("Leave blank to run every iteration until the target is reached, or enter 1 to run the first iteration only.")
      )
    ),
    div(
      class = "hs-progress-row",
      bslib::input_switch("progress_bar", "Progress", value = TRUE),
      field_help("Always on, because HACSim only prints its report and draws its plots when progress is on.")
    ),
    div(
      class = "hs-actions",
      actionButton("reset", "Reset", icon = hs_icon("undo"), class = "btn-outline-secondary")
    )
  )
}

# ---- Sub interface ---------------------------------------------------------------------------

# One block of preloaded values per species. Same inputs and limits as the original app.
preset_ui <- function(preset) {
  id <- preset$id
  conditionalPanel(
    condition = sprintf("input.Id008 === '%s'", preset$label),
    class = "hs-preset",
    div(
      class = "hs-preset-file",
      tags$a(
        href = utils::URLencode(preset$fasta), download = preset$fasta, class = "hs-file-link",
        hs_icon("file-download"), " ", preset$fasta
      ),
      div(
        class = "hs-loaded",
        tags$progress(value = "100", max = "100", "100%"),
        tags$span("Upload complete \u2713")
      )
    ),
    div(
      class = "hs-grid-2",
      numericInput(paste0("N_load_", id), "Number of observed specimens (N)",
                   value = preset$N, min = preset$N, max = preset$N, width = "100%"),
      numericInput(paste0("Hstar_load_", id), "Number of observed haplotypes (Hstar)",
                   value = preset$Hstar, min = preset$Hstar, max = preset$Hstar, width = "100%")
    ),
    textInput(paste0("probs_load_", id), "Haplotype frequency distribution (probs)",
              value = preset$probs, width = "100%")
  )
}

real_panel_ui <- function() {
  div(
    class = "hs-form",
    h3(class = "hs-h", "Preloaded examples"),
    bslib::input_switch("Id015", "Show examples", value = FALSE),

    # Your own data
    conditionalPanel(
      condition = "!input.Id015",
      fileInput("fastafile", "Upload an aligned and trimmed FASTA file",
                accept = c(".fas", ".fasta", ".fa", ".fna", ".txt"),
                buttonLabel = "Browse...", placeholder = "No file selected", width = "100%"),
      field_help(
        tags$strong("Note"),
        ": Inputted DNA sequences should not contain missing and/or ambiguous nucleotides, which may lead to",
        " overestimation of the number of observed unique haplotypes. Consider excluding sequences or alignment",
        " sites containing these data. If missing and/or ambiguous bases occur at the ends of sequences,",
        " further alignment trimming is an option."
      )
    ),

    # Preloaded species
    conditionalPanel(
      condition = "input.Id015",
      selectInput("Id008", "Species",
                  choices = vapply(SPECIES_PRESETS, function(x) x$label, character(1)),
                  selected = DEFAULTS$species, selectize = FALSE, width = "100%"),
      lapply(SPECIES_PRESETS, preset_ui)
    ),

    checkboxInput("subsampleseqs", "Subsample DNA sequences", value = FALSE),
    conditionalPanel(
      condition = "input.subsampleseqs",
      numericInput("prop", "Proportion of DNA sequences to subsample (prop.seqs)",
                   value = DEFAULTS$prop, min = 0, max = 1, step = 0.01, width = "100%")
    )
  )
}

hypothetical_panel_ui <- function() {
  div(
    class = "hs-form",
    div(
      class = "hs-grid-2",
      numericInput("N", "Number of sampled specimens/DNA sequences (N)",
                   value = DEFAULTS$N, min = 2, width = "100%"),
      numericInput("Hstar", "Number of observed species' haplotypes (Hstar)",
                   value = DEFAULTS$Hstar, min = 1, width = "100%")
    ),
    textInput("probs", "Observed haplotype frequency distribution (probs)",
              value = DEFAULTS$probs, width = "100%"),
    field_help("Comma-separated frequencies, one for each haplotype. They must add up to 1."),
    checkboxInput("subsampleseqs_2", "Subsample haplotype labels", value = FALSE),
    conditionalPanel(
      condition = "input.subsampleseqs_2",
      numericInput("prop_2", "Proportion of haplotype labels to subsample (prop.haps)",
                   value = DEFAULTS$prop_2, min = 0, max = 1, step = 0.01, width = "100%")
    )
  )
}

sub_interface_ui <- function() {
  div(
    class = "hs-form",
    h3(class = "hs-h", "Simulation type"),
    bslib::navset_pill(
      id = "sim_type",
      selected = "real",
      bslib::nav_panel("Real", value = "real", real_panel_ui()),
      bslib::nav_panel("Hypothetical", value = "hypothetical", hypothetical_panel_ui())
    ),
    div(
      class = "hs-actions",
      actionButton("run", "Run", icon = hs_icon("play"), class = "btn-primary"),
      actionButton("refresh", "Refresh", icon = hs_icon("sync-alt"), class = "btn-outline-secondary")
    ),
    field_help(
      tags$strong("Disclaimer"),
      ": Simulation may take time to run depending on the size of the inputted dataset and parameters."
    )
  )
}

# ---- Result panel ----------------------------------------------------------------------------

results_ui <- function() {
  div(
    id = "hs-results",
    class = "hs-panel hs-results",
    h3(class = "hs-h hs-results-title", "Result Panel"),
    uiOutput("status"),
    verbatimTextOutput("text"),
    shinycssloaders::withSpinner(
      uiOutput("pdfview"),
      image = "giphy.gif", image.width = 200, image.height = 200
    )
  )
}

idle_hint_ui <- function() {
  div(
    class = "hs-idle",
    tags$p("Set the parameters in the Main interface and the Sub interface, then click Run.",
           " The summary, report and plots appear here.")
  )
}

error_alert_ui <- function(title, msgs) {
  div(
    class = "alert alert-danger hs-alert", role = "alert",
    tags$strong(title),
    if (length(msgs) == 1) {
      tags$p(class = "mb-0", msgs)
    } else {
      tags$ul(class = "mb-0", lapply(msgs, tags$li))
    }
  )
}

pdf_view_ui <- function(url) {
  tagList(
    div(
      class = "hs-plot-head",
      tags$h4(class = "hs-h", "Graphics output"),
      tags$a(href = url, target = "_blank", rel = "noopener", class = "hs-link",
             hs_icon("external-link-alt"), " Open in a new tab")
    ),
    tags$iframe(src = url, class = "hs-pdf", title = "HACSim graphics output (PDF)")
  )
}

stat_item <- function(label, value) {
  div(class = "hs-stat", tags$dt(label), tags$dd(value))
}

# A single line that places N (what you have), N* (what you need) and the confidence interval
# on the same scale, so the answer can be read at a glance.
scale_ui <- function(s, ci_ok) {
  if (!is_number(s$N) || !is.finite(s$n_star)) return(NULL)
  top <- max(c(s$n_star, s$N, if (ci_ok) s$n_high), na.rm = TRUE) * 1.12
  at <- function(x) paste0(round(100 * min(max(x / top, 0), 1), 2), "%")
  div(
    class = "hs-scale", `aria-hidden` = "true",
    div(class = "hs-scale-track"),
    if (ci_ok) {
      div(class = "hs-scale-band",
          style = sprintf("left:%s;width:%s", at(s$n_low),
                          paste0(round(100 * min((s$n_high - s$n_low) / top, 1), 2), "%")))
    },
    div(class = "hs-scale-n", style = sprintf("left:%s", at(s$N)),
        tags$span(class = "hs-scale-tick"),
        tags$span(class = "hs-scale-label", sprintf("N = %s", fmt_int(s$N)))),
    div(class = "hs-scale-nstar", style = sprintf("left:%s", at(s$n_star)),
        tags$span(class = "hs-scale-dot"),
        tags$span(class = "hs-scale-label", sprintf("N* = %s", fmt_int(s$n_star))))
  )
}

readout_ui <- function(s) {
  target <- paste0(signif(100 * s$p, 4), "%")
  conf <- paste0(signif(100 * s$conf.level, 4), "%")
  ci_ok <- is.finite(s$n_low) && is.finite(s$n_high) && s$n_high > s$n_low

  extra <- if (is.finite(s$n_star) && is_number(s$N)) max(0, s$n_star - s$N) else NA_real_
  recovered <- if (is.finite(s$R)) {
    if (is.finite(s$R_low) && is.finite(s$R_high)) {
      sprintf("%s (%s to %s)", fmt_pct(s$R), fmt_pct(s$R_low), fmt_pct(s$R_high))
    } else {
      fmt_pct(s$R)
    }
  }
  stats <- tags$dl(
    class = "hs-stats",
    if (is.finite(extra)) stat_item("Additional specimens needed", fmt_int(extra)),
    if (!is.null(recovered)) stat_item("Haplotypes recovered", recovered),
    if (is.finite(s$iters)) stat_item("Iterations", fmt_int(s$iters)),
    if (is_number(s$perms)) stat_item("Permutations", fmt_int(s$perms)),
    if (is.finite(s$elapsed)) stat_item("Run time", sprintf("%.1f s", s$elapsed))
  )

  if (isTRUE(s$reached) && is.finite(s$n_star)) {
    div(
      class = "hs-readout",
      div(
        class = "hs-readout-head",
        div(class = "hs-readout-label", "Estimated sampling sufficiency (N*)"),
        div(class = "hs-readout-figure",
            tags$span(class = "hs-readout-number", fmt_int(s$n_star)),
            tags$span(class = "hs-readout-unit", "specimens")),
        div(class = "hs-readout-sub",
            sprintf("to recover %s of the species' haplotypes", target),
            if (ci_ok) tags$span(class = "hs-ci", sprintf("%s CI %s\u2013%s", conf, fmt_int(s$n_low), fmt_int(s$n_high))))
      ),
      scale_ui(s, ci_ok),
      stats
    )
  } else {
    div(
      class = "hs-readout hs-readout-pending",
      div(class = "hs-readout-label", "Desired level of haplotype recovery has not yet been reached"),
      tags$p(class = "hs-readout-sub",
             if (isTRUE(s$first_only)) {
               "Only the first iteration was run. Clear the number of iterations to run until the target is reached."
             } else {
               "Run the simulation again with more permutations."
             }),
      stats
    )
  }
}

iteration_table_ui <- function(tab) {
  if (is.null(tab)) return(NULL)
  head_row <- tags$tr(lapply(names(tab), function(n) tags$th(scope = "col", n)))
  body_rows <- lapply(seq_len(nrow(tab)), function(i) {
    tags$tr(lapply(seq_along(tab), function(j) {
      tags$td(format(signif(tab[[j]][i], 5), scientific = FALSE, trim = TRUE))
    }))
  })
  tags$details(
    class = "hs-details",
    tags$summary("Measures of sampling closeness by iteration"),
    div(class = "table-responsive",
        tags$table(class = "table table-sm hs-table", tags$thead(head_row), tags$tbody(body_rows)))
  )
}

downloads_ui <- function() {
  div(
    class = "hs-downloads",
    downloadButton("dl_pdf", "Plots (PDF)", class = "btn-sm hs-btn-ghost", icon = hs_icon("file-pdf")),
    downloadButton("dl_csv", "Results (CSV)", class = "btn-sm hs-btn-ghost", icon = hs_icon("file-csv")),
    downloadButton("dl_log", "Report (TXT)", class = "btn-sm hs-btn-ghost", icon = hs_icon("file-alt"))
  )
}

# Everything above the report text for a finished run.
result_status_ui <- function(res) {
  s <- res$summary
  tagList(
    if (length(res$warnings) > 0) {
      div(class = "alert alert-warning hs-alert", role = "alert",
          tags$strong("Check your data"),
          lapply(res$warnings, function(w) tags$p(class = "mb-0 mt-1", w)))
    },
    if (!is.null(s)) {
      tagList(
        tags$p(class = "hs-runline",
               tags$strong(res$label),
               sprintf(" with N = %s specimens and H* = %s haplotypes",
                       if (is_number(s$N)) fmt_int(s$N) else "?",
                       if (is_number(s$Hstar)) fmt_int(s$Hstar) else "?")),
        readout_ui(s)
      )
    },
    downloads_ui(),
    if (!is.null(s)) iteration_table_ui(s$table)
  )
}
