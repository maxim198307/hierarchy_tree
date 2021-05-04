module TreeNodeV1
  def draw_hierarchy(data)
    tree = compose_data_structure(data)

    tree.each do |node|
      if node[:parent].nil?
        puts node[:name]

        next
      end

      current_print_position = 0

      node[:relations].each do |relation|
        current_print_position = relation[:depth] - current_print_position

        if relation[:own]
          print_element(current_print_position, "\u251C#{node[:name]}") if relation[:siblings].any?
          print_element(current_print_position, "\u2514#{node[:name]}") if relation[:siblings].empty?

          current_print_position = relation[:depth] + 2 #2 due to node[:name] being printed
        else
          print_element(current_print_position, "\u2502")

          current_print_position = relation[:depth] + 1
        end
      end

      puts
    end
  end

  def compose_data_structure(data)
    data.each_with_object([]).with_index do |(current_node, arr), i|
      arr << {
        name: current_node.first,
        depth: calculate_depth(current_node, arr),
        parent: current_node.last,
        children: compose_children(data, current_node),
        relations: compose_relations(data, arr, i)
      }
    end
  end

  private

  def print_element(current_print_position, element)
    print("#{' ' * current_print_position}", element)
  end

  def calculate_depth(node, arr)
    return 0 if node.last.nil?

    arr.find { |el| el[:name] == node.last }[:depth] + 1
  end

  def compose_children(data, current_node)
    data.map { |el| el.first if el.last == current_node.first }.compact
  end

  def compose_relations(data, existing_structure, i)
    [].tap do |arr|
      return arr if data[i].last.nil?

      previous_entity = existing_structure[i - 1]
      own = false

      previous_entity[:relations].each do |relation|
        next if relation[:siblings].empty?

        own = relation[:parent] == data[i].last
        siblings = relation[:siblings] - [data[i].first]

        arr << { parent: relation[:parent], depth: relation[:depth], siblings: siblings, own: own }
      end

      if !own
        siblings = (data.map { |el| el.first if el.last == data[i].last } - [data[i].first]).compact
        depth = existing_structure.find { |el| el[:name] == data[i].last }[:depth]

        arr << { parent: data[i].last, depth: depth, siblings: siblings, own: true }
      end

      leftovers =  previous_entity[:children] - [data[i].first]

      leftovers.each do |leftover|
        if arr.select { |el| el[:siblings].include?(leftover) }.empty?
          arr << { parent: previous_entity[:name], depth: previous_entity[:depth], siblings: leftovers, own: false }
        end
      end
    end
  end

  module_function :compose_data_structure,
                  :calculate_depth,
                  :compose_relations,
                  :compose_children,
                  :draw_hierarchy,
                  :print_element
end

# a = [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'B'], ['E', 'A'], ['F', 'D']]
# tree = [
#   { name: 'A', depth: 0, parent: nil, relations: [] },
#   { name: 'B', depth: 1, parent: 'A', relations: [{ parent: 'A', depth: 0, siblings: ['E'], own: true }]},
#   { name: 'C', depth: 2, parent: 'B', relations: [{ parent: 'A', depth: 0, siblings: ['E'], own: false}, { parent: 'B', depth: 1, siblings: ['D'], own: true }]},
#   { name: 'D', depth: 2, parent: 'B', relations: [{ parent: 'A', depth: 0, siblings: ['E'], own: false}, { parent: 'B', depth: 1, siblings: [], own: true }]},
#   { name: 'E', depth: 1, parent: 'A', relations: [{ parent: 'A', depth: 0, own: true, siblings: []}, { parent: 'D', depth: 2, siblings: ['F'], own: false }]},
#   { name: 'F', depth: 3, parent: 'D', relations: [{ parent: 'D', depth: 2, own: true, siblings: []}]}
# ]

 # => [{:name=>"A", :depth=>0, :parent=>nil, :children=>["B", "E"], :relations=>[]},
       # {:name=>"B", :depth=>1, :parent=>"A", :children=>["C", "D"], :relations=>[{:parent=>"A", :depth=>0, :siblings=>["E"], :own=>true}]},
       # {:name=>"C", :depth=>2, :parent=>"B", :children=>[], :relations=>[{:parent=>"A", :depth=>0, :siblings=>["E"], :own=>false}, {:parent=>"B", :depth=>1, :siblings=>["D"], :own=>true}]},
       # {:name=>"D", :depth=>2, :parent=>"B", :children=>["F"], :relations=>[{:parent=>"A", :depth=>0, :siblings=>["E"], :own=>false}, {:parent=>"B", :depth=>1, :siblings=>[], :own=>true}]},
       # {:name=>"E", :depth=>1, :parent=>"A", :children=>[], :relations=>[{:parent=>"A", :depth=>0, :siblings=>[], :own=>true}, {:parent=>"D", :depth=>2, :siblings=>["F"], :own=>false}]},
       # {:name=>"F", :depth=>3, :parent=>"D", :children=>[], :relations=>[{:parent=>"D", :depth=>2, :siblings=>[], :own=>true}]}]


# A
# ├B
# │├C
# │└D
# └E│
#   └F


# a = [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'D']]

# tree = [
#   { name: 'A', parent: nil, relations: [] },
#   { name: 'B', parent: 'A', relations: [{depth: 0, siblings: [], own: true }]},
#   { name: 'C', parent: 'B', relations: [{depth: 1, siblings: [], own: true }]},
#   { name: 'D', parent: 'C', relations: [{depth: 2, siblings: [], own: true }]},
#   { name: 'E', parent: 'D', relations: [{depth: 3, siblings: [], own: true }]}
# ]
# A
# └B
#  └C
#   └D
#    └E




# a = [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'D'], ['F', 'B'], ['G', 'E'], ['H', 'A']]

# tree = [
#   { name: 'A', parent: nil, relations: [] },
#   { name: 'B', parent: 'A', relations: [{ depth: 0, siblings: ['H'], own: true }]},
#   { name: 'C', parent: 'B', relations: [{ depth: 0, own: false }, { depth: 1, siblings: ['F'], own: true }]},
#   { name: 'D', parent: 'C', relations: [{ depth: 0, own: false }, { depth: 1, own: false }, { depth: 2, siblings: [], own: true }]},
#   { name: 'E', parent: 'D', relations: [{ depth: 0, own: false }, { depth: 1, own: false }, { depth: 3, siblings: [], own: true }]},
#   { name: 'F', parent: 'B', relations: [{ depth: 0, own: false }, { depth: 1, siblings: [], own: true }, { depth: 4, own: false }]},
#   { name: 'G', parent: 'E', relations: [{ depth: 0, own: false }, { depth: 4, siblings: [], own: true }]},
#   { name: 'H', parent: 'A', relations: [{ depth: 0, siblings: [], own: true }]}
# ]

# A
# ├B
# │├C
# ││└D
# ││ └E
# │└F │
# │   └G
# └H

# A
# ├B
# │├C
# │└D
# └E│
#   └F



