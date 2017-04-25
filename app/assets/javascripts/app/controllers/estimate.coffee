angular.module('Constructor').controller 'EstimateController', class EstimateController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl   = @
    @scope.estimate = @pHelper.get('estimate')
    @scope.stages = [
      {
        number: 1,
        text: {
          name:     'Первый этап',
          summ:     'Итого по первому этапу:',
          summ_dis: 'по первому этапу',
          discount: 'Итого по первому этапу со скидкой:'
        },
        products: [],
        price: 0,
        total_price: 0,
      },
      {
        number: 2,
        text: {
          name:     'Второй этап',
          summ:     'Итого по двум этапам:',
          summ_dis: 'по второму этапу',
          discount: 'Итого по первому этапу со скидкой:'
        },
        products: [],
        price: 0,
        total_price: 0,
      },
      {
        number: 3,
        text: {
          name:     'Третий этап',
          summ:     'Итого по трем этапам:',
          summ_dis: 'по третьему этапу',
          discount: 'Итого по первому этапу со скидкой:'
        },
        products: [],
        price: 0,
        total_price: 0,
      }
    ]

    discount        = @pHelper.get('discount')
    discount.values = discount.values.map((x) -> parseFloat(x))

    @scope.discount = discount
    @scope.products = @pHelper.get('products')

    @scope.currentStage          = null
    @scope.selectedProduct       = null
    @scope.selectedProductId     = 'Выберите сметный продукт'
    @scope.selectedProductUnit   = null
    @scope.selectedProductCustom = false
    @scope.selectedSet           = null
    @scope.selectedSetId         = 'Выберите сборку'

    @scope.selectedEditProduct       = null
    @scope.selectedEditProductId     = null
    @scope.selectedEditProductCustom = false
    @scope.selectedEditSet           = null
    @scope.selectedEditSetId         = 'Выберите сборку'

    @scope.addModal = {
      header: 'Добавление сметного продукта.'
      products: []
    }
    @scope.editModal = {
      header: 'Редактирование сметного продукта.'
      products: []
    }

    true

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
      product.sets[i].selected = v.id == parseInt(set_id)
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
      product.price = 0
      set_id = @scope.selectedSetId
      set = product.sets.find((x) -> x.id == parseInt(set_id))
      $.each($('.template-quantity'), (i, v) ->
        set.selected   = true
        set.items[i]   = Object.assign(set.items[i], {quantity: $(v).val()})
        product.price += set.items[i].value.price * $(v).val()
      )
      product = Object.assign(product, {quantity: 1})
    else
      product = Object.assign(product, {quantity: quantity})

    stage.products.push(product)

    this.recalcStage(stage_number)
    this.recalEstimate()

    $('#product-quantity').val(null)
    $('#add-product').modal('hide')
    true

  deleteProduct: (stage, id) ->
    product = stage.products.find((x) -> x.id == id)
    index = stage.products.indexOf(product)
    stage.products.splice(index, 1)
    this.recalcStage(stage.number)
    this.recalEstimate()

  getPrice: () ->
    estimate = @scope.estimate
    if estimate.price == 0 || estimate.area == 0
      0
    else
      (estimate.price / estimate.area).toFixed(2)

  getStageTotalPrice: (stage_number) ->
    estimate = @scope.estimate
    stage    = this.getStage(stage_number)
    if stage.total_price == 0 || estimate.area == 0
      0
    else
      (stage.total_price / estimate.area).toFixed(2)

  getStagePrice: (stage_number) ->
    estimate = @scope.estimate
    stage    = this.getStage(stage_number)
    if stage.price == 0 || estimate.area == 0
      0
    else
      (stage.price / estimate.area).toFixed(2)

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

  getStage: (number) ->
    @scope.stages.find((x) -> x.number == number)

  recalEstimate: () ->
    estimate = @scope.estimate
    stages   = @scope.stages

    $('#estimate_json_stages').val(JSON.stringify(stages))

    estimate.price = 0
    $.each(stages, (i,v) -> estimate.price += v.total_price)

  getProductFromStage: (product_id) ->
    stages = @scope.stages
    product = undefined
    $.each(stages, (i,v) ->
      if product == undefined
        product = v.products.find((x) -> x.id == product_id)
    )
    product

  recalcProduct: () ->
    stage = @scope.currentStage
    product = @scope.selectedEditProduct
    product.price = 0
    $.each(product.sets, (i,v) ->
      if v.selected
        $.each(v.items, (y,x) ->
          product.price += x.quantity * x.value.price
        )
    )
    this.recalcStage(stage)
    this.recalEstimate()
