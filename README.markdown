random-word
====
[![Build Status](https://travis-ci.org/openlogic/random-word.svg?branch=master)](https://travis-ci.org/openlogic/random-word)
[![Coverage Status](https://coveralls.io/repos/github/openlogic/random-word/badge.svg?branch=master)](https://coveralls.io/github/openlogic/random-word?branch=master)

A random word generator intended for use in test data factories.  This
library uses a large list (the wordnet corpus) of english words and
provides an enumerator interface to that corpus that will return the
words in a random order without repeats.

Usage
----

You can get a random word any where you need one. Just request the
next of which ever word flavor you prefer.

```ruby
RandomWord.adjs.next  #=> "pugnacious"
RandomWord.nouns.next #=> "audience"
```
    
### Factory Girl

This library was first developed to use in factories. It can be used
with Factory Girl like this.

```ruby
Factory.define(:user) do |u|
  u.name { "#{RandomWord.adjs.next} User" }
  u.email { "#{name.gsub(/ +/, '.')}@example.com" }
end

Factory(:user) #=> ...
```

Exclusion
----

Words may be excluded by pattern, or exact match. To do this just add
an object that responds to `#===` to the exclude list.

```ruby
RandomWord.exclude_list << /fo+/
RandomWord.exclude_list << 'bar'
```

This will prevent the return of the exact string `"bar"` and any word
which matches the regex `/fo+/`.

Constraining word length
----

You can constrain the length of words provided by the `nouns` and `adjs` iterators like so:

```ruby
RandomWord.nouns(not_longer_than: 56).next
RandomWord.adjs(not_shorter_than: 3).next
RandomWord.adjs(not_shorter_than: 16, not_longer_than: 672).next
```

Contributing to random-word
----
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Update history
* Update version (remember to use [semantic versioning][semver])
* Commit and push
* Send me a pull request. Bonus points for topic branches.

[semver]:http://semver.org/ 

Copyright
----

Copyright (c) 2011 OpenLogic, Inc. See LICENSE.txt for
further details.

