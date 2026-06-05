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
    copy,
    extend,
    getParents,
    globalContext,
    Logger,
    Mapping,
    NOOP,
    trailingThrottle
} from 'clientnode'
import {object} from 'clientnode/property-types'
import Headroom from 'headroom.js'
import Swiper from 'swiper'
import {Autoplay, HashNavigation, Navigation, Pagination} from 'swiper/modules'
import WaveSurfer from 'wavesurfer.js'
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
// region plugins/classes
/**
 * This plugin holds all necessary methods to extend a whole homepage.
 * @property _defaultOptions - Options extended by the options given to the
 * initializer method.
 * @property _defaultOptions.trackingCode {string} - Tracking code for
 * collection users metadata.
 * @property _defaultOptions.maximumFooterHeightInPercent {number} - Indicates
 * when the footer should stick to the bottom.
 * @property _defaultOptions.scrollInLinearTime {boolean} - Indicates whether
 * animated scrolling should be speeded up and brake or not.
 * @property _defaultOptions.backgroundDependentHeightSections - A list: of
 * section names which dimensions depend on their
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
            on-unfocus-responsive-menu="return !(
                parameters[1] ||
                Array.from(this.rootInstance.switchLanguageButtonDomNodes)
                    .includes(event.target)
            )"
        >
            <web-internationalization
                options="{selection: this.rootInstance.options.languages}"
                on-switch="
                    this.rootInstance.switchLanguageButton(parameters[1], this)
                "
                on-ensure="this.rootInstance.switchLanguageButton(data, this)"
                on-ensured="this.rootInstance.mainSwiper?.updateAutoHeight()"
                on-switched="this.rootInstance.mainSwiper?.updateAutoHeight()"
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
                initial: 'headroom',
                // when scrolling up
                pinned: 'headroom--pinned',
                // when scrolling down
                unpinned: 'headroom--unpinned',
                // when above offset
                top: 'headroom--top',
                // when below offset
                notTop: 'headroom--not-top',
                // when at bottom of scroll area
                bottom: 'headroom--bottom',
                // when not at bottom of scroll area
                notBottom: 'headroom--not-bottom',
                // when frozen method has been called
                frozen: 'headroom--frozen'
            }
        },

        languages: ['enUS', 'deDE'],

        selectors: {
            header: 'header',
            navigation: '.wu-priority-navigation',
            navigationButtons: '.wu-priority-navigation a',
            switchLanguageButtons: '.hp-switch-language',

            section: '.hp-section',

            mainSwiper: 'section.swiper',
            sectionSwiperWrapper: '.hp-section__swiper-wrapper',

            greetingHeadlines:
                '.hp-section__swiper-wrapper__slide--about-me h1',

            projectCards: '.hp-card',
            projectCardOpenClassName: 'hp-card--open',
            projectSwiper: '.hp-card .swiper',

            waveSurfer: '.hp-audio-player'
        },

        mainSwiper: {
            grabCursor: false,
            keyboard: true,
            centeredSlidesBounds: true,

            modules: [HashNavigation, Navigation, Pagination],

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
        },
        projectSwiper: {
            grabCursor: false,
            keyboard: true,
            centeredSlidesBounds: true,

            modules: [Autoplay, Pagination],

            simulateTouch: false,

            autoplay: {
                delay: 3000,
                pauseOnMouseEnter: true
            },

            a11y: true,

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
    mainSwiper: Swiper | null = null
    // region domNodes
    headerDomNode: HTMLElement | null = null
    navigationDomNodes: NodeListOf<HTMLElement> | null = null
    switchLanguageButtonDomNodes: NodeListOf<HTMLElement> | null = null

    sectionDomNode: HTMLElement | null = null

    mainSwiperDomNode: HTMLElement | null = null
    sectionSwiperWrapperDomNodes: NodeListOf<HTMLElement> | null = null

    greetingHeadlineDomNodes: NodeListOf<HTMLElement> | null = null

    projectCardDomNodes: NodeListOf<HTMLElement> | null = null
    projectSwiperDomNodes: NodeListOf<HTMLElement> | null = null

    waveSurferDomNodes: NodeListOf<HTMLElement> | null = null
    // endregion
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

        this.applyGreeting()

        if (this.headerDomNode) {
            const headroom =
                new Headroom(this.headerDomNode, this.options.headroom)
            headroom.init()
            // TODO headroom.destroy()
        }

        if (this.mainSwiperDomNode)
            this.mainSwiper = new Swiper(
                this.mainSwiperDomNode,
                {
                    ...this.options.mainSwiper,
                    on: {
                        slideChangeTransitionStart: () => {
                            this.sectionDomNode?.scrollTo({top: 0})
                            globalContext.window?.scrollTo({top: 0})
                        },
                        slideChangeTransitionEnd: (swiper) => {
                            this.sectionDomNode?.scrollTo({top: 0})
                            globalContext.window?.scrollTo({top: 0})
                            swiper.updateAutoHeight()
                        }
                    }
                }
            )

        this.applyProjectCardInteractions()

        if (globalContext.window)
            this.addSecureEventListener(
                globalContext.window,
                'resize',
                () => {
                    trailingThrottle(
                        () => {
                            this.mainSwiper?.updateSize()
                            this.mainSwiper?.updateAutoHeight()
                        },
                        20
                    )()
                }
            )

        /*
            NOTE: We have to use event delegation here since navigation links
            might switch its dom node representation position between mobile
            and normal menu. Doing it this way we avoid maintaining to assign
            and remove event listeners during runtime.
        */

        for (const domNode of this.navigationDomNodes || [])
            this.addSecureEventListener(domNode, 'click', (event) => {
                const domNode = (event.target as HTMLElement).closest(
                    this.options.selectors.navigationButtons
                )
                if (!domNode)
                    return

                /*
                    NOTE: Prevent jumping to headline's page position with
                    matching id.
                */
                event.preventDefault()

                if (!globalContext.window)
                    return

                const newHash = domNode.getAttribute('href')
                const oldURL = globalContext.window.location.href

                /*
                    Update browser URL and history stack without triggering
                    native event.
                */
                globalContext.window.history.pushState(null, '', newHash)

                // Manually construct and fire the synthetic "HashChangeEvent".
                const hashEvent = new HashChangeEvent(
                    'hashchange',
                    {
                        oldURL: oldURL,
                        newURL: globalContext.window.location.href
                    }
                )

                globalContext.window.dispatchEvent(hashEvent)
            })

        for (const domNode of this.waveSurferDomNodes || []) {
            const url = domNode.firstElementChild?.textContent.trim()
            const waveSurfer = WaveSurfer.create({
                container: domNode,

                dragToSeek: false,
                interact: false,

                waveColor: '#86228a',
                progressColor: '#eb9be7',

                barHeight: 10,
                cursorWidth: 0,
                barWidth: 3,
                barGap: 9,

                url
            })
            this.addSecureEventListener(
                domNode,
                'click',
                () => {
                    void waveSurfer.playPause()
                }
            )
        }

        await this.resolveRenderingPromiseIfSet(reason, resolveRendering)
    }
    /// endregion
    grabDomNodes() {
        this.headerDomNode =
            this.hostDomNode.querySelector(this.options.selectors.header)
        this.navigationDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.navigation
        )
        this.switchLanguageButtonDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.switchLanguageButtons
        )

        this.mainSwiperDomNode =
            this.hostDomNode.querySelector(this.options.selectors.mainSwiper)
        this.sectionDomNode =
            this.hostDomNode.querySelector(this.options.selectors.section)
        this.sectionSwiperWrapperDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.sectionSwiperWrapper
        )

        this.greetingHeadlineDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.greetingHeadlines
        )

        this.projectCardDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.projectCards
        )
        this.projectSwiperDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.projectSwiper
        )

        this.waveSurferDomNodes = this.hostDomNode.querySelectorAll(
            this.options.selectors.waveSurfer
        )
    }
    applyProjectCardInteractions() {
        if (!(
            this.projectCardDomNodes &&
            this.projectSwiperDomNodes &&
            globalContext.document
        ))
            return

        for (const domNode of this.projectSwiperDomNodes)
            new Swiper(domNode, copy(this.options.projectSwiper))

        let openProjectDomNode: HTMLElement | null = null
        let openProjectPresenterDomNode: HTMLElement | null = null
        let closeOpenPresenterDomNode: () => void = NOOP
        for (const domNode of this.projectCardDomNodes)
            this.addSecureEventListener(
                domNode,
                'click',
                () => {
                    if (openProjectDomNode === domNode)
                        return

                    closeOpenPresenterDomNode()

                    openProjectDomNode = domNode
                    openProjectPresenterDomNode =
                        domNode.cloneNode(true) as HTMLElement
                    domNode.after(openProjectPresenterDomNode)
                    openProjectPresenterDomNode.classList.add(
                        this.options.selectors.projectCardOpenClassName
                    )

                    /*
                        Listen for clicks anywhere on the webpage to close
                        opened project.
                    */
                    const deregister = this.addSecureEventListener(
                        globalContext.document as Node,
                        'click',
                        (event) => {
                            const clickWasInOpenProjectCard = Boolean(
                                event.target &&
                                getParents(event.target as Node)
                                    .some((parentDomNode) =>
                                        openProjectPresenterDomNode ===
                                            parentDomNode ||
                                        openProjectDomNode === parentDomNode
                                    )
                            )
                            if (!clickWasInOpenProjectCard)
                                closeOpenPresenterDomNode()
                        }
                    )
                    closeOpenPresenterDomNode = () => {
                        /*
                        TODO

                        openProjectDomNode.addEventListener(
                            'transitionend',
                            () => {*/
                        deregister()
                        openProjectPresenterDomNode?.remove()
                        openProjectDomNode = null
                        openProjectPresenterDomNode = null
                        closeOpenPresenterDomNode = NOOP/*
                            }
                        )
                        openProjectDomNode.classList.remove(
                            this.options.selectors.projectCardOpenClassName
                        )*/
                    }
                }
            )
    }
    applyGreeting() {
        if (!this.greetingHeadlineDomNodes?.length)
            return

        const greets = [
            {
                enUS: 'What are you doing that early?',
                deDE: 'Was machst du so früh?'
            },
            {
                enUS: 'Good Morning',
                deDE: 'Guten Morgen'
            },
            {
                enUS: 'Good Afternoon',
                deDE: 'Moin'
            },
            {
                enUS: 'Good Evening',
                deDE: 'Guten Abend'
            }
        ]
        const currentHours = new Date().getHours()
        const index = Math.floor(currentHours / 24 * greets.length)
        for (const domNode of this.greetingHeadlineDomNodes)
            domNode.innerHTML =
                `${greets[index].enUS}<!--deDE:${greets[index].deDE}-->`
    }
    switchLanguageButton(
        newLanguage: string, languageComponentInstance: WebInternationalization
    ) {
        for (
            const domNode of
            languageComponentInstance.switchLanguageButtonDomNodes ||
            []
        )
            for (const language of languageComponentInstance.options.selection)
                if (language !== newLanguage) {
                    const url = domNode.getAttribute('href')
                    if (url) {
                        domNode.setAttribute(
                            'href',
                            url.replace(/^(#lang-).+$/, `$1${language}`)
                        )
                        domNode.innerText = language.substr(0, 2)
                    }
                }
    }
    // endregion
    // region protected methods
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
