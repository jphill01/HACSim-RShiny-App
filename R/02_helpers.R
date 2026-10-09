# Helper functions: parsing, validation, running the simulation and summarising it.
# Nothing in this file touches Shiny, so each function can be tested on its own.

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

is_number <- function(x) {
  is.numeric(x) && length(x) == 1 && !is.na(x) && is.finite(x)
}

is_blank_number <- function(x) {
  is.null(x) || length(x) == 0 || is.na(x[[1]])
}

fmt_int <- function(x) {
  format(round(x), big.mark = ",", scientific = FALSE, trim = TRUE)
}

fmt_pct <- function(x, digits = 3) {
  paste0(signif(100 * x, digits), "%")
}

# "0.5, 0.3, 0.2" -> c(0.5, 0.3, 0.2). Entries that are not numbers become NA.
parse_probs <- function(x) {
  if (is.null(x) || length(x) != 1 || is.na(x) || !nzchar(trimws(x))) {
    return(numeric(0))
  }
  parts <- trimws(strsplit(x, ",", fixed = TRUE)[[1]])
  parts <- parts[nzchar(parts)]
  suppressWarnings(as.numeric(parts))
}

SUBSAMPLE_MESSAGE <- paste(
  "Proportion to subsample is either missing, non-numeric, less than or equal to zero",
  "or greater than one. Enter a numeric value greater than 0 and at most 1."
)

# ---- Validation ---------------------------------------------------------------------------

# Checks for the N / H* / probs triple (hypothetical species and preloaded examples).
validate_dataset <- function(N, Hstar, probs) {
  msgs <- character()
  if (!is_number(N) || !is_number(Hstar)) {
    msgs <- c(msgs, "N and Hstar must both be numbers")
  } else {
    if (N < Hstar) msgs <- c(msgs, "N must be greater than or equal to Hstar")
    if (N <= 1) msgs <- c(msgs, "N must be greater than 1")
    if (Hstar <= 1) msgs <- c(msgs, "H* must be greater than 1")
    if (N != round(N) || Hstar != round(Hstar)) {
      msgs <- c(msgs, "N and Hstar must be whole numbers")
    }
  }
  if (length(probs) == 0 || anyNA(probs)) {
    msgs <- c(msgs, "probs must be a comma-separated list of numbers, for example 0.5, 0.3, 0.2")
  } else {
    if (any(probs < 0)) {
      msgs <- c(msgs, "probs must not contain negative values")
    }
    if (!isTRUE(all.equal(1, sum(probs), tolerance = .Machine$double.eps^0.25))) {
      msgs <- c(msgs, "probs must sum to 1")
    }
    if (is_number(Hstar) && length(probs) != Hstar) {
      msgs <- c(msgs, "probs must have Hstar elements")
    }
  }
  msgs
}

# Checks every input collected by the Run button. `a` is the list built by read_inputs() in app.R.
validate_params <- function(a) {
  msgs <- character()

  if (!is_number(a$perms) || a$perms <= 1) {
    msgs <- c(msgs, "perms must be greater than 1")
  } else if (a$perms != round(a$perms)) {
    msgs <- c(msgs, "perms must be a whole number")
  }
  if (!is_number(a$p) || a$p <= 0 || a$p > 1) {
    msgs <- c(msgs, "p must be greater than 0 and less than or equal to 1")
  }
  if (!is_number(a$conf.level) || a$conf.level <= 0 || a$conf.level >= 1) {
    msgs <- c(msgs, "conf.level must be between 0 and 1.")
  }
  if (!is.null(a$num.iters) && !(is_number(a$num.iters) && a$num.iters == 1)) {
    msgs <- c(msgs, "num.iters must be left blank (run all iterations) or set to 1 (first iteration only)")
  }

  if (identical(a$mode, "real_upload")) {
    if (is.null(a$fasta_path) || !nzchar(a$fasta_path)) {
      msgs <- c(msgs, "Upload an aligned FASTA file (.fas, .fasta, .fa or .fna) to simulate a real species, or show the preloaded examples.")
    } else if (!(tolower(tools::file_ext(a$fasta_name)) %in% c("fas", "fasta", "fa", "fna"))) {
      msgs <- c(msgs, "Please upload a FASTA file (.fas, .fasta, .fa or .fna)")
    }
  } else {
    msgs <- c(msgs, validate_dataset(a$N, a$Hstar, a$probs))
    if (is_number(a$perms) && is_number(a$N) && a$perms * a$N > MAX_CELLS) {
      msgs <- c(msgs, "perms x N is too large for this app to run. Reduce the number of permutations or specimens.")
    }
  }

  if (isTRUE(a$subsample)) {
    if (!is_number(a$prop) || a$prop <= 0 || a$prop > 1) {
      msgs <- c(msgs, SUBSAMPLE_MESSAGE)
    } else if (!identical(a$mode, "real_upload") && is_number(a$Hstar) && ceiling(a$prop * a$Hstar) < 2) {
      msgs <- c(msgs, "The subsample must keep at least 2 haplotypes. Increase the proportion to subsample.")
    }
  }
  msgs
}

