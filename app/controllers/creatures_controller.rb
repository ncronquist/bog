require 'flickraw'

class CreaturesController < ApplicationController

  def index
    @creatures = Creature.all
  end

  def new
    @creature = Creature.new
    @tags = Tag.all
  end

  def create

    # render :json => params

    @creature = Creature.create(creature_params)

    params['creature']['tag_ids'].each do |tag_id|
      @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    end
    redirect_to @creature
  end

  def show
    # Set up the FlickRaw gem
    FlickRaw.api_key=ENV["FLICKR_API_KEY"]
    FlickRaw.shared_secret=ENV["FLICKR_API_SECRET"]

    # Find the current creature
    @creature = Creature.find(params[:id])

    # Retrieve a list of images that are relevant to the creature name
    list = flickr.photos.search :text => @creature.name, :sort => "relevance"

    # The list of images returns sorted by relevant
    # Retrieve the 3 most relevant public photos
    photolist = []
    i = 0
    until photolist.length == 3 do
      photolist << list[i] if list[i].ispublic
      i += 1
    end

    # For each photo retrieve the small version of the image
    @photos = []
    photolist.each do |photo|
      sizes = flickr.photos.getSizes :photo_id => photo.id
      # The fourth object is always the small picture
      @photos << sizes[3]
    end
  end

  def edit
    @creature = Creature.find(params[:id])
    @tags = Tag.all
  end

  def update
    @creature = Creature.find(params[:id])
    @creature.update!(creature_params)

    params['creature']['tag_ids'].each do |tag_id|
      @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    end

    redirect_to @creature
  end

  def destroy
    Creature.find(params[:id]).destroy
    redirect_to creatures_path
  end

  private

  def creature_params
    params.require(:creature).permit(:name,:description)
  end

end
