def in_directory dir
  previous_working_dir = FileUtils.pwd
  FileUtils.cd dir
  yield
ensure
  FileUtils.cd previous_working_dir
end
