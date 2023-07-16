"""
    get_encompassing_device_bounding_box(bbs::Vector{BoundingBox})
    --> bounding box in the device coordinate system.

Remember to call this function while in the same user coordinate system
as where bbb was defined, i.e. inside the same '@layer begin..end`
"""
function get_encompassing_device_bounding_box(bbs::Vector{BoundingBox})
    # This initial value will be mutated with the firs
    # bb = BoundingBox(O, O)
    local bb
    for (i, b) in enumerate(bbs)
        encompass(b)
        ptul = point_device_get(b.corner1)
        ptbr = point_device_get(b.corner2)
        bd = BoundingBox(ptul, ptbr)
        if i == 1
            bb = bd
        else
            bb += bd
        end
    end
    bb
end
