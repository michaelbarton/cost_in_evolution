class GeneMutation < ActiveRecord::Base
  belongs_to :alignment

  acts_as_summary :estimated_rate,
    :name => :codeml_estimated_rate,
    :active_record => { :conditions => {:dataset => 'Barton2009'}  }

  acts_as_summary :estimated_rate,
    :name => :wall_estimated_rate,
    :active_record => { :conditions => {:dataset => 'Wall2005'}  }
end
