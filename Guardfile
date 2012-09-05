# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', cli: '--tag ~integration' do
  watch('spec/spec_helper.rb'){ 'spec' }
  watch(%r{spec/support/*}){ 'spec' }
  watch(%r{^spec/(?!integration/).+_spec\.rb})

  watch(%r{^lib/bigint_pk\.rb}){ 'spec/monkey_patch/connection_adapters_spec.rb' }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'ctags-bundler', :src_path => ["lib", "spec/support"] do
  watch(/^(app|lib|spec\/support)\/.*\.rb$/)
  watch('Gemfile.lock')
end
