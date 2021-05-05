module TreeNode
  module HierarchyDrawer
    def call(data)
      tree = DataStructureComposer.call(data)

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

    module_function :call,
                    :print_element,
                    :next_child_from_trailing_list?,
                    :next_child_trailing?
  end
end
