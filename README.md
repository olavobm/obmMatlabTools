# obmMatlabTools

Matlab functions I've written over the years for my own work. This repository is in constant development and contains several functions called by my other repositories. In addition, there is a folder (byOthers) with general functions written by other people that I decided to include in my personal coding toolkit.

Though these functions were mostly designed with oceanographic data analysis in mind, most of them are quite general and can be combined in different ways to help you achieve your goals. See some examples of functions I have found particularly useful in various situations and I hope them to be helpful for many people out there.

## Interpolation:

Let’s say you want to linearly interpolate (in 1D) a variable (*data*) specified at *t*. You can do:

```matlab
datainterp = interp1overnans(t, data, tinterp, maxgap)
```

The variable data can be a vector or a matrix, in which case, each column is interpolated separately. The function takes care of NaNs, such that it fills the gaps (NaN locations) with interpolated values. The last 2 inputs of the function above are optional. Input *tinterp* explicitly defines where you want to interpolate and *maxgap* defines an upper bound for the length of the gap that can be interpolated over.

## Spectral estimates:

In many scientific areas, estimating power spectra is a routine job. However, from my experience, there are several **little details** that are usually not explained and can cause a lot of pain for beginners when writing their own code. The comments in my functions hopefully address these issues.

### Power spectrum:

There are [several ways](https://en.wikipedia.org/wiki/Spectral_density_estimation) to estimate the power spectral density of a digital signal. In fact, we never compute the true power spectrum: we make an **estimate**. Over time, better estimates have been developed. See below an example for making an estimate using the [Welch's method](https://en.wikipedia.org/wiki/Welch%27s_method), which is still widely used, though the Multitaper method gives a better estimate.

Given a vector (real or complex) *data*, regularly spaced by *dt*, make an estimate of the power spectrum by simply calling

```matlab
[pwspec] = obmPSpec(data, dt, np, ovrlap)
```

The function computes power spectra for data chunks of *np* data points, overlapping those chunks by *ovrlap* ($0 \leq ovrlap < 1$) and finally taking the mean of all spectra. Each chunk is windowed by a hanning window. The output is a struct variable with the following fields:

**To be continued...**

* freq
* allpsd
* psd
* fcoef
* dof
* err

### Cross-spectral analysis:

## Classical least-squares fit:

## Plotting a vector field:

## Plotting a vector field:

## Miscellaneous stuff:
