window.require.noConflict = true
this.require.asyncronModulePatternHandling =
    '^.+\.coffee$': (coffeeScriptCode, module) ->
        window.console.log "Run module \"#{module[0]}\"."
        try
            window.CoffeeScript.run coffeeScriptCode
        catch exception
            window.console.log window.CoffeeScript.compile coffeeScriptCode
            throw exception
this.require [['jQuery.Website', 'jquery-website-1.0.coffee']], ->
    ###
        Embedd jQuery and require full compatible to all other
        JavaScripts.
        The global scope is clean after this sequence. The given
        function is called when the dom-tree was loaded.
    ###
    ###window.jQuery.noConflict(true)###
    this.jQuery (jQuery) ->
        jQuery.Website 'logging': true
