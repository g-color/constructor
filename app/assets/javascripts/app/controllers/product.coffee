angular.module('Constructor').controller 'ProductController', class ProductController
  @$inject: ['$scope', '$http', '$filter', 'pHelper', 'toaster']

  constructor: (@scope, @http, @filter, @pHelper, @toaster) ->
    @scope.ctrl         = @
    @scope.product      = @pHelper.get('product')
    @scope.custom       = @scope.product.custom
    @scope.compositions = @pHelper.get('compositions')
    @scope.templates    = @pHelper.get('templates')
    @scope.sets         = @pHelper.get('sets')

    this.setProductCompositions()
    this.setProductTemplates()
    this.setProductSets()

  getIndex: (id, scope) ->
    item = scope.find((x) -> x.id == id)
    scope.indexOf(item)

  validate: ->
    custom = @scope.custom
    event.preventDefault()

    validate = if custom then this.validateCustom() else this.validateRegular()

    if validate.error
      @toaster.error(validate.message)
    else
      $('form').submit()
    true

  validateRegular: ->
    compositions = @scope.compositions
    validate     = { error: false, message: null }

    if compositions.length == 0
      validate.error   = true
      validate.message = "Должно быть не менее одного примитива или объекта"
    validate

  validateCustom: ->
    templates = @scope.templates
    sets      = @scope.sets

    validate = { error: false, message: null }

    if templates.length == 0 || sets.length == 0
      validate.error   = true
      validate.message = "Должно быть не менее одной сборки"
    else
      $.each(sets, (i, set) ->
        return false if validate.error

        if set.name == ''
          validate.error   = true
          validate.message = "У одной или нескольких сборок не указано название"
        $.each(set.items, (i, item) ->
          return false if validate.error

          if item.value.id == '' || item.value.name == ''
            validate.error   = true
            validate.message = "У одной или нескольких сборок не указаны состовляющие"
        )
      )
    validate

  # Compositions Logic

  addComposition: () ->
    self         = this
    compositions = @scope.compositions
    id           = $('#autocomplete_composition_id').val()
    name         = $('#autocomplete_composition_name').val()

    if this.getIndex(id, compositions) == -1
      @http.post(@pHelper.get('url_composition_info'), id: id)
      .success (response) ->
        compositions.push({
          id:       id,
          name:     response.name,
          quantity: 0,
          unit:     response.unit
        })
        self.setProductCompositions()
        self.clearCompositionsFields()
      .error (response) ->
        debugger

  removeComposition: (id) ->
    @scope.compositions.splice(this.getIndex(id, @scope.compositions), 1)
    this.setProductCompositions()

  setProductCompositions: () ->
    compositions = JSON.stringify(@scope.compositions)
    $('#product_compositions').val(compositions)
    true

  clearCompositionsFields: () ->
    $('#product_compositions').val('')
    true

  # Templates Logic

  addTemplate: () ->
    templates = @scope.templates
    templates.push({
      id:   new Date().getTime(),
      name: $('#template_name').val()
    })
    this.clearTemplatesFields()
    this.recalcSetItems()
    this.setProductTemplates()

  editTemplate: (id) ->
    $('#edit-template-' + id).modal('show')
    true

  updateTemplate: (id) ->
    this.setProductTemplates()
    this.recalcSetItems()

  removeTemplate: (id) ->
    self = this
    @scope.templates.splice(this.getIndex(id, @scope.templates), 1)
    sets = @scope.sets
    $.each(sets, (i,set) ->
      set.items.splice(self.getIndex(id, set.items), 1)
    )
    this.setProductTemplates()
    this.setProductSets()

  setProductTemplates: () ->
    templates = JSON.stringify(@scope.templates)
    $('#product_templates').val(templates)
    true

  clearTemplatesFields: () ->
    $('#template_name').val('')
    true

  # Sets Logic

  addSet: () ->
    sets = @scope.sets
    templates = @scope.templates
    items = []
    $('.set-template-value').each (i, v) ->
      id_input = $(v).data('id-element')
      items.push({
        id:    templates[i].id,
        name:  templates[i].name,
        value: {
          name: $(v).val(),
          id:   $(id_input).val(),
        }
      })
    sets.push({
      id:     new Date().getTime(),
      name:   $('#set_name').val(),
      items:  items
    })
    this.clearSetsFields()
    this.setProductSets()

  editSet: (id) ->
    $('#edit-set-' + id).modal('show')
    true

  removeSet: (id) ->
    @scope.sets.splice(this.getIndex(id, @scope.sets), 1)
    this.setProductSets()

  clearSetsFields: () ->
    $('.set-fields').each((i, v) -> $(v).val(''))
    true

  setProductSets: () ->
    sets = JSON.stringify(@scope.sets)
    $('#product_sets').val(sets)
    true


  recalcSetItems: () ->
    sets      = @scope.sets
    templates = @scope.templates

    $.each(sets, (i,set) ->
      $.each(templates, (i,template) ->
        index = set.items.indexOf(set.items.find((x) -> x.id == template.id))
        if index == -1
          set.items.push({
            id:    template.id,
            name:  template.name,
            value: {
              id: '',
              name: ''
            },
          })
        else
          set.items[index].name = template.name
      )
    )
    this.setProductSets()
