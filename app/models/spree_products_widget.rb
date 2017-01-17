class SpreeProductsWidget < Widget
  attribute :product_ids, :stringlist

  def products
    return [] unless product_ids.present?

    spree_products = Spree::Product.find(product_ids)

    # Spree API may return products in different order!
    product_ids.map { |id| spree_products.detect { |p| p.id.to_s == id } }
  end
end
