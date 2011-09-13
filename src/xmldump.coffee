window.XMLDump = class XMLDump
  @DEFAULT_OPTIONS = {
    verbose: false
    mntp: false
  }
  
  @GUI = '''
<div id="xmldumpGUI">
  <form action="xmldump" method="get">
    <p>
      <label for="options">Options:</label>
      <input type="text" id="options" name="options" value="" placeholder="Type an ID, an XPath or an DocumentType Alias&#8230;" />
    </p>
    <p>
      <input type="checkbox" id="v" name="v" value="yes" />
      <label for="v">Verbose</label>
    </p>
  </form>
</div>'''
  
  @show = ->
    @element = document.createElement 'div'
    @element.outerHTML = @GUI
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

  
  
  

  