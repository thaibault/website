## require

# region header

###!
    jQuery plugin for "jquery-1.9.1".

    Copyright see require on https://github.com/thaibault/require

    Conventions see require on https://github.com/thaibault/require

    @author t.sickert@gmail.com (Torben Sickert)
    @version 1.0 stable
    @requires require-1.0+
              jquery-1.9.1+
              jquery-tools-1.0+
              bootstrap-2.3.1+
    @fileOverview
    This module provides common resuable logic for every jquery non trivial
    plugin.
###

###*
    @name jQuery
    @see www.jquery.com
###
## standalone
## ((jQuery) ->
this.window.require([
    ['less', 'less-1.3.3'],

    ['jQuery.Tools', 'jquery-tools-1.0.coffee'],

    ['jQuery.fn.carousel', 'bootstrap-2.3.1'],

    ['jQuery.scrollTo', 'jquery-scrollTo-1.4.3.1'],
    ['jQuery.fn.waypoint', 'jquery-waypoints-2.0.2'],
    ['jQuery.fn.spin', 'jquery-spin-1.2.8']],
(less, jQuery) ->
##

# endregion

# region plugins

    ###*
        @memberOf jQuery
        @class
    ###
    class Website extends jQuery.Tools.class

    # region private properties

        __name__: 'Website'

    # endregion

    # region protected properties 

        ###*
            Saves default options for manipulating the default behaviour.

            @property {Object}
        ###
        _options:
            logging: false
            domNodeSelectorPrefix: 'body.website'
            addtionalPageLoadingTimeInMilliseconds: 0
            mediaQueryCssIndicator:
                desktop: '0px dashed rgb(0, 0, 0)'
                tablet: '0px solid rgb(0, 0, 0)'
                smartphone: '0px dotted rgb(0, 0, 0)'
            domNodes:
                navigationBarOnTopIndicatorClass: 'on-top'
                carousel: 'div.carousel.slide'
                navigationBar: 'div.navbar-wrapper'
                navigationButtons: 'div.navbar-wrapper ul.nav li a'
                scrollToTopButtons: 'a[href="#top"]'
                startUpAnimationClassPrefix: '.start-up-animation-number-'
                windowLoadingCover: 'div.window-loading-cover'
                windowLoadingSpinner: 'div.window-loading-cover div'
                dimensionIndicator:
                    'div.navbar-wrapper div.dimension-indicator'
            startUpFadeInOptions:
                easing: 'swing'
                duration: 'slow'
            windowLoadingCoverFadeOutOptions:
                easing: 'swing'
                duration: 'slow'
            startUpAnimationElementDelayInMiliseconds: 100
            carouselOptions:
                interval: false
                pause: 'hover'
            windowLoadingSpinnerOptions:
                lines: 9 # The number of lines to draw
                length: 23 # The length of each line
                width: 11 # The line thickness
                radius: 40 # The radius of the inner circle
                corners: 1 # Corner roundness (0..1)
                rotate: 75 # The rotation offset
                color: '#000' # #rgb or #rrggbb
                speed: 1.1 # Rounds per second
                trail: 58 # Afterglow percentage
                shadow: false # Whether to render a shadow
                hwaccel: false # Whether to use hardware acceleration
                className: 'spinner' # CSS class to assign to the spinner
                zIndex: 2e9 # The z-index (defaults to 2000000000)
                top: 'auto' # Top position relative to parent in px
                left: 'auto' # Left position relative to parent in px
        ###*
            Holds all needed dom nodes.

            @property {Object}
        ###
        _domNodes: {}
        ###*
            Determines weather the vieport is on top of the page.

            @property {Boolean}
        ###
        _vieportIsOnTop: true
        ###*
            Describes the current mode defined by the css media querys.

            @property {String}
        ###
        _currentMediaQueryMode: ''

    # endregion

    # region public methods

        # region special methods

        ###*
            @description Initializes the interactive web app.

            @param {Object} options An options object.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        initialize: (options) ->
            super options
            this._domNodes = this.grapDomNodes this._options.domNodes
            this._options.windowLoadingCoverFadeOutOptions.always =
                this.getMethod this._handleStartUpEffects
            this._domNodes.windowLoadingSpinner.spin(
                this._options.windowLoadingSpinnerOptions)
            this._bindScrollEvents()._domNodes.parent.show()
            this._domNodes.window.ready this.getMethod(
                this._removeLoadingCover)
            this._domNodes.carousel.carousel this._options.carouselOptions
            this._addNavigationEvents()._addMediaQueryChangeEvents(
            )._triggerWindowResizeEvents()
            # TODO
            this#._handleGooleAnalytics()

        # endregion

    # endregion

    # region protected methods

        # region event methods

        _onVieportMovesToTop: ->
            this._domNodes.navigationBar.addClass(
                this._options.domNodes.navigationBarOnTopIndicatorClass)
            this._domNodes.scrollToTopButtons.fadeOut 'slow'
            this

        _onVieportMovesAwayFromTop: ->
            this._domNodes.navigationBar.removeClass(
                this._options.domNodes.navigationBarOnTopIndicatorClass)
            this._domNodes.scrollToTopButtons.fadeIn 'slow'
            this

        _onChangeToDesktopMode: ->
            this._domNodes.dimensionIndicator.hide()
            this

        _onChangeToTabletMode: ->
            this._domNodes.dimensionIndicator.fadeOut 'slow', =>
                this._domNodes.dimensionIndicator.text(
                    'tablet-mode'
                ).fadeIn 'slow'
            this

        _onChangeToSmartphoneMode: ->
            this._domNodes.dimensionIndicator.fadeOut 'slow', =>
                this._domNodes.dimensionIndicator.text(
                    'smartphone-mode'
                ).fadeIn 'slow'
            if this._vieportIsOnTop
                this._domNodes.navigationBar.addClass(
                    this._options.domNodes.navigationBarOnTopIndicatorClass)
            this

        # endregion

        _addMediaQueryChangeEvents: ->
            this.bind this._domNodes.window, 'resize', this.getMethod(
                this._triggerWindowResizeEvents)
            this

        _triggerWindowResizeEvents: ->
            jQuery.each(
                this._options.mediaQueryCssIndicator,
                (mode, cssValue) =>
                    if (this._domNodes.parent.css('border') is cssValue and
                        mode isnt this._currentMediaQueryMode
                    )
                        this._currentMediaQueryMode = mode
                        this.fireEvent.apply(
                            this, [
                                this.stringFormat('changeTo{1}Mode',
                                mode.substr(0, 1).toUpperCase() +
                                    mode.substr 1),
                                false, this
                            ].concat this.argumentsObjectToArray arguments))
            this

        _bindScrollEvents: ->
            this.bind window, 'scroll', =>
                if this._domNodes.parent.scrollTop()
                    if this._vieportIsOnTop
                        this._vieportIsOnTop = false
                        this.fireEvent.apply this, [
                            'vieportMovesAwayFromTop', false, this
                        ].concat this.argumentsObjectToArray arguments
                else if not this._vieportIsOnTop
                    this._vieportIsOnTop = true
                    this.fireEvent.apply this, [
                        'vieportMovesToTop', false, this
                    ].concat this.argumentsObjectToArray arguments
            this

        _removeLoadingCover: ->
            window.setTimeout(
                =>
                    ###
                        Hide startup animation dom nodes to show them step
                        by step.
                    ###
                    jQuery(
                        '[class^="' +
                        this.sliceDomNodeSelectorPrefix(
                            this._options.domNodes
                                .startUpAnimationClassPrefix
                        ).substr(1) + '"]'
                    ).hide()
                    this._domNodes.windowLoadingCover.fadeOut(
                        this._options.windowLoadingCoverFadeOutOptions)
                , this._options.addtionalPageLoadingTimeInMilliseconds)
            this

        _handleStartUpEffects: (elementNumber) ->
            if not jQuery.isNumeric elementNumber
                elementNumber = 1
            window.setTimeout =>
                    jQuery(
                        this._options.domNodes.startUpAnimationClassPrefix +
                        elementNumber
                    ).fadeIn this._options.startUpFadeInOptions
                    if (jQuery(
                            this._options.domNodes.startUpAnimationClassPrefix +
                            (elementNumber + 1)).length)
                        this._handleStartUpEffects elementNumber + 1,
                this._options.startUpAnimationElementDelayInMiliseconds
            this

        _addNavigationEvents: ->
            self = this._handleScrollToTopButton()
            this.bind this._domNodes.navigationButtons, 'click', ->
                clickedButton = this
                self._domNodes.navigationButtons.each (index) ->
                    if clickedButton is this
                        if self._vieportIsOnTop
                            self._domNodes.carousel.carousel index
                        else
                            jQuery.scrollTo(
                                self._domNodes.parent,
                                    ###
                                        Scroll as long as we have distance to
                                        top.
                                    ###
                                    duration:
                                        self._domNodes.parent.scrollTop()
                                    onAfter: ->
                                        self._domNodes.carousel.carousel index)
                        jQuery(this).parent('li').addClass 'active'
                    else
                        jQuery(this).parent('li').removeClass 'active'
            this

        _handleScrollToTopButton: ->
            this.bind(
                this._domNodes.scrollToTopButtons, 'click', (event) =>
                    event.preventDefault()
                    # Scroll as long as we have distance to top.
                    jQuery.scrollTo(
                        this._domNodes.parent,
                        this._domNodes.parent.scrollTop()))
            this._domNodes.scrollToTopButtons.hide()
            this

        _handleGooleAnalytics: ->
            # TODO check if "_gaq" has to be global.
            _gaq = [['_setAccount', 'UA-XXXXX-X'], ['_trackPageview']]
            jQuery('script')[0].parent().before jQuery('<script>').attr(
                'src', (
                    if 'https:' is location.protocol then '//ssl' else '//www'
                ) + '.google-analytics.com/ga.js')
            this

    # endregion

    ###* @ignore ###
    jQuery.Website = ->
        self = new Website
        self._controller.apply self, arguments

# endregion

## standalone ).call this, this.jQuery
)
