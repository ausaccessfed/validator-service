# frozen_string_literal: true
module Documentation
  class AttributesController < ApplicationController
    skip_before_action :ensure_authenticated

    before_action :public_action
    before_action :set_documentation_attribute, only: [:show]

    def index
      @federation_attributes = FederationAttribute.order(:name).all
    end

    def show
      @attribute_categories = @federation_attribute.categories
                                                   .enabled
                                                   .map do |category|
        [category.name, documentation_category_path(category)]
      end
    end

    private

    def set_documentation_attribute
      @federation_attribute = FederationAttribute.find_by_oid(params[:id])
    end
  end
end
