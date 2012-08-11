# Inits the On Page Mode from Alchemy
# The On Page Mode is the mode in which the logged in user has a menu bar and the element inplace editor

if typeof @Alchemy == 'undefined'
  @Alchemy = {}

@Alchemy.onPageMode =

  init: (options) =>
    @Alchemy.onPageMode.options = options

    load = =>
      @Alchemy.Menubar.show()
      @Alchemy.onPageEditor.init()

    if typeof(jQuery) == 'undefined'
      @Alchemy.loadjQuery(load)
    else
      load()
