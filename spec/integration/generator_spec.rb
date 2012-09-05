require 'spec_helper'

describe BigintPk::Generators::InstallGenerator, :integration do
  before do
    in_directory( RailsDir ) do
      run 'rails generate bigint_pk:install' do |stdout, stderr|
        expect( stdout.read ).to_not include 'Could not find generator'
      end
    end
  end

  it 'creates a bigint_pk initializer' do
    expect( File.exists? "#{RailsDir}/config/initializers/bigint_pk.rb").to be_true
  end

  it 'creates a bigint_pk migration' do
    expect( Dir["#{RailsDir}/db/migrate/*change_keys_to_bigint.rb"].size ).to eq 1
  end
end
