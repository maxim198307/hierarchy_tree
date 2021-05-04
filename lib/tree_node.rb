module TreeNode
  def draw_hierarchy(data)
    tree = compose_data_structure(data)

    tree.each_with_index do |node, i|
      puts node[:name]

      ind = 0
      node[:trailing_children].each do |k, v|
        if v[:children].count > 1 && v[:children].include?(tree[i + 1][:name]) #&&(node[:trailing_children].keys.count == 1)
          print("#{' ' * (v[:parent_index] - ind)}\u251C")

          ind += 1
          break
        end

        if v[:children].count == 1 && tree[i + 1][:name] == v[:children].first
          print("#{' ' * (v[:parent_index] - ind)}\u2514")

          ind += 1
          break
        else
          print("#{' ' * (v[:parent_index] - ind)}\u2502")

          ind += 1
        end
      end

      final_depth = node[:depth] - node[:trailing_children].count > 0 ?  node[:depth] - node[:trailing_children].count : 0
      print("#{' ' * final_depth}\u251C") if node[:children].count > 1
      print("#{' ' * final_depth}\u2514") if node[:children].count == 1
      # print("#{' ' * node[:depth]}\u251C") if node[:children].count > 1
      # print("#{' ' * node[:depth]}\u2514") if node[:children].count == 1
    end
  end

# A
# ├B
# ├C
# │├D
# │ └E
# └F

# [{:name=>"A", :parent=>nil, :depth=>0, :trailing_children=>{}, :children=>["B", "C", "F"]},
#  {:name=>"B", :parent=>"A", :depth=>1, :trailing_children=>{"A"=>{:children=>["F", "C"], :parent_index=>1}}, :children=>[]},
#  {:name=>"C", :parent=>"A", :depth=>1, :trailing_children=>{"A"=>{:children=>["F"], :parent_index=>1}}, :children=>["D", "E"]},
#  {:name=>"D", :parent=>"C", :depth=>2, :trailing_children=>{"A"=>{:children=>["F"], :parent_index=>2}, "C"=>{:children=>["E"], :parent_index=>2}}, :children=>[]},
#  {:name=>"E", :parent=>"C", :depth=>2, :trailing_children=>{"A"=>{:children=>["F"], :parent_index=>2}}, :children=>[]},
#  {:name=>"F", :parent=>"A", :depth=>1, :trailing_children=>{}, :children=>[]}]

  def compose_data_structure(data)tr
    data.each_with_object([]).with_index do |(current_node, arr), i|

      trailing_children = compose_trailing_children(current_node, arr[i-1], arr)

      arr << { name: current_node.first,
               parent: current_node.last,
               depth: calculate_depth(current_node, arr),
               trailing_children: trailing_children,
               children: compose_children(data, current_node) }
    end
  end

  private

  def compose_children(data, current_node)
    data.each_with_object([]) { |node, arr| arr << node.first if current_node.first == node.last }
  end

# trailing_children=>{"A"=>{children: ["H"], parent_index: 0}, "C"=>{children:["G", "E"], parent_index: 2}}

  def compose_trailing_children(current_node, previous_node, arr)
    {}.tap do |h|
      return {} if current_node.last.nil?
      # previous_node[:children].each do |child|
      values = (previous_node[:children] - [current_node.first])

      h[previous_node[:name]] = { children: values.reverse, parent_index: arr.find { |node| node[:name] == previous_node[:name] }[:depth].to_i} if values.any?#{"C" => ["E", "F"]}
      # end
      previous_node[:trailing_children].each do |k, v|
        remaining_values = v[:children] - [current_node.first]

        h[k] = { children: remaining_values.reverse, parent_index: arr.find { |node| node[:name] == k }[:depth].to_i} if remaining_values.any?
      end
    end.sort.to_h
  end

# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "C"],
#  ["E", "C"],
#  ["F", "E"],
#  ["G", "F"],
#  ["H", "A"],
# ]

  def calculate_depth(current_node, arr)
    return 0 if current_node.last.nil?

    arr.find { |node| node[:name] == current_node.last }[:depth].to_i + 1
  end

  module_function :draw_hierarchy,
                  :compose_data_structure,
                  :compose_children,
                  :compose_trailing_children,
                  :calculate_depth
