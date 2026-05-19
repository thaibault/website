// #!/usr/bin/env babel-node
// -*- coding: utf-8 -*-
/** @module website */
'use strict'
/* !
    region header
    [Project page](https://torben.website)

    Copyright Torben Sickert (info["~at~"]torben.website) 16.12.2012

    License
    -------

    This library written by Torben Sickert stands under a creative commons
    naming 3.0 unported license.
    See https://creativecommons.org/licenses/by/3.0/deed.de
    endregion
*/
// region imports
import {
    camelCaseToDelimited,
    createDomNodes,
    extend,
    format,
    getAll,
    getText,
    globalContext,
    KEYBOARD_CODES,
    Logger,
    Mapping,
    NOOP,
    wrap
} from 'clientnode'
import {func, object} from 'clientnode/property-types'
import Headroom from 'headroom.js'
import Swiper from 'swiper'
import {
    EffectCube, HashNavigation, Navigation, Pagination, Scrollbar
} from 'swiper/modules'
import {property} from 'web-component-wrapper/decorator'
import {WebComponentAPI} from 'web-component-wrapper/type'
import {Web} from 'web-component-wrapper/Web'
import {api as websiteUtilitiesAPI} from 'website-utilities'
import WebInternationalization, {
    api as webInternationalizationAPI
} from 'web-internationalization'

import {DefaultOptions, Options} from './type'
// endregion
export const log = new Logger({name: 'website'})
// region declaration
declare var OFFLINE: boolean
// endregion
// region plugins/classes
/**
 * This plugin holds all necessary methods to extend a whole homepage.
 * @property static:_name - Defines this class name to allow retrieving them
 * after name mangling.
 *
 * @property _initialContentHeightAdaptionDone - Indicates whether initial main
 * content height has been adapted.
 * @property _initialMenuHightlightDone - Indicates whether initial menu
 * highlighting has been done.
 * @property _loadingCoverRemoved - Indicates whether startup loading cover has
 * been removed.
 * @property _oldSectionHeightInPixel - Old section height needed for section
 * switch animations.
 * @property _sectionTopMarginInPixel - Distance to window top from the section
 * body.
 * @property _defaultOptions - Options extended by the options given to the
 * initializer method.
 * @property _defaultOptions.trackingCode {string} - Tracking code for
 * collection users metadata.
 * @property _defaultOptions.maximumFooterHeightInPercent {number} - Indicates
 * when the footer should stick to the bottom.
 * @property _defaultOptions.scrollInLinearTime {boolean} - Indicates whether
 * animated scrolling should be speeded up and brake or not.
 * @property _defaultOptions.backgroundDependentHeightSections
 * {Array.<string>} - A list: of section names which dimensions depend on their
 * background image.
 * @property _defaultOptions.maximumBackgroundDependentHeight {number} - Upper
 * range bound until a dynamic background image adjusted is needed.
 * @property _defaultOptions.menuHighlightAnimation {Object} - Options for menu
 * highlight animation.
 * @property _defaultOptions.hideMobileMenuAfterSelection {boolean} - Indicates
 * whether the mobile menu should be hide after a menu item was selected.
 * @property _defaultOptions.domNode {Object} - Mapping if needed dom node
 * descriptions to their corresponding selectors.
 * @property _defaultOptions.carousel {Object} - Options for the integrated
 * section carousel.
 * @property _defaultOptions.dimensionIndicator {Object} - Options for the
 * injectable dimension indicator.
 * @property _defaultOptions.dimensionIndicator.template {string} - Markup for
 * injectable dimension indicator to show current media query mode.
 * @property _defaultOptions.dimensionIndicator.effectOptions {Object} -
 * Options for showing and hiding the dimension indicator between a dimension
 * change.
 * @property _defaultOptions.dimensionIndicator.effectOptions.showAnimation
 * {Object} - Options for the show animation.
 * @property _defaultOptions.dimensionIndicator.effectOptions.hideAnimation
 * {Object} - Options for the hide animation.
 * @property _defaultOptions.aboutThisWebsiteSection {Object} - Animation
 * options for showing and hiding the about this website section.
 * @property _defaultOptions.aboutThisWebsiteSection.showAnimation {Object} -
 * Show options.
 * @property _defaultOptions.aboutThisWebsiteSection.hideAnimation {Object} -
 * Hide options.
 */
