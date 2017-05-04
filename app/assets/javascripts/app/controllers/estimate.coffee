angular.module('Constructor').controller 'EstimateController', class EstimateController
  @$inject: ['$scope', '$http', '$filter', 'pHelper', 'toaster']

  constructor: (@scope, @http, @filter, @pHelper, @toaster) ->
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
    for i in [1..3]
      this.recalcStage(i)
    this.saveJsonValue()

  showAddModal: (stage) ->
    @scope.addModal.header       = 'Добавление сметного продукта. Этап ' + stage
    @scope.addModal.products     = this.getProducts(stage)
    @scope.selectedProduct       = null
    @scope.selectedProductId     = 'Выберите сметный продукт'
    @scope.selectedProductCustom = false
    @scope.selectedSetId         = 'Выберите сборку'
    @scope.selectedSet           = null
    @scope.currentStage          = stage

    $('#productHint').collapse('hide')
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

    $('#productEditHint').collapse('hide')
    $('#edit-product').modal('show')
    true

  addProduct: () ->
    estimate     = @scope.estimate
    discount     = @scope.discount
    stage_number = @scope.currentStage
    product      = @scope.selectedProduct
    quantity     = $('#product-quantity').val()
    error        = false
    message      = 'Необходимо выбрать сметный продукт'

    stage = this.getStage(stage_number)
    if product.custom

      product.price_with_work    = 0
      product.price_without_work = 0

      set_id = @scope.selectedSetId
      if set_id == "Выберите сборку"
        error = true
        message = 'Необходимо выбрать сборку сметного продукта'

      set = product.sets.find((x) -> x.id == parseInt(set_id))
      $.each($('.template-quantity'), (i, v) ->
        quantity     = $(v).val()
        set.selected = true
        set.items[i] = Object.assign(set.items[i], {quantity: $(v).val()})

        if $(v).val() == '' && error == false
          error = true
          message = 'Необходимо указать количество для всех составляющих сметного продукта'

        product.price_with_work += set.items[i].value.price * $(v).val()
        unless set.items[i].value.work_primitive
          product.price_without_work += set.items[i].value.price * $(v).val()
      )
      product = Object.assign(product, {quantity: 1, with_work: true})
    else
      if quantity == ''
        error   = true
        message = 'Необходимо указать количество сметного продукта'

      product = Object.assign(product, {quantity: quantity, with_work: true})

    unless error
      this.recalcProductPrice(stage, product)
      stage.products.push(product)

      this.recalcStage(stage.number)

      $('#product-quantity').val(null)
      $('#add-product').modal('hide')
      true
    else
      @toaster.error(message)

  deleteProduct: (stage, id) ->
    product = stage.products.find((x) -> x.id == parseInt(id))
    index = stage.products.indexOf(product)
    stage.products.splice(index, 1)
    this.recalcStage(stage.number)

  updateTemplateValue: (template) ->
    product = @scope.selectedProduct
    product = @scope.selectedEditProduct if product == null
    angular.forEach product.sets, (set,k) ->
      angular.forEach set.items, (item, k) ->
        item.quantity = template.quantity if item.id == template.id

    @toaster.error('Необходимо указать количество составляющих для сметного продукта') if template.quantity == ''

  # Basic logic

  getProducts: (stage) ->
    @scope.products[stage - 1]

  getProduct: (id) ->
    products = @scope.products
    product  = undefined
    $.each products, (i,v) ->
      if product == undefined
        product = v.find((x) -> x.id == parseInt(id))
    product

  getSet: (id, sets) ->
    set = undefined
    if set == undefined
      set = sets.find((x) -> x.id == parseInt(id))
    set

  getPriceByArea: (price) ->
    estimate = @scope.estimate
    return 0 if price == 0 || estimate.area == 0
    (price / estimate.area).toFixed(2)

  getStagePrice: (stage) ->
    price = 0
    for i in [1..stage.number]
      price += this.getStage(i).price
    price.toFixed(2)

  getStageDiscountPrice: (stage) ->
    price = 0
    for i in [1..stage.number]
      price += this.getStage(i).price_with_discount
    price.toFixed(2)

  getDiscountValue: (stage) ->
    discount = @scope.discount
    estimate = @scope.estimate
    (stage.price * discount.values[stage.number - 1] / 100).toFixed(2)

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

  setSelectedProduct: () ->
    product_id = @scope.selectedProductId
    if product_id != 'Выберите сметный продукт'
      product = this.getProduct(product_id)
      @scope.selectedProduct = product
      @scope.selectedProductCustom = product.custom
    else
      $('#productHint').collapse('hide')
      @scope.selectedProduct = null

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

  # Recalc logic

  recalcStage: (number) ->
    product = @scope.selectedEditProduct
    @toaster.error('Необходимо указать количество сметного продукта') if product != null && product.quantity == ''

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
    stage.price_with_discount = stage.price - (stage.price * discount / 100)

    this.recalEstimate()

  recalEstimate: () ->
    estimate = @scope.estimate
    stages   = @scope.stages
    estimate.price = 0
    $.each(stages, (i,v) -> estimate.price += v.price_with_discount)
    this.saveJsonValue()

  recalcProduct: (template) ->
    this.updateTemplateValue(template) unless template == undefined

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

  recalcProductPrice: (stage, product) ->
    if product.with_work
      price = product.price_with_work
    else
      price = product.price_without_work
    product.price = price + (price / 100 * (@scope.expense.percent + product.profit))
    this.recalcStage(stage.number)

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
      stages[i].price               = parseFloat(stage.price)
      stages[i].price_with_discount = parseFloat(stage.price_with_discount)
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
