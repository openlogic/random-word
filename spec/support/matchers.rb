RSpec::Matchers.define :be_one_of do |expected|
  match do |actual|
    expected.any?{|exp_val| exp_val === actual}
  end

end
