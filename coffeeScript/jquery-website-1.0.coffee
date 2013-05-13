## require

# region header

###!
    jQuery plugin for "jquery-1.9.1".

    Copyright see require on https://github.com/thaibault/require

    Conventions see require on https://github.com/thaibault/require

    @author t.sickert@gmail.com (Torben Sickert)
    @version 1.0 stable
    @fileOverview
    This module provides common logic for the whole webpage.
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
        __googleAnalyticsCode: "
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', '{1}', 'github.io');ga('send', 'pageview');"

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
            mediaQueryCssIndicatorStyleType: 'border-left-style'
            trackingCode: 'UA-40192634-1'
            mediaQueryCssIndicator:
                desktop: 'dashed'
                tablet: 'solid'
                smartphone: 'dotted'
            domNodes:
                navigationBar: 'div.navbar-wrapper'
                navigationButtons:
                    'div.navbar-wrapper ul.nav li a, a[href="#imprint"]'
                navigationOnTopIndicatorClass: 'on-top'

                scrollToTopButtons: 'a[href="#top"]'

                carousel: 'div.carousel.slide'

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
            )._triggerWindowResizeEvents()._handleGooleAnalytics(
                this._options.trackingCode)

        # endregion

    # endregion

    # region protected methods

        # region event methods

        _onVieportMovesToTop: ->
            # Fixes overlay movement caused by the menu positioning
            # transformation.
            this._domNodes.windowLoadingCover.css 'margin-top', '-20px'
            # Switch navigation bar from fixed positioning to static smooth
            # in smartphone mode.
            this._domNodes.navigationBar.addClass(
                this._options.domNodes.navigationOnTopIndicatorClass)
            this._domNodes.scrollToTopButtons.fadeOut 'slow'
            this

        _onVieportMovesAwayFromTop: ->
            # Fixes overlay movement caused by the menu positioning
            # transformation.
            this._domNodes.windowLoadingCover.css 'margin-top', 0
            this._domNodes.navigationBar.removeClass(
                this._options.domNodes.navigationOnTopIndicatorClass)
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
                    this._options.domNodes.navigationOnTopIndicatorClass)
            this

        # endregion

        # region helper methods

        _addMediaQueryChangeEvents: ->
            this.on this._domNodes.window, 'resize', this.getMethod(
                this._triggerWindowResizeEvents)
            this

        _triggerWindowResizeEvents: ->
            jQuery.each(
                this._options.mediaQueryCssIndicator,
                (mode, cssValue) =>
                    if (this._domNodes.parent.css(this._options.mediaQueryCssIndicatorStyleType) is cssValue and
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
            this.on window, 'scroll', =>
                distanceToTop = this._domNodes.window.scrollTop()
                if distanceToTop
                    if this._vieportIsOnTop
                        this._vieportIsOnTop = false
                        this.fireEvent.apply this, [
                            'vieportMovesAwayFromTop', false, this
                        ].concat this.argumentsObjectToArray arguments
                    menuHeight = this._domNodes.navigationBar.find(
                        'div.navbar'
                    ).outerHeight()
                    if distanceToTop < menuHeight
                        this._domNodes.carousel.css(
                            'margin-top', (menuHeight - distanceToTop) + 'px')
                else if not this._vieportIsOnTop
                    this._domNodes.carousel.css(
                        'margin-top', 0)
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
                    # Fixes overlay movement caused by the menu positioning
                    # transformation.
                    this._domNodes.windowLoadingCover.css 'margin-top', 0
                    this._domNodes.windowLoadingCover.fadeOut(
                        this._options.windowLoadingCoverFadeOutOptions)
                , this._options.addtionalPageLoadingTimeInMilliseconds)
            this

        _handleStartUpEffects: (elementNumber) ->
            # Stop and delete spinner instance.
            this._domNodes.windowLoadingSpinner.spin false
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
                        this._handleStartUpEffects elementNumber + 1
                    else if window.location.href.indexOf('#') != -1
                        window.setTimeout =>
                                # All start up effects are ready. Handle direct
                                # section links.
                                this._domNodes.navigationButtons.filter(
                                    "a[href=\"#{window.location.href.substr(
                                        window.location.href.indexOf '#' )}\"]"
                                ).trigger 'click',
                            this._options.
                                startUpAnimationElementDelayInMiliseconds
                ,this._options.startUpAnimationElementDelayInMiliseconds
            this

        _addNavigationEvents: ->
            self = this._handleScrollToTopButton()
            this.on this._domNodes.navigationButtons, 'click', ->
                clickedButton = this
                self._domNodes.navigationButtons.each (index) ->
                    if clickedButton is this
                        if self._vieportIsOnTop
                            self._domNodes.carousel.carousel index
                        else
                            self._scrollToTop(->
                                self._domNodes.carousel.carousel index)
                        jQuery(this).parent('li').addClass 'active'
                    else
                        jQuery(this).parent('li').removeClass 'active'
            this

        _handleScrollToTopButton: ->
            this.on(
                this._domNodes.scrollToTopButtons, 'click', (event) =>
                    event.preventDefault()
                    this._scrollToTop())
            this._domNodes.scrollToTopButtons.hide()
            this

        _scrollToTop: (onAfter=->) ->
            distanceToTop = this._domNodes.window.scrollTop()
            menuHeight = this._domNodes.navigationBar.find(
                'div.navbar'
            ).outerHeight()
            distanceToScroll = distanceToTop + menuHeight
            if distanceToTop < menuHeight
                distanceToScroll = distanceToScroll + menuHeight -
                    distanceToTop
            jQuery.scrollTo(
                {top: "-=#{distanceToScroll}px", left: '-=0'},
                # Scroll as fast as we have distance to top.
                {duration: distanceToScroll, onAfter: onAfter})
            this

        _handleGooleAnalytics: (trackingCode) ->
            window.eval this.stringFormat(
                this.__googleAnalyticsCode, trackingCode)
            this

        # endregion

    # endregion

    ###* @ignore ###
    jQuery.Website = ->
        self = new Website
        self._controller.apply self, arguments

# endregion

## standalone ).call this, this.jQuery
)
