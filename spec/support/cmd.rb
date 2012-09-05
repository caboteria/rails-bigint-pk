require 'open3'

def run *args
  stdin, stdout, stderr, wait_thr = Open3.popen3 *args
  cmd_process = wait_thr.value

  # Uncomment for debugging
  #
  # unless cmd_process.success?
  #   puts stdout.read
  #   puts stderr.read
  # end

  expect( cmd_process ).to be_success

  if block_given?
    yield stdout, stderr
  else
    stdout.read.chomp
  end
end

def rake task
  in_directory( RailsDir){ run "bundle exec rake #{task}"}
end
