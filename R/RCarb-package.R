#' @title RCarb - Dose Rate Modelling of Carbonate-Rich Samples
#'
#' @description The package provides a dose rate modelling for carbonate-rich samples in the
#' context of trapped charged dating (e.g., luminescence dating) applications.
#'
#'
#' \if{html}{
#' \figure{Logo_RCarb.png}{options: width="50px" alt="https://github.com/R-Lum/RCarb"}\cr
#' }
#'
#'
#' \tabular{ll}{
#' **Package:** \tab RCarb\cr
#' **Type:** \tab Package\cr
#' **Version:** \tab 0.1.2\cr
#' **Date:** \tab 2018-12-02\cr
#' **License:** \tab GPL-3
#' }
#'
#' @name RCarb-package
#'
#' @aliases RCarb-package RCarb
#'
#' @docType package
#'
#' @keywords package
#'
#' @import utils
#'
#' @references
#'
#' This package bases on a 'MATLAB' programme with name 'Carb', details can be found the
#' following references:\cr
#'
#' Mauz, B., Hoffmann, D., 2014. What to do when carbonate replaced water: Carb, the model for estimating the
#' dose rate of carbonate-rich samples. Ancient TL 32, 24–32. \url{http://ancienttl.org/ATL_32-2_2014/ATL_32-2_Mauz_p24-32.pdf}
#'
#' Nathan, R.P., Mauz, B., 2008. On the dose-rate estimate of carbonate-rich sediments for trapped charge dating.
#' Radiation Measurements 43, 14–25. \doi{10.1016/j.radmeas.2007.12.012}
#'
#' **Further reading**
#'
#' Nathan, R.P., 2010. Numerical modelling of environmental dose rate and its application to trapped-charge dating.
#' DPhil thesis, St Hugh’s College, Oxford. \url{https://ora.ox.ac.uk/objects/ora:6421}
#'
#' @importFrom grDevices rgb
#' @importFrom graphics plot plot.default abline lines par mtext polygon points
#' @importFrom stats approx nlminb rnorm sd na.exclude density
#'
#' @md
NULL


#' Example data
#'
#' @name Example_Data
#'
#' @description
#' Example data as shipped with *Carb* by Mauz \& Hoffmann (2014). In contrast to the original
#' data, `NA` values have been replaced by 0 and columns and rows have been transposed. Samples
#' are now organised in rows and parameters in columns.
#'
#' The data can be used to test 'RCarb' and play with the secondary carbonatisation process.
#' Sample HD107 was remnamed to LV107 for the sake of consistency with Fig. 4 in Mauz \& Hoffmann (2014).
#'
#'
#' @format
#'
#' `Example_Data`: [data.frame] (28 x 29)
#'
#' Each column has two attributes:
#'
#' - `UNIT`: the unit, so far applicable, e.g. "ppm"
#' - `DESCRIPTION`: the column description
#'
#' @section Version: 0.1.0
#'
#' @keywords datasets
#'
#' @author Mauz \& Hoffmann (2014), with minor modifcations by Sebastian Kreutzer, IRAMAT-CRP2A, UMR 5060,
#' CNRS-Université Bordeaux Montaigne (France)
#'
#'
#' @references
#'
#' Mauz, B., Hoffmann, D., 2014. What to do when carbonate replaced water: Carb, the model
#' for estimating the dose rate of carbonate-rich samples. Ancient TL 32, 24-32.
#'
#' @examples
#'
#' ## show first elements of the example data
#' data(Example_Data, envir = environment())
#' head(Example_Data)
#'
#' ##show only column U230
#' Example_Data$U238
#'
#' @docType data
#' @md
NULL


