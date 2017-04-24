angular.module('Constructor').controller 'EstimateController', class EstimateController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl   = @
    @scope.area   = 0
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
      }
    ]
    @scope.discount = {
      name:         null,
      first_stage:  0,
      second_stage: 0,
      third_stage:  0
    }
    @scope.products = @pHelper.get('products')

    @scope.currentStage = null
    @scope.selectedProduct = null
    @scope.selectedProductId = 'Выберите сметный продукт'
    @scope.selectedProductUnit = null
    @scope.selectedProductCustom = false
    @scope.selectedSet = null
    @scope.selectedSetId = 'Выберите сборку'

    @scope.addModal = {
      header: 'Добавление сметного продукта.'
      products: []
    }

  getDiscount: (number) ->
    switch number
      when 1 then '-' + @scope.discount.first_stage
      when 2 then '-' + @scope.discount.second_stage
      when 3 then '-' + @scope.discount.third_stage

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

  addProduct: () ->
    stage_number = @scope.currentStage
    product = @scope.selectedProduct
    quantity = $('#product-quantity').val()

    stage = @scope.stages.find((x) -> x.number == stage_number)
    stage.products.push(Object.assign(product, {quantity: quantity}))
    stage.price += product.price * quantity
    $('#product-quantity').val(null)
    $('#add-product').modal('hide')
    true

  deleteProduct: (stage, id) ->
    product = stage.products.find((x) -> x.id == id)
    index = stage.products.indexOf(product)
    stage.products.splice(index, 1)
