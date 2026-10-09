# Constants shared by the UI and the server.
# Generated from the original HACSim app so preset data are not retyped.

APP_TITLE   <- "HACSim: Haplotype Accumulation Curve Simulator"
APP_VERSION <- "2.0.0"

# Default values used by the inputs and by the Reset button.
DEFAULTS <- list(
  perms     = 10000,
  p         = 0.95,
  conf.level = 0.95,
  num.iters = NA,
  N         = 100,
  Hstar     = 5,
  probs     = "0.20, 0.20, 0.20, 0.20, 0.20",
  prop      = 0.20,
  prop_2    = 0.20,
  species   = "Pea aphid (Acyrthosiphon pisum)"
)

# Preloaded real-species examples (order = order in the drop-down).
# `id` keeps the original input suffixes (N_load_a, Hstar_load_a, probs_load_a, ...).
SPECIES_PRESETS <- list(
  list(
    id    = "b",
    label = "Pea aphid (Acyrthosiphon pisum)",
    fasta = "Acyrthosiphon pisum_aligned.fas",
    N     = 356,
    Hstar = 12,
    probs = "0.966292135,0.005617978,0.002808989,0.002808989,0.002808989,0.002808989, 0.002808989,0.002808989,0.002808989,0.002808989,0.002808989,0.002808989"
  ),
  list(
    id    = "a",
    label = "Lake whitefish (Coregonus clupeaformis)",
    fasta = "Coregonus clupeaformis_aligned.fas",
    N     = 235,
    Hstar = 15,
    probs = "0.914893617,0.012765957,0.012765957,0.008510638,0.008510638,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319"
  ),
  list(
    id    = "c",
    label = "Common mosquito (Culex pipiens)",
    fasta = "Culex pipens_aligned.fas",
    N     = 217,
    Hstar = 25,
    probs = "0.843317972,0.032258065,0.009216590,0.009216590,0.009216590,0.009216590,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295"
  ),
  list(
    id    = "d",
    label = "Deer tick (Ixodes scapularis)",
    fasta = "Ixodes scapularis_aligned.fas",
    N     = 349,
    Hstar = 83,
    probs = "0.131805158,0.083094556,0.071633238,0.063037249,0.057306590,0.037249284,0.034383954,0.034383954,0.025787966,0.022922636,0.020057307,0.020057307,0.020057307,0.017191977,0.017191977,0.014326648,0.014326648,0.014326648,0.011461318,0.011461318,0.011461318,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330"
  ),
  list(
    id    = "e",
    label = "Gypsy moth (Lymantria dispar)",
    fasta = "Lymantria dispar_aligned.fas",
    N     = 365,
    Hstar = 58,
    probs = "0.232876712,0.208219178,0.120547945,0.106849315,0.035616438,0.024657534,0.024657534,0.019178082,0.013698630,0.013698630,0.013698630,0.010958904,0.010958904,0.010958904,0.008219178,0.008219178,0.008219178,0.005479452,0.005479452,0.005479452,0.005479452,0.005479452,0.005479452,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726"
  ),
  list(
    id    = "f",
    label = "Scalloped hammerhead shark (Sphyrna lewini)",
    fasta = "Sphyrna lewini_aligned.fas",
    N     = 171,
    Hstar = 12,
    probs = "0.409356725,0.304093567,0.163742690,0.035087719,0.029239766,0.023391813,0.005847953,0.005847953,0.005847953,0.005847953,0.005847953,0.005847953"
  )
)

# Largest perms x N the app will attempt (keeps a shared server from running out of memory).
MAX_CELLS <- 5e8

ABSTRACT_TEXT <- "Assessing levels of standing genetic variation within species requires a robust sampling for the purpose of accurate specimen identification using molecular techniques such as DNA barcoding; however, statistical estimators for what constitutes a robust sample are currently lacking. Moreover, such estimates are needed because most species are currently represented by only one or a few sequences in existing databases, which can safely be assumed to be undersampled. Unfortunately, sample sizes of 5\u201310 specimens per species typically seen in DNA barcoding studies are often insufficient to adequately capture within-species genetic diversity. Here, we introduce a novel iterative extrapolation simulation algorithm of haplotype accumulation curves, called HACSim (Haplotype Accumulation Curve Simulator) that can be employed to calculate likely sample sizes needed to observe the full range of DNA barcode haplotype variation that exists for a species. Using uniform haplotype and non-uniform haplotype frequency distributions, the notion of sampling sufficiency (the sample size at which sampling accuracy is maximized and above which no new sampling information is likely to be gained) can be gleaned. HACSim can be employed in two primary ways to estimate specimen sample sizes: (1) to simulate haplotype sampling in hypothetical species, and (2) to simulate haplotype sampling in real species mined from public reference sequence databases like the Barcode of Life Data Systems (BOLD) or GenBank for any genomic marker of interest. While our algorithm is globally convergent, runtime is heavily dependent on initial sample sizes and skewness of the corresponding haplotype frequency distribution."
