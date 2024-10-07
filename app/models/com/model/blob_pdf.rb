# frozen_string_literal: true
module Com
  module Model::BlobPdf
    extend ActiveSupport::Concern

    included do
      attribute :url, :string

      has_one_attached :file

      before_create :process_file
    end

    def process_file
      pdf_path = UrlUtil.filepath_from_url url
      return if CompressUtil.pdf_pages(pdf_path).to_i > 10
      file = CompressUtil.pdf_to_jpg(pdf_path)
      self.file.attach(io: file, filename: pdf_path.basename)
    end

    def file_url
      file.url
    end

  end
end
