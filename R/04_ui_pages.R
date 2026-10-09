# Pages and theme. Text is carried over from the original app (a few typos corrected).

hacsim_theme <- function() {
  bslib::bs_theme(
    version = 5,
    bg = "#F5F7F8", fg = "#12262E",
    primary = "#C8423C", secondary = "#4A6CAE", success = "#1E7F72",
    info = "#4A6CAE", warning = "#F0A080", danger = "#B3261E",
    "border-radius" = "0.5rem",
    "border-radius-lg" = "0.9rem",
    "font-size-base" = "1rem"
  )
}

brand_ui <- function() {
  tags$a(
    href = "#", class = "hs-brand", `data-goto` = "home",
    tags$img(src = "HACSim.png", class = "hs-logo",
             alt = "HACSim: Haplotype Accumulation Curve Simulator")
  )
}

cta <- function(goto, ..., class = "btn-primary") {
  tags$a(href = "#", class = paste("btn btn-lg hs-cta", class), `data-goto` = goto, ...)
}

# ---- Home ------------------------------------------------------------------------------------

home_page <- function() {
  div(
    class = "hs-home",
    div(
      class = "hs-home-lead",
      h1(class = "hs-home-title",
         "HACSim helps researchers estimate required specimen sample sizes necessary for species genetic diversity assessment"),
      div(
        class = "hs-home-actions",
        cta("run", hs_icon("rocket"), " Run Simulation"),
        cta("tutorial", "Read the tutorial", class = "btn-outline-light")
      )
    ),
    tags$section(
      class = "hs-abstract", `aria-labelledby` = "hs-abstract-title",
      h2(id = "hs-abstract-title", "Abstract"),
      tags$p(ABSTRACT_TEXT)
    )
  )
}

# ---- Tutorial --------------------------------------------------------------------------------

shot <- function(src, alt, class = NULL) {
  tags$a(href = src, target = "_blank", rel = "noopener", class = paste("hs-shot", class),
         tags$img(src = src, alt = alt, loading = "lazy"))
}

tutorial_page <- function() {
  div(
    class = "hs-page hs-tutorial",
    div(
      class = "hs-panel",
      h2(class = "hs-h", "Running the Simulation"),
      tags$ol(
        class = "hs-steps",
        tags$li(
          tags$p(class = "hs-step-title",
                 "Click on the 'Run Simulation' button located at the top-right corner of the home page to start HACSim."),
          shot("run_button.png", "Start Simulator", "hs-shot-narrow")
        ),
        tags$li(
          tags$p(class = "hs-step-title",
                 "Enter all the required arguments in the main interface and sub interface."),
          tags$p(class = "hs-step-text",
                 "First, click on the main interface and fill in the desired number of permutations, proportion of",
                 " haplotypes to recover, as well as the desired confidence level for calculations and plotting.",
                 " By default, all iterations are run. However, users can choose to run the first iteration only.",
                 " This is useful when simulations take a long time to finish, or when a user is interested only in",
                 " assessing genetic diversity present in the current dataset. Next, go to the sub interface and",
                 " toggle either real or hypothetical species simulation type."),
          div(class = "hs-shots",
              shot("main_interface.png", "Main interface"),
              shot("sub_interface.png", "Sub interface"))
        ),
        tags$li(
          tags$p(class = "hs-step-title", "To simulate real species, follow the instructions in the picture below."),
          tags$p(class = "hs-step-text",
                 "Users can either upload an aligned and trimmed FASTA file, or choose from several preloaded",
                 " taxon datasets via a drop-down menu."),
          shot("real.png", "Real species", "hs-shot-narrow")
        ),
        tags$li(
          tags$p(class = "hs-step-title",
                 "To simulate hypothetical species, fill in the required input arguments depicted in the picture below."),
          shot("hypothetical.png", "Hypothetical species", "hs-shot-narrow")
        ),
        tags$li(
          tags$p(class = "hs-step-title",
                 "For both hypothetical and real species simulations, users have the option to input either the",
                 " proportion of haplotype labels or DNA sequences to subsample. To do so, click the appropriate",
                 " checkbox and enter the desired value in the input field."),
          tags$p(class = "hs-step-text",
                 "Once all steps have been completed, click 'Run'. If simulating a real species, upload your FASTA",
                 " file first, or show the preloaded examples and pick a species."),
          div(class = "hs-shots",
              shot("subsample.png", "Subsample DNA sequences"),
              shot("hit.png", "Run button"))
        )
      ),
      tags$p(class = "hs-prose",
             "Depending on the size of input parameters to the simulation, the algorithm in its current form can be",
             " quite slow to reach full convergence. For a species with equal haplotype frequency, saturation of the",
             " haplotype accumulation curve is (usually) reached very rapidly (one exception occurs when N = Hstar).",
             " On the other hand, for a species with many rare haplotypes, the generated haplotype accumulation curve",
             " will take significantly longer to reach an asymptote since rare haplotypes will not be sampled as",
             " frequently as dominant ones."),
      tags$p(class = "hs-prose",
             "Altered input parameters can be set back to their default values by clicking the 'Reset' button found",
             " in the main interface. In addition, the 'Refresh' button within the Sub interface can be used to clear",
             " the Results Panel between simulations.")
    )
  )
}

