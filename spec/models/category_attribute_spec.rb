# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CategoryAttribute, type: :model do
  context 'class' do
    describe '.sort_by_order' do
      it 'sorts by order key' do
        sortable = [{ name: 'a', order: 2 }, { name: 'b', order: 1 }]

        expect(CategoryAttribute.sort_by_order(sortable)).to(
          eql([{ name: 'b', order: 1 }, { name: 'a', order: 2 }])
        )
      end
    end
  end
end
