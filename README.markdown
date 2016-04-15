random-word
====

A random word generator intended for use in test data factories.  This
library uses a large list (the wordnet corpus) of english words and
provides an enumerator interface to that corpus that will return the
words in a random order without repeats.

Usage
----

You can get a random word any where you need one. Just request the
next of which ever word flavor you prefer.

    RandomWord.adjs.next  #=> "pugnacious"
    RandomWord.nouns.next #=> "audience"
    
### Factory Girl

This library was first developed to use in factories. It can be used
with Factory Girl like this.

    Factory.define(:user) do |u|
      u.name  "#{RandomWord.adjs.next} User"
      u.email "{|u| "#{u.name.gsub(/ +/, '.')}@example.com"
    end

    Factory(:user) #=> ...

### Machinist


For Machinist a `#sw` (short for serial word) method is provided. It works exactly like `#sn`
but it returns a string instead of a number.

    User.blueprint do 
      name  { "#{sw.capitalize} User" }
      email { "#{sw}.user@example.com" }
    end

Exclusion
----

Words may be excluded by pattern, or exact match. To do this just add
an object that responds to `#===` to the exclude list.

    RandomWord.exclude_list << /fo+/
    RandomWord.exclude_list << 'bar'

This will prevent the return of the exact string `"bar"` and any word
which matches the regex `/fo+/`.


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

