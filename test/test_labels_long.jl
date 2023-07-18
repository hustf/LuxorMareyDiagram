using Test
using LuxorMareyDiagram
import Random
import Luxor
using Luxor: Drawing, background, O, BoundingBox, box
#using Luxor: setcolor, text, settext, sethue
using LuxorLayout
using LuxorMareyDiagram: draw_prominent_axis_labels_update_inkextent
using LuxorMareyDiagram: draw_axis_arrow

###########################
# Read a list of stop names
###########################
lbls = include("100_stops.jl")

###########################
# Assign priorites to stops
###########################
# Max pri on start of route
pris = [1]
#println("pri 1 ", lbls[length(pris)])
# Assing priorities to stops; some third-pris, followed by a second pri
while length(pris) < length(lbls) - 1
    n_low_pri_stops = rand(0:5)
    #println(" n_low_pri_stops = ", n_low_pri_stops)
    j = 1
    while j <= n_low_pri_stops && length(pris) < length(lbls) - 2
        push!(pris, 3)
        #println("pri 3 ", lbls[length(pris)])
        j += 1
    end
    push!(pris, 2)
    #println("pri 2 ", lbls[length(pris)])
end
# Top pri on end 
push!(pris, 1)
#println("pri 1 ", lbls[length(pris)])


#############################################
# Assing position along the line to each stop
#############################################
# Zero position on start of route
x = 0.0
xs = [x]
#println("x = 0 ", lbls[length(xs)])
# Add a random length after each stop, store the incremental pos
while length(xs) < length(lbls)
    dist_to_next = 0.1 + Random.randexp()
    global x += dist_to_next
    push!(xs, x)
    #println("x = $x ", lbls[length(xs)])
end
# Normalize xs to 0..1
xs /= last(xs)

txt = "Location axis labels"
Drawing(NaN, NaN, :rec)
background("salmon")
LuxorLayout.inkextent_set(BoundingBox(O, O))
draw_axis_arrow()
bb = draw_prominent_axis_labels_update_inkextent(lbls, xs, pris)
box(bb, :stroke)
mark_cs(O)
snap(txt)
Luxor.finish()
@test true

txt = "Time axis labels"
Drawing(NaN, NaN, :rec)
background("salmon")
LuxorLayout.inkextent_set(BoundingBox(O, O))
draw_axis_arrow(section = "Time axis")
bb = draw_prominent_axis_labels_update_inkextent(lbls, xs, pris; section = "Time axis")
box(bb, :stroke)
mark_cs(O)
snap(txt)
Luxor.finish()
@test true