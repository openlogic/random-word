module RandomWord
  module Machinist
    # The serial word for the object being manufactured.
    def serial_word
      @serial_word ||= RandomWord.adjs.next
    end
    alias_method :sw, :serial_word

    # The serial adjective for the object being manufactured.
    def serial_adj
      serial_word
    end

    # The serial noun for the object being manufactured.
    def serial_noun
      @serial_noun ||= RandomWord.nouns.next
    end

  end
end

begin
  require 'machinist/lathe'
  Machinist::Lathe.send(:include, RandomWord::Machinist)
rescue LoadError, NameError
  # Machinist is not available
end
