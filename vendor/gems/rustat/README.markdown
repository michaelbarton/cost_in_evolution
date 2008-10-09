# rustat

* www.github.com/michaelbarton/rustat

## DESCRIPTION:

Rustat is a gem that provides simple statistical summary methods in Ruby. Rustat also provides an acts_as_summary method to ActiveRecord::Base that makes these methods available to database models.

## FEATURES/PROBLEMS:

Rustat currently provides methods for
 * Mean, median and mode
 * Largest and smallest observation
 * Sum, and standard deviation

Rustat::ActsAsSummary can be used to tag all these methods onto an ActiveRecord::Base class, as well as providing options for
 * Choosing the name for the variable which forms the basename of the method
 * Using a select block to decide which data are used in the method
 * Using a map block to transform the data in some way

## SYNOPSIS:

### Rustat

    require 'rustat'
    data = [1,2,3,4,5]

    Rustat.mean_observation(data)
    Rustat.standard_deviation_of_observations(data)

### Rustat::ActsAsSummary

    require 'rustat/acts_as_summary'

    # An AR database model
    class User < ActiveRecord::Base
      # There must be a method on User called age
      # that returns a numeric value unless a map
      # block is used (see below)
      acts_as_summary :age
    end

    # All rustat methods are now available to user
    # See Rustat for full list
    User.mean_age
    User.standard_deviation_of_ages

    # Map and select can be used to provide more 
    # specific summaries
    class User < ActiveRecord::Base
      acts_as_summary :timestamp,
        :active_record => {:conditions => {premium => true}}
        :map           => lambda {|time| Time.now - time},
        :name          => :premium_user_subscription_time
    end

    User.median_premium_user_subscription_time

## INSTALL:

Not on Rubyforge at present

## LICENSE:

(The MIT License)

Copyright (c) 2008 Michael D. Barton

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