export class HomePage<
    TElement = HTMLElement,
    ExternalProperties extends Mapping<unknown> = Mapping<unknown>,
    InternalProperties extends Mapping<unknown> = Mapping<unknown>
> extends Web<TElement, ExternalProperties, InternalProperties> {
    static content = `
        <website-utilities
            options="{
                sectionNames: {
                    default: 'about-me',
                    managed: ['about-this-website'],
                    unmanaged: ['about-me', 'contact', 'work']
                }
            }"
            on-section-switch="this.rootInstance._onSwitchSection(data)"
        >
            <web-internationalization
                options="{selection: this.rootInstance.options.languages}"
                on-switch="this.rootInstance.prepareToSwitchLanguage(parameters[0], parameters[1], this)"
                on-switched="/* TODO this.rootInstance._adaptContentHeight()*/"
                on-ensured="this.rootInstance.prepareToSwitchLanguage(this.currentLanguage, data, this)/*this.rootInstance._adaptContentHeight()*/"
            >
                <slot>Please provide a template to transclude.</slot>
            </web-internationalization>
        </website-utilities>
    `

    static _name = 'HomePage'

    static _defaultOptions: DefaultOptions = {
        trackingCode: 'UA-40192634-1',
        maximumFooterHeightInPercent: 50,
        backgroundDependentHeightSections: ['about-me'],
        maximumBackgroundDependentHeight: 750,
        hideMobileMenuAfterSelection: true,

        headroom: {
            offset: {
                down: 100,
                up: 0
            },
            tolerance: 0,
            classes: {
                // when element is initialized
                initial : 'headroom',
                // when scrolling up
                pinned : 'headroom--pinned',
                // when scrolling down
                unpinned : 'headroom--unpinned',
                // when above offset
                top : 'headroom--top',
                // when below offset
                notTop : 'headroom--not-top',
                // when at bottom of scroll area
                bottom : 'headroom--bottom',
                // when not at bottom of scroll area
                notBottom : 'headroom--not-bottom',
                // when frozen method has been called
                frozen: 'headroom--frozen',
                // multiple classes are also supported with a space-separated list
                pinned: 'headroom--pinned foo bar'
            }
        },

        languages: ['enUS', 'deDE'],

        selectors: {
            header: 'header',
            swiper: '.swiper',
            curriculumVitaeLink: 'a[href*="curriculumVitae"]',
            section: '.hp-section',
            sectionSwiperWrapper: '.hp-section__swiper-wrapper',
            navigationButtons: '.wu-priority-navigation a'
        },

        swiper: {
            grabCursor: true,
            keyboard: true,
            centeredSlidesBounds: true,

            modules: [EffectCube, HashNavigation, Navigation, Pagination],

            autoHeight: true,

            a11y: true,

            hashNavigation: {
                watchState: true
            },

            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev'
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
                type: 'bullets'
            }
        }
    }

    static doRender = true

    readonly self = HomePage
    // region api properties
    @property({type: object})
        options = {} as Options
    // endregion
    swiper: Swiper | null = null
    // region domNodes
    headerDomNode: HTMLElement | null = null
    swiperDomNode: HTMLElement | null = null
    curriculumVitaeLinkDomNodes: NodeListOf<HTMLLinkElement> | null = null
    sectionDomNode: HTMLElement | null = null
    sectionSwiperWrapperDomNodes: HTMLElement | null = null
    navigationButtonDomNodes: NodeListOf<HTMLElement> | null = null
    // endregion
    _initialContentHeightAdaptionDone = false
    _initialMenuHighlightDone = false

    _oldSectionHeightInPixel = 200
    _sectionTopMarginInPixel = 0
    // region public methods
    /// region live-cycle
    /**
     * Defines dynamic getter and setter interface and resolves a configuration
     * object. Initializes the map implementation.
     */
    constructor() {
        super()

        /*
            Babel property declaration transformation overwrites defined
            properties at the end of an implicit constructor. So we have to
            redefine them as long as we want to declare expected component
            interface properties to enable static type checks.
        */
        this.defineGetterAndSetterInterface()
    }
    /**
     * Triggered when ever a given attribute has changed and triggers to update
     * configured dom content.
     * @param name - Attribute name which was updates.
     * @param newValue - New updated value.
     * @returns Returns promise resolving when attribute has been updated.
     */
    async onUpdateAttribute(name: string, newValue: string): Promise<void> {
        await super.onUpdateAttribute(name, newValue)

        if (name === 'options')
            this._extendOptions()
    }
    /**
     * Updates controlled dom elements.
     * @param reason - Why an update has been triggered.
     * @param resolveRendering - Indicates whether rendering should be resolved
     * finally. Should be set to "false" via super calls in inherited render
     * methods which do further dom manipulations afterward and resolve the
     * rendering process by their own.
     * @returns A promise resolving when rendering has finished. A promise may
     * be needed for classes inheriting from this class.
     */
    async render(reason = 'unknown', resolveRendering = true): Promise<void> {
        if (Object.keys(this.options).length === 0)
            this._extendOptions()

        await super.render(reason, false)

        await this.waitForNestedComponentRendering()

        this.grabDomNodes()

        const headroom =
            new Headroom(this.headerDomNode, this.options.headroom)
        headroom.init()
        // headroom.destroy()

        this.swiper = new Swiper(
            this.swiperDomNode,
            {
                ...this.options.swiper,
                on: {
                    slideChangeTransitionStart: () => {
                        this.sectionDomNode.scrollTo({top: 0})
                        globalContext.window?.scrollTo({top: 0})
                    },
                    slideChangeTransitionEnd: (swiper: Swiper) => {
                        this.sectionDomNode.scrollTo({top: 0})
                        globalContext.window?.scrollTo({top: 0})
                        swiper.updateAutoHeight()
                    }
                }
            }
        )
        if (globalContext.window)
            this.addSecureEventListener(
                globalContext.window,
                'resize', () => {
                    this.swiper.updateAutoHeight()
                }
            )

        // navigation
        for (const domNode of this.navigationButtonDomNodes)
            this.addSecureEventListener(domNode, 'click', (event) => {
                /*
                    NOTE: Prevent jumping to headline's page position with
                    matching id.
                */
                event.preventDefault()

                const newHash = domNode.getAttribute('href')
                const oldURL = window.location.href

                /*
                    Update browser URL and history stack without triggering
                    native event.
                */
                window.history.pushState(null, '', newHash)

                // Manually construct and fire the synthetic "HashChangeEvent".
                const hashEvent = new HashChangeEvent('hashchange', {
                    oldURL: oldURL,
                    newURL: window.location.href
                })

                window.dispatchEvent(hashEvent)
            })

        // TODO
        return
        this.constructor.extend(true, options, {language: {
            onEnsure: (oldLanguage: string, newLanguage: string): any => {
                const result: any = !initialOnEnsureCallback || (
                    initialOnEnsureCallback.call(
                        this, oldLanguage, newLanguage))
                // Add language toggle button functionality.
                $(`a[href="#language-${newLanguage}"]`).attr(
                    'href', `#language-${oldLanguage}`
                ).text(oldLanguage.substr(0, 2))
                self._adaptCurriculumVitaeLink(oldLanguage, newLanguage)
                return result
            }
        }})
        // Disable tab functionality to prevent inconsistent carousel states.
        this.on(this.$domNodes.parent, 'keydown', (event: Object) => {
            if (event.code === KEYBOARD_CODES.TAB)
                event.preventDefault()
        })
        this.$domNodes.aboutThisWebsiteSection.hide().css(
            'position', 'absolute')
        if (!(
            'location' in $.global && $.global.location.hash &&
            this.$domNodes.navigationButton.parent('li').children(
                this.$domNodes.navigationButton
            ).add(this.$domNodes.aboutThisWebsiteButton).filter(
                `[href="${$.global.location.hash}"]`
            ).length
        ))
            $.global.location.hash = this.$domNodes.navigationButton.parent(
                'li'
            ).filter('.active').children(this.$domNodes.navigationButton).attr(
                'href')
        this._initializeSwipe()
        if ('location' in $.global)
            this.fireEvent(
                'switchSection', false, this, $.global.location.hash.substring(
                    '#'.length))
        this.on(
            this.$domNodes.window, 'resize',
            this._adaptContentHeight.bind(this))

        return this
    }
    /// endregion
    grabDomNodes() {
        this.headerDomNode =
            this.hostDomNode.querySelector(this.options.selectors.header)
        this.swiperDomNode =
            this.hostDomNode.querySelector(this.options.selectors.swiper)
        this.sectionDomNode =
            this.hostDomNode.querySelector(this.options.selectors.section)
        this.sectionSwiperWrapperDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.sectionSwiperWrapper
        )
        this.navigationButtonDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.navigationButtons
        )
    }
    async prepareToSwitchLanguage(
        oldLanguage: string,
        newLanguage: string,
        languageComponentInstance: WebInternationalization
    ) {
        for (
            const domNode of
            languageComponentInstance.switchLanguageButtonDomNodes
        )
            for (const language of languageComponentInstance.options.selection)
                if (language !== newLanguage) {
                    domNode.setAttribute(
                        'href',
                        domNode.getAttribute('href')
                            .replace(/^(#lang-).+$/, `$1${language}`)
                    )
                    domNode.innerText = language.substr(0, 2)
                }
    }
    // endregion
    // region protected methods
    /// region event
    /**
     * This method triggers if the responsive design switches to another
     * resolution mode.
     * @param oldMode - Old media query mode.
     * @param newMode - New media query mode.
     * @returns Returns the current instance.
     */
    _onChangeMediaQueryMode(oldMode: string, newMode: string): HomePage {
        console.log('TODO', oldMode, newMode)

        // TODO
        return

        // Determine top margin for image-dependent sections.
        this.$domNodes.section.children().css('margin-top', '')

        if ('getComputedStyle' in $.global)
            this._sectionTopMarginInPixel = parseInt(
                $.global.getComputedStyle($('h1')[1], ':before').height, 10
            )
    }
    /**
     * This method triggers if the responsive design switches to extra small
     * mode.
     * @returns Returns the current instance.
     */
    _onChangeToExtraSmallMode(): HomePage {
        // Resets the image-dependent section heights.
        this.$domNodes.section.children().css('height', 'auto')
        return this
    }
    /**
     * Switches to the given section.
     * @param sectionName - Location to switch to.
     * @returns Returns the current instance.
     */
    async _onSwitchSection(sectionName: string) {
        const currentSectionDomNode = this.hostDomNode.querySelector(
            `.hp-section__swiper-wrapper__slide__image-${sectionName}`
        )

        return

        if (['next', 'prev'].includes(sectionName))
            sectionName = this._determineRelativeSections(sectionName)
        const hash: string = `#${sectionName}`
        if (hash === this.$domNodes.aboutThisWebsiteButton.attr('href')) {
            if ('location' in $.global)
                $.global.location.hash = hash
            this._handleSwitchToAboutThisWebsite()
            this._adaptContentHeight()
        } else {
            let sectionFound: boolean = false
            this.$domNodes.navigationButton.each((
                index: number, button: DomNode
            ): void => {
                const $button: $DomNode = $(button)
                let $sectionButton: $DomNode = $button.parent('li')
                if (!$sectionButton.length)
                    $sectionButton = $button
                /*
                    NOTE: We need both brackets to follow the right logical
                    execution order.
                */
                if (
                    $button.attr('href') === hash || (
                        hash === '#' && (
                            this._currentMediaQueryMode === 'extraSmall' &&
                            $button.attr('href') === '#contact' ||
                            this._currentMediaQueryMode !== 'extraSmall' &&
                            index === 0))
                ) {
                    if ('location' in $.global)
                        $.global.location.hash = $button.attr('href')
                    sectionFound = true
                    if (!$sectionButton.hasClass('active'))
                        this._performSectionSwitch(
                            sectionName, index, $sectionButton)
                } else
                    $sectionButton.removeClass('active')
            })
            // If no section could be determined, initialize the first one.
            if (!sectionFound) {
                const forceSection: string =
                    this.$domNodes.navigationButton.first().attr(
                        'href'
                    ).substring('#'.length)
                this.debug(`Force section "${forceSection}".`)
                return this._onSwitchSection(forceSection)
            }
        }
        if (!this._initialContentHeightAdaptionDone)
            this._adaptContentHeight()

        return super._onSwitchSection(sectionName)
    }
    /// endregion
    /// region helper
    /**
     * Extends given options by default options.
     */
    _extendOptions() {
        /*
            NOTE: Using the internal setter avoids triggering an additional
            rendering.
        */
        this.setPropertyValue(
            'options',
            extend<Options>(true, {}, this.self._defaultOptions, this.options)
        )
    }
    /**
     * Switches to the given section.
     * @param sectionName - Section name to switch to.
     * @param index - Index of a section to switch to.
     * @param $sectionButton - The current section button.
     * @returns Returns the current instance.
     */
    _performSectionSwitch(
        sectionName: string, index: number, $sectionButton: $DomNode
    ): HomePage {
        this.$domNodes.aboutThisWebsiteSection.animate(
            ...this._options.aboutThisWebsiteSection.hideAnimation)
        this.debug(`Switch to section "${sectionName}".`)
        $sectionButton.addClass('active')
        if (this._viewportIsOnTop) {
            this.$domNodes.carousel.data('Swipe').slide(index)
            this._adaptContentHeight()
            return this._highlightMenuEntry()
        }

        return this.scrollToTop(() => {
            this.$domNodes.carousel.data('Swipe').slide(index)
            this._adaptContentHeight()
            this._highlightMenuEntry()
        })
    }
    /**
     * Switches to about this website section.
     * @returns Returns the current instance.
     */
    _handleSwitchToAboutThisWebsite(): HomePage {
        if ('location' in $.global)
            this.debug(
                'Switch to section "' +
                `${$.global.location.hash.substring('#'.length)}".`)
        this.scrollToTop()
        this.$domNodes.menuHighlighter.animate(
            ...this._options.aboutThisWebsiteSection.hideAnimation)
        this.$domNodes.section.animate(
            ...this._options.aboutThisWebsiteSection.hideAnimation)
        // TODO bei umstellung auf animate statt fadeIn und fadeOut ist display
        // nicht mehr richtig gesetzt..
        this.$domNodes.aboutThisWebsiteSection.css('display', 'block')
        this.$domNodes.aboutThisWebsiteSection.animate(
            ...this._options.aboutThisWebsiteSection.showAnimation)
        this.$domNodes.navigationButton.parent('li').removeClass('active')
        return this
    }
    /**
     * This method is complete if the last startup animation was initialized.
     * @param parameter - Forwards all given arguments to registered startup
     * animation complete handler callback.
     * @returns Returns the current instance.
     */
    _onStartUpAnimationComplete(...parameter: Array<any>): HomePage {
        super._onStartUpAnimationComplete(...parameter)
        return this._highlightMenuEntry()._adaptContentHeight()
    }
    /**
     * This method triggers after a window is loaded. It overwrites the super
     * method to wait for removing the loading cover until section height is
     * adapted.
     * @param parameter - Forwards all given arguments to registered callbacks.
     * @returns Returns the current instance.
     */
    _removeLoadingCover(...parameter: Array<any>): HomePage {
        if (
            this._initialContentHeightAdaptionDone &&
            !this._loadingCoverRemoved
        ) {
            this._loadingCoverRemoved = true
            super._removeLoadingCover(...parameter)
        }
        return this
    }
    /**
     * Highlights current menu entry.
     * @param transition - Indicates whether to use configured transition.
     * @returns Returns the current instance.
     */
    _highlightMenuEntry(transition = true): HomePage {
        if (
            this._currentMediaQueryMode !== 'extraSmall' && this.windowLoaded
        ) {
            const $sectionButton: $DomNode =
                this.$domNodes.navigationButton.parent('li').filter('.active')
            const sectionButtonPosition: {
                left: number;
                top: number;
            } = $sectionButton.position()
            if (sectionButtonPosition && sectionButtonPosition.left)
                if (this._initialMenuHightlightDone && transition) {
                    this.constructor.extend(
                        true,
                        this._options.menuHighlightAnimation,
                        {
                            left: $sectionButton.position().left,
                            width: $sectionButton.width(),
                            duration: this._options.carousel.speed
                        }
                    )
                    this.$domNodes.menuHighlighter.stop().animate(
                        ...this._options.aboutThisWebsiteSection.showAnimation
                    ).animate(this._options.menuHighlightAnimation)
                } else {
                    this._initialMenuHightlightDone = true
                    this.$domNodes.menuHighlighter.stop().animate(
                        ...this._options.aboutThisWebsiteSection.showAnimation
                    ).css({
                        left: $sectionButton.position().left,
                        width: $sectionButton.width()
                    })
                }
        }
        return this
    }
    /**
     * Adapt the carousel height to the current main section height.
     * @returns Returns the new generated swipe instance.
     */
    _adaptContentHeight(): HomePage {
        if ('location' in $.global && $.global.location.hash) {
            const $currentSection: $DomNode = this.$domNodes.section
                .add(this.$domNodes.aboutThisWebsiteSection)
                .filter(`.${$.global.location.hash.substring(1)}`)
            if ($currentSection && $currentSection.length) {
                let newSectionHeightInPixel: number =
                    this._determineSectionHeightInPixel($currentSection)
                if (
                    newSectionHeightInPixel &&
                    newSectionHeightInPixel !== this._oldSectionHeightInPixel
                ) {
                    this._oldSectionHeightInPixel = newSectionHeightInPixel
                    /* TODO
                    newSectionHeightInPixel =
                        this._adaptBackgroundDependentHeight(
                            newSectionHeightInPixel, $currentSection)
                    */
                    // First, stop currently running animations.
                    if (this.startUpAnimationIsComplete) {
                        this.$domNodes.footer.stop(true)
                        this.$domNodes.carousel.stop(true)
                    }
                    let transitionMethod: string = 'css'
                    if (this._initialContentHeightAdaptionDone)
                        transitionMethod = 'animate'
                    /*
                        NOTE: If current section is "about-this-website" we
                        place it in front of last selected section and position
                        footer absolutely.
                    */
                    if (
                        'location' in $.global &&
                        $.global.location.hash === '#about-this-website'
                    ) {
                        // Move footer from last known position.
                        this.$domNodes.footer.css({
                            position: 'absolute',
                            top: this.$domNodes.carousel.height()})
                        this.$domNodes.footer[transitionMethod]({
                            top: newSectionHeightInPixel
                        }, {
                            duration: this._options.carousel.speed
                        })
                        this.$domNodes.carousel.height(newSectionHeightInPixel)
                    } else
                        this._adaptSectionHeight(
                            transitionMethod, newSectionHeightInPixel,
                            $currentSection)
                }
                if (!this._initialContentHeightAdaptionDone) {
                    this._initialContentHeightAdaptionDone = true
                    if (!this._loadingCoverRemoved)
                        this._removeLoadingCover()
                }
            }
        }
        return this
    }
    /**
     * Adapts the new section height after window resizing or section switch.
     * @param transitionMethodName - Method name to perform adaption.
     * @param newSectionHeightInPixel - Section height to adapt to.
     * @param $currentSection - The current section dom node.
     * @returns Returns the current instance.
     */
    _adaptSectionHeight(
        transitionMethodName: string,
        newSectionHeightInPixel: number,
        $currentSection: $DomNode
    ): HomePage {
        this.$domNodes.footer.css({position: 'relative', top: 0})
        let newPseudoCarouselHeightInPixel: number = newSectionHeightInPixel
        // Make smooth transition till viewport ending.
        if (transitionMethodName === 'animate') {
            if (this.$domNodes.carousel.height(
            ) > this.$domNodes.window.height())
                /*
                    If section height is larger than current viewport pre-set
                    height to current viewport.
                */
                this.$domNodes.carousel.css(
                    'height', this.$domNodes.window.height())
            if (newSectionHeightInPixel > this.$domNodes.window.height())
                /*
                    If new section height is larger than current viewport make
                    the transition till current viewport and reset after
                    animation completes.
                */
                newPseudoCarouselHeightInPixel = this.$domNodes.window.height()
        }
        this.$domNodes.carousel[transitionMethodName]({
            height: newPseudoCarouselHeightInPixel
        }, {
            duration: this._options.carousel.speed,
            always: () => {
                this.$domNodes.carousel.css('height', newSectionHeightInPixel)
                // Check if height has changed after adaption.
                if (newSectionHeightInPixel !== $currentSection.outerHeight())
                    this._adaptContentHeight()
            }
        })
        return this
    }
    /**
     * Adapts the background-dependent sections' height.
     * @param newSectionHeightInPixel - Section height to adapt to.
     * @param $currentSection - The current section dom node.
     * @returns Returns the new calculated section height in pixel.
     */
    _adaptBackgroundDependentHeight(
        newSectionHeightInPixel: number, $currentSection: $DomNode
    ): number {
        if (
            this._currentMediaQueryMode === 'extraSmall' ||
            'location' in $.global &&
            !this._options.backgroundDependentHeightSections.includes(
                $.global.location.hash.substring('#'.length))
        ) {
            this.$domNodes.section.children().css('marginTop', 0)
            return this._determineSectionHeightInPixel($currentSection)
        }
        // Calculate stretched background sections.
        let additionalMarginTopInPixel = 0
        if (
            newSectionHeightInPixel >
            this._options.maximumBackgroundDependentHeight
        ) {
            // Calculate the vertical centering margins.
            additionalMarginTopInPixel = (
                newSectionHeightInPixel -
                this._options.maximumBackgroundDependentHeight
            ) / 2
            newSectionHeightInPixel =
                this._options.maximumBackgroundDependentHeight
        }
        $currentSection.children().css(
            'height', newSectionHeightInPixel - this._sectionTopMarginInPixel)
        this.$domNodes.section.children().css(
            'marginTop', additionalMarginTopInPixel)
        return Math.max(
            this._determineSectionHeightInPixel($currentSection),
            parseInt(
                this.$domNodes.section.children().outerHeight(), 10
            ) +
            parseInt(
                this.$domNodes.section.children().css('marginTop'), 10
            ) +
            this._sectionTopMarginInPixel
        )
    }
    /**
     * Determines the new section height in the pixel after webview size or
     * section has changed.
     * @param $currentSection - The current section dom node.
     * @returns Returns the new computed section height.
     */
    _determineSectionHeightInPixel($currentSection: $DomNode):number {
        if (
            this._currentMediaQueryMode === 'extraSmall' ||
            'location' in $.global &&
            this._options.backgroundDependentHeightSections.includes(
                $.global.location.hash.substring('#'.length))
        ) {
            const newSectionHeightInPixel: number = $currentSection.outerHeight(
            )
            const footerHeightInPixel: number = this.$domNodes.document.height(
            ) - newSectionHeightInPixel
            const footerHeightInPercent: number = (footerHeightInPixel * 100) /
                this.$domNodes.document.height()
            if (
                this._options.maximumFooterHeightInPercent <
                    footerHeightInPercent &&
                newSectionHeightInPixel < this.$domNodes.document.height(
                ) - this.$domNodes.footer.height()
            )
                /*
                    If we have a high resolution available, we will let the
                    footer stay on the bottom.
                */
                return this.$domNodes.document.height(
                ) - this.$domNodes.footer.height()
            return newSectionHeightInPixel
        }
        return this.$domNodes.document.height()
    }
    /// endregion
    // endregion
}
// endregion
export const api: WebComponentAPI<
    HTMLElement, Mapping<unknown>, Mapping<unknown>, typeof Web
> = {
    component: HomePage,
    register: (
        tagName: string = camelCaseToDelimited(HomePage._name)
    ) => {
        websiteUtilitiesAPI.register()
        webInternationalizationAPI.register()

        customElements.define(tagName, HomePage)
    }
}
export default HomePage

if ((globalContext as Mapping<boolean>).AUTO_DEFINE_HOME_PAGE)
    api.register()
// endregion
