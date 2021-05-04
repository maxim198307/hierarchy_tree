# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "C"],
#  ["E", "B"],
#  ["F", "A"]
# ]

# tree = [
#         { name: 'A', depth: 0, children: ["B", "F"] },
#         { name: 'B', depth: 0, trailing_children: [{ name: "F" }], children: ["C", "E"] },
#         { name: 'C', depth: 0, trailing_children: [{ name: "F" }, { name: "E" }], children: ["D"] },
#         { name: 'D', depth: 1, trailing_children: [{ name: "F" }, { name: "E" }], children: [] },
#         { name: 'E', depth: 2, trailing_children: [{ name: "F" }], children: [] },
#         { name: 'F', depth: 1, children: [] }
#        ]

# A
# ├B
# │├C
# ││└D
# │└E
# └F
