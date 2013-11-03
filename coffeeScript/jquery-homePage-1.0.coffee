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
            domNode:
                carousel: '> div.carousel.slide'
                section: '> div.carousel.slide > div.carousel-inner > div.item'
                top: '> div.navbar-wrapper'
                logoLink:
                    '> div.navbar-wrapper > div.container > ' +
                    'div.navbar.navbar-inverse > div.container > ' +
                    'div.navbar-header > a.navbar-brand'
                navigationButton:
                    '> div.navbar-wrapper > div.container > ' +
                    'div.navbar.navbar-inverse > div.container > ' +
                    'div.navbar-collapse > ul.nav.navbar-nav li a'
                aboutThisWebsiteButton:
                    '> div.footer > footer > p > a[href="#about-this-website"]'
                aboutThisWebsiteSection: '> div.about-this-website'
                dimensionIndicator:
                    '> div.navbar-wrapper > div.container > ' +
                    'div.navbar.navbar-inverse > div.container > ' +
                    'div.navbar-header > a.navbar-brand > ' +
                    'span.dimension-indicator'
                footer: '> div.footer'
            carouselOptions:
                startSlide: 0
                speed: 1000
                auto: 0
                continuous: false
                disableScroll: false
                stopPropagation: false
            language: default: 'deDE'
            dimensionIndicator:
                fadeIn: duration: 'slow'
                fadeOut: duration: 'slow'
            aboutThisWebsiteSection:
                fadeIn: duraction: 'normal'
                fadeOut: duration: 'normal'
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
            $.extend true, options, {
                language: onSwitched: (oldLanguage, newLanguage) =>
                    # Add language toggle button functionality.
                    self = this
                    $("a[href=\"#lang-#{newLanguage}\"]").fadeOut 'fast', ->
                        $(this).attr('href', "#lang-#{oldLanguage}").text(
                            oldLanguage.substr 0, 2)
                        self._adaptContentHeight()
                        $(this).fadeIn 'fast'
            }
            super options
            if not window.location.hash
                window.location.hash = this.$domNodes.navigationButton.parent(
                    'li'
                ).filter('.active').children(
                    this.$domNodes.navigationButton
                ).attr 'href'
            # Handle "about-this-website" and main section switch.
            this.on this.$domNodes.aboutThisWebsiteButton, 'click', =>
                this._scrollToTop()
                this.$domNodes.aboutThisWebsiteSection.fadeIn(
                    this._options.aboutThisWebsiteSection.fadeIn)
            this.on this.$domNodes.navigationButton.add(
                this.$domNodes.logoLink
            ), 'click', =>
                this.$domNodes.aboutThisWebsiteSection.fadeOut(
                    this._options.aboutThisWebsiteSection.fadeOut)
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
            # Show responsive dimension indicator switching.
            this._options.dimensionIndicator.fadeOut.always = =>
                this.$domNodes.dimensionIndicator.text(
                    this.stringFormat(
                        this._options.dimensionIndicatorTemplate,
                        "#{newMode}-mode")
                ).fadeIn this._options.dimensionIndicator.fadeIn
            this.$domNodes.dimensionIndicator.stop().fadeOut(
                this._options.dimensionIndicator.fadeOut)
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
            this.$domNodes.navigationButton.each (index, button) =>
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
                            this.$domNodes.carousel.data('Swipe').slide index
                        else
                            this._scrollToTop(=>
                                this.$domNodes.carousel.data(
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
            this.$domNodes.navigationButton.add(
                this.$domNodes.aboutThisWebsiteButton
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
            newSectionHeightInPixel = this.$domNodes.carousel.find(
                this.$domNodes.section
            ).add(this.$domNodes.aboutThisWebsiteSection).filter(
                ".#{window.location.hash.substr(1)}"
            ).outerHeight()
            # NOTE: If current section is "about-this-website" we place it in
            # front of last selected section and position footer absolutely.
            if window.location.hash is '#about-this-website'
                # Move footer from last known position.
                this.$domNodes.footer.css(
                    position: 'absolute'
                    top: this.$domNodes.carousel.height())
                this.$domNodes.footer.animate top: newSectionHeightInPixel
                this.$domNodes.carousel.height newSectionHeightInPixel
            else
                this.$domNodes.footer.css position: 'relative', top: 0
                this.$domNodes.carousel.animate height: newSectionHeightInPixel
            this
        ###*
            @description Attaches needed event handler to the swipe plugin and
                         initializes the slider.

            @returns {$.Swipe} Returns the new generated swipe instance.
        ###
        _initializeSwipe: ->
            this._options.carouselOptions.transitionEnd = (index, domNode) =>
                this.$domNodes.navigationButton.each (subIndex, button) =>
                    if index is subIndex
                        this.fireEvent(
                            'switchSection', false, this, $(button).attr(
                                'href'))
                        return false
                return true
            this.$domNodes.carousel.Swipe this._options.carouselOptions
        ###*
            @description This method adds triggers to switch section.

            @returns {$.HomePage} Returns the current instance.
        ###
        _addNavigationEvents: ->
            this.on this.$domNodes.navigationButton, 'click', (event) =>
                this.fireEvent(
                    'switchSection', false, this, $(event.target).attr 'href')
            super()
        ###*
            @description Determines current section to the right or the left.

            @param {String} hash Relative section ("next" or "prev"),

            @returns {String} Returns the absolute hash string.
        ###
        _determineRelativeSections: (hash) ->
            this.$domNodes.navigationButton.each (index, button) =>
                if $(button).attr('href') is window.location.hash
                    # NOTE: We subtract 1 from navigation buttons length
                    # because we want to ignore the about this website section.
                    # And the index starts counting by zero.
                    numberOfButtons =
                        this.$domNodes.navigationButton.length - 1
                    if hash is 'next'
                        newIndex = (index + 1) % numberOfButtons
                    else if hash is 'prev'
                        # NOTE: Subtracting 1 in the residue class ring means
                        # adding the number of numbers minus 1. This prevents
                        # us from getting negative button indexes.
                        newIndex = (index + numberOfButtons - 1) %
                            numberOfButtons
                    hash = $(
                        this.$domNodes.navigationButton[newIndex]
                    ).attr 'href'
                    false
            hash

        # endregion

    # endregion

    # region handle $ extending

    ###* @ignore ###
    $.HomePage = -> $.Tools().controller HomePage, arguments
    ###* @ignore ###
    $.HomePage.class = HomePage

    # endregion

# endregion

## standalone
)
