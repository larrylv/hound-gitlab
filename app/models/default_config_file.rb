class DefaultConfigFile
  CONFIG_DIR = "config/style_guides"

  pattr_initialize :file_name

  def path
    File.join(directory, file_name)
  end

  private

  def directory
    CONFIG_DIR
  end
end
