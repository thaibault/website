// @flow
// #!/usr/bin/env node
// -*- coding: utf-8 -*-
/** @module jQuery-homePage */
'use strict'
/* !
    region header
    [Project page](http://torben.website)

    Copyright Torben Sickert (info["~at~"]torben.website) 16.12.2012

    License
    -------

    This library written by Torben Sickert stand under a creative commons
    naming 3.0 unported license.
    See http://creativecommons.org/licenses/by/3.0/deed.de
    endregion
*/
// region imports
import $ from 'jquery'
import 'jQuery-website'
import type {$DomNode} from 'jQuery-tools'
require(
    'imports?jQuery=jquery!imports?$=jquery!imports?window=>{jQuery: jQuery}' +
    '!swipe')
// endregion
const context:Object = (():Object => {
    if ($.type(window) === 'undefined') {
        if ($.type(global) === 'undefined')
            return ($.type(module) === 'undefined') ? {} : module
        return global
    }
    return window
})()
if (!context.hasOwnProperty('document') && $.hasOwnProperty('context'))
    context.document = $.context
// region plugins/classes
/**
 * This plugin holds all needed methods to extend a whole homepage.
 * @extends jQuery-website:Website
 * @property static:_name - Defines this class name to allow retrieving them
 * after name mangling.
 * TODO
 */
