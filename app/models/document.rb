class Document < ApplicationRecord
  attachment :attachment

  before_save :add_attachment_data

  def add_attachment_data
    attachment_io = self.attachment.to_io

    reader = PDF::Reader.new(attachment_io)

    # might be set by filename
    if title = reader.info[:Title]
      self.attachment_name = title.strip
    end

    self.attachment_fingerprint = Digest::SHA256.hexdigest(attachment_io.read)
    self.attachment_tags = reader.info[:Keywords].try(:strip).try(:split, ',').try(:map) { |tag|
      tag.strip
    }
    self.attachment_pages = reader.pages.map { |page|
      page.text.gsub(/\n{2,}/, "\n\n").gsub(/ {2,}/, " ").split("\n").map(&:strip).join("\n")
    }
  end
end
