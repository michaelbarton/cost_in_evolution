public

def output_from_sql(sql_file,target_file)

  raise ArgumentError, "SQL file not found : #{sql_file}" unless File.exists?(sql_file)

  data = ActiveRecord::Base.connection.execute(File.open(sql_file).read)

  keys = data.fetch_fields.map(&:name)
  FasterCSV.open(target_file,'w') do |csv|
    csv << keys
    data.each { |row| csv << row }
  end
end
