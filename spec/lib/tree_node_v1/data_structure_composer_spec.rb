require 'tree_node_v1/data_structure_composer.rb'

describe TreeNodeV1::DataStructureComposer do
  describe '.call' do
    subject { described_class.call(input) }

    context 'when input data does not contain trailing children' do
      let(:input) {  [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'C'], ['E', 'D']] }
      let(:expected_result) do
        [
          { children: ['B'], depth: 0, name: 'A', parent: nil, relations: []},
          { children: ['C'], depth: 1, name: 'B', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: [] }]},
          { children: ['D'], depth: 2, name: 'C', parent: 'B', relations: [{ depth: 1, own: true, parent: 'B', siblings: [] }]},
          { children: ['E'], depth: 3, name: 'D', parent: 'C', relations: [{ depth: 2, own: true, parent: 'C', siblings: [] }]},
          { children: [], depth: 4, name: 'E', parent: 'D', relations: [{ depth: 3, own: true, parent: 'D', siblings: [] }]}
        ]
      end

      it { is_expected.to eq(expected_result) }
      # A
      # └B
      #  └C
      #   └D
      #    └E
    end

    describe 'when input data contains trailing children' do
      context 'example A' do
        let(:input) {  [['A', nil], ['B', 'A'], ['C', 'B'], ['D', 'B'], ['E', 'A'], ['F', 'D']] }
        let(:expected_result) do
          [
            { children: ['B', 'E'],  depth: 0, name: 'A', parent: nil, relations: []},
            { children: ['C', 'D'], depth: 1, name: 'B', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: ['E'] }]},
            { children: [], depth: 2, name: 'C', parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['E'] }, { depth: 1, own: true, parent: 'B', siblings: ['D'] }]},
            { children: ['F'], depth: 2, name: 'D', parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['E'] }, { depth: 1, own: true, parent: 'B', siblings: [] }]},
            { children: [], depth: 1, name: 'E', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: [] }, { depth: 2, own: false, parent: 'D', siblings: ['F'] }]},
            { children: [], depth: 3, name: 'F', parent: 'D', relations: [{ depth: 2, own: true, parent: 'D', siblings: [] }]}
          ]
        end

        it { is_expected.to eq(expected_result) }
        # A
        # ├B
        # │├C
        # │└D
        # └E│
        #   └F
      end

      context 'example B' do
        let(:input) do
          [
            ['A', nil],
            ['B', 'A'],
            ['C', 'B'],
            ['D', 'C'],
            ['E', 'D'],
            ['F', 'B'],
            ['G', 'E'],
            ['H', 'A']
          ]
        end

        let(:expected_result) do
          [
            { children: ['B', 'H'],  depth: 0, name: 'A', parent: nil, relations: []},
           { children: ['C', 'F'], depth: 1, name: 'B', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: ['H'] }]},
           { children: ['D'], depth: 2, name: 'C', parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['H'] }, { depth: 1, own: true, parent: 'B', siblings: ['F'] }]},
           { children: ['E'], depth: 3, name: 'D', parent: 'C', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['H'] }, { depth: 1, own: false, parent: 'B', siblings: ['F'] }, { depth: 2, own: true, parent: 'C', siblings: [] }]},
           { children: ['G'], depth: 4, name: 'E', parent: 'D', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['H'] }, { depth: 1, own: false, parent: 'B', siblings: ['F'] }, { depth: 3, own: true, parent: 'D', siblings: [] }]},
           { children: [], depth: 2, name: 'F', parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['H'] }, { depth: 1, own: true, parent: 'B', siblings: [] }, { depth: 4, own: false, parent: 'E', siblings: ['G'] }]},
           { children: [], depth: 5, name: 'G', parent: 'E', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['H'] }, { depth: 4, own: true, parent: 'E', siblings: [] }]},
           { children: [], depth: 1, name: 'H', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: [] }]}
          ]
        end

        it { is_expected.to eq(expected_result) }
        # A
        # ├B
        # │├C
        # ││└D
        # ││ └E
        # │└F │
        # │   └G
        # └H
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
          { children: ['B', 'Q'], depth: 0, name: 'A', parent: nil, relations: []},
          { children: ['C', 'P'], depth: 1, name: 'B', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: ['Q'] }]},
          { children: ['D', 'E'], depth: 2, name: 'C', parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: true, parent: 'B', siblings: ['P'] }]},
          { children: [], depth: 3, name: 'D', parent: 'C', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 2, own: true, parent: 'C', siblings: ['E'] }]},
          { children: ['F', 'O'], depth: 3, name: 'E', parent: 'C', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 2, own: true, parent: 'C', siblings: [] }]},
          { children: ['G', 'I'], depth: 4, name: 'F', parent: 'E', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 3, own: true, parent: 'E', siblings: ['O'] }]},
          { children: ['H'], depth: 5, name: 'G', parent: 'F', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 3, own: false, parent: 'E', siblings: ['O'] }, { depth: 4, own: true, parent: 'F', siblings: ['I']}]},
          { children: [], depth: 6, name: 'H', parent: 'G', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 3, own: false, parent: 'E', siblings: ['O'] }, { depth: 4, own: false, parent: 'F', siblings: ['I'] }, { depth: 5, own: true, parent: 'G', siblings: [] }]},
          { children: [], depth: 5, name: 'I', parent: 'F', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 3, own: false, parent: 'E', siblings: ['O'] }, { depth: 4, own: true, parent: 'F', siblings: [] }]},
          { children: [], depth: 4, name: 'O', parent: 'E', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: false, parent: 'B', siblings: ['P'] }, { depth: 3, own: true, parent: 'E', siblings: [] }]},
          { children: [], depth: 2, name: 'P', parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['Q'] }, { depth: 1, own: true, parent: 'B', siblings: [] }]},
          { children: [], depth: 1, name: 'Q', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: [] }]}
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
            { children: ['B', 'G'],  depth: 0, name: 'A', parent: nil, relations: []},
            { children: ['C'], depth: 1, name: 'B', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: ['G'] }]},
            { children: ['D', 'E'], depth: 2, name: 'C',  parent: 'B', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['G'] }, { depth: 1, own: true, parent: 'B', siblings: [] }]},
            { children: [], depth: 3, name: 'D', parent: 'C', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['G'] }, { depth: 2, own: true, parent: 'C', siblings: ['E'] }]},
            { children: ['F'], depth: 3, name: 'E', parent: 'C', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['G'] }, { depth: 2, own: true, parent: 'C', siblings: [] }]},
            { children: [], depth: 4, name: 'F', parent: 'E', relations: [{ depth: 0, own: false, parent: 'A', siblings: ['G'] }, { depth: 3, own: true, parent: 'E', siblings: [] }]},
            { children: [], depth: 1, name: 'G', parent: 'A', relations: [{ depth: 0, own: true, parent: 'A', siblings: [] }]}
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
