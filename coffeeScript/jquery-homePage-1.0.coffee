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
            domNodes:
                # TODO make nodes more tree like
                carousel: 'div.carousel.slide'
                section: 'div.item'
                topDomNode: 'div.navbar-wrapper'
                logoLink: 'a.navbar-brand'
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
                default: 'deDE'
                onSwitched: (oldLanguage, newLanguage) ->
                    # Add language toggle button functionality.
                    $("a[href=\"#lang-#{newLanguage}\"]").fadeOut('fast', ->
                        $(this).attr('href', "#lang-#{oldLanguage}").text(
                            oldLanguage.substr 0, 2
                        ).fadeIn 'fast'
                    )
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
            # TODO options
            # TODO _domNodes -> $domNode
            this.on this._domNodes.aboutThisWebsiteButton, 'click', =>
                this._domNodes.aboutThisWebsiteSection.fadeIn()
            this.on this._domNodes.navigationButton.add(
                this._domNodes.logoLink
            ), 'click', =>
                this._domNodes.aboutThisWebsiteSection.fadeOut()
            this._initializeSwipe()

        # endregion

    # endregion

    # region protected methods

        # region event

        ###*
            @description This method triggers if the responsive design switches
                         to desktop mode.

            @returns {$.HomePage} Returns the current instance.
        ###
        _onChangeMediaQueryMode: (oldMode, newMode) ->
            this._domNodes.dimensionIndicator.fadeOut 'slow', =>
                this._domNodes.dimensionIndicator.text(
                    this.stringFormat(
                        this._options.dimensionIndicatorTemplate,
                        "#{newMode}-mode")
                ).fadeIn 'slow'
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
            @description Adapt the carousel height to current main section
                         height.

            @returns {$.Swipe} Returns the new generated swipe instance.
        ###
        _adaptContentHeight: ->
            newSectionHeightInPixel = this._domNodes.carousel.find(
                this._domNodes.section
            ).add(this._domNodes.aboutThisWebsiteSection).filter(
                ".#{window.location.hash.substr(1)}"
            ).outerHeight()
            # TODO
            if window.location.hash is '#about-this-website'
                this._domNodes.footer.css(
                    position: 'absolute'
                    top: newSectionHeightInPixel)
                this._domNodes.carousel.height newSectionHeightInPixel
            else
                this._domNodes.footer.css position: 'relative', top: 0
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
