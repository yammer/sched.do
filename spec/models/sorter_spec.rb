require 'spec_helper'

describe Sorter, '#sort' do
  context 'with objects that are DateTime compatible' do
    it 'returns date based objects sorted in chronological order' do
      suggestion1 = create(:primary_suggestion, description: 'Mar 05, 2013')
      suggestion2 = create(:primary_suggestion, description: 'Mar 01, 2013')

      results = Sorter.new([suggestion1, suggestion2]).sort

      expect(results).to eq [suggestion2, suggestion1]
    end

    it 'returns time based objects sorted in chronological order' do
      suggestion1 = create(:primary_suggestion, description: '10pm')
      suggestion2 = create(:primary_suggestion, description: '10am')

      results = Sorter.new([suggestion1, suggestion2]).sort

      expect(results).to eq [suggestion2, suggestion1]
    end
  end

  context 'with objects that are not DateTime compatible' do
    it 'returns objects in the original sort order' do
      suggestion1 = create(:primary_suggestion, description: 'Mar 05, 2013')
      suggestion2 = create(:primary_suggestion, description: 'Mar 01, 2013')

      results = Sorter.new([suggestion1, suggestion2]).sort

      expect(results).to eq [suggestion2, suggestion1]
    end
  end

  context 'with objects that do not respond to #full_description' do
    it 'raises a NoMethodError' do
      expect { Sorter.new([200, 100]).sort }.to raise_error NoMethodError
    end
  end
end
