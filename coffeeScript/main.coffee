## require

# region vim modline

# vim: set tabstop=4 shiftwidth=4 expandtab:
# vim: foldmethod=marker foldmarker=region,endregion:

# endregion

## standalone
## this.jQuery.noConflict(true) (jQuery) ->
##     jQuery.HomePage window.OPTIONS
this.require.noConflict = true
this.require.asyncronModulePatternHandling =
    '^.+\.coffee$': (coffeeScriptCode, module) =>
        module = if module[0] then module[0] else module[1]
        this.console.log "Run coffee script module \"#{module}\"."
        try
            this.CoffeeScript.run coffeeScriptCode
        catch exception
            this.console.log this.CoffeeScript.compile coffeeScriptCode
            throw exception
this.require [['jQuery.HomePage', 'jquery-homePage-1.0.coffee']], (jQuery) ->
    ###
        Embedd jQuery and require full compatible to all other
        JavaScripts.
        The global scope is clean after this sequence. The given
        function is called when the dom-tree was loaded.
    ###
    # Production mode:
    # jQuery.noConflict(true) (jQuery) -> jQuery.HomePage window.OPTIONS
    jQuery (jQuery) -> jQuery.HomePage window.OPTIONS
##
