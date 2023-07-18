# LuxorMareyDiagram
An add-on to [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl).

This is inspired by [Visualizing MBTA Data](http://mbtaviz.github.io/).

Exports three functions: 

- `draw_prominent_axis_labels_update_inkextent`
- `draw_axis_arrow`
- `get_config_value`

The default look is configureable in the .ini file. 
Plotting of data is done by drawing in Luxor. The axes are drawn
from the drawing origin. `y`` is down, positive rotation axis points inwards.

