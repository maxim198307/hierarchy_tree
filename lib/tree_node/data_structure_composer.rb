module TreeNode
  module DataStructureComposer
    def call(data)
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

    def compose_trailing_children(current_node, previous_node, arr)
      {}.tap do |h|
        return {} if current_node.last.nil?

        remaining_children = previous_node[:children] - [current_node.first]

        if remaining_children.any?
          h[previous_node[:name]] = {
                                      children: remaining_children.reverse,
                                      parent_index: arr.find { |node| node[:name] == previous_node[:name] }[:depth]
                                    }
        end

        previous_node[:trailing_children].each do |k, v|
          remaining_trailing_children = v[:children] - [current_node.first]

          if remaining_trailing_children.any?
            h[k] = {
                     children: remaining_trailing_children.reverse,
                     parent_index: arr.find { |node| node[:name] == k }[:depth]
                   }
          end
        end
      end.sort.to_h
    end

    def calculate_depth(current_node, arr)
      return 0 if current_node.last.nil?

      arr.find { |node| node[:name] == current_node.last }[:depth] + 1
    end

    module_function :call,
                    :compose_children,
                    :compose_trailing_children,
                    :calculate_depth
  end
end