# ---- Reading a FASTA alignment --------------------------------------------------------------

# Turns an aligned FASTA file into the N / H* / probs triple HACSim needs.
# This is what the HACSim package does internally for real species, except that it asks for the file
# with file.choose(), which cannot work on a web server.
read_haplotypes <- function(path, subsample = FALSE, prop = NULL) {
  seqs <- ape::read.dna(file = path, format = "fasta")
  if (!is.matrix(seqs)) {
    stop("The FASTA file is not an alignment because its sequences have different lengths. ",
         "Align and trim the sequences, then upload the file again.", call. = FALSE)
  }
  warns <- character()

  bf <- tryCatch(ape::base.freq(seqs, all = TRUE)[5:17], error = function(e) 0)
  if (any(bf > 0)) {
    warns <- c(warns, paste(
      "The uploaded sequences contain missing and/or ambiguous nucleotides, which may lead to",
      "overestimation of the number of observed unique haplotypes. Consider excluding sequences or",
      "alignment sites containing these data. If missing and/or ambiguous bases occur at the ends of",
      "sequences, further alignment trimming is an option."
    ))
  }

  n_total <- nrow(seqs)
  if (isTRUE(subsample)) {
    keep <- sample(n_total, size = ceiling(prop * n_total), replace = FALSE)
    if (length(keep) < 2) {
      stop("The subsample must keep at least 2 sequences. Increase the proportion to subsample.", call. = FALSE)
    }
    seqs <- seqs[keep, , drop = FALSE]
  }

  N <- nrow(seqs)
  h <- pegas::haplotype(seqs)
  h <- sort(h, decreasing = TRUE, what = "frequencies")
  probs <- as.numeric(lengths(attr(h, "index"))) / N

  list(N = N, Hstar = nrow(h), probs = probs, n_total = n_total, warnings = warns)
}

# ---- Running the simulation -----------------------------------------------------------------

# Tidies what HAC.simrep() prints: drops the console progress bar, squeezes whitespace and removes
# runs of blank lines. Line breaks are kept because the report relies on them.
clean_log <- function(x) {
  if (length(x) == 0) return(character())
  x <- unlist(strsplit(paste(x, collapse = "\n"), "\n", fixed = TRUE))
  x <- gsub("\\|[= ]*\\|\\s*[0-9]+%", "", x)
  x <- gsub("[[:space:]]+", " ", x)
  x <- trimws(x)
  blank <- !nzchar(x)
  x <- x[!(blank & c(TRUE, utils::head(blank, -1)))]   # drop leading blanks and repeated blanks
  while (length(x) > 0 && !nzchar(x[length(x)])) x <- x[-length(x)]
  x
}

