module XmlTestHelpers

  def get_text_from_file(path)
    file = File.open(path)
    file.read
  end
end

