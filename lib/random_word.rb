require 'set'

module RandomWord
  module EachRandomly
    def each_randomly(&blk)
      used = Set.new
      
      while true
        idx = next_unused_idx(used)
        used << idx
        yield at(idx)
      end

    rescue OutOfWords
      # we are done.
    end
    
    private
    def next_unused_idx(used)
      idx = rand(length)
      try = 1
      while used.include?(idx)
        raise OutOfWords if try > 1000
        idx = rand(length)
        try += 1
      end 
      
      idx
    end
    class OutOfWords < Exception; end
  end

  class << self
    def enumerator(word_list)
      word_list.extend EachRandomly
      Enumerator.new(word_list, :each_randomly)
    end


    def nouns
      @nouns ||= enumerator(load_word_list("nouns.dat"))
    end

    def adjs
      @adjs ||= enumerator(load_word_list("adjs.dat"))
    end

    protected
    def load_word_list(name)
      data_root = Pathname(File.dirname(__FILE__)) + "../data"
      File.open(data_root + name){|f| Marshal.load(f)}
    end
  end
end

