class UploadsController < ApplicationController
  def new
  end

  def create
    @document = Document.new(params.require(:document).permit(:attachment))

    if @document.save
      redirect_to edit_document_path(@document.id)
    else
      render text: "Oh No!"
    end
  end
end
