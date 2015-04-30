class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create

    @tag = Tag.create(tag_params)
    redirect_to :tags

  end

  def show
    @tag = Tag.find(params[:id])
    @creatures = @tag.creatures
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update!(creature_params)
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.creatures.length == 0
      @tag.destroy
      redirect_to :tags
    else
      # flash[:danger] = "Cannot delete this tag because there is/are #{@tag.creatures.length} creature(s) using it."
      @tag.creatures.each do |c|
        c.tags.delete(@tag)
      end
      @tag.destroy
      redirect_to :tags
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end