class HomePage extends $.Website.class {
    // region static properties
    static _name:string = 'HomePage'
    // endregion
    // region dynamic properties
    $domNodes:{[key:string]:$DomNode};
    // endregion
    // region public methods
    // / region special
    initialize: (
        options={}, @_sectionBackgroundColor='white'
        @_oldSectionHeightInPixel=200, @_sectionTopMarginInPixel=0
        @_initialContentHeightAdaptionDone=false
        @_initialMenuHightlightDone=false, @_loadingCoverRemoved=false
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
            backgroundImagePath: 'image/carousel/'
            backgroundImageFileExtension: '.jpg'
            backgroundDependentHeightSections: ['about']
            maximumBackgroundDependentHeight: 750
            menuHighlightAnimation: easing: 'linear'
            hideMobileMenuAfterSelection: true
            domNode:
                carousel: 'div.carousel.slide'
                section:
                    'div.carousel.slide div.carousel-inner div.item'
                logoLink:
                    'div.navbar-wrapper div.navbar.navbar-inverse ' +
                    'div.navbar-header a.navbar-brand'
                navigationButton:
                    'div.navbar-wrapper div.navbar.navbar-inverse ' +
                    'div.navbar-collapse ul.nav.navbar-nav li a'
                aboutThisWebsiteButton:
                    'div.footer footer a[href="#about-this-website"]'
                aboutThisWebsiteSection: 'div.about-this-website'
                dimensionIndicator:
                    'div.navbar-wrapper div.navbar.navbar-inverse ' +
                    'div.navbar-header a.navbar-brand ' +
                    'span.dimension-indicator'
                footer: 'div.footer'
                menuHighlighter:
                    'div.navbar-wrapper div.navbar.navbar-inverse ' +
                     'div.navbar-collapse div.navbar-highlighter'
                mobileCollapseButton:
                    'div.navbar-wrapper div.navbar.navbar-inverse ' +
                    'div.navbar-header button.navbar-toggle'
                navigationWrapper:
                    'div.navbar-wrapper div.navbar.navbar-inverse ' +
                    'div.navbar-collapse'
            carousel:
                startSlide: 0
                speed: 400
                auto: 0
                continuous: false
                disableScroll: false
                stopPropagation: false
            dimensionIndicator:
                template: '<span ' +
                          'class="glyphicon glyphicon-resize-horizontal"' +
                          '></span> <span>{1}</span>'
                effectOptions:
                    fadeIn: duration: 'fast'
                    fadeOut: duration: 'fast'
            aboutThisWebsiteSection:
                fadeIn: duraction: 'fast'
                fadeOut: duration: 'fast'
        # Adapt menu highlighter after language switching.
        self = this
        initialOnSwitchedCallback = options.language?.onSwitched
        initialOnEnsuredCallback = options.language?.onEnsureded
        initialOnSwitchCallback = options.language?.onSwitch
        initialOnEnsureCallback = options.language?.onEnsure
        initialLanguageFadeOutAlwaysCallback =
            options.language?.textNodeParent?.fadeOut?.always
        $.extend true, options, language:
            onSwitched: ->
                result = not initialOnSwitchedCallback or (
                    initialOnSwitchedCallback?.apply this, arguments)
                # Only adapt menu highlighter if a section is currently
                # selected.
                self._highlightMenuEntry false
                fadeInOptions = self.languageHandler?._options
                    .textNodeParent.fadeIn or {}
                if self.$domNodes.navigationButton.parent('li').filter(
                    '.active'
                ).length
                    self.$domNodes.menuHighlighter.fadeIn fadeInOptions
                self._adaptContentHeight()
                result
            onEnsured: ->
                result = not initialOnEnsuredCallback or (
                    initialOnEnsuredCallback?.apply this, arguments)
                # Only adapt menu highlighter if a section is currently
                # selected.
                self._highlightMenuEntry false
                self._adaptContentHeight()
                result
            onSwitch: (oldLanguage, newLanguage) ->
                result = not initialOnSwitchCallback or (
                    initialOnSwitchCallback?.apply this, arguments)
                # Add language toggle button functionality.
                fadeOutOptions = self.languageHandler?._options
                    .textNodeParent.fadeOut or {}
                fadeInOptions = self.languageHandler?._options
                    .textNodeParent.fadeIn or {}
                self.$domNodes.menuHighlighter.fadeOut fadeOutOptions
                fadeOutOptions = $.extend true, {}, fadeOutOptions, {
                    always: ->
                        result =
                        initialLanguageFadeOutAlwaysCallback?.apply(
                            this, arguments)
                        $(this).attr(
                            'href', "#lang-#{oldLanguage}"
                        ).text(oldLanguage.substr 0, 2).fadeIn(
                            fadeInOptions)
                        result
                }
                $("a[href=\"#lang-#{newLanguage}\"]").fadeOut(
                    fadeOutOptions)
                # Adapt curriculum vitae link.
                self._adaptCurriculumVitaeLink oldLanguage, newLanguage
                result
            onEnsure: (oldLanguage, newLanguage) ->
                result = not initialOnEnsureCallback or (
                    initialOnEnsureCallback?.apply this, arguments)
                # Add language toggle button functionality.
                $("a[href=\"#lang-#{newLanguage}\"]").attr(
                    'href', "#lang-#{oldLanguage}"
                ).text(oldLanguage.substr 0, 2)
                self._adaptCurriculumVitaeLink oldLanguage, newLanguage
                result
        super options
        # Disable tab functionality to prevent inconsistent carousel states.
        this.on this.$domNodes.parent, 'keydown', (event) =>
            event.preventDefault() if event.keyCode is this.keyCode.TAB
        this.$domNodes.aboutThisWebsiteSection.hide().css(
            'position', 'absolute')
        if not (
            window.location.hash and this.$domNodes.navigationButton.parent(
                'li'
            ).children(this.$domNodes.navigationButton).filter(
                "[href=\"#{window.location.hash}\"]"
            ).length
        )
            window.location.hash =
                this.$domNodes.navigationButton.parent('li').filter(
                    '.active'
                ).children(this.$domNodes.navigationButton).attr 'href'
        this._initializeSwipe()
        this.fireEvent(
            'switchSection', false, this, window.location.hash.substring(
                '#'.length))
        this.on this.$domNodes.window, 'resize', this.getMethod(
            this._adaptContentHeight)
        this
    // / endregion
    // endregion
    // region protected methods
    // / region event
    _adaptCurriculumVitaeLink: (oldLanguage, newLanguage) ->
        ###
            Switches the language dependent curriculum vitae links.

            **returns {$.HomePage}** - Returns the current instance.
        ###
        $curriculumVitaeLink = $ 'a[href*="curriculumVitae"].hidden-xs'
        if not $curriculumVitaeLink.data(oldLanguage)?
            $curriculumVitaeLink.data(
                oldLanguage, $curriculumVitaeLink.attr 'href')
        if not $curriculumVitaeLink.data(newLanguage)?
            $curriculumVitaeLink.data(
                newLanguage, $curriculumVitaeLink.data(oldLanguage).substr(
                    0, $curriculumVitaeLink.data(oldLanguage).lastIndexOf(
                        '.'
                    ) - oldLanguage.length
                ) + newLanguage.substr(0, 2).toUpperCase(
                ) + newLanguage.substr(2).toLowerCase(
                ) + $curriculumVitaeLink.data(oldLanguage).substr(
                    $curriculumVitaeLink.data(oldLanguage).lastIndexOf '.'
                ))
        $curriculumVitaeLink.attr 'href', $curriculumVitaeLink.data(
            newLanguage)
        this
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
        this._options.dimensionIndicator.effectOptions.fadeIn.always = =>
            # Adapt menu highlighter after changing layout and
            # dimension indicator.
            this._highlightMenuEntry false
        this._options.dimensionIndicator.effectOptions.fadeOut.always = =>
            this.$domNodes.dimensionIndicator.html(
                this.stringFormat(
                    this._options.dimensionIndicator.template, newMode)
            ).fadeIn this._options.dimensionIndicator.effectOptions.fadeIn
        this.$domNodes.dimensionIndicator.stop().fadeOut(
            this._options.dimensionIndicator.effectOptions.fadeOut)
        super
    _onChangeToExtraSmallMode: ->
        ###
            This method triggers if the responsive design switches to
            extra small mode.

            **returns {$.HomePage}** - Returns the current instance.
        ###
        # Resets the image dependent section heights.
        this.$domNodes.section.children().css height: 'auto'
    _onSwitchSection: (sectionName) ->
        ###
            Switches to given section.

            **sectionName {String}** - Location to switch to.

            **returns {$.HomePage}** - Returns the current instance.
        ###
        direction = false
        if $.inArray(sectionName, ['next', 'prev']) isnt -1
            direction = sectionName
            sectionName = this._determineRelativeSections sectionName
        hash = "##{sectionName}"
        if hash is this.$domNodes.aboutThisWebsiteButton.attr 'href'
            window.location.hash = hash
            this._handleSwitchToAboutThisWebsite()
            this._adaptContentHeight()
        else
            sectionFound = false
            this.$domNodes.navigationButton.each (index, button) =>
                $button = $ button
                $sectionButton = $button.parent 'li'
                if not $sectionButton.length
                    $sectionButton = $button
                # NOTE: We need both brackets to follow the right logical
                # execution order.
                if $button.attr('href') is hash or (
                    hash is '#' and ((
                        this._currentMediaQueryMode is 'extraSmall' and
                        $button.attr('href') is '#contact'
                    ) or (
                        this._currentMediaQueryMode isnt 'extraSmall' and
                        index is 0
                    ))
                )
                    window.location.hash = $button.attr 'href'
                    sectionFound = true
                    if not $sectionButton.hasClass 'active'
                        this._performSectionSwitch(
                            sectionName, direction, index, $sectionButton)
                else
                    $sectionButton.removeClass 'active'
            # If no section could be determined initialize the first one.
            if not sectionFound
                forceSection = this.$domNodes.navigationButton.first(
                ).attr('href').substring('#'.length)
                this.debug "Force section \"#{forceSection}\"."
                return this._onSwitchSection forceSection
        if not this._initialContentHeightAdaptionDone
            this._adaptContentHeight()
        super
    // / endregion
    // / region helper
    _performSectionSwitch: (
        sectionName, direction, index, $sectionButton
    ) ->
        ###
            Switches to given section.

            **sectionName {String}**       - Section name.

            **direction {String|Boolean}** - Relative section position.

            **index {Number}**             - Index of section to switch to.

            **$sectionButton {domNode}**   - The current section button.

            **returns {$.Website}**        - Returns the current instance.
        ###
        this.$domNodes.aboutThisWebsiteSection.fadeOut(
            this._options.aboutThisWebsiteSection.fadeOut)
        this.debug "Switch to section \"#{sectionName}\"."
        # Swipe in endless cycle if we get a direction.
        index = direction if direction
        $sectionButton.addClass 'active'
        if this._viewportIsOnTop
            this.$domNodes.carousel.data('Swipe').slide index
            this._adaptContentHeight()
            return this._highlightMenuEntry()
        this._scrollToTop =>
            this.$domNodes.carousel.data('Swipe').slide index
            this._adaptContentHeight()
            this._highlightMenuEntry()
    _handleSwitchToAboutThisWebsite: ->
        ###
            Switches to about this website section.

            **returns {$.Website}** - Returns the current instance.
        ###
        this.debug(
            'Switch to section "' +
            "#{window.location.hash.substring '#'.length}\".")
        this.$domNodes.menuHighlighter.fadeOut(
            this._options.aboutThisWebsiteSection.fadeOut)
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
        super
        this._highlightMenuEntry()._adaptContentHeight()
    _removeLoadingCover: ->
        ###
            This method triggers after window is loaded. It overwrites the
            super method to wait for removing the loading cover until
            section height is adapted.

            **returns {$.Website}** - Returns the current instance.
        ###
        if(
            this._initialContentHeightAdaptionDone and
            not this._loadingCoverRemoved
        )
            this._loadingCoverRemoved = true
            super
        this
    _highlightMenuEntry: (transition=true) ->
        ###
            Highlights current menu entry.

            **$sectionButton {domNode}** - The current section button.

            @returns {$.HomePage}        - Returns the current instance.
        ###
        if this._currentMediaQueryMode isnt 'extraSmall' and this.windowLoaded
            $sectionButton = this.$domNodes.navigationButton.parent(
                'li'
            ).filter '.active'
            if $sectionButton.position()?.left
                if this._initialMenuHightlightDone and transition
                    $.extend true, this._options.menuHighlightAnimation,
                        left: $sectionButton.position().left
                        width: $sectionButton.width()
                        duration: this._options.carousel.speed
                    this.$domNodes.menuHighlighter.stop().fadeIn(
                        this._options.aboutThisWebsiteSection.fadeIn
                    ).animate this._options.menuHighlightAnimation
                else
                    this._initialMenuHightlightDone = true
                    this.$domNodes.menuHighlighter.stop().fadeIn(
                        this._options.aboutThisWebsiteSection.fadeIn
                    ).css
                        left: $sectionButton.position().left
                        width: $sectionButton.width()
        this
    _adaptContentHeight: ->
        ###
            Adapt the carousel height to current main section height.

            **returns {$.Swipe}** - Returns the new generated swipe
                                    instance.
        ###
        if(window.location.hash and ($currentSection =
            this.$domNodes.section.add(
                this.$domNodes.aboutThisWebsiteSection
            ).filter(".#{window.location.hash.substr 1}")) and
            $currentSection.length
        )
            newSectionHeightInPixel =
            this._determineSectionHeightInPixelForFooterPositioning(
                $currentSection)
            if (
                newSectionHeightInPixel and
                newSectionHeightInPixel isnt this._oldSectionHeightInPixel
            )
                this._oldSectionHeightInPixel = newSectionHeightInPixel
                newSectionHeightInPixel =
                this._adaptBackgroundDependentHeight(
                    newSectionHeightInPixel, $currentSection)
                # First stop currently running animations.
                if this.startUpAnimationIsComplete
                    this.$domNodes.footer.stop true
                    this.$domNodes.carousel.stop true
                transitionMethod = 'css'
                if this._initialContentHeightAdaptionDone
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
            if not this._initialContentHeightAdaptionDone
                this._initialContentHeightAdaptionDone = true
                this._removeLoadingCover() if this.windowLoaded
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
        newPseudoCarouselHeightInPixel = newSectionHeightInPixel
        # Make smooth transition till viewport ending.
        if transitionMethod is 'animate'
            if this.$domNodes.carousel.height() > this.$domNodes.window.height(
            )
                # If section height is larger than current viewport pre set
                # height to current viewport.
                this.$domNodes.carousel.css(
                    height: this.$domNodes.window.height())
            if newSectionHeightInPixel > this.$domNodes.window.height()
                # If new section height height is larger than current
                # viewport make the transition till current viewport and
                # reset after animation ist complete.
                newPseudoCarouselHeightInPixel =
                    this.$domNodes.window.height()
        this.$domNodes.carousel[transitionMethod] {
            height: newPseudoCarouselHeightInPixel
            duration: this._options.carousel.speed
        }, always: =>
            this.$domNodes.carousel.css height: newSectionHeightInPixel
            # Check if height has changed after adaption.
            if newSectionHeightInPixel isnt $currentSection.outerHeight()
                this._adaptContentHeight()
        this
    _adaptBackgroundDependentHeight: (
        newSectionHeightInPixel, $currentSection
    ) ->
        ###
            Adapts the background dependent sections height.

            **newSectionHeightInPixel {Number} - Section height to adapt
                                                 to.

            **$currentSection {domNode}**      - The current section dom
                                                 node.

            **returns {Number}**               - Returns the new calculated
                                                 section height in pixel.
        ###
        if this._currentMediaQueryMode is 'extraSmall' or $.inArray(
            window.location.hash.substring '#'.length
            this._options.backgroundDependentHeightSections
        ) is -1
            this.$domNodes.section.children().css marginTop: 0
            return this._determineSectionHeightInPixelForFooterPositioning(
                $currentSection)
        # Calculate stretched background sections.
        additionalMarginTopInPixel = 0
        if (
            newSectionHeightInPixel >
            this._options.maximumBackgroundDependentHeight
        )
            # Calculate the vertical centering margins.
            additionalMarginTopInPixel = (
                newSectionHeightInPixel -
                this._options.maximumBackgroundDependentHeight
            ) / 2
            newSectionHeightInPixel =
                this._options.maximumBackgroundDependentHeight
        $currentSection.children().css(
            height: newSectionHeightInPixel -
                this._sectionTopMarginInPixel)
        this.$domNodes.section.children().css(
            marginTop: additionalMarginTopInPixel)
        window.Math.max(
            this._determineSectionHeightInPixelForFooterPositioning(
                $currentSection
            ), window.parseInt(
                this.$domNodes.section.children().outerHeight()
            ) + window.parseInt(this.$domNodes.section.children().css(
                'marginTop'
            )) + this._sectionTopMarginInPixel)
    _determineSectionHeightInPixelForFooterPositioning: (
        $currentSection
    ) ->
        ###
            Determines the new section height in pixel after webview size
            or section has changed.

            **$currentSection {domNode}** - The current section dom node.

            **returns {Number}**          - Returns the new computed
                                            section height.
        ###
        if this._currentMediaQueryMode is 'extraSmall' or $.inArray(
            window.location.hash.substring '#'.length
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
                # If we have high screens we will let the footer stay on the
                # bottom.
                return this.$domNodes.window.height(
                ) - this.$domNodes.footer.height()
            return newSectionHeightInPixel
        this.$domNodes.window.height()
    _initializeSwipe: ->
        ###
            Attaches needed event handler to the swipe plugin and initializes
            the slider.

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
                            'href'
                        ).substring '#'.length)
                    return false
            return true
        # NOTE: A cyclic slide effect is more intuitive on touch devices.
        this._options.carousel.continuous =
            this._currentMediaQueryMode is 'extraSmall'
        this.$domNodes.carousel.Swipe this._options.carousel
    _addNavigationEvents: ->
        ###
            This method adds triggers to switch section.

