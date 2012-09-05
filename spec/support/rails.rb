def use_database! db
  case db
  when :mysql
    FileUtils.cp "#{FixturesDir}/mysql_database.yml", "#{RailsDir}/config/database.yml"
  when :postgres
    FileUtils.cp "#{FixturesDir}/postgresql_database.yml", "#{RailsDir}/config/database.yml"
  when :sqlite3
    FileUtils.cp "#{FixturesDir}/sqlite3_database.yml", "#{RailsDir}/config/database.yml"
  end

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
  in_directory( RailsDir ) do
    run "bundle exec rails runner #{TmpDir}/cmd.rb"
  end
end
