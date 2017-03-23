PranavSourcerView = require './pranav-sourcer-view'
{CompositeDisposable} = require 'atom'

module.exports = PranavSourcer =
  pranavSourcerView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @pranavSourcerView = new PranavSourcerView(state.pranavSourcerViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @pranavSourcerView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pranav-sourcer:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pranavSourcerView.destroy()

  serialize: ->
    pranavSourcerViewState: @pranavSourcerView.serialize()

  toggle: ->
    console.log 'PranavSourcer was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
