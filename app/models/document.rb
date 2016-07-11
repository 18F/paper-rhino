class Document < ApplicationRecord
  attachment :attachment

  before_save :add_attachment_data

  def add_attachment_data
    reader = PDF::Reader.new(self.attachment.to_io)

    self.attachment_name = reader.info[:Title].try(:strip)
    self.attachment_tags = reader.info[:Keywords].try(:strip).try(:split, ',').try(:map) { |tag|
      tag.strip
    }
    self.attachment_pages = reader.pages.map { |page|
      page.text.gsub(/\n{2,}/, "\n\n").gsub(/ {2,}/, " ").split("\n").map(&:strip).join("\n")
    }
  end
end