            **returns {$.HomePage}** - Returns the current instance.
        ###
        toggleMobilMenu = (event) =>
            # This handler rebuilds bootstrap mobile menu collapse feature.
            slideOut = this.$domNodes.navigationWrapper.is '.in'
            this.$domNodes.navigationWrapper.one(
                this.transitionEndEventNames, =>
                    if slideOut
                        this.$domNodes.navigationWrapper.removeClass(
                            'collapsing in')
                        this.$domNodes.navigationWrapper.addClass(
                            'collapse')
                    else
                        this.$domNodes.navigationWrapper.removeClass(
                            'collapsing')
                        this.$domNodes.navigationWrapper.addClass(
                            'collapse in')
            )
            this.$domNodes.navigationWrapper.removeClass 'collapse'
            this.$domNodes.navigationWrapper.addClass 'collapsing'
            if slideOut
                this.$domNodes.navigationWrapper.height 0
                this.$domNodes.navigationWrapper.removeClass 'in'
            else
                this.$domNodes.navigationWrapper.height(
                    this.$domNodes.navigationWrapper.find(
                        'ul'
                    ).outerHeight true)
        this.on(
            this.$domNodes.mobileCollapseButton, 'click', toggleMobilMenu)
        if this._options.hideMobileMenuAfterSelection
            this.on this.$domNodes.navigationButton, 'click', =>
                if this._currentMediaQueryMode is 'extraSmall'
                    toggleMobilMenu.apply this, arguments
        this.on this.$domNodes.navigationButton.add(
            this.$domNodes.aboutThisWebsiteButton
        ), 'click', (event) =>
            this.fireEvent(
                'switchSection', false, this, $(event.target).attr(
                    'href'
                ).substring '#'.length)
        super
    _determineRelativeSections: (sectionName) ->
        ###
            Determines current section to the right or the left.

            **sectionName {String}** - Relative section ("next" or "prev").

            **returns {String}**     - Returns the absolute section name.
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
                if sectionName is 'next'
                    newIndex = (index + 1) % numberOfButtons
                else if sectionName is 'prev'
                    ###
                        NOTE: Subtracting 1 in the residue class ring means
                        adding the number of numbers minus 1. This prevents
                        us from getting negative button indexes.
                    ###
                    newIndex = (index + numberOfButtons - 1) %
                        numberOfButtons
                sectionName = $(
                    this.$domNodes.navigationButton[newIndex]
                ).attr('href').substring '#'.length
                false
        sectionName
    // / endregion
    // endregion
}
// endregion
$.HomePage = function():any {
    return $.Tools().controller(HomePage, arguments)
}
$.HomePage.class = HomePage
/** The jQuery-incrementer plugin class. */
export default HomePage
$.noConflict()(($):HomePage => $.HomePage({
    googleTrackingCode: 'UA-40192634-1', language: {
        allowedLanguages: ['enUS', 'deDE'], sessionDescription: 'website{1}'
    }
}))
// region vim modline
// vim: set tabstop=4 shiftwidth=4 expandtab:
// vim: foldmethod=marker foldmarker=region,endregion:
// endregion
