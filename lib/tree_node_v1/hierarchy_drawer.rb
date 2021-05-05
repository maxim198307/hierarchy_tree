module TreeNodeV1
  module HierarchyDrawer
    def call(data)
      tree = DataStructureComposer.call(data)

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

            current_print_position = relation[:depth] + 2
          else
            print_element(current_print_position, "\u2502")

            current_print_position = relation[:depth] + 1
          end
        end

        puts
      end
    end

    private

    def print_element(current_print_position, element)
      print("#{' ' * current_print_position}", element)
    end

    module_function :call, :print_element
  end
end
