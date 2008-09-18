require 'delegate'
require 'stringio'


module Bio
  module Rind
    class Counts < DelegateClass(Array)

      def initialize(counts)
        super(parse_counts(counts))
      end

      def parse_counts(counts)
        
        frequencies = Array.new
   
        io = StringIO.new(counts)

        header = io.readline.split(/\s+/)
        
        io.each_line do |line|

          # Skip position lines
          next if line =~ /position/

          # Split into cell results
          entries = line.split(/\s(?=\d+\.\d+\s+\+\-\s+\d+\.\d+)/)

          # Split individual cells into and array of estimated rate and error
          entries.map!{|x| x.strip.split(/\s+\+\-\s+/)}

          # Add the header to each entry
          entries = entries.zip(header)

          frequencies << entries.inject(Hash.new) do |hash, entry|
            # Ignore if there is no estimated rate for the entry
            unless entry.first.first == '0.000'
              hash[entry.last] = entry.first.map{|x| x.to_f}
            end
            hash
          end

        end # End of line loop

       frequencies
      end

    end # Parser
  end # Rind
end # Bio
