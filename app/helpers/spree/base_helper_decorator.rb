Spree::BaseHelper.module_eval do

	def cache_key_for_product(product = @product)
    (common_product_cache_keys + [product.cache_key, product.possible_promotions]).compact.join("/")
  end

	def common_product_cache_keys
    [I18n.locale, current_currency] + price_options_cache_key
  end

	def price_options_cache_key
    current_price_options.sort.map(&:last).map do |value|
      value.try(:cache_key) || value
    end
  end

end
