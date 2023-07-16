module LuxorMareyDiagram
export get_config_value
using LuxorLabels, LuxorLayout, IniFile
import Luxor
using Luxor: line, rotate, setline, translate, sethue, ngon
using Luxor: O, @layer, BoundingBox, fontface, fontsize, setfont
using Luxor: setcolor, text
const EM = 44
const PT = 4
const FS = 37.5
include("ini_file.jl")
include("util.jl")
include("arrow.jl")
include("label.jl")
end # Module