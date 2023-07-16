"""
    draw_prominent_axis_labels_update_inkextent(lbls, xs::Vector{Float64}, 
            pris; section = "Location axis", fraction_of_WI = 1)

    draw_prominent_axis_labels_update_inkextent(foo, lbls, xs::Vector{Float64}, 
            pris; section = "Location axis", fraction_of_WI = 1)

    --> BoundingBox


You can define your own label plotting function. Refer to
 `LuxorMareyDiagram.LuxorLabels.labels_prominent`.
We recommend you include offsets from config file. See `default_label_func` below.
"""
function draw_prominent_axis_labels_update_inkextent(foo, lbls, xs::Vector{Float64}, 
        pris; section = "Location axis", fraction_of_WI = 1)
    @assert maximum(xs) <= 1.0
    @assert minimum(xs) >= 0.0
    wi = Int64(round(get_config_value("Canvas", "Width", Int64) * fraction_of_WI))
    α = get_config_value(section, "Direction along [deg]", Float64) * π / 180
    toy_fs = get_config_value(section, "Toy text size [FS]", Float64) * FS
    pro_fs = get_config_value(section, "Pro text size [FS]", Float64) * FS
    toy_fa = get_config_value(section, "Toy font face")
    pro_fa = get_config_value(section, "Pro font face")
    offsetx = get_config_value(section, "Labels offset x [EM]", Float64) * EM
    offsety = get_config_value(section, "Labels offset y [EM]", Float64) * EM
    # We'll rotate to local horizontal axis later.
    tip_pt = O + (wi, 0)
    poss = xs .* tip_pt
    @layer begin
        rotate(α)
        fontface(toy_fa)
        fontsize(toy_fs)
        setfont(pro_fa, pro_fs)
        it, bbs = labels_prominent(foo, lbls, poss, pris)
        bbso = map(bb -> bb + (offsetx, offsety), bbs)
        bb = get_encompassing_device_bounding_box(bbso)
    end
    bb
end
function draw_prominent_axis_labels_update_inkextent(lbls, xs::Vector{Float64}, 
    pris; section = "Location axis", fraction_of_WI = 1)
    f = default_label_func(section)
    draw_prominent_axis_labels_update_inkextent(f, lbls, xs, 
        pris; section, fraction_of_WI = 1)
end



"""
    default_label_func(section)

This captures default values from ini file and defines a three-argument 
function to be used as argument for `draw_prominent_axis_labels_update_inkextent`
"""
function default_label_func(section)
    offsetx = get_config_value(section, "Labels offset x [EM]", Float64) * EM
    offsety = get_config_value(section, "Labels offset y [EM]", Float64) * EM
    c1 = get_config_value("Default label", "Pri 1 X11 color")
    c2 = get_config_value("Default label", "Pri 2 X11 color")
    c3 = get_config_value("Default label", "Pri 3 X11 color")
    offsety = get_config_value(section, "Labels offset y [EM]", Float64) * EM
    function foo(label, pos, pri)
        if pri <= 1
            c = c1
        elseif pri <= 2
            c = c2
        else
            c = c3
        end
        @layer begin
            sethue(c)
            text(label, pos + (offsetx, offsety)) # Toy API
        end
    end
end