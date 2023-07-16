"""
    draw_axis_arrow(;section = "Location axis", fraction_of_WI = 1)
    --> BoundingBox
"""
function draw_axis_arrow(;section = "Location axis", fraction_of_WI = 1)
    wi = Int64(round(get_config_value("Canvas", "Width", Int64) * fraction_of_WI))
    α = get_config_value(section, "Direction along [deg]", Float64) * π / 180
    linewidth = get_config_value(section, "Line width [PT]", Float64) * PT
    arrowheadlength = get_config_value(section, "Arrow length [EM]", Float64) * EM
    β = get_config_value(section, "Arrow head angle [deg]", Float64) * π / 180
    halfheight = sin(β) * arrowheadlength
    @layer begin
        tip_pt = O + (wi, 0)
        rotate(α)
        setline(linewidth)
        line(O, tip_pt, :stroke)
        arrowhead(tip_pt, halfheight, arrowheadlength)
    end
    # Return bounding box for inkextent
    pttl = O + halfheight.* (cos(α - π / 2) , sin(α - π / 2))
    ptbr = O + halfheight.* (cos(α + π / 2) , sin(α + π / 2)) +
              wi .* (cos(α), sin(α))
    BoundingBox(pttl, ptbr)
end

function arrowhead(tip_pt, halfheight, arrowheadlength)
    root_pt = tip_pt + (-arrowheadlength, 0)
    line(tip_pt, root_pt + (0, halfheight), :stroke)
    line(tip_pt, root_pt + (0, -halfheight), :stroke)
end

"""
    draw_axes_update_inkextent(; time_axis_relative_length = 0.75)

Uses the full canvas width from config file. A plot with margins will extend outside the canvas.
"""
function draw_axes_update_inkextent(; time_axis_relative_length = 0.75)
    # We don't show if this is time interval or distance along the path
    draw_axis_arrow(;section = "Location axis") |> encompass
    draw_axis_arrow(;section = "Time axis", fraction_of_WI = time_axis_relative_length) |> encompass
end

