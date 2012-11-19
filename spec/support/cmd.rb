require 'open3'

def run *args
  _, stdout, stderr, wait_thr = Open3.popen3( *args )
  cmd_process = wait_thr.value

  log do
    "(in #{Dir.pwd})
      command: #{args.join ' '}"
  end

  unless cmd_process.success?
    fail [
      "Error",
      "\n\nstdout:\n\n#{stdout.read}",
      "\n\nstderr:\n\n#{stderr.read}"
    ].join("\n")
  end

  if block_given?
    yield stdout, stderr
  else
    output, error = stdout.read, stderr.read
    log do
      "stdout: #{output}
       stderr: #{error}"
    end
    output.chomp
  end
end

def rake task
  bundle_exec "rake #{task}"
end

def bundle_exec command
  in_directory( RailsDir) do
    Bundler.with_clean_env do
      run "bundle exec #{command}"
    end
  end
end