# ---- About -----------------------------------------------------------------------------------

hacsim_version <- function() {
  tryCatch(as.character(utils::packageVersion("HACSim")), error = function(e) "1.05")
}

ref_item <- function(...) tags$li(class = "hs-ref", ...)

about_page <- function() {
  div(
    class = "hs-page hs-about",
    div(
      class = "hs-panel",
      bslib::navset_pill(
        id = "about_tabs",
        bslib::nav_panel(
          "About HACSim", value = "about_hacsim",
          div(
            class = "hs-prose-block",
            h3(class = "hs-h", "What is HACSim and how does it work?"),
            tags$p("HACSim is a novel nonparametric stochastic (Monte Carlo) local search optimization algorithm",
                   " written in R for the simulation of haplotype accumulation curves. It can be employed to determine",
                   " likely required sample sizes for DNA barcoding, specifically pertaining to recovery of total",
                   " haplotype variation that may exist for a given species."),
            tags$p("Most DNA barcoding studies conducted to date suggest sampling between 5-10 individuals per",
                   " species due to research costs. However, it has been shown that low sample sizes can greatly",
                   " underestimate haplotype diversity for geographically-widespread taxa. The present algorithm",
                   " is in place to more accurately determine sample sizes that are needed to uncover all putative",
                   " haplotypes that may exist for a given species. Implications of such an approach include",
                   " accelerating the construction and growth of DNA barcode reference libraries for species of",
                   " interest within the Barcode of Life Data Systems",
                   tags$a(href = "http://www.boldsystems.org", target = "_blank", rel = "noopener", "(BOLD)"),
                   "or similar database such as",
                   tags$a(href = "https://www.ncbi.nlm.nih.gov/genbank/", target = "_blank", rel = "noopener", "GenBank.")),
            tags$p("Within the simulation algorithm, species haplotypes are treated as distinct character labels",
                   " (1, 2, ...), where 1 denotes the most frequent haplotype, 2 denotes the second-most frequent",
                   " haplotype, and so forth. The algorithm then randomly samples species haplotype labels in an",
                   " iterative fashion, until all unique haplotypes have been observed. The idea is that levels of",
                   " species haplotypic variation that are currently catalogued in BOLD can serve as proxies for",
                   " total haplotype diversity that may exist for a given species."),
            tags$p("Molecular loci besides DNA barcode genes (5'-COI, rbcL/matK, ITS regions) can be used with HACSim (",
                   tags$em("e.g.,", .noWS = c("before")), "cytb)."),
            h3(class = "hs-h", "App version"),
            tags$p(sprintf("The HACSim R Shiny web app is currently running on version %s of the HACSim R package.",
                           hacsim_version()))
          )
        ),
        bslib::nav_panel(
          "More Information", value = "more_info",
          div(
            class = "hs-prose-block",
            h3(class = "hs-h", "More Information"),
            tags$p("Are you interested in doing even more with HACSim? Consider downloading the R package! See the HACSim",
                   tags$a(href = "https://cran.r-project.org/web/packages/HACSim/index.html",
                          target = "_blank", rel = "noopener", "CRAN"),
                   "page for more details. You can also check out the development version of the HACSim R package on",
                   tags$a(href = "https://github.com/jphill01/HACSim.R", target = "_blank", rel = "noopener", "GitHub."))
          )
        ),
        bslib::nav_panel(
          "Authors", value = "authors",
          div(
            class = "hs-prose-block",
            h3(class = "hs-h", "Jarrett D. Phillips"),
            tags$p("Email: ", tags$a(href = "mailto:phillipsjarrett1@gmail.com", "phillipsjarrett1@gmail.com")),
            h3(class = "hs-h", "Navdeep Singh"),
            tags$p("Email: ", tags$a(href = "mailto:navuonweb@gmail.com", "navuonweb@gmail.com"))
          )
        ),
        bslib::nav_panel(
          "Citations", value = "citations",
          div(
            class = "hs-prose-block",
            h3(class = "hs-h", "Citations"),
            tags$p("If you intend to use the HACSim R Shiny web app in your research, please cite the HACSim publication",
                   " below. A publication for the app is currently in preparation for submission to",
                   tags$em("Bioinformatics"), "as an Application Note."),
            tags$ul(
              class = "hs-refs",
              ref_item(
                "Chang, W., Cheng, J., Allaire, J.J., Sievert, C., Schloerke, B., Xie, Y., Allen, J., McPherson, J.,",
                " Dipert, A. and Borges, B. (2021). shiny: Web Application Framework for R. R package version 1.6.0.",
                tags$a(href = "https://CRAN.R-project.org/package=shiny", target = "_blank", rel = "noopener",
                       "https://CRAN.R-project.org/package=shiny")
              ),
              ref_item(
                tags$strong("Phillips, J.D.", .noWS = c("after")), ", French, S.H., Hanner, R.H. and Gillis, D.J. (2020).",
                " HACSim: An R package to estimate intraspecific sample sizes for genetic diversity assessment using",
                " haplotype accumulation curves. ", tags$em("PeerJ Computer Science,"), " ",
                tags$strong("6", .noWS = c("after")), "(192): 1-37. ",
                tags$a(href = "https://doi.org/10.7717/peerj-cs.243", target = "_blank", rel = "noopener",
                       "DOI: 10.7717/peerj-cs.243.")
              ),
              ref_item(
                tags$strong("Phillips, J.D.", .noWS = c("after")), ", Gillis, D.J. and Hanner, R.H. (2019).",
                " Incomplete estimates of genetic diversity within species: Implications for DNA barcoding. ",
                tags$em("Ecology and Evolution,"), " ", tags$strong("9", .noWS = c("after")), "(5): 2996-3010. ",
                tags$a(href = "https://doi.org/10.1002/ece3.4757", target = "_blank", rel = "noopener",
                       "DOI: 10.1002/ece3.4757.")
              ),
              ref_item(
                tags$strong("Phillips, J.D.", .noWS = c("after")), ", Gwiazdowski, R.A., Ashlock, D. and Hanner, R. (2015).",
                " An exploration of sufficient sampling effort to describe intraspecific DNA barcode haplotype",
                " diversity: examples from the ray-finned fishes (Chordata: Actinopterygii). ",
                tags$em("DNA Barcodes,"), " ", tags$strong("3", .noWS = c("after")), ": 66-73. ",
                tags$a(href = "https://doi.org/10.1515/dna-2015-0008", target = "_blank", rel = "noopener",
                       "DOI: 10.1515/dna-2015-0008.")
              ),
              ref_item(
                "Ratnasingham, S. and Hebert, P.D.N. (2007). BOLD: The Barcode of Life Data System",
                " (www.barcodinglife.org). ", tags$em("Molecular Ecology Notes"), " ",
                tags$strong("7", .noWS = c("after")), "(3): 355-364. URL: ",
                tags$a(href = "https://v4.boldsystems.org", target = "_blank", rel = "noopener",
                       "https://v4.boldsystems.org.")
              )
            )
          )
        )
      )
    )
  )
}

# ---- Run Simulation --------------------------------------------------------------------------

run_page <- function() {
  div(
    class = "hs-page hs-run",
    div(
      class = "hs-panel hs-params",
      bslib::navset_pill(
        id = "param_tabs",
        bslib::nav_panel("Main interface", value = "main", main_interface_ui()),
        bslib::nav_panel("Sub interface", value = "sub", sub_interface_ui())
      )
    ),
    results_ui()
  )
}
