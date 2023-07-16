using Test
using LuxorMareyDiagram
import Luxor
using Luxor: Drawing, background, O, box, BoundingBox, rotate
using Luxor: setcolor, text
using LuxorLayout
import LuxorMareyDiagram: draw_axis_arrow, draw_axes_update_inkextent

# Location axis, starting at 0, 0 
Drawing(NaN, NaN, :rec)
background("grey")
LuxorLayout.inkextent_set(BoundingBox(O, O))
bb = draw_axis_arrow()
encompass(bb)
snap()
Luxor.finish()
@test true

# Time axis, but vertical 
Drawing(NaN, NaN, :rec)
background("salmon")
LuxorLayout.inkextent_set(BoundingBox(O, O))
bb = draw_axis_arrow(section = "Time axis"; fraction_of_WI = 0.3)
encompass(bb)
snap()
Luxor.finish()
@test true

# Both axes 
Drawing(NaN, NaN, :rec)
background("gold")
LuxorLayout.inkextent_set(BoundingBox(O, O))
draw_axes_update_inkextent()
snap()
Luxor.finish()
@test true
