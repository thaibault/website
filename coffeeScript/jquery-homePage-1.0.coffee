#!/usr/bin/env require

# region vim modline

# vim: set tabstop=4 shiftwidth=4 expandtab:
# vim: foldmethod=marker foldmarker=region,endregion:

# endregion

# region header

###!
    Copyright see require on https://github.com/thaibault/require

    Conventions see require on https://github.com/thaibault/require

    @author t.sickert@gmail.com (Torben Sickert)
    @version 1.0 stable
    @fileOverview
    This module provides common logic for the whole web page.
###

## standalone
## do ($=this.jQuery) ->
this.require([
    ['jQuery.Website', 'jquery-website-1.0.coffee']

    ['jQuery.fn.collapse', 'bootstrap-3.0.0']
    ['jQuery.fn.Swipe', 'jquery-swipe-2.0']],
($) ->
##

# endregion

# region plugins

    ###*
        @memberOf $
        @class
    ###
    class HomePage extends $.Website.class

    # region properties

        ###*
            Saves default options for manipulating the default behaviour.

            @property {Object}
        ###
        _options:
            trackingCode: 'UA-40192634-1'
            scrollInLinearTime: true
            dimensionIndicatorTemplate: '({1})'
            viewportIsOnTopIndicatorClassName: 'on-top'
            navigationIsCollapsedClassName: 'navigation-is-collapsed'
            domNodes:
                # TODO make nodes more tree like
                navigationBarWrapper: 'div.navbar-wrapper'
                navigationBar: 'div.navbar-collapse'
                logoLink: 'a.navbar-brand'
                carousel: 'div.carousel.slide'
                section: 'div.item'
                transformIfViewportIsOnTop:
                    'div.navbar-wrapper, div.carousel.slide'
                topDomNode: 'div.navbar-wrapper'
                navigationButton: 'div.navbar-wrapper ul.nav li a'
                aboutThisWebsiteButton: 'a[href="#about-this-website"]'
                aboutThisWebsiteSection: 'div.about-this-website'
                dimensionIndicator: '.dimension-indicator'
                footer: 'div.footer'
            carouselOptions:
                startSlide: 0
                speed: 1000
                auto: 0
                continuous: false
                disableScroll: false
                stopPropagation: false
            language:
                onSwitched: (oldLanguage, newLanguage) ->
                    # Add language toggle button functionality.
                    $("a[href=\"#lang-#{newLanguage}\"]").fadeOut('fast', ->
                        $(this).attr('href', "#lang-#{oldLanguage}").text(
                            oldLanguage.substr 0, 2
                        ).fadeIn 'fast'
                    )
        ###*
            Indicates if smartphone navigation is open or closed.

            @property {Boolean}
        ###
        _navigationIsCollapsed: true
        ###*
            Saves the current scrollable spaces between current viewport and
            top of document.

            @property {Number}
        ###
        _distanceToTopInPixel: 0
        ###*
            Saves the height from navigation bar in collapsed state to handle
            correct transitions.

            @property {Number}
        ###
        _collapsedNavigationHeightInPixel: 0
        ###*
            Saves the height from navigation bar in expanded state to handle
            correct transitions.

            @property {Number}
        ###
        _expandedNavigationHeightInPixel: 0
        ###*
            Saves the main content background color to attach a border with
            same color for compensating with right colored margin.

            @property {String}
        ###
        _sectionBackgroundColor: 'white'
        ###*
            Saves the class name for introspection.

            @property {String}
        ###
        __name__: 'HomePage'

    # endregion

    # region public methods

        # region special

        ###*
            @description Initializes the interactive web application.

            @param {Object} options An options object.

            @returns {$.HomePage} Returns the current instance.
        ###
        initialize: (options) ->
            super options
            if not window.location.hash
                window.location.hash = this._domNodes.navigationButton.parent(
                    'li'
                ).filter('.active').children(
                    this._domNodes.navigationButton
                ).attr 'href'
            # Handle "about-this-website" and main section switch.
            this.on this._domNodes.aboutThisWebsiteButton, 'click', =>
                # TODO
                if not this._navigationIsCollapsed
                    this._domNodes.navigationBar.collapse 'hide'
                this._domNodes.footer.css position: 'absolute', 'top': '500px'
                this._domNodes.aboutThisWebsiteSection.fadeIn 'normal', =>
                    this._domNodes.section.hide()
            this.on this._domNodes.navigationButton.add(
                this._domNodes.logoLink
            ), 'click', =>
                this._domNodes.section.show()
                this._domNodes.footer.removeAttr 'style'
                this._domNodes.aboutThisWebsiteSection.fadeOut()
            this._initializeSwipe()
            # We have to manipulate the content behavior depending on
            # smartphone navigation bar state.
            this._handleCollapsingNavigationBarCompensations()
            # TODO describe.
            # TODO wenn sodann wird initial kein border gesetzt.
            this._handleBeforeExpandNavigationBarCompensation()
            this._handleAfterExpandNavigationBarCompensation()
            this._handleBeforeCollapseNavigationBarCompensation()
            this._handleAfterCollapseNavigationBarCompensation()

        # endregion

    # endregion

    # region protected methods

        # region event

        ###*
            @description This method triggers if the viewport moves to top.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onViewportMovesToTop: ->
            if this._currentMediaQueryMode is 'smartphone'
                # Move main content up for the height of navigation bar to make
                # a smooth transition between relative and fixed positioning of
                # the navigation bar. A negative margin with relative
                # positioning corresponds to no margin with fixed positioning.
                this._domNodes.carousel.css(
                    'margin-top': "-#{this._expandedNavigationHeightInPixel}px"
                    'border-top':
                        "#{this._expandedNavigationHeightInPixel -
                        this._collapsedNavigationHeightInPixel}px solid " +
                        this._sectionBackgroundColor)
            # Switch navigation bar from fixed positioning to static smooth in
            # smart phone mode.
            this._domNodes.transformIfViewportIsOnTop.addClass(
                this._options.viewportIsOnTopIndicatorClassName)
            super()
        ###*
            @description This method triggers if the viewport moves away from
                         top.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onViewportMovesAwayFromTop: ->
            if this._currentMediaQueryMode is 'smartphone'
                # Remove the navigation height space if we switch to fixed
                # navigation positioning.
                if this._navigationIsCollapsed
                    this._domNodes.carousel.css(
                        'margin-top': 0, 'border-top': 0)
                else
                    this._domNodes.carousel.css(
                        'margin-top': 0
                        'border-top':
                            "#{this._expandedNavigationHeightInPixel -
                            this._collapsedNavigationHeightInPixel}px solid " +
                            this._sectionBackgroundColor)
            this._domNodes.transformIfViewportIsOnTop.removeClass(
                this._options.viewportIsOnTopIndicatorClassName)
            super()
        ###*
            @description This method triggers if the responsive design switches
                         to desktop mode.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onChangeMediaQueryMode: (oldMode, newMode) ->
            this._domNodes.carousel.removeAttr 'style'
            this._domNodes.dimensionIndicator.fadeOut 'slow', =>
                this._domNodes.dimensionIndicator.text(
                    this.stringFormat(
                        this._options.dimensionIndicatorTemplate,
                        "#{newMode}-mode")
                ).fadeIn 'slow'
            super()
        ###*
            @description This method triggers if the responsive design switches
                         to smart phone mode.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onChangeToSmartphoneMode: ->
            if this._viewportIsOnTop
                this._domNodes.transformIfViewportIsOnTop.addClass(
                    this._options.viewportIsOnTopIndicatorClassName)
            super()
        ###*
            @description Switches to given section.

            @param {String} hash Location to switch to.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onSwitchSection: (hash) ->
            direction = false
            if $.inArray(hash, ['next', 'prev']) isnt -1
                direction = hash
                hash = this._determineRelativeSections hash
            if hash.substr(0, 1) isnt '#'
                hash = "##{hash}"
            switched = false
            this._domNodes.navigationButton.each (index, button) =>
                button = $ button
                sectionButtonDomNode = button.parent 'li'
                if not sectionButtonDomNode.length
                    sectionButtonDomNode = button
                if button.attr('href') is hash or (
                    index is 0 and hash is '#' and hash = button.attr 'href'
                )
                    if not sectionButtonDomNode.hasClass 'active'
                        this.debug "Switch to section \"#{hash}\"."
                        window.location.hash = hash
                        this._adaptContentHeight()
                        switched = true
                        # Swipe in endless cycle if we get a direction.
                        if direction
                            index = direction
                        if this._viewportIsOnTop
                            this._domNodes.carousel.data('Swipe').slide(
                                index)
                        else
                            this._scrollToTop(=>
                                this._domNodes.carousel.data(
                                    'Swipe'
                                ).slide index)
                        sectionButtonDomNode.addClass 'active'
                else
                    sectionButtonDomNode.removeClass 'active'
            if not switched
                window.location.hash = hash
                this._adaptContentHeight()
            super()
        ###*
            @description This method triggers if all startup animations are
                         ready.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onStartUpAnimationComplete: ->
            # All start up effects are ready. Handle direct section links.
            this._domNodes.navigationButton.add(
                this._domNodes.aboutThisWebsiteButton
            ).filter(
                "a[href=\"#{window.location.href.substr(
                    window.location.href.indexOf '#'
                )}\"]"
            ).trigger 'click'
            this._adaptContentHeight()
            super()

        # endregion

        # region helper

        ###*
            @description Adapt the footer height to current main section
                         height.

            @returns {$.Swipe} Returns the new generated swipe instance.
        ###
        _adaptContentHeight: (borderInPixel=0) ->
            newSectionHeightInPixel = this._domNodes.carousel.find(
                this._domNodes.section
            ).add(this._domNodes.aboutThisWebsiteSection).filter(
                ".#{window.location.hash.substr(1)}"
            ).outerHeight()
            if this._currentMediaQueryMode is 'smartphone'
                if not this._navigationIsCollapsed
                    border = this._domNodes.carousel.css('border-top-width')
                    borderInPixel = window.parseInt(border.substr(
                        0, border.length - 2))
                this._domNodes.carousel.css(
                    height: "#{newSectionHeightInPixel + borderInPixel}px")
            else
                this._domNodes.carousel.animate height: newSectionHeightInPixel
            this
        ###*
            @description Attaches needed event handler to the swipe plugin and
                         initializes the slider.

            @returns {$.Swipe} Returns the new generated swipe instance.
        ###
        _initializeSwipe: ->
            this._options.carouselOptions.transitionEnd = (index, domNode) =>
                this._domNodes.navigationButton.each (subIndex, button) =>
                    if index is subIndex
                        this.fireEvent(
                            'switchSection', false, this, $(button).attr(
                                'href'))
                        return false
                return true
            this._domNodes.carousel.Swipe this._options.carouselOptions
        ###*
            @description Handles needed page manipulations to compensate the
                         navigation's dualism from being fixed and relative
                         positioned depending on the current viewport position.

            @returns {$.HomePage} Returns the current instance.
        ###
        _handleCollapsingNavigationBarCompensations: ->
            this._sectionBackgroundColor = this._domNodes.carousel.css(
                'background-color')
            this._domNodes.navigationBar.on('show.bs.collapse', this.getMethod(
                this._handleBeforeExpandNavigationBarCompensation)
            ).on('shown.bs.collapse', this.getMethod(
                this._handleAfterExpandNavigationBarCompensation)
            ).on('hide.bs.collapse', this.getMethod(
                this._handleBeforeCollapseNavigationBarCompensation)
            ).on 'hidden.bs.collapse', this.getMethod(
                this._handleAfterCollapseNavigationBarCompensation)
            this
        ###*
            @description Compensates margin from switching between positions
                         of viewport before expanding the real document
                         heights.

            @returns {$.HomePage} Returns the current instance.
        ###
        _handleBeforeExpandNavigationBarCompensation: ->
            this._collapsedNavigationHeightInPixel =
                this._domNodes.navigationBarWrapper.height()
            if this._viewportIsOnTop
                this._domNodes.carousel.css(
                    'margin-top':
                        "-#{this._expandedNavigationHeightInPixel}px"
                    'border-top':
                        "#{this._expandedNavigationHeightInPixel -
                        this._collapsedNavigationHeightInPixel}px solid " +
                        this._sectionBackgroundColor)
                this._adaptContentHeight(
                    this._expandedNavigationHeightInPixel -
                    this._collapsedNavigationHeightInPixel)
            this
        ###*
            @description Compensates margin from switching between positions
                         of viewport after expanding the real document heights.

            @returns {$.HomePage} Returns the current instance.
        ###
        _handleAfterExpandNavigationBarCompensation: ->
            this._expandedNavigationHeightInPixel =
                this._domNodes.navigationBarWrapper.height()
            this._navigationIsCollapsed = false
            if not this._viewportIsOnTop
                this._domNodes.carousel.css(
                    'margin-top': 0
                    'border-top':
                        "#{this._expandedNavigationHeightInPixel -
                        this._collapsedNavigationHeightInPixel}px solid " +
                        this._sectionBackgroundColor)
                $.scrollTo(
                    "+=#{this._expandedNavigationHeightInPixel -
                    this._collapsedNavigationHeightInPixel}px")
            this
        ###*
            @description Compensates margin from switching between positions
                         of viewport before reducing the real document heights.

            @returns {$.HomePage} Returns the current instance.
        ###
        _handleBeforeCollapseNavigationBarCompensation: ->
            this._distanceToTopInPixel = this._domNodes.window.scrollTop()
            if(this._distanceToTopInPixel and
               this._distanceToTopInPixel <
               this._expandedNavigationHeightInPixel -
               this._collapsedNavigationHeightInPixel)
                topMargin = this._domNodes.carousel.css 'margin-top'
                topMarginInPixel = window.parseInt topMargin.substring(
                    0, topMargin.length - 2)
                this._domNodes.carousel.animate(
                    {marginTop:
                        topMarginInPixel + this._distanceToTopInPixel -
                        this._expandedNavigationHeightInPixel +
                        this._collapsedNavigationHeightInPixel},
                     complete: this.getMethod(
                        this._handleCollapsedNavigationBarCompensation))
            this
        ###*
            @description Compensates margin from switching between positions
                         of viewport after reducing the real document heights.

            @returns {$.HomePage} Returns the current instance.
        ###
        _handleAfterCollapseNavigationBarCompensation: ->
            this._navigationIsCollapsed = true
            if this._viewportIsOnTop
                this._domNodes.carousel.css(
                    'margin-top':
                        "-#{this._collapsedNavigationHeightInPixel}px"
                    'border-top': 0)
                this._adaptContentHeight()
            else
                # NOTE: Stopping the animation of reducing the margin avoids
                # flicker effects.
                this._domNodes.carousel.stop()
                this._domNodes.carousel.css 'margin-top': 0, 'border-top': 0
                $.scrollTo
                    top: "#{this._distanceToTopInPixel -
                         this._expandedNavigationHeightInPixel +
                         this._collapsedNavigationHeightInPixel}px"
                    left: '+=0'
            this
        ###*
            @description This method adds triggers to switch section.

            @returns {$.HomePage} Returns the current instance.
        ###
        _addNavigationEvents: ->
            this.on this._domNodes.navigationButton, 'click', (event) =>
                this.fireEvent(
                    'switchSection', false, this, $(event.target).attr 'href')
            super()
        ###*
            @description Determines current section to the right or the left.

            @param {String} hash Relative section ("next" or "prev"),

            @returns {String} Returns the absolute hash string.
        ###
        _determineRelativeSections: (hash) ->
            this._domNodes.navigationButton.each (index, button) =>
                if $(button).attr('href') is window.location.hash
                    # NOTE: We subtract 1 from navigation buttons length
                    # because we want to ignore the about this website section.
                    # And the index starts counting by zero.
                    numberOfButtons =
                        this._domNodes.navigationButton.length - 1
                    if hash is 'next'
                        newIndex = (index + 1) % numberOfButtons
                    else if hash is 'prev'
                        # NOTE: Subtracting 1 in the residue class ring means
                        # adding the number of numbers minus 1. This prevents
                        # us from getting negative button indexes.
                        newIndex = (index + numberOfButtons - 1) %
                            numberOfButtons
                    hash = $(
                        this._domNodes.navigationButton[newIndex]
                    ).attr 'href'
                    false
            hash

        # endregion

    # endregion

    # region handle $ extending

    ###* @ignore ###
    $.HomePage = ->
        self = new HomePage
        self._controller.apply self, arguments

    # endregion

# endregion

## standalone
)
