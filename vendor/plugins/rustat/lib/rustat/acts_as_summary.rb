module Rustat
  module ActsAsSummary
    module ActiveRecordExtensions
    
      # Include this module in active record base
      def self.included(base)
        base.send(:extend, ClassMethods)
      end
      
      module ClassMethods
        def acts_as_summary(var,options=Hash.new)
          (class << self; self; end).instance_eval do
          
            # The name to be used in the method is the variable
            # name unless otherwise specified
            if options[:name]
              name = options[:name]
            else
              name = var
            end

            # Is there a block supplied to transfrom the data?
            if options[:map]
              transform = options[:map]
            else
              transform = lambda {|x|x} if transform.nil?
            end

            # Is there a block supplied to filter the data
            if options[:select]
              filter = options[:select]
            else
              filter = lambda {|x|true}
            end


            # List of methods that contain the word observation
            methods = Rustat.public_methods.select{|x| x =~ /observation/}

            # For each Rustat method containing the word observation
            # replace the word 'observation' with the provided
            # variable name and dynamically create a class method
            # on this AR class that deletegates to corresponding
            # Rustat method
            methods.inject(Array.new) do |array,method|
              new_method = method.gsub('observation',name.to_s)
              define_method(new_method) do
                data = self.all(options[:active_record]).select(&filter).map(&var).map(&transform)
                Rustat.send method, data
              end

              # Add to an array so that the acts_as_summary method returns
              # the names of the newly defined methods
              array << new_method
            end
          end
        end
      end
    
    end # ActiveRecordExtension
  end # ActsAsSummary
end # Rustat

ActiveRecord::Base.send(:include, Rustat::ActsAsSummary::ActiveRecordExtensions)
