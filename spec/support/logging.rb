$LOG = true
def log
  STDERR.puts yield if $LOG
end
