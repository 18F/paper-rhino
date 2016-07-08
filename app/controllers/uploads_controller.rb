class UploadsController < ApplicationController
  def new
  end

  def create
    @document = Document.new(params.require(:document).permit(:attachment))

    if @document.save
      render text: "Great!"
    else
      render text: "Oh No!"
    end
  end
end
