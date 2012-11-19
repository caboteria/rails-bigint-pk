def use_database! db
  src, dest =
    case db
    when :mysql
      ["#{FixturesDir}/mysql_database.yml", "#{RailsDir}/config/database.yml"]
    when :postgres
      ["#{FixturesDir}/postgresql_database.yml", "#{RailsDir}/config/database.yml"]
    when :sqlite3
      ["#{FixturesDir}/sqlite3_database.yml", "#{RailsDir}/config/database.yml"]
    end

  log{ "copying #{src} to #{dest}" }
  FileUtils.cp src, dest

  rake 'db:drop'
  rake 'db:create'
end

def execute_sql sql
  File.open("#{TmpDir}/cmd.sql", 'w'){|f| f.print sql }
  execute_ruby %Q{
    sqls = File.read('#{TmpDir}/cmd.sql').gsub(/\\s+/, ' ').strip
    sqls.split(';').each do |sql|
      ActiveRecord::Base.connection.execute sql
    end
  }
end

def execute_ruby ruby
  File.open("#{TmpDir}/cmd.rb", 'w'){|f| f.print ruby }
  bundle_exec "rails runner #{TmpDir}/cmd.rb"
end