#' Reference data
#'
#' @name Reference_Data
#'
#' @description Correction factors for beta and gamma radiation used for internal calculations.
#' These values are used instead of the correction factors given in Aitken (1985) for the carbonate model.
#'
#' @details The reference values are used internally to account for: (1) grain size depend beta-attenuation
#' factors (Mejdahl, 1979) and (2) to correct nuclide dependent beta and gamma radiation for water/carbonate proportions.
#' The latter values are given as matrix and precise values are interpolated during the modelling process.
#'
#' Different values quoted for U-238 and U-234 accounts for different activity ratios. For further details
#' on the origin of these data we refer to Nathan \& Mauz (2008) and Nathan (2010).\cr
#'
#' **Nuclear data origin according to Nathan \& Mauz (2008)**
#'
#' The gamma primary energy spectra of uranium, thorium and potassium are drawn from
#' Evaluated Nuclear Structure Data File (ENSDF) database at \url{http://www.nndc.bnl.gov} (2002-01-16)
#' and the beta primary energy spectra was derived from ENSDF end-point energies using a
#' Fermi beta decay model (Evans, 1955) modified by Behrens \& Szybisz (1976).
#' For the simulations of the collisional mass stopping powers for quartz the software ESTAR
#' (Berger et al., 2000) was used. The mass energy-absorption coefficients for quartz were
#' tabulated by Hubbell \& Seltzer (2004).
#'
#' *For further details and references please read Nathan \& Mauz (2008)*
#'
#'
#' @format
#'
#' `Reference_Data`: [list] \cr
#'
#' \tabular{llll}{
#' **NAME** \tab **TYPE** \tab **DIM** \tab **DESCRIPTION**\cr
#' DATAek \tab	 `matrix` \tab 4 x 4 \tab correction factors for electrons for water and carbonate to sediment mass ratio for K\cr
#' DATAet \tab	 `matrix` \tab 4 x 4 \tab correction factors for electrons for water and carbonate to sediment mass ratio for Th \cr
#' DATAet230 	\tab `matrix` \tab 4 x 4 \tab correction factors for electrons for water and carbonate to sediment mass ratio for Th-230\cr
#' DATAeu 	\tab `matrix` \tab 4 x 4 \tab correction factors for electrons for water and carbonate to sediment mass ratio for U\cr
#' DATAeu234 	\tab `matrix` \tab 4 x 4 \tab correction factors for electrons for water and carbonate to sediment mass ratio for U-234\cr
#' DATAeu238 	\tab `matrix` \tab 4 x 4 \tab correction factors for electrons for water and carbonate to sediment mass ratio for U-238\cr
#' DATApk \tab	 `matrix` \tab 4 x 4 \tab correction factors for photons for water and carbonate to sediment mass ratio for K\cr
#' DATApt \tab	 `matrix` \tab 4 x 4 \tab correction factors for photons for water and carbonate to sediment mass ratio for T\cr
#' DATApt230 \tab	 `matrix` \tab 4 x 4 \tab correction factors for photons for water and carbonate to sediment mass ratio for Th-230\cr
#' DATApu \tab	 `matrix` \tab 4 x 4 \tab correction factors for photons for water and carbonate to sediment mass ratio for U\cr
#' DATApu234 \tab	 `matrix` \tab 4 x 4 \tab correction factors for photons for water and carbonate to sediment mass ratio for U-234\cr
#' DATApu238 \tab	 `matrix` \tab 4 x 4 \tab correction factors for photons for water and carbonate to sediment mass ratio for U-238\cr
#' mejdahl \tab	 `data.frame` \tab 36 x 4 \tab beta-dose attenuation values for quartz grains according to Mejdahl (1979)
#' }
#'
#' @section Version: 0.1.0
#'
#' @keywords datasets
#'
#' @references
#'
#' Mejdahl, V., 1979. Thermoluminescence dating: beta-dose attenuation in quartz grains. Archaeometry 21, 61-72.
#' \url{http://ancienttl.org/ATL_32-2_2014/ATL_32-2_Mauz_p24-32.pdf}
#'
#' Nathan, R.P., Mauz, B., 2008. On the dose-rate estimate of carbonate-rich sediments for trapped charge dating.
#' Radiation Measurements 43, 14-25. \doi{10.1016/j.radmeas.2007.12.012}
#'
#' Nathan, R.P., 2010. Numerical modelling of environmental dose rate and its application to trapped-charge dating.
#' DPhil thesis, St Hugh’s College, Oxford. \url{https://ora.ox.ac.uk/objects/ora:6421}\cr
#'
#' **Further reading**
#'
#' Aitken, M.J., 1985. Thermoluminescence dating. Academic Press.
#'
#' Berger, M.J., Coursey, J.S., Zucker, M.A., 2000. ESTAR, PSTAR, and
#' ASTAR: Computer Programs for Calculating Stopping-Power and Range
#' Tables for Electrons, Protons, and Helium Ions (version 1.2.2).
#' http://physics.nist.gov/Star (2005-08-09).
#' National Institute of Standards and Technology, Gaithersburg, MD.
#'
#' Behrens, H., Szybisz, L., 1976. Shapes of beta spectra. Physics Data 6-1,
#' Zentralstelle fuer Atomkernenergie-Dokumentation (ZAED), Germany.
#'
#' Evans, R.D., 1955. The Atomic Nucleus. McGraw-Hill, NY.
#'
#' Hubbell, J.H., Seltzer, S.M., 2004. Tables of X-Ray Mass Attenuation Coefficients and Mass
#' Energy-Absorption Coefficients (version 1.4). http://physics.nist.gov/xaamdi
#' (2005-08-09). National Institute of Standards and Technology, Gaithersburg, MD.
#'
#'
#' @examples
#'
#' data(Reference_Data, envir = environment())
#' str(Reference_Data)
#' Reference_Data$DATAek
#'
#' @docType data
#' @md
NULL