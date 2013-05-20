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
    ['jQuery.fn.touchwipe', 'jquery-touchwipe.1.1.1'],

    ['jQuery.fn.spin', 'jquery-spin-1.2.8'],

    ['jQuery.fn.hashchange', 'jquery-observeHashChange-1.0']],
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
            vieportMovesToTop: jQuery.noop()
            vieportMovesAwayFromTop: jQuery.noop()
            changeToDesktopMode: jQuery.noop()
            changeToTabletMode: jQuery.noop()
            changeToSmartphoneMode: jQuery.noop()
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
            Determines weather the view port is on top of the page.

            @property {Boolean}
        ###
        _vieportIsOnTop: true
        ###*
            Describes the current mode defined by the css media queries.

            @property {String}
        ###
        _currentMediaQueryMode: ''

    # endregion

    # region public methods

        # region special methods

        ###*
            @description Initializes the interactive webapp.

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
            )._triggerWindowResizeEvents()._handleGoogleAnalytics(
                this._options.trackingCode)

        # endregion

    # endregion

    # region protected methods

        # region event methods

        ###*
            @description This method triggers if the vieport moves to top.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _onVieportMovesToTop: ->
            # Fixes overlay movement caused by the menu positioning
            # transformation.
            this._domNodes.windowLoadingCover.css 'margin-top', '-20px'
            # Switch navigation bar from fixed positioning to static smooth
            # in smartphone mode.
            this._domNodes.navigationBar.addClass(
                this._options.domNodes.navigationOnTopIndicatorClass)
            this._domNodes.scrollToTopButtons.animate(
                bottom: '+=30'
                opacity: 0
            ,
                duration: 'normal'
                always: =>
                    this._domNodes.scrollToTopButtons.css 'bottom', '-=30')
            this
        ###*
            @description This method triggers if the vieport moves away from
                         top.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _onVieportMovesAwayFromTop: ->
            # Fixes overlay movement caused by the menu positioning
            # transformation.
            this._domNodes.windowLoadingCover.css 'margin-top', 0
            this._domNodes.navigationBar.removeClass(
                this._options.domNodes.navigationOnTopIndicatorClass)
            this._domNodes.scrollToTopButtons.css(
                bottom: '+=30'
                display: 'block'
                opacity: 0
            ).animate(
                bottom: '-=30'
                queue: false
                opacity: 1
            ,
                duration: 'normal')
            this
        ###*
            @description This method triggers if the responsive design
                         switches to desktop mode.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _onChangeToDesktopMode: ->
            this._domNodes.dimensionIndicator.hide()
            this
        ###*
            @description This method triggers if the responsive design
                         switches to tablet mode.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _onChangeToTabletMode: ->
            this._domNodes.dimensionIndicator.fadeOut 'slow', =>
                this._domNodes.dimensionIndicator.text(
                    'tablet-mode'
                ).fadeIn 'slow'
            this
        ###*
            @description This method triggers if the responsive design
                         switches to smartphone mode.

            @returns {jQuery.Tools} Returns the current instance.
        ###
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

        ###*
            @description This method adds triggers for responsive design
                         switches.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _addMediaQueryChangeEvents: ->
            this.on this._domNodes.window, 'resize', this.getMethod(
                this._triggerWindowResizeEvents)
            this
        ###*
            @description This method triggers if the responsive design
                         switches its mode.

            @returns {jQuery.Tools} Returns the current instance.
        ###
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
        ###*
            @description This method triggers if viewport arrives at special
                         areas.

            @returns {jQuery.Tools} Returns the current instance.
        ###
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
        ###*
            @description This method triggers after window is loaded.

            @returns {jQuery.Tools} Returns the current instance.
        ###
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
        ###*
            @description This method handles the given start up effect step.

            @param {Number} elementNumber The current start up step.

            @returns {jQuery.Tools} Returns the current instance.
        ###
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
        ###*
            @description This method adds triggers to switch section.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _addNavigationEvents: ->
            this._domNodes.window.hashchange(=>
                this._switchSection window.location.hash)
            self = this._handleScrollToTopButton()._handleTouchWipe()
            this.on this._domNodes.navigationButtons, 'click', ->
                self._switchSection jQuery(this).attr 'href'
            this
        ###*
            @description Switches to given section.

            @param {String} hash Location to switch to.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _switchSection: (hash) ->
            if jQuery.inArray(hash, ['next', 'prev']) isnt -1
                this._domNodes.navigationButtons.each (index, button) =>
                    if jQuery(button).attr('href') is window.location.hash
                        # NOTE: We subtract 1 from navigation buttons length
                        # because we want to ignore the imprint section. And
                        # the index starts counting by zero.
                        numberOfButtons =
                            this._domNodes.navigationButtons.length - 1
                        if hash is 'next'
                            newIndex = (index + 1) % numberOfButtons
                        else if hash is 'prev'
                            # NOTE: Subtracting 1 in the residue class ring
                            # means adding the number of numbers minus 1. This
                            # prevents us from getting negative button indixes.
                            newIndex = (index + numberOfButtons - 1) %
                                numberOfButtons
                        hash = jQuery(
                            this._domNodes.navigationButtons[newIndex]
                        ).attr 'href'
                        false
            if hash.substr(0, 1) isnt '#'
                hash = "##{hash}"
            window.location.hash = hash
            this._domNodes.navigationButtons.each (index, button) =>
                button = jQuery button
                sectionDomNode = button.parent 'li'
                if button.attr('href') is hash
                    if not sectionDomNode.hasClass 'active'
                        this.debug "Switch to section \"#{hash}\"."
                        if this._vieportIsOnTop
                            this._domNodes.carousel.carousel index
                        else
                            this._scrollToTop(=>
                                this._domNodes.carousel.carousel index)
                        sectionDomNode.addClass 'active'
                else
                    sectionDomNode.removeClass 'active'
            this
        ###*
            @description Adds trigger to switch section on swipt gestures.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _handleTouchWipe: ->
            this._domNodes.parent.touchwipe(
                wipeLeft: => this._switchSection 'next'
                wipeRight: => this._switchSection 'prev'
                preventDefaultEvents: false)
            this
        ###*
            @description Adds trigger to scroll top buttons.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _handleScrollToTopButton: ->
            this.on(
                this._domNodes.scrollToTopButtons, 'click', (event) =>
                    event.preventDefault()
                    this._scrollToTop())
            this._domNodes.scrollToTopButtons.hide()
            this
        ###*
            @description Scrolls to top of page. Runs the given function
                         after viewport arrives.

            @param {Function} onAfter Callback to call after effect has
                                      finished.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _scrollToTop: (onAfter=jQuery.noop()) ->
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
        ###*
            @description Scrolls to top of page. Runs the given function
                         after vieport arrives.

            @param {String} trackingCode Google's javaScript embedding code
                                         snippet.

            @returns {jQuery.Tools} Returns the current instance.
        ###
        _handleGoogleAnalytics: (trackingCode) ->
            window.eval this.stringFormat(
                this.__googleAnalyticsCode, trackingCode)
            this

        # endregion

    # endregion

    # region handle jQuery extending

    ###* @ignore ###
    jQuery.Website = ->
        self = new Website
        self._controller.apply self, arguments

    # endregion

# endregion

## standalone ).call this, this.jQuery
)
