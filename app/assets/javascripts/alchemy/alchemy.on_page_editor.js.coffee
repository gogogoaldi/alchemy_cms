if typeof @Alchemy == 'undefined'
  @Alchemy = {}

@Alchemy.onPageEditor =

  init: =>
    self = @Alchemy.onPageEditor
    self.options = @Alchemy.onPageMode.options
    self.body = $('html')
    self.overlay = self.buildOverlay()
    self.attachEvents()

  attachEvents: =>
    self = @Alchemy.onPageEditor

    # show an overlay on mouse enter
    $('[data-alchemy-element]').on 'mouseenter', self.showOverlay

    # hide the overlay on mouse leave unless the editor is open
    self.overlay.on 'mouseleave', ->
      self.overlay.hide() if typeof self.editor == 'undefined'

    # add an element editor if the element overlay is clicked
    self.overlay.on 'click', (event) ->
      element = $(this).data('alchemy-element')
      self.elementID = element.data('alchemy-element')
      event.preventDefault()

      # removes any present editor from page before adding the new one
      self.removeEditor(-> self.addEditor(element))
      return false

    # remove the element editor if clicked outside of it
    self.body.on 'click', (event) ->
      unless event.target == self.editor[0] or self.editor.find(event.target).length == 1
        self.removeEditor()
      return false

  buildOverlay: =>
    self = @Alchemy.onPageEditor
    overlay = $('<div>', {id: 'alchemy_element_overlay'})
    overlay.css({
      left: 0,
      top: 0,
      width: 'auto',
      height: 'auto',
      display: 'none'
    })
    self.body.append(overlay)
    overlay

  showOverlay: ->
    self = _this.Alchemy.onPageEditor
    element = $(this)
    position = element.offset()
    width = element.outerWidth()
    height = element.outerHeight()
    self.overlay.data('alchemy-element', element)
    element.data('dimensions', {
      width: width,
      height: height
      position: position
    })
    self.overlay.css
      width: width,
      height: height,
      left: position.left,
      top: position.top
    .show()

  addEditor: (element) =>
    self = @Alchemy.onPageEditor
    body = self.body
    self.element = element = $(element)
    dimensions = element.data('dimensions')
    position = dimensions.position
    width = dimensions.width

    # load the element editor partial via ajax
    $.get "#{self.options.route}/admin/elements/#{self.elementID}/edit.html", (data) ->
      self.editor = editor = $('<div>', {id: 'alchemy_element_inplace_editor'})
      editor.css({
        left: position.left + width / 2,
        top: position.top,
        display: 'none'
      })
      body.append(editor.html(data))
      editor.show('fast')

      # catches the default form metho and submit it via ajax
      $('button', editor).on 'click', (event) ->
        event.preventDefault()
        self.saveElement()
        return false

  removeEditor: (callback) =>
    self = @Alchemy.onPageEditor
    if self.editor
      self.editor.hide('fast', -> $(this).remove())
    if callback
      callback()

  saveElement: () =>
    self = @Alchemy.onPageEditor
    params = $('form', self.editor).serializeArray()

    # send the serialized form data via ajax
    $.post("#{self.options.route}/admin/elements/#{self.elementID}.js", params, (response) ->
      # for now we just log the response. later on we should replace the element with the new data
      console.log(response)
    )