# Pulls the headline numbers out of the package's results environment, exactly as HAC.simrep()
# reports them. Anything missing becomes NA and the corresponding card is simply left out.
summarise_run <- function(env, a, elapsed) {
  if (!is.environment(env)) return(NULL)
  value <- function(name) tryCatch(get0(name, envir = env, inherits = FALSE), error = function(e) NULL)
  first_num <- function(name) {
    v <- value(name)
    if (is.numeric(v) && length(v) >= 1 && is.finite(v[[1]])) as.numeric(v[[1]]) else NA_real_
  }
  last_num <- function(name) {
    v <- value(name)
    if (is.numeric(v) && length(v) >= 1 && is.finite(v[[length(v)]])) as.numeric(v[[length(v)]]) else NA_real_
  }

  R <- first_num("R")
  Nstar <- first_num("Nstar")
  X <- first_num("X")
  n_star <- if (is.finite(Nstar) && is.finite(X)) Nstar - X else NA_real_

  tab <- value("df.out")
  if (is.data.frame(tab) && nrow(tab) > 0) {
    tab <- data.frame(Iteration = seq_len(nrow(tab)), tab, check.names = FALSE)
  } else {
    tab <- NULL
  }

  list(
    N = a$N, Hstar = a$Hstar, p = a$p, conf.level = a$conf.level, perms = a$perms,
    reached = is.finite(R) && R >= a$p,
    first_only = !is.null(a$num.iters),
    n_star = n_star,
    n_low = first_num("Nstar.low"),
    n_high = first_num("Nstar.high"),
    R = R, R_low = last_num("R.low"), R_high = last_num("R.high"),
    iters = first_num("iters"),
    elapsed = elapsed,
    table = tab
  )
}

# Runs one simulation. Graphics go to `pdf_path`; everything the package prints is captured.
# Always returns a list with ok = TRUE/FALSE and never throws.
run_simulation <- function(a, pdf_path) {
  t0 <- proc.time()[["elapsed"]]
  warn_msgs <- character()
  label <- a$label

  out <- tryCatch({
    if (identical(a$mode, "real_upload")) {
      info <- read_haplotypes(a$fasta_path, subsample = isTRUE(a$subsample), prop = a$prop)
      a$N <- info$N
      a$Hstar <- info$Hstar
      a$probs <- info$probs
      a$subsample <- FALSE            # sequences were already subsampled above
      warn_msgs <- c(warn_msgs, info$warnings)
      label <- sprintf("%s (%s of %s sequences used)", a$fasta_name, fmt_int(info$N), fmt_int(info$n_total))

      problems <- validate_dataset(a$N, a$Hstar, a$probs)
      if (is_number(a$perms) && a$perms * a$N > MAX_CELLS) {
        problems <- c(problems, "perms x N is too large for this app to run. Reduce the number of permutations or sequences.")
      }
      if (length(problems) > 0) {
        stop(paste(problems, collapse = "; "), call. = FALSE)
      }
    }

    obj <- HACSim::HACHypothetical(
      N = a$N, Hstar = a$Hstar, probs = a$probs,
      perms = a$perms, p = a$p, conf.level = a$conf.level,
      subsample = isTRUE(a$subsample),
      prop = if (isTRUE(a$subsample)) a$prop else NULL,
      progress = TRUE,            # HACSim only draws its plots and report when progress is TRUE
      num.iters = a$num.iters,
      filename = NULL
    )

    grDevices::pdf(file = pdf_path, width = 12, height = 5, onefile = TRUE,
                   title = "HACSim Graphics Output", paper = "special")
    dev_id <- grDevices::dev.cur()
    on.exit({
      if (dev_id %in% grDevices::dev.list()) grDevices::dev.off(dev_id)
    }, add = TRUE)

    log <- withCallingHandlers(
      utils::capture.output(suppressMessages(HACSim::HAC.simrep(obj))),
      warning = function(w) {
        warn_msgs <<- c(warn_msgs, conditionMessage(w))
        invokeRestart("muffleWarning")
      }
    )
    grDevices::dev.off(dev_id)

    # Read the results straight away: HACSim keeps them in one environment shared by all sessions.
    env <- tryCatch(get("envr", envir = asNamespace("HACSim")), error = function(e) NULL)
    summary <- summarise_run(env, a, elapsed = proc.time()[["elapsed"]] - t0)

    list(ok = TRUE, log = clean_log(log), summary = summary, label = label,
         warnings = unique(clean_log(warn_msgs)))
  }, error = function(e) {
    list(ok = FALSE, title = "The simulation stopped with an error.", errors = conditionMessage(e))
  })

  out
}
