# frozen_string_literal: true
module Documentation
  class CategoriesController < ApplicationController
    skip_before_action :ensure_authenticated

    before_action :public_action
    before_action :set_documentation_category, only: [:show]

    def index
      @federation_categories = Category.enabled.order(:order).all
    end

    def show
      @category_attributes = @federation_category
                             .federation_attributes.map do |attribute|
        [attribute.name, documentation_attribute_path(attribute.oid)]
      end
    end

    private

    def set_documentation_category
      @federation_category = Category.enabled.find(params[:id])
    end
  end
end
