# obmMatlabTools

Matlab functions I've written over the years for my own work. This repository is in constant development and contains several functions called by my other repositories. In addition, there is a folder (byOthers) with general functions written by other people that I decided to include in my personal coding toolkit.

Though these functions were mostly designed with oceanographic data analysis in mind, most of them are quite general and can be combined in different ways to help you achieve your goals. See my description below of some functions I have found particularly useful in various situations.

## Examples

### Interpolation:

Let’s say you want to linearly interpolate (in 1D) a variable (*data*) whose values are specified at *t*. You can do:

```matlab
datainterp = interp1overnans(t, data, tinterp, maxgap)
```

The variable data can be a vector or a matrix, in which case, each column is interpolated separately. The function takes care of NaNs, such that it fills the gaps (NaN locations) with interpolated values. The last 2 inputs of the function above are optional. Input *tinterp* explicitly defines where you want to interpolate and *maxgap* defines an upper bound for the length of the gap that can be interpolated over.


