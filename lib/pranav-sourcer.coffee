'use babel'
#PranavSourcerView = require './pranav-sourcer-view'
{CompositeDisposable} = require 'atom'
request = require 'request'
cheerio = require 'cheerio'
google = require 'google'
google.resultsPerPage = 1

module.exports = PranavSourcer =
  # pranavSourcerView: null
  # modalPanel: null
  subscriptions: null

  activate: (state) ->
  #   @pranavSourcerView = new PranavSourcerView(state.pranavSourcerViewState)
  #   @modalPanel = atom.workspace.addModalPanel(item: @pranavSourcerView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # require("request").install("pranav-sourcer")
    # require("cheerio").install("pranav-sourcer")
    # require("google").install("pranav-sourcer")
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pranav-sourcer:fetch': => @fetch()

  deactivate: ->
    # @modalPanel.destroy()
    @subscriptions.dispose()
    # @pranavSourcerView.destroy()

  # serialize: ->
  #   pranavSourcerViewState: @pranavSourcerView.serialize()

  fetch: ->
    # self has to be defined as the global context cannot be passed to the callback functions.
    self = this
    if (editor = atom.workspace.getActiveTextEditor())
      query = editor.getSelectedText()
      language = editor.getGrammar().name
      self.search(query, language).then((url) ->
        atom.notifications.addSuccess('Found Google Results ..!!')
        editor.insertText(url)
        return self.download(url)).then((html) ->
          answer = self.scrape(html)
          if answer == ''
            atom.notifications.addWarning('No answer Found :(')
          else
            atom.notifications.addSuccess('Found snippet!')
            editor.insertText(answer)
          ).catch((error) ->
            console.log error
            atom.notifications.addWarning(error.reason))

  search: (query, language) ->
    new Promise((resolve, reject) ->
      searchString = "#{query} in #{language} site:stackoverflow.com"
      console.log searchString
      google(searchString, (err, res) ->
        if err
          reject({reason : 'A search error has occured :('})
        else if res.links.lenght == 0
          reject({reason : 'No results found :('})
        else
          resolve(res.links[0].href)))

  scrape:(html) ->
    $ = cheerio.load(html)
    $('div.accepted-answer pre code').text()

  download: (url) ->
    # added a promise object so that we can fetch the responce asynchronously
    new Promise (resolve, reject) ->
      request url, (error, response, body) ->
        if !error and response.statusCode == 200
          resolve body
        else
          reject {reason: 'Unable to download page'}
