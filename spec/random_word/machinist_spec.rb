require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'machinist/machinable'
require 'machinist/blueprint'
require 'machinist/lathe'
require 'random_word/machinist'

describe RandomWord::Machinist do
  let(:klass){ Class.new(Struct.new(:name)) do
      extend Machinist::Machinable
    end
  }

  it "allows the use of #sw in blue prints" do
    klass.blueprint do
      name do
        serial_word
       end
    end
    klass.make.name.should_not be_nil
  end

end
