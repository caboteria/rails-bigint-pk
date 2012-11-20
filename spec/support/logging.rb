# Switch to true to enable verbose logging.
$LOG = false
def log
  STDERR.puts yield if $LOG
end
