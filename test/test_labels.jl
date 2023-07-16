using Test
using LuxorMareyDiagram
import Luxor
using Luxor: Drawing, background, O, box, BoundingBox, rotate
using Luxor: setcolor, text, settext, sethue
using LuxorLayout
import LuxorMareyDiagram: draw_prominent_axis_labels_update_inkextent

function foo(label, pos, pri)
    if pri == 1
        setcolor("black")
    elseif pri == 2
        setcolor("green")
    else
        setcolor("grey")
    end
     text(label, pos)
end

lbls = String[]
pris = Int64[]
xs = Float64[]
for i = 0:70
    push!(lbls, string(i))
    if mod(i, 10) == 0
        push!(pris, 1)
    elseif mod(i, 5) == 0
        push!(pris, 2)
    else
        push!(pris, 3)
    end
    push!(xs, i / 70)
end

txt = "Horizontal custom number labels"
Drawing(NaN, NaN, :rec)
background("cyan")
LuxorLayout.inkextent_set(BoundingBox(O, O))
bb = draw_prominent_axis_labels_update_inkextent(foo, lbls, xs, pris)
box(bb, :stroke)
mark_cs(O)
snap(txt)
Luxor.finish()
@test true

txt = "Vertical custom number labels"
Drawing(NaN, NaN, :rec)
background("lightyellow")
LuxorLayout.inkextent_set(BoundingBox(O, O + (200,0)))
bb = draw_prominent_axis_labels_update_inkextent(foo, lbls, xs, pris; section = "Time axis", fraction_of_WI = 1.0)
box(bb, :stroke)
mark_cs(O)
snap() do 
    setcolor(sethue("blue")..., .8)
    settext(txt, O + (-10, -100), angle = -90)
end
Luxor.finish()
@test true

txt = "Horizontal default number labels"
Drawing(NaN, NaN, :rec)
background("salmon")
LuxorLayout.inkextent_set(BoundingBox(O, O))
bb = draw_prominent_axis_labels_update_inkextent(lbls, xs, pris)
box(bb, :stroke)
mark_cs(O)
snap(txt)
Luxor.finish()
@test true


txt = "Vertical default number labels"
Drawing(NaN, NaN, :rec)
background("salmon")
LuxorLayout.inkextent_set(BoundingBox(O, O + (400,0)))
bb = draw_prominent_axis_labels_update_inkextent(lbls, xs, pris;  section = "Time axis", fraction_of_WI = 1.0)
box(bb, :stroke)
mark_cs(O)
snap() do 
    setcolor(sethue("blue")..., .8)
    settext(txt, O + (-10, -100), angle = -90)
end
Luxor.finish()
@test true