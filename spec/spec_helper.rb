require 'rubygems'
require 'bundler/setup'
require 'bigint_pk'
require 'fileutils'
require 'active_record'
Dir["#{File.dirname __FILE__}/support/**"].each{|f| require f }

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.include Module.new{
    Root = File.expand_path "#{File.dirname __FILE__}/.."
    TmpDir = File.expand_path "#{Root}/tmp" 
    RailsAppName = "test_rails_app"
    RailsDir = "#{TmpDir}/#{RailsAppName}"
    FixturesDir = "#{Root}/spec/fixtures"
  }

  c.before :all, :integration do
    FileUtils.mkdir_p TmpDir

    in_directory TmpDir do
      FileUtils.rm_rf RailsAppName
      run "rails new #{RailsAppName}"
      FileUtils.cp "#{FixturesDir}/Gemfile", "#{RailsDir}/Gemfile"
      File.open "#{RailsDir}/Gemfile", 'a' do |f|
        f.puts %Q{gem 'rails-bigint-pk', path: '#{Root}'}
      end
    end

    in_directory RailsDir do
      %w(app/models db/migrate).each do |dir|
        FileUtils.mkdir_p "#{RailsDir}/#{dir}"
        FileUtils.cp_r  Dir["#{FixturesDir}/test_rails_app/#{dir}/*.rb"],
                        "#{RailsDir}/#{dir}"
      end

      run "bundle install --binstubs"
      run "git init && git add . && git commit -m 'Root'"
    end
  end

  c.before :each, :integration do
    in_directory RailsDir do
      # Save anything done before :all
      run 'git add . && git commit -m "test group setup"; true'
    end
  end

  c.after :each, :integration do
    in_directory RailsDir do
      run 'git reset --hard'
      run 'git clean -fd'
    end
  end
end
