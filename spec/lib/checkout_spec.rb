require 'checkout'
require 'rule'
require 'item'

RSpec.describe Checkout do
  let!(:lavendar_heart) { FactoryGirl.build(:item, product_code: '001', name: 'Lavendar Heart',         price: 925) }
  let!(:cufflinks)      { FactoryGirl.build(:item, product_code: '002', name: 'Personalised Cufflinks', price: 4500) }
  let!(:shirt)          { FactoryGirl.build(:item, product_code: '003', name: 'Kids T-Shirt',           price: 1995) }

  context 'without rules' do
    let(:checkout) { Checkout.new }

    it 'applies no discounts' do
      checkout.scan(lavendar_heart)
      checkout.scan(cufflinks)
      checkout.scan(lavendar_heart)
      checkout.scan(shirt)
      expect(checkout.total).to eq 8345
    end
  end

  context 'with rules' do
    let!(:rules) { Rule.import }
    let(:checkout) { Checkout.new(rules) }

    it 'applies discount over £60' do
      checkout.scan(lavendar_heart)
      checkout.scan(cufflinks)
      checkout.scan(shirt)
      expect(checkout.total).to eq 6678
    end

    it 'applies discount for many lavendar_hearts' do
      checkout.scan(lavendar_heart)
      checkout.scan(shirt)
      checkout.scan(lavendar_heart)
      expect(checkout.total).to eq 3695
    end

    it 'combines discounts' do
      checkout.scan(lavendar_heart)
      checkout.scan(cufflinks)
      checkout.scan(lavendar_heart)
      checkout.scan(shirt)
      expect(checkout.total).to eq 7376
    end
  end
end
