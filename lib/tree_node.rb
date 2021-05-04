module TreeNode
  def draw_hierarchy(data)
    tree = compose_data_structure(data)

    tree.each_with_index do |node, i|
      puts node[:name]

      current_print_position = 0

      node[:trailing_children].each do |k, v|
        print_position = v[:parent_index] - current_print_position

        print_element(print_position, "\u251C") and break if next_child_from_trailing_list?(v[:children], tree[i + 1][:name])
        print_element(print_position, "\u2514") and break if next_child_trailing?(v[:children], tree[i + 1][:name])

        print_element(print_position, "\u2502")

        current_print_position = v[:parent_index] + 1
      end

      child_print_position = node[:depth] - current_print_position

      print_element(child_print_position, "\u251C") if node[:children].count > 1
      print_element(child_print_position, "\u2514") if node[:children].count == 1
    end
  end

  def compose_data_structure(data)
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

  def next_child_from_trailing_list?(children, next_node_name)
    children.count > 1 && children.include?(next_node_name)
  end

  def next_child_trailing?(children, next_node_name)
    children.count == 1 && next_node_name == children.first
  end

  def print_element(print_position, element)
    print("#{' ' * print_position}", element)

    true
  end

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

  module_function :draw_hierarchy,
                  :compose_data_structure,
                  :compose_children,
                  :compose_trailing_children,
                  :calculate_depth,
                  :print_element,
                  :next_child_from_trailing_list?,
                  :next_child_trailing?
end
