class ProductCache
  constructor: -> @cache = {}
  add_raw: (product) ->
    id = String(product.id)
    @cache[id] =
      id: id
      value: product.name + ' (' + product.id + ')'
  find_by_id: (id) -> @cache[id]
  find_by_value: (value) ->
    _(@cache).detect (item) -> item.value == value

# fetch products via spree API and add them to the cache
fetch_products = (elem, cache, data) ->
  $.ajax(
    url: '/api/products',
    dataType: 'json',
    beforeSend: (xhr) -> xhr.setRequestHeader('X-Spree-Token', elem.data('spree-api-key')),
    data: data,
  ).then (data) ->
    data.products.map (product) -> cache.add_raw(product)

init_editor = (elem, cache, initial_values) ->
  elem.tagEditor # jQuery tagEditor
    initialTags: initial_values
    forceLowercase: false
    autocomplete:
      source: (request, response) ->
        fetch_products(elem, cache, 'q[name_cont]': request.term).done (products) ->
          response(products.map (product) -> product.value)
    onChange: (field, editor, values) ->
      product_ids = values.map (value) -> cache.find_by_value(value).id
      field.scrivito('save', product_ids)

products_editor =
  can_edit: (element) ->
    $(element).data('scrivito-field-name') == 'product_ids' &&
    $(element).data('scrivito-field-obj-class') == 'SpreeProductsWidget'
  activate: (element) ->
    elem = $(element)
    cache = new ProductCache()

    current_item_ids = elem.scrivito('content')
    if current_item_ids.length
      fetch_products(elem, cache, ids: current_item_ids.join(',')).then (products) ->
        # reiterate current_item_ids, since fetch_products does not response in the correct order
        intial_values = current_item_ids.map (item_id) -> cache.find_by_id(item_id).value
        init_editor(elem, cache, intial_values)
    else
      init_editor(elem, cache, [])

scrivito.on 'load', () ->
  scrivito.define_editor 'products_editor', products_editor
  scrivito.select_editor (element, editor) ->
    editor.use('products_editor')
