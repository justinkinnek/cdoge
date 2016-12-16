class ItemsController < ApplicationController
  skip_authorization_check

  # GET items
  def index
    items = Item.all
    respond_to do |format|
      format.json { paginate json: items, per_page: 10 }
      format.html {}
    end
  end

end
