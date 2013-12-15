#!/usr/bin/env require

# region vim modline

# vim: set tabstop=4 shiftwidth=4 expandtab:
# vim: foldmethod=marker foldmarker=region,endregion:

# endregion

# region header

###!
[Project page](https://thaibault.github.com)

This module provides common logic for the whole home page.

Copyright
---------

Torben Sickert 16.12.2012

License
-------

This library written by Torben Sickert stand under a creative commons naming
3.0 unported license. see http://creativecommons.org/licenses/by/3.0/deed.de

Extending this module
---------------------

For conventions see require on https://github.com/thaibault/require

Author
------

t.sickert@gmail.com (Torben Sickert)

Version
-------

1.0 stable
###

## standalone
## do ($=this.jQuery) ->
this.require.scopeIndicator = 'jQuery.HomePage'
this.require [
    'jquery-website-1.0.coffee', ['jQuery.fn.collapse', 'bootstrap-3.0.3']
    ['jQuery.fn.Swipe', 'jquery-swipe-2.0']
    ['jQuery.fn.backstretch', 'jquery-backstrech-2.0.4']],
($) ->
##

# endregion

# region plugins/classes

    class HomePage extends $.Website.class
        ###This plugin holds all needed methods to extend a whole homepage.###

    # region properties

        ###
            **__name__ {String}**
            Holds the class name to provide inspection features.
        ###
        __name__: 'HomePage'

    # endregion

    # region public methods

        # region special

        initialize: (options={}, @_sectionBackgroundColor='white') ->
            ###
                Initializes the interactive web application.

                **options {Object}**     - An options object.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            # Saves default options for manipulating the default behaviour.
            this._options =
                trackingCode: 'UA-40192634-1'
                scrollInLinearTime: true
                dimensionIndicatorTemplate: '({1})'
                backgroundImagePath: 'image/carousel/'
                backgroundImageFileExtension: '.jpg'
                domNode:
                    carousel: '> div.carousel.slide'
                    section: '> div.carousel.slide > div.carousel-inner > ' +
                             'div.item'
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
                        '> div.footer > footer > p > ' +
                        'a[href="#about-this-website"]'
                    aboutThisWebsiteSection: '> div.about-this-website'
                    dimensionIndicator:
                        '> div.navbar-wrapper > div.container > ' +
                        'div.navbar.navbar-inverse > div.container > ' +
                        'div.navbar-header > a.navbar-brand > ' +
                        'span.dimension-indicator'
                    footer: '> div.footer'
                    menuHighlighter: '> div.navbar-wrapper > div.container ' +
                                     '> div.navbar.navbar-inverse ' +
                                     '> div.container > div.navbar-collapse ' +
                                     '> div.navbar-highlighter'
                carousel:
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
                backstrech: {}
            $.extend true, options, language: onSwitched: (
                oldLanguage, newLanguage
            ) =>
                # Add language toggle button functionality.
                self = this
                $("a[href=\"#lang-#{newLanguage}\"]").fadeOut 'fast', ->
                    $(this).attr('href', "#lang-#{oldLanguage}").text(
                        oldLanguage.substr 0, 2)
                    self._adaptContentHeight()
                    $(this).fadeIn 'fast'
            super options
            if not window.location.hash
                window.location.hash = this.$domNodes.navigationButton.parent(
                    'li'
                ).filter('.active').children(
                    this.$domNodes.navigationButton
                ).attr 'href'
            this.on this.$domNodes.window, 'resize', this.debounce(
                this.getMethod this._adaptContentHeight)
            this

        # endregion

    # endregion

    # region protected methods

        # region event

        _onChangeMediaQueryMode: (oldMode, newMode) ->
            ###
                This method triggers if the responsive design switches to
                desktop mode.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            # Show responsive dimension indicator switching.
            this._options.dimensionIndicator.fadeOut.always = =>
                this.$domNodes.dimensionIndicator.text(
                    this.stringFormat(
                        this._options.dimensionIndicatorTemplate,
                        "#{newMode}-mode")
                ).fadeIn this._options.dimensionIndicator.fadeIn
            this.$domNodes.dimensionIndicator.stop().fadeOut(
                this._options.dimensionIndicator.fadeOut)
            # Activate backstretching in non extra small mode only.
            # TODO if((not oldMode or oldMode is 'extraSmall') and
            #   newMode isnt 'extraSmall')
            #    this._initializeBackstretch()
            this.$domNodes.section.each ->
                $this = $ this
                $this.backstretch 'resize' if $this.data 'backstretch'
            super()
        _onSwitchSection: (hash) ->
            ###
                Switches to given section.

                **hash {String}**        - Location to switch to.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            direction = false
            if $.inArray(hash, ['next', 'prev']) isnt -1
                direction = hash
                hash = this._determineRelativeSections hash
            hash = "##{hash}" if hash.substr(0, 1) isnt '#'
            if hash is this.$domNodes.aboutThisWebsiteButton.attr 'href'
                this.debug "Switch to section \"#{hash}\"."
                # Handle "about-this-website" and main section switch.
                this._scrollToTop()
                this.$domNodes.aboutThisWebsiteSection.fadeIn(
                    this._options.aboutThisWebsiteSection.fadeIn)
            this.$domNodes.navigationButton.each (index, button) =>
                $button = $ button
                $sectionButtonDomNode = $button.parent 'li'
                if not $sectionButtonDomNode.length
                    $sectionButtonDomNode = $button
                if $button.attr('href') is hash or (index is 0 and hash is '#')
                    hash = $button.attr 'href'
                    if not $sectionButtonDomNode.hasClass 'active'
                        this.$domNodes.aboutThisWebsiteSection.fadeOut(
                            this._options.aboutThisWebsiteSection.fadeOut)
                        this.debug "Switch to section \"#{hash}\"."
                        # Swipe in endless cycle if we get a direction.
                        index = direction if direction
                        if this._viewportIsOnTop
                            this.$domNodes.carousel.data('Swipe').slide index
                        else
                            this._scrollToTop(=>
                                this.$domNodes.carousel.data(
                                    'Swipe'
                                ).slide index)
                        this._highlightMenuEntry(
                            $sectionButtonDomNode.addClass 'active')
                else
                    $sectionButtonDomNode.removeClass 'active'
            window.location.hash = hash
            this._adaptContentHeight()
            super()
        _onStartUpAnimationComplete: ->
            ###
                This method triggers if all startup animations are ready.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            # TODO if this._currentMediaQueryMode isnt 'extraSmall'
            #    this._initializeBackstretch()
            this._initializeSwipe()
            # All start up effects are ready. Handle direct section links.
            this.$domNodes.navigationButton.add(
                this.$domNodes.aboutThisWebsiteButton
            ).filter(
                "a[href=\"#{window.location.href.substr(
                    window.location.href.indexOf '#'
                )}\"]"
            ).trigger 'click'
            super()

        # endregion

        # region helper

        _highlightMenuEntry: ($sectionButtonDomNode) ->
            ###
                Highlights current menu entry.

                **$sectionButtonDomNode {domNode}** - The current section
                                                      button.

                @returns {$.HomePage} - Returns the current instance.
            ###
            this.$domNodes.menuHighlighter.animate
                left: $sectionButtonDomNode.position().left
                width: $sectionButtonDomNode.width()
            this
        _initializeBackstretch: ->
            ###
                Initializes the backstretch instance on every section
                background image.

                @returns {$.HomePage} - Returns the current instance.
            ###
            self = this
            this.$domNodes.navigationButton.each ->
                hash = $(this).attr('href').substr 1
                $this = self.$domNodes.section.filter ".#{hash}"
                if not $this.data 'backstrech'
                    $this.backstretch(
                        self._options.backgroundImagePath + hash +
                        self._options.backgroundImageFileExtension,
                        self._options.backstretch)
            this
        _adaptContentHeight: ->
            ###
                Adapt the carousel height to current main section height.

                **returns {$.Swipe}** - Returns the new generated swipe
                                        instance.
            ###
            # TODO
            $('div[class^=carousel-image-]').css('min-height', $(window).height() - 80)

            newSectionHeightInPixel = this.$domNodes.section.add(
                this.$domNodes.aboutThisWebsiteSection
            ).filter(".#{window.location.hash.substr(1)}").outerHeight()
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
        _initializeSwipe: ->
            ###
                Attaches needed event handler to the swipe plugin and
                initializes the slider.

                **returns {$.Swipe}** - Returns the new generated swipe
                                        instance.
            ###
            this._options.carousel.transitionEnd = (index, domNode) =>
                this.$domNodes.navigationButton.each (subIndex, button) =>
                    if index is subIndex
                        this.fireEvent(
                            'switchSection', false, this, $(button).attr(
                                'href'))
                        return false
                return true
            # NOTE: A cyclic slide effect is more intuitive on touch devices.
            if this._currentMediaQueryMode is 'extraSmall'
                this._options.carousel.continuous = true
            this.$domNodes.carousel.Swipe this._options.carousel
        _addNavigationEvents: ->
            ###
                This method adds triggers to switch section.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            this.on this.$domNodes.navigationButton.add(
                this.$domNodes.aboutThisWebsiteButton
            ), 'click', (event) =>
                this.fireEvent(
                    'switchSection', false, this, $(event.target).attr 'href')
            super()
        _determineRelativeSections: (hash) ->
            ###
                Determines current section to the right or the left.

                **hash {String}**    - Relative section ("next" or "prev"),

                **returns {String}** - Returns the absolute hash string.
            ###
            this.$domNodes.navigationButton.each (index, button) =>
                if $(button).attr('href') is window.location.hash
                    ###
                        NOTE: We subtract 1 from navigation buttons length
                        because we want to ignore the about this website
                        section. And the index starts counting by zero.
                    ###
                    numberOfButtons =
                        this.$domNodes.navigationButton.length - 1
                    if hash is 'next'
                        newIndex = (index + 1) % numberOfButtons
                    else if hash is 'prev'
                        ###
                            NOTE: Subtracting 1 in the residue class ring means
                            adding the number of numbers minus 1. This prevents
                            us from getting negative button indexes.
                        ###
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

    $.HomePage = -> $.Tools().controller HomePage, arguments
    $.HomePage.class = HomePage

    # endregion

# endregion
