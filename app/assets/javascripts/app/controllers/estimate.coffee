angular.module('Constructor').controller 'EstimateController', class EstimateController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl     = @
    @scope.estimate = @pHelper.get('estimate')
    @scope.expense  = @pHelper.get('expense')
    @scope.stages   = @pHelper.get('stages')
    @scope.discount = @pHelper.get('discount')
    @scope.products = @pHelper.get('products')

    this.initModals()
    this.parseEstimate()
    this.parseProducts()
    this.parseExpense()
    this.parseDiscount()
    this.parseStages()
    this.saveJsonValue()

  showAddModal: (stage) ->
    @scope.addModal.header       = 'Добавление сметного продукта. Этап ' + stage
    @scope.addModal.products     = this.getProducts(stage)
    @scope.selectedProductId     = 'Выберите сметный продукт'
    @scope.selectedProductCustom = false
    @scope.selectedSetId         = 'Выберите сборку'
    @scope.selectedSet           = null
    @scope.currentStage          = stage

    $('#add-product').modal('show')
    true

  showEditModal: (stage, product) ->
    product = this.getProductFromStage(product)

    @scope.currentStage              = stage
    @scope.editModal.header          = 'Редактирование сметного продукта. Этап ' + stage
    @scope.selectedEditProduct       = product
    @scope.selectedEditProductId     = product.name
    @scope.selectedEditProductCustom = product.custom

    if product.custom
      set = product.sets.find((x) -> x.selected == true)
      @scope.selectedEditSetId         = set.id
      @scope.selectedEditSet           = set

    $('#edit-product').modal('show')
    true

  # Basic logic

  getProducts: (stage) ->
    @scope.products[stage - 1]

  getProduct: (id) ->
    products = @scope.products
    product  = undefined
    $.each(products, (i,v) ->
      if product == undefined
        product = v.find((x) -> x.id == parseInt(id))
    )
    product

  getSet: (id, sets) ->
    set = undefined
    if set == undefined
      set = sets.find((x) -> x.id == parseInt(id))
    set

  setSelectedProduct: () ->
    product_id = @scope.selectedProductId
    if product_id != 'Выберите сметный продукт'
      product = this.getProduct(product_id)
      @scope.selectedProduct = product
      @scope.selectedProductCustom = product.custom

  setSelectedSet: () ->
    product = @scope.selectedProduct
    set_id = @scope.selectedSetId
    if set_id != 'Выберите сборку'
      @scope.selectedSet = this.getSet(set_id, product.sets)
    else
      @scope.selectedSet = null

  setSelectedEditSet: () ->
    set_id = @scope.selectedEditSetId
    stage = this.getStage(@scope.currentStage)
    product = @scope.selectedEditProduct
    $.each(product.sets, (i,v) ->
      product.sets[i].selected = v.id == set_id
      true
    )
    @scope.selectedEditSet = this.getSet(set_id, @scope.selectedEditProduct.sets)
    this.recalcProduct()

  addProduct: () ->
    estimate     = @scope.estimate
    discount     = @scope.discount
    stage_number = @scope.currentStage
    product      = @scope.selectedProduct
    quantity     = $('#product-quantity').val()

    stage = this.getStage(stage_number)
    if product.custom
      product.price_with_work    = 0
      product.price_without_work = 0

      set_id = @scope.selectedSetId
      set = product.sets.find((x) -> x.id == parseInt(set_id))
      $.each($('.template-quantity'), (i, v) ->
        set.selected   = true
        set.items[i]   = Object.assign(set.items[i], {quantity: $(v).val()})
        product.price_with_work    += set.items[i].value.price    * $(v).val()
        unless set.items[i].value.work_primitive
          product.price_without_work += set.items[i].value.price * $(v).val()
      )
      product = Object.assign(product, {quantity: 1, with_work: true})
    else
      product = Object.assign(product, {quantity: quantity, with_work: true})

    this.recalcProductPrice(stage, product)
    stage.products.push(product)

    this.recalcStage(stage.number)

    $('#product-quantity').val(null)
    $('#add-product').modal('hide')
    true

  recalcProductPrice: (stage, product) ->
    if product.with_work
      price = product.price_with_work
    else
      price = product.price_without_work
    product.price = price + (price / 100 * (@scope.expense.percent + product.profit))
    this.recalcStage(stage.number)

  deleteProduct: (stage, id) ->
    product = stage.products.find((x) -> x.id == parseInt(id))
    index = stage.products.indexOf(product)
    stage.products.splice(index, 1)
    this.recalcStage(stage.number)

  getPriceByArea: (price) ->
    estimate = @scope.estimate
    return 0 if price == 0 || estimate.area == 0
    (price / estimate.area).toFixed(2)

  getPriceWithDiscount: (stage) ->
    discount = @scope.discount
    estimate = @scope.estimate
    discount_value = estimate.price * discount.values[stage.number - 1] / 100
    (stage.aggregated_price - discount_value).toFixed(2)

  getDiscountValue: (stage) ->
    discount = @scope.discount
    estimate = @scope.estimate
    (estimate.price * discount.values[stage.number - 1] / 100).toFixed(2)

  getProductFromStage: (product_id) ->
    stages = @scope.stages
    product = undefined
    $.each(stages, (i,v) ->
      if product == undefined
        product = v.products.find((x) -> x.id == parseInt(product_id))
    )
    product

  getStage: (number) ->
    @scope.stages.find((x) -> x.number == number)

  # Recalc logic

  recalcStage: (number) ->
    discount    = @scope.discount
    stage       = this.getStage(number)
    stage.price = 0
    $.each(stage.products, (i,p) ->
      if p.custom
        stage.price += p.price
      else
        stage.price += p.price * p.quantity
    )
    if discount.values[number - 1] < 0
      discount.values[number - 1] = 0

    discount = discount.values[number - 1]
    stage.total_price = stage.price - (stage.price * discount / 100)

    this.recalcStages()
    this.recalEstimate()

  recalcStages: () ->
    for i in [0..2]
      @scope.stages[i].aggregated_price = @scope.stages[i].price
      @scope.stages[i].aggregated_price += @scope.stages[i-1].aggregated_price if i != 0

  recalEstimate: () ->
    estimate = @scope.estimate
    stages   = @scope.stages
    estimate.price = 0
    $.each(stages, (i,v) -> estimate.price += v.total_price)
    this.saveJsonValue()

  recalcProduct: () ->
    expense = @scope.expense
    stage = @scope.currentStage
    product = @scope.selectedEditProduct

    product.price_with_work    = 0
    product.price_without_work = 0

    $.each(product.sets, (i,v) ->
      if v.selected
        $.each(v.items, (y,x) ->
          product.price_with_work    += x.quantity * x.value.price
          product.price_without_work += x.quantity * x.value.price unless x.value.work_primitive
        )
    )

    if product.with_work
      price = product.price_with_work
    else
      price = product.price_without_work
    product.price = price + (price / 100 * (expense.percent + product.profit))

    this.recalcStage(stage)

  saveJsonValue: () ->
    $('#estimate_json_stages').val(JSON.stringify(@scope.stages))
    true

  # Init data

  initModals: () ->
    @scope.currentStage              = null
    @scope.selectedProduct           = null
    @scope.selectedProductId         = 'Выберите сметный продукт'
    @scope.selectedProductUnit       = null
    @scope.selectedProductCustom     = false
    @scope.selectedSet               = null
    @scope.selectedSetId             = 'Выберите сборку'

    @scope.selectedEditProduct       = null
    @scope.selectedEditProductId     = null
    @scope.selectedEditProductCustom = false
    @scope.selectedEditSet           = null
    @scope.selectedEditSetId         = 'Выберите сборку'

    @scope.addModal  = { header: 'Добавление сметного продукта.',     products: [] }
    @scope.editModal = { header: 'Редактирование сметного продукта.', products: [] }

  parseEstimate: () ->
    @scope.estimate = {
      area:  parseFloat(@scope.estimate.area),
      price: parseFloat(@scope.estimate.price),
    }

  parseProducts: () ->
    products = @scope.products
    $.each(products, (i,stages) ->
      $.each(stages, (i,product) ->
        stages[i].price_with_work    = parseFloat(product.price_with_work)
        stages[i].price_without_work = parseFloat(product.price_without_work)
        stages[i].profit             = parseFloat(product.profit)

        $.each(product.sets, (i,set) ->
          $.each(set.items, (i, item) ->
            set.items[i].value.price = parseFloat(item.value.price)
          )
        )
      )
    )

  parseExpense: () ->
    @scope.expense.percent = parseFloat(@scope.expense.percent)

  parseDiscount: () ->
    discount        = @scope.discount
    discount.values = discount.values.map((x) -> parseFloat(x))

  parseStages: () ->
    self    = this
    stages  = @scope.stages
    expense = @scope.expense

    $.each(stages, (i,stage) ->
      stages[i].price       = parseFloat(stage.price)
      stages[i].total_price = parseFloat(stage.total_price)
      $.each(stage.products, (i,product) ->
        stage.products[i].price_with_work     = parseFloat(product.price_with_work)
        stage.products[i].price_without_work  = parseFloat(product.price_without_work)
        stage.products[i].profit              = parseFloat(product.profit)

        if product.with_work
          price = parseFloat(product.price_with_work)
        else
          price = parseFloat(product.price_without_work)
        stage.products[i].price = price + (price / 100 * (expense.percent + product.profit))

        $.each(product.sets, (i,set) ->
          $.each(set.items, (i,item) ->
            set.items[i].value.price = parseFloat(item.value.price)
          )
        )
      )
    )
    this.recalcStages()