end


# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "B"],
#  ["E", "A"]]


# tree = [
#         { name: 'A', depth: 0, children: ["B", "E"] },
#         { name: 'B', depth: 0, trailing_children: [{ name: "E" }], children: ["C", "D"] },
#         { name: 'C', depth: 0, trailing_children: [{ name: "E" }, { depth: 0, name: "D" }], children: [] },
#         { name: 'D', depth: 1, trailing_children: [{ name: "E" }], children: [] },
#         { name: 'E', depth: 1, children: [] }
#        ]

# A
# ├B
# │├C
# │└D
# └E





# a = [["A", nil],
#  ["B", "A"],
#  ["C", "A"],
#  ["D", "C"]]

# tree = [
#         { name: 'A', depth: 0, children: ["B"] },
#         { name: 'B', depth: 1, children: ["C"] },
#         { name: 'C', depth: 2, children: ["D"] },
#         { name: 'D', depth: 3, children: [] }
#        ]
# A
# ├B
# └C
#  └D









# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "C"],
#  ["E", "A"]]

# tree = [
#         { name: 'A', depth: 0, children: ["B", "E"] },
#         { name: 'B', depth: 0, trailing_children: [{ name: "E" }], children: ["C"] },
#         { name: 'C', depth: 1, trailing_children: [{ name: "E" }], children: ["D"] },
#         { name: 'D', depth: 2, trailing_children: [{ name: "E" }], children: [] },
#         { name: 'E', depth: 1, children: [] }
#        ]

# A
# ├B
# │└C
# │ └D
# └E



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





#  => [{:name=>"A", :depth=>0, :trailing_children=>[], :children=>["B", "C", "F"]}, {:name=>"B", :depth=>0, :trailing_children=>[{:name=>"F"}, {:name=>"C"}], :children=>[]}, {:name=>"C", :depth=>0, :trailing_children=>[{:name=>"F"}], :children=>["D", "E"]}, {:name=>"D", :depth=>1, :trailing_children=>[{:name=>"F"}, {:name=>"E"}], :children=>[]}, {:name=>"E", :depth=>2, :trailing_children=>[{:name=>"F"}], :children=>[]}, {:name=>"F", :depth=>1, :trailing_children=>[], :children=>[]}]



# a = [["A", nil],
#  ["B", "A"],
#  ["C", "A"],
#  ["D", "C"],
#  ["E", "C"],
#  ["F", "A"]
# ]




# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "C"],
#  ["E", "C"],
#  ["F", "E"],
#  ["G", "F"],
#  ["H", "A"],
# ]


# tree = [{:name=>"A", :parent=>nil, :depth=>0, :trailing_children=>{}, :children=>["B", "H"]},
#         {:name=>"B", :parent=>"A", :depth=>0, :trailing_children=>{"A"=>["H"]}, :children=>["C"]},
#         {:name=>"C", :parent=>"B", :depth=>1, :trailing_children=>{"A"=>["H"]}, :children=>["D", "E", "G"]},
#         {:name=>"D", :parent=>"C", :depth=>1, :trailing_children=>{"A"=>["H"], "C"=>["G", "E"]}, :children=>[]},
#         {:name=>"E", :parent=>"C", :depth=>1, :trailing_children=>{"A"=>["H"], "C"=>["G"]}, :children=>["F"]},
#         {:name=>"F", :parent=>"E", :depth=>3, :trailing_children=>{"A"=>["H"], "C"=>["G"]}, :children=>[]},
#         {:name=>"G", :parent=>"C", :depth=>2, :trailing_children=>{"A"=>["H"]}, :children=>[]},
#         {:name=>"H", :parent=>"A", :depth=>1, :trailing_children=>{}, :children=>[]}]




# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "C"],
#  ["E", "C"],
#  ["F", "B"],
#  ["G", "A"],
# ]



# a = [["A", nil],
#  ["B", "A"],
#  ["C", "B"],
#  ["D", "C"],
#  ["E", "C"],
#  ["F", "E"],
#  ["G", "A"],
# ]
