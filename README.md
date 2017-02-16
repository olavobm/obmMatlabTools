# obmMatlabTools

Matlab functions I've written over the years for my own work. This repository is in constant development and contains several functions called by my other repositories. In addition, there is a folder (byOthers) with general functions written by other people that I decided to include in my personal coding toolkit.

Though these functions were mostly designed with oceanographic data analysis in mind, most of them are quite general and can be combined in different ways to help you achieve your goals. See my description below of some functions I have found particularly useful in various situations.

## Examples

1. Interpolation:

Let’s say you want to linearly interpolate (in 1D) a variable (data). You can use do:

```matlab
datainterp = interp1overnans(t, data, tinterp, maxgap)
```


