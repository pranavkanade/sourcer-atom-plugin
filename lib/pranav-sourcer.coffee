'use babel'
#PranavSourcerView = require './pranav-sourcer-view'
{CompositeDisposable} = require 'atom'
request = require 'request'


module.exports = PranavSourcer =
  # pranavSourcerView: null
  # modalPanel: null
  subscriptions: null

  activate: (state) ->
  #   @pranavSourcerView = new PranavSourcerView(state.pranavSourcerViewState)
  #   @modalPanel = atom.workspace.addModalPanel(item: @pranavSourcerView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pranav-sourcer:fetch': => @fetch()

  deactivate: ->
    # @modalPanel.destroy()
    @subscriptions.dispose()
    # @pranavSourcerView.destroy()

  # serialize: ->
  #   pranavSourcerViewState: @pranavSourcerView.serialize()

  fetch: ->
    if (editor = atom.workspace.getActiveTextEditor())
      selection = editor.getSelectedText()
      @download selection


  download: (url) ->
    request url, (error, response, body) ->
      console.log body if !error and (response.statusCode == 200)
    # alternative arrow function request
    # `request(url, (error, response, body) => {
    #   if (!error && response.statusCode == 200) {
    #     console.log(body)
    #   }
    # })`
