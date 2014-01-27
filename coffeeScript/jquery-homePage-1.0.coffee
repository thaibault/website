#!/usr/bin/env require
# -*- coding: utf-8 -*-

# region vim modline

# vim: set tabstop=4 shiftwidth=4 expandtab:
# vim: foldmethod=marker foldmarker=region,endregion:

# endregion

# region header

###!
[Project page](https://thaibault.github.com)

This module provides common logic for the whole home page.

Copyright Torben Sickert 16.12.2012

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
    ['jQuery.fn.Swipe', 'jquery-swipe-2.0']],
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

        initialize: (
            options={}, @_sectionBackgroundColor='white',
            @_oldSectionHeightInPixel=200, @_sectionTopMarginInPixel=0,
            @_initialContentHeightAdaptionHappens=false
        ) ->
            ###
                Initializes the interactive web application.

                **options {Object}**     - An options object.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            # Saves default options for manipulating the default behaviour.
            this._options =
                trackingCode: 'UA-40192634-1'
                maximumFooterHeightInPercent: 50
                scrollInLinearTime: true
                dimensionIndicatorTemplate: '({1})'
                backgroundImagePath: 'image/carousel/'
                backgroundImageFileExtension: '.jpg'
                backgroundDependentHeightSections: ['about']
                maximumBackgroundDependentHeight: 750
                menuHighlightAnimation: easing: 'linear'
                domNode:
                    carousel: '> div.carousel.slide'
                    section: '> div.carousel.slide > div.carousel-inner > ' +
                             'div.item'
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
                    speed: 400
                    auto: 0
                    continuous: false
                    disableScroll: false
                    stopPropagation: false
                language: default: 'deDE'
                dimensionIndicator:
                    fadeIn: duration: 'fast'
                    fadeOut: duration: 'fast'
                aboutThisWebsiteSection:
                    fadeIn: duraction: 'fast'
                    fadeOut: duration: 'fast'
            # Adapt menu highlighter after language switching.
            $.extend true, options,
                language:
                    onSwitched: =>
                        this._highlightMenuEntry()._adaptContentHeight()
                    onSwitch: (oldLanguage, newLanguage) =>
                        # Add language toggle button functionality.
                        self = this
                        $("a[href=\"#lang-#{newLanguage}\"]").fadeOut(
                            'fast', ->
                                $(this).attr(
                                    'href', "#lang-#{oldLanguage}"
                                ).text(oldLanguage.substr 0, 2).fadeIn 'fast'
                        )
                        # Adapt curriculum vitae link.
                        $curriculumVitaeLink = $(
                            'a[href*="curriculumVitae"].hidden-xs')
                        linkPath = $curriculumVitaeLink.attr 'href'
                        $curriculumVitaeLink.attr(
                            'href', linkPath.substr(
                                0, linkPath.lastIndexOf('.') -
                                oldLanguage.length
                            ) + newLanguage.substr(0, 2).toUpperCase() +
                            newLanguage.substr(2).toLowerCase() +
                            linkPath.substr(linkPath.lastIndexOf '.'))
            super options
            this.$domNodes.aboutThisWebsiteSection.hide().css(
                'position', 'absolute')
            # Disable tab functionality to prevent inconsistent carousel
            # states.
            this.on this.$domNodes.parent, 'keydown', (event) =>
                event.preventDefault() if event.keyCode is this.keyCode.TAB
            this.on this.$domNodes.window, 'resize', this.getMethod(
                this._adaptContentHeight)
            this._initializeSwipe()
            if not window.location.hash
                if this._currentMediaQueryMode is 'extraSmall'
                    window.location.hash = 'contact'
                else
                    window.location.hash =
                        this.$domNodes.navigationButton.parent(
                            'li'
                        ).filter('.active').children(
                            this.$domNodes.navigationButton
                        ).attr 'href'
            this.fireEvent 'switchSection', false, this, window.location.hash
            this

        # endregion

    # endregion

    # region protected methods

        # region event

        _onChangeMediaQueryMode: (oldMode, newMode) ->
            ###
                This method triggers if the responsive design switches to
                another resolution mode.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            # Determine top margin for background image dependent sections.
            this.$domNodes.section.children().css 'margin-top', ''
            this._sectionTopMarginInPixel = window.parseInt(
                window.getComputedStyle($('h1')[1], ':before').height)
            # Show responsive dimension indicator switching.
            this._options.dimensionIndicator.fadeIn.always = =>
                # Adapt menu highlighter after changing layout and
                # dimension indicator.
                this._highlightMenuEntry()
            this._options.dimensionIndicator.fadeOut.always = =>
                this.$domNodes.dimensionIndicator.text(
                    this.stringFormat(
                        this._options.dimensionIndicatorTemplate,
                        "#{newMode}-mode")
                ).fadeIn this._options.dimensionIndicator.fadeIn
            this.$domNodes.dimensionIndicator.stop().fadeOut(
                this._options.dimensionIndicator.fadeOut)
            super()
        _onChangeToExtraSmallMode: ->
            ###
                This method triggers if the responsive design switches to
                extra small mode.

                **returns {$.HomePage}** - Returns the current instance.
            ###
            # Resets the image dependent section heights.
            this.$domNodes.section.children().css height: 'auto'
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
                this._handleSwitchToAboutThisWebsite hash
            else
                sectionFound = false
                this.$domNodes.navigationButton.each (index, button) =>
                    $button = $ button
                    $sectionButton = $button.parent 'li'
                    if not $sectionButton.length
                        $sectionButton = $button
                    if($button.attr('href') is hash or (
                        hash is '#' and ((
                            this._currentMediaQueryMode is 'extraSmall' and
                            $button.attr('href') is '#contact'
                        ) or (
                            this._currentMediaQueryMode isnt 'extraSmall' and
                            index is 0
                        ))
                    ))
                        hash = $button.attr 'href'
                        sectionFound = true
                        if not $sectionButton.hasClass 'active'
                            this._performSectionSwitch(
                                hash, direction, index, $sectionButton)
                    else
                        $sectionButton.removeClass 'active'
                # If no section could be determined initialize the first one.
                if not sectionFound
                    forceSection = this.$domNodes.navigationButton.first(
                    ).attr 'href'
                    this.debug "Force section \"#{forceSection}\"."
                    return this._onSwitchSection forceSection
            window.location.hash = hash
            this._adaptContentHeight()
            super()

        # endregion

        # region helper

        _performSectionSwitch: (hash, direction, index, $sectionButton) ->
            ###
                Switches to given section.

                **hash {String}**              - Section hash value.

                **direction {String|Boolean}** - Relative section position.

                **index {Number}**             - Index of section to switch to.

                **$sectionButton {domNode}**   - The current section button.

                **returns {$.Website}**        - Returns the current instance.
            ###
            this.$domNodes.aboutThisWebsiteSection.fadeOut(
                this._options.aboutThisWebsiteSection.fadeOut)
            this.debug "Switch to section \"#{hash}\"."
            # Swipe in endless cycle if we get a direction.
            index = direction if direction
            if this._viewportIsOnTop
                this.$domNodes.carousel.data('Swipe').slide index
            else
                this._scrollToTop =>
                    this.$domNodes.carousel.data('Swipe').slide index
            $sectionButton.addClass 'active'
            this._highlightMenuEntry()
        _handleSwitchToAboutThisWebsite: (hash) ->
            ###
                Switches to about this website section.

                **hash {String}**       - Section hash value.

                **returns {$.Website}** - Returns the current instance.
            ###
            this.debug "Switch to section \"#{hash}\"."
            this.$domNodes.menuHighlighter.hide()
            this._scrollToTop()
            this.$domNodes.aboutThisWebsiteSection.fadeIn(
                this._options.aboutThisWebsiteSection.fadeIn)
            this.$domNodes.navigationButton.parent('li').removeClass 'active'
            this
        _onStartUpAnimationComplete: ->
            ###
                This method is complete if last startup animation was
                initialized.

                **returns {$.Website}** - Returns the current instance.
            ###
            super()
            this._highlightMenuEntry()
        _removeLoadingCover: ->
            ###
                This method triggers after window is loaded. It overwrites the
                super method to wait for removing the loading cover until
                section height is adapted.

                **returns {$.Website}** - Returns the current instance.
            ###
            if this._initialContentHeightAdaptionHappens
                super()
            this
        _highlightMenuEntry: ->
            ###
                Highlights current menu entry.

                **$sectionButton {domNode}** - The current section button.

                @returns {$.HomePage}        - Returns the current instance.
            ###
            if this._currentMediaQueryMode isnt 'extraSmall'
                $sectionButton = this.$domNodes.navigationButton.parent(
                    'li'
                ).filter '.active'
                if $sectionButton.position()?.left
                    $.extend true, this._options.menuHighlightAnimation,
                        left: $sectionButton.position().left
                        width: $sectionButton.width()
                        duration: this._options.carousel.speed
                    this.$domNodes.menuHighlighter.stop().show().animate(
                        this._options.menuHighlightAnimation)
            this
        _adaptContentHeight: ->
            ###
                Adapt the carousel height to current main section height.

                **returns {$.Swipe}** - Returns the new generated swipe
                                        instance.
            ###
            $currentSection = this.$domNodes.section.add(
                this.$domNodes.aboutThisWebsiteSection
            ).filter ".#{window.location.hash.substr(1)}"
            newSectionHeightInPixel = this._determineNewSectionHeightInPixel(
                $currentSection)
            if(newSectionHeightInPixel and
               newSectionHeightInPixel isnt this._oldSectionHeightInPixel)
                this._oldSectionHeightInPixel = newSectionHeightInPixel
                # First stop currently running animations.
                if this.startUpAnimationIsComplete
                    this.$domNodes.footer.stop true
                    this.$domNodes.carousel.stop true
                transitionMethod = 'css'
                if this._initialContentHeightAdaptionHappens
                    transitionMethod = 'animate'
                # NOTE: If current section is "about-this-website" we place it
                # in front of last selected section and position footer
                # absolutely.
                if window.location.hash is '#about-this-website'
                    # Move footer from last known position.
                    this.$domNodes.footer.css(
                        position: 'absolute'
                        top: this.$domNodes.carousel.height())
                    this.$domNodes.footer[transitionMethod]
                        top: newSectionHeightInPixel
                        duration: this._options.carousel.speed
                    this.$domNodes.carousel.height newSectionHeightInPixel
                else
                    this._adaptSectionHeight(
                        transitionMethod, newSectionHeightInPixel,
                        $currentSection)
            if not this._initialContentHeightAdaptionHappens
                this._initialContentHeightAdaptionHappens = true
                this._removeLoadingCover()
            this
        _adaptSectionHeight: (
            transitionMethod, newSectionHeightInPixel, $currentSection
        ) ->
            ###
                Adapts the new section height after window resizing or section
                switch.

                **transitionMethod {String}**      - Method name to perform
                                                     adaption.

                **newSectionHeightInPixel {Number} - Section height to adapt
                                                     to.

                **$currentSection {domNode}**      - The current section dom
                                                     node.

                **returns {$.HomePage}**           - Returns the current
                                                     instance.
            ###
            this.$domNodes.footer.css position: 'relative', top: 0
            this.$domNodes.carousel[transitionMethod] {
                height: newSectionHeightInPixel
                duration: this._options.carousel.speed
            }, always: =>
                # Check if height has changed after adaption.
                if(newSectionHeightInPixel isnt
                   $currentSection.outerHeight())
                    this._adaptContentHeight()
            if $.inArray(
                window.location.hash.substr(1),
                this._options.backgroundDependentHeightSections
            ) is -1 or this._currentMediaQueryMode is 'extraSmall'
                this.$domNodes.section.children().stop().css
                    marginTop: 0
            else
                additionalMarginTopInPixel = 0
                if(newSectionHeightInPixel >
                   this._options.maximumBackgroundDependentHeight)
                    additionalMarginTopInPixel = (
                        newSectionHeightInPixel -
                        this._options.maximumBackgroundDependentHeight
                    ) / 2
                    newSectionHeightInPixel =
                        this._options.maximumBackgroundDependentHeight
                $currentSection.children().css(
                    height: newSectionHeightInPixel -
                        this._sectionTopMarginInPixel
                    duration: this._options.carousel.speed)
                this.$domNodes.section.children().stop().animate(
                    marginTop: additionalMarginTopInPixel)
            this
        _determineNewSectionHeightInPixel: ($currentSection) ->
            ###
                Determines the new section height in pixel after webview size
                or section has changed.

                **$currentSection {domNode}** - The current section dom node.

                **returns {Number}**          - Returns the new computed
                                                section height.
            ###
            if this._currentMediaQueryMode is 'extraSmall' or $.inArray(
                window.location.hash.substr(1),
                this._options.backgroundDependentHeightSections
            ) is -1
                newSectionHeightInPixel = $currentSection.outerHeight()
                footerHeightInPixel = this.$domNodes.window.height() -
                    newSectionHeightInPixel
                footerHeightInPercent = (footerHeightInPixel * 100) /
                    this.$domNodes.window.height()
                if(this._options.maximumFooterHeightInPercent <
                   footerHeightInPercent and newSectionHeightInPixel <
                   this.$domNodes.window.height() -
                   this.$domNodes.footer.height())
                    return this.$domNodes.window.height() -
                        this.$domNodes.footer.height()
                return newSectionHeightInPixel
            this.$domNodes.window.height()
        _initializeSwipe: ->
            ###
                Attaches needed event handler to the swipe plugin and
                initializes the slider.

                **returns {$.Swipe}** - Returns the new generated swipe
                                        instance.
            ###
            # Remove anchor ids to avoid conflicts with native section
            # switching.
            $('h1').removeAttr('id').filter(->
                not $.trim $(this).html()
            ).remove()
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
