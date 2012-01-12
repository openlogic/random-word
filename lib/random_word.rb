require 'set'
require 'pathname'

# Provides random, non-repeating enumerators of a large list of
# english words. For example"
#
#     RandomWord.adjs.next #=> "strengthened"
#
module RandomWord
  module EachRandomly
    attr_accessor :random_word_exclude_list

    def each_randomly(&blk)
      used = Set.new
      exclude_list = Array(@random_word_exclude_list)
      while true
        idx = next_unused_idx(used)
        used << idx
        word = at(idx)
        next if exclude_list.any?{|r| r === word }
        yield word
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
    def exclude_list
      @exclude_list ||= []
    end

    # @return [Enumerator] Random noun enumerator
    def nouns
      @nouns ||= enumerator(load_word_list("nouns.dat"), exclude_list)
    end

    # @return [Enumerator] Random adjective enumerator
    def adjs
      @adjs ||= enumerator(load_word_list("adjs.dat"), exclude_list)
    end

    # @return [Enumerator] Random phrase enumerator
    def phrases
      @phrases ||= Enumerator.new(Class.new do 
        def each()
          while true
            yield "#{RandomWord.adjs.next} #{RandomWord.nouns.next}"
          end
        end
      end.new)
    end

    # Create a random, non-repeating enumerator for a list of words
    # (or anything really).
    def enumerator(word_list, list_of_regexs_or_strings_to_exclude = [])
      word_list.extend EachRandomly
      word_list.random_word_exclude_list = list_of_regexs_or_strings_to_exclude
      word_list.enum_for(:each_randomly)
    end

    protected

    def load_word_list(name)
      data_root = Pathname(File.dirname(__FILE__)) + "../data"
      File.open(data_root + name){|f| Marshal.load(f)}
    end
  end
end

