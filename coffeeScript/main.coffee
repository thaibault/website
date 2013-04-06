this.require.noConflict = true
self = this
this.require.asyncronModulePatternHandling =
    '^.+\.coffee$': (coffeeScriptCode, module) ->
        module = if module[0] then module[0] else module[1]
        self.console.log "Run coffee script module \"#{module}\"."
        try
            self.CoffeeScript.run coffeeScriptCode
        catch exception
            self.console.log self.CoffeeScript.compile coffeeScriptCode
            throw exception
this.require [['jQuery.Website', 'jquery-website-1.0.coffee']], ->
    ###
        Embedd jQuery and require full compatible to all other
        JavaScripts.
        The global scope is clean after this sequence. The given
        function is called when the dom-tree was loaded.
    ###
    # TODO self.jQuery.noConflict(true
    this.jQuery (jQuery) ->
        jQuery.Website 'logging': true
