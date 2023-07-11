using Test
using LuxorMareyDiagram
using LuxorMareyDiagram: get_config_value

@test_throws ArgumentError get_config_value("A", "B")
@test_throws ArgumentError get_config_value("Location axis", "B")
@test "1" == get_config_value("Location axis", "Toy text size [FS]")
