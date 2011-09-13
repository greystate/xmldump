window.XMLDump = class XMLDump
  @DEFAULT_OPTIONS = {
    verbose: false
    mntp: false
  }
  
  @GUI = '''
<div id="xmldumpGUI">
  
</div>
'''
  
  @show = ->
    @element = document.createElement 'div'
    document.body.appendChild @element
    
  
  
  @getResult = (options) ->
    # options = options?.merge(@DEFAULT_OPTIONS)
    
    document.location = ("?" + "#{key}=#{value}" for key, value of options)
  
  @nodeById = (nodeId) ->
    @getResult { id: nodeId }
  
  @nodesByType = (name) ->
    @getResult { type: name }
  
  @nodesByXPath = (expression) ->
    @getResult { xpath: expression }
  
  @nodesWithProperty = (propertyName) ->
    @getResult { prop: propertyName }

  @mediaById = (mediaId) ->
    @getResult { media: mediaId }
    
  @searchFor = (query) ->
    @getResult { search: query }
    
  @showSitemap = ->
    @getResult { sitemap: true }

  @showHiddenNodes = ->
    @getResult { hidden: true }

  
  
  

  