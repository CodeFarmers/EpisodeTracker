module XmlTestHelpers

  def get_xml_from_file(path)
    file = File.open(path)
    REXML::Document.new file
  end

  def get_text_from_file(path)
    file = File.open(path)
    file.read
  end
end

