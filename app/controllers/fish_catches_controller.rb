# frozen_string_literal: true

class FishCatchesController < ApplicationController
  before_action :require_signin
  before_action :set_fish_catch, only: %i[show edit update destroy]

  def index
    @pagy, @fish_catches =
      pagy(current_user.filter_catches(params),
           items: params[:per_page] ||= 5,
           link_extra: 'data-turbo-action="advance"')

    @bait_names = Bait.pluck(:name)
    @species = FishCatch::SPECIES

    @min_weight = current_user.min_catch_weight
    @max_weight = current_user.max_catch_weight
  end

  def show; end

  def edit; end

  def update
    if @fish_catch.update(fish_catch_params)
      @fish_catches = fish_catches_for_bait(@fish_catch.bait)

      flash.now[:notice] = 'Catch successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @fish_catch = current_user.fish_catches.new(fish_catch_params)

    if @fish_catch.save
      @fish_catches = fish_catches_for_bait(@fish_catch.bait)

      @new_catch = current_user.fish_catches.new(bait: @fish_catch.bait)

      flash.now[:notice] = 'Catch successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @fish_catch.destroy

    @fish_catches = fish_catches_for_bait(@fish_catch.bait)

    flash.now[:notice] = 'Catch successfully deleted.'
  end

  private

  def set_fish_catch
    @fish_catch = current_user.fish_catches.find(params[:id])
  end

  def fish_catch_params
    params.require(:fish_catch).permit(:species, :weight, :length, :bait_id)
  end

  def tackle_box_item_for_catch(fish_catch)
    current_user.tackle_box_items.find_sole_by(bait: fish_catch.bait)
  end

  def fish_catches_for_bait(bait)
    current_user.fish_catches.where(bait: bait).select(:weight)
  end
end
