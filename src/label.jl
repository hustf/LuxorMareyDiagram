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
    β = get_config_value(section, "Labels rotation from device direction [deg]", Float64) * π / 180
    anchor = get_config_value(section, "Label anchor side (left / right)")
    toy_fs = get_config_value(section, "Toy text size [FS]", Float64) * FS
    pro_fs = get_config_value(section, "Pro text size [FS]", Float64) * FS
    toy_fa = get_config_value(section, "Toy font face")
    pro_fa = get_config_value(section, "Pro font face")
    off_x = get_config_value(section, "Labels offset x [EM]", Float64) * EM
    off_y = get_config_value(section, "Labels offset y [EM]", Float64) * EM
    rotated_offsetvector = (off_x * cos(-α) + off_y * sin(-α), off_y * cos(-α) + off_x * sin(-α))
    # We are going to rotate user to local horizontal axis in a while..
    tip_x = wi
    poss_in_axis_coordinates = map(xs) do x
        Point(x * tip_x, 0.0)
    end
    @layer begin
        rotate(α)
        β0 = rotation_device_get()
        rotate(β - β0)
        anchors_in_label_aligned_coordinates = map(poss_in_axis_coordinates) do (x, _y)
            Point(x * cos(-β + β0), x * sin(-β + β0))
        end
        fontface(toy_fa)
        fontsize(toy_fs)
        setfont(pro_fa, pro_fs)
        shown_label_indexes, bbs = labels_prominent(foo, lbls, anchors_in_label_aligned_coordinates, pris; anchor)
        bbso = map(bb -> bb + rotated_offsetvector, bbs)
        bb = get_encompassing_device_bounding_box(bbso)
    end
    # Add leaders
    if get_config_value(section, "Include label leaders to axis (true / false)", Bool)
        @layer begin
            setline(PT * get_config_value("Label leaders", "Width [PT]", Float64))
            setcolor(get_config_value("Label leaders", "Color"))
            for i in shown_label_indexes
                axis_point = poss_in_axis_coordinates[i]
                label_anchor_point = axis_point + (off_x, off_y)
                line(axis_point, label_anchor_point, :stroke)
            end
        end
    end
    # Return boundary box for all these labels, oriented along device directions.
    bb
end
function draw_prominent_axis_labels_update_inkextent(lbls, xs::Vector{Float64}, 
    pris; section = "Location axis", fraction_of_WI = 1)
    f = default_label_func(section)
    draw_prominent_axis_labels_update_inkextent(f, lbls, xs, 
        pris; section, fraction_of_WI)
end



"""
    default_label_func(section)

This captures default values from ini file and defines a three-argument 
function to be used as argument for `draw_prominent_axis_labels_update_inkextent`
"""
function default_label_func(section)
    off_x = get_config_value(section, "Labels offset x [EM]", Float64) * EM
    off_y = get_config_value(section, "Labels offset y [EM]", Float64) * EM
    α = get_config_value(section, "Labels rotation from device direction [deg]", Float64) * π / 180
    local_offset_vector = (off_x * cos(α) + off_y * sin(α), off_y * cos(α) - off_x * sin(α))
    c1 = get_config_value("Default label", "Pri 1 X11 color")
    c2 = get_config_value("Default label", "Pri 2 X11 color")
    c3 = get_config_value("Default label", "Pri 3 X11 color")
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
            # The Pro API would give prettier png.
            text(label, pos + local_offset_vector) # Toy API
        end
    end
end