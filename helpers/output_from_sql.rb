public

def output_from_sql(sql_file,target_file)

  raise ArgumentError, "SQL file not found : #{sql_file}" unless File.exists?(sql_file)

  data = ActiveRecord::Base.connection.select_all(File.open(sql_file).read)

  keys = data.first.keys
  FasterCSV.open(target_file,'w') do |csv|
    csv << keys
    data.each do |row|
      csv << keys.map {|key| row[key]}
    end
  end
end
