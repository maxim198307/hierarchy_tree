module TreeNodeV1
  module DataStructureComposer
    def call(data)
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

        leftovers = previous_entity[:children] - [data[i].first]

        leftovers.each do |leftover|
          if arr.select { |el| el[:siblings].include?(leftover) }.empty?
            arr << { parent: previous_entity[:name], depth: previous_entity[:depth], siblings: leftovers, own: false }
          end
        end
      end
    end

    module_function :call,
                    :calculate_depth,
                    :compose_relations,
                    :compose_children
  end
end
