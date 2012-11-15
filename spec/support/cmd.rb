require 'open3'

def run *args
  stdin, stdout, stderr, wait_thr = Open3.popen3 *args
  cmd_process = wait_thr.value

  unless cmd_process.success?
    fail [
      "Error running: '#{args.join(' ')}'",
      "\n\nstdout:\n\n#{stdout.read}",
      "\n\nstderr:\n\n#{stderr.read}"
    ].join("\n")
  end

  if block_given?
    yield stdout, stderr
  else
    stdout.read.chomp
  end
end

def rake task
  in_directory( RailsDir){ run "bundle exec rake #{task}"}
end
