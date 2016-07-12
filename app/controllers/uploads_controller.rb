class UploadsController < ApplicationController
  def new
  end

  def create
    @document = Document.new(params.require(:document).permit(:attachment))

    file = params[:document][:attachment]

    @document.attachment_filename ||= file.original_filename
    @document.attachment_name ||= file.original_filename
    @document.attachment_size ||= file.size

    if @document.save
      redirect_to document_path(@document.id)
    else
      render text: "Oh No!"
    end
  rescue ActiveRecord::RecordNotUnique
    doc = Document.where(attachment_fingerprint: @document.attachment_fingerprint).first
    redirect_to document_path(doc.id)
  end
end
