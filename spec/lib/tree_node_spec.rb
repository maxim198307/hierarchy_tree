require 'tree_node.rb'

describe TreeNode do
  describe '.compose_data_structure' do
    subject { described_class.compose_data_structure(input) }

    context 'when input data does not contain trailing children' do
      let(:input) {  [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C']] }
      let(:expected_result) do
        [
          { children: ['B'], depth: 0, name: 'A', parent: nil, trailing_children: {}},
          { children: ['C'], depth: 1, name: 'B', parent: 'A', trailing_children: {}},
          { children: ['D'], depth: 2, name: 'C', parent: 'B', trailing_children: {}},
          { children: [], depth: 3, name: 'D', parent: 'C', trailing_children: {}}
        ]
      end

      it { is_expected.to eq(expected_result) }
      # A
      # └B
      #  └C
      #   └D
    end

    describe 'when input data contains trailing children' do
      context 'example A' do
        let(:input) {  [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'B'], ['F', 'A']] }
        let(:expected_result) do
          [
            { children: ['B', 'F'], depth: 0, name: 'A', parent: nil, trailing_children: {}},
            { children: ['C', 'E'], depth: 1, name: 'B', parent: 'A', trailing_children: { 'A' => { children: ['F'], parent_index: 0 }}},
            { children: ['D'], depth: 2, name: 'C', parent: 'B', trailing_children: { 'A' => { children: ['F'], parent_index: 0 }, 'B' => { children: ['E'], parent_index: 1 }}},
            { children: [], depth: 3, name: 'D', parent: 'C', trailing_children:  { 'A' => { children: ['F'], parent_index: 0 },'B' => { children: ['E'], parent_index: 1 }}},
            { children: [], depth: 2, name: 'E', parent: 'B', trailing_children: { 'A' => { children: ['F'], parent_index: 0 }}},
            { children: [], depth: 1, name: 'F', parent: 'A', trailing_children: {}}
          ]
        end

        it { is_expected.to eq(expected_result) }
        # A
        # ├B
        # │├C
        # ││└D
        # │└E
        # └F
      end

      context 'example B' do
        let(:input) do
          [
            ['A', nil],
            ['B', 'A'],
            ['C', 'B'],
            ['D', 'C'],
            ['E', 'C'],
            ['F', 'E'],
            ['G', 'F'],
            ['H', 'G'],
            ['I', 'F'],
            ['P', 'A']
          ]
        end

        let(:expected_result) do
          [
            { children: ['B', 'P'], depth: 0, name: 'A', parent: nil, trailing_children: {}},
            { children: ['C'],depth: 1,name: 'B', parent: 'A', trailing_children: { 'A' => { children: ['P'], parent_index: 0 }}},
            { children: ['D', 'E'], depth: 2, name: 'C', parent: 'B', trailing_children: { 'A' => { children: ['P'], parent_index: 0 }}},
            { children: [], depth: 3, name: 'D', parent: 'C', trailing_children: { 'A' => { children: ['P'], parent_index: 0 },'C'=>{ children: ['E'], parent_index: 2 }}},
            { children: ['F'],depth: 3, name: 'E', parent: 'C',trailing_children: { 'A' => { children: ['P'], parent_index: 0 }}},
            { children: ['G', 'I'], depth: 4, name: 'F', parent: 'E', trailing_children: { 'A' => { children: ['P'], parent_index: 0 }}},
            { children: ['H'], depth: 5, name: 'G', parent: 'F', trailing_children: { 'A' => { children: ['P'], parent_index: 0 }, 'F'=>{ children: ['I'], parent_index: 4 }}},
            { children: [], depth: 6, name: 'H', parent: 'G', trailing_children: { 'A' => { children: ['P'], parent_index: 0 },'F'=>{ children: ['I'], parent_index: 4 }}},
            { children: [],depth: 5, name: 'I', parent: 'F', trailing_children: { 'A' => { children: ['P'], parent_index: 0 }}},
            { children: [], depth: 1, name: 'P', parent: 'A', trailing_children: {}}
          ]
        end

        it { is_expected.to eq(expected_result) }
        # A
        # ├B
        # │└C
        # │ ├D
        # │ └E
        # │  └F
        # │   ├G
        # │   │└H
        # │   └I
        # └P
      end

      context 'example C' do
        let(:input) do
          [
            ['A', nil],
            ['B', 'A'],
            ['C', 'B'],
            ['D', 'C'],
            ['E', 'C'],
            ['F', 'E'],
            ['G', 'F'],
            ['H', 'G'],
            ['I', 'F'],
            ['O', 'E'],
            ['P', 'B'],
            ['Q', 'A']
          ]
        end

        let(:expected_result) do
          [
            { children: ['B', 'Q'], depth: 0, name: 'A', parent: nil, trailing_children: {}},
            { children: ['C', 'P'], depth: 1, name: 'B', parent: 'A', trailing_children: { 'A' => { children: ['Q'], parent_index: 0 }}},
            { children: ['D', 'E'], depth: 2, name: 'C', parent: 'B', trailing_children: { 'A' => { children: ['Q'], parent_index: 0}, 'B' => { children: ['P'], parent_index: 1 }}},
            { children: [], depth: 3, name: 'D', parent: 'C', trailing_children: { 'A' => { children: ['Q'], parent_index: 0}, 'B' => { children: ['P'], parent_index: 1}, 'C' => { children: ['E'], parent_index: 2 }}},
            { children: ['F', 'O'], depth: 3, name: 'E', parent: 'C', trailing_children: { 'A' => { children: ['Q'], parent_index: 0}, 'B' => { children: ['P'], parent_index: 1 }}},
            { children: ['G', 'I'], depth: 4, name: 'F', parent: 'E', trailing_children: { 'A' => { children: ['Q'], parent_index: 0},
               'B' => { children: ['P'], parent_index: 1}, 'E' => { children: ['O'], parent_index: 3 }}},
            { children: ['H'],depth: 5, name: 'G', parent: 'F', trailing_children: { 'A' => { children: ['Q'], parent_index: 0},'B' => { children: ['P'], parent_index: 1}, 'E' => { children: ['O'], parent_index: 3}, 'F' => { children: ['I'], parent_index: 4 }}},
            { children: [], depth: 6, name: 'H', parent: 'G', trailing_children: { 'A' => { children: ['Q'], parent_index: 0}, 'B' => { children: ['P'], parent_index: 1}, 'E' => { children: ['O'], parent_index: 3}, 'F' => { children: ['I'], parent_index: 4 }}},
            { children: [], depth: 5, name: 'I', parent: 'F', trailing_children:  { 'A' => { children: ['Q'], parent_index: 0}, 'B' => { children: ['P'], parent_index: 1}, 'E' => { children: ['O'], parent_index: 3 }}},
            { children: [], depth: 4, name: 'O', parent: 'E', trailing_children: { 'A' => { children: ['Q'], parent_index: 0}, 'B' => { children: ['P'], parent_index: 1 }}},
             { children: [], depth: 2, name: 'P', parent: 'B', trailing_children: { 'A' => { children: ['Q'], parent_index: 0 }}},
            { children: [], depth: 1, name: 'Q', parent: 'A', trailing_children: {}}
          ]
        end

        it { is_expected.to eq(expected_result) }
        # A
        # ├B
        # │├C
        # ││├D
        # ││└E
        # ││ ├F
        # ││ │├G
        # ││ ││└H
        # ││ │└I
        # ││ └O
        # │└P
        # └Q
      end

      context 'example D' do
        let(:input) { [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'C'], ['F', 'E'], ['G', 'A']] }
        let(:expected_result) do
          [
            { children: ['B', 'G'], depth: 0, name: 'A', parent: nil, trailing_children: {}},
            { children: ['C'], depth: 1, name: 'B', parent: 'A', trailing_children: { 'A' => { children: ['G'], parent_index: 0 }}},
            { children: ['D', 'E'], depth: 2, name: 'C', parent: 'B', trailing_children: { 'A' => { children: ['G'], parent_index: 0 }}},
            { children: [], depth: 3, name: 'D', parent: 'C', trailing_children: { 'A' => { children: ['G'], parent_index: 0 }, 'C' => { children: ['E'], parent_index: 2 }}},
            { children: ['F'], depth: 3, name: 'E', parent: 'C', trailing_children: { 'A' => { children: ['G'], parent_index: 0 }}},
            { children: [], depth: 4, name: 'F', parent: 'E', trailing_children: { 'A' => { children: ['G'], parent_index: 0 }}},
            { children: [], depth: 1, name: 'G', parent: 'A', trailing_children: {}}
          ]
        end

        it { is_expected.to eq(expected_result) }
        # A
        # ├B
        # │└C
        # │ ├D
        # │ └E
        # │  └F
        # └G
      end
    end
  end
end





# array = [
#   [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C']],
#   [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'B'], ['F', 'A']],
#   [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'C'], ['F', 'E'], ['G', 'A']],
#   [["A", nil], ["B", "A"], ["C", "B"], ["D", "C"], ["E", "C"], ["F", "E"], ["G", "F"], ["H", "G"], ["I", "F"], ["P", "A"]],
#   [["A", nil], ["B", "A"], ["C", "B"], ["D", "C"], ["E", "C"], ["F", "E"], ["G", "F"], ["H", "G"], ["I", "F"], ["O", "E"], ["P", "B"],["Q", "A"]]
# ]


# array.each { |el| TreeNode.draw_hierarchy(el) }
