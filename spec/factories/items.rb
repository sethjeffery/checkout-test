FactoryGirl.define do
  factory :item do
    sequence :product_code do |index|
      index.to_s.rjust(3, '0')
    end
  end
end
