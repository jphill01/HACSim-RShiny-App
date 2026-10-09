# HACSim Shiny app 

A rebuilt version of the HACSim R Shiny web app. Every page, input, button and output from the original is still here. The code is reorganised, the design is new, and "Real" mode now works on a web server.

## Run it

```r
install.packages(c("shiny", "bslib", "shinyjs", "shinycssloaders", "HACSim"))
shiny::runApp("HACSim-RShiny-App")
```

Needs R 4.1 or newer, shiny 1.7+, bslib 0.5+. `ape` and `pegas` come with HACSim. To redeploy to shinyapps.io, deploy the folder as it is (`rsconnect/` is the original deployment record).

## What is kept

| Original element | Now |
| --- | --- |
| Logo, Home, Tutorial, About, Run Simulation tabs | Same four tabs. Run Simulation is drawn as a button, as before. |
| Home headline and abstract | Same text. |
| Tutorial steps and all seven screenshots | Same steps and images. |
| About: About HACSim, More Information, Authors, Citations | Same four tabs and text. Citations now link to their DOIs. |
| Main interface: perms, p, conf.level, num.iters, Progress (locked on), Reset | Same inputs, defaults and limits. |
| Sub interface: Real / Hypothetical, Preloaded examples Show / Hide | Same. Real / Hypothetical is now a segmented control. |
| Six preloaded species with FASTA download link, "Upload complete" bar, N, Hstar, probs | Same, generated from one list in `R/01_constants.R`. |
| Subsample checkboxes and proportions (`prop`, `prop_2`) | Same. |
| Run, Refresh, Disclaimer | Same. |
| Result Panel with report text, PDF viewer and loading GIF | Same, plus the additions below. |

## What changed

- **Real species with your own data now works on a server.** HACSim's real-species mode opens a file chooser (`file.choose()`), which cannot work on a hosted app. The app now has a FASTA upload (`fastafile`), reads the alignment itself and passes the haplotype counts to HACSim.
- **Results are per session.** The original wrote every user's plots to the same `www/Rplots.pdf`. Each session now gets its own folder, removed when the session ends.
- **Result summary.** The estimate N\*, its confidence interval, additional specimens needed and iterations are shown at the top, with N, N\* and the interval on one scale. Downloads for the plots (PDF), per-iteration results (CSV) and the report (TXT).
- **Clearer input checks.** Problems are listed in the Result Panel in plain words. Added checks: `num.iters` must be blank or 1 (any other value made HACSim fail), subsample proportions must be above 0, and a size limit on `perms` x `N` protects shared servers.
- **Preloaded examples and subsampling.** With preloaded examples there are no sequences to subsample, so the checkbox switches to "Subsample haplotype labels".
- **Reset** now returns every input to its default, including the switches.
- **Fewer packages.** `shinydashboard`, `shinydashboardPlus`, `shinymeta`, `ggplot2`, `stringr` and `shinyWidgets` were loaded but not needed.
- **Example FASTA files are bundled** in `www/`, so the download links no longer lead nowhere.
- **Small fixes.** Logo no longer stretched, `alt` text typo, typos in the Tutorial and About text, About page shows the installed HACSim version instead of a fixed "1.05".

## Things to know

- The Tutorial screenshots are the originals and show the old look. Retake them when convenient.
- HACSim keeps its results in one shared environment, so the app runs one simulation at a time per R process (as the original did).
- The app was written without access to an R installation, so it has not been run end to end. See the notes that came with this delivery.
