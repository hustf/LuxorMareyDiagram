using Test
using LuxorMareyDiagram

@test_throws ArgumentError get_config_value("A", "B")
@test_throws ArgumentError get_config_value("Location axis", "B")
@test "1" == get_config_value("Location axis", "Toy text size [FS]")
@test 1889 == get_config_value("Canvas", "Width", Int64)