// #!/usr/bin/env babel-node
// -*- coding: utf-8 -*-
'use strict'
/* !
    region header
    Copyright Torben Sickert (info["~at~"]tsickert.com) 16.12.2012

    License
    -------

    This library written by Torben Sickert stands under a creative commons
    naming 3.0 unported license.
    See https://creativecommons.org/licenses/by/3.0/deed.de
    endregion
*/
// region imports
import {afterEach, beforeAll, describe, expect, jest, test} from '@jest/globals'
import '@webcomponents/webcomponentsjs/custom-elements-es5-adapter'
import type WebInternationalization from 'web-internationalization'

import HomePage, {api} from './index'
// endregion
describe('HomePage', (): void => {
    let root: HomePage

    beforeAll(async () => {
        api.register()
        root = document.createElement('home-page') as HomePage
        document.body.appendChild(root)

        await root.renderState.promise
    })
    afterEach(() => {
        jest.restoreAllMocks()
    })
    // region tests
    test('should be defined', () => {
        expect(root).toBeDefined()
    })
    /// region register
    test('register', () => {
        expect(customElements.get('home-page')).toStrictEqual(HomePage)
        expect(customElements.get('website-utilities')).toBeDefined()
        expect(customElements.get('web-internationalization')).toBeDefined()
    })
    /// endregion
    /// region options
    test('options are extended by defaults', () => {
        expect(root.options.languages).toStrictEqual(['enUS', 'deDE'])
        expect(root.options.selectors).toStrictEqual(
            HomePage._defaultOptions.selectors
        )
        expect(root.options.trackingCode)
            .toStrictEqual(HomePage._defaultOptions.trackingCode)
    })
    test('given options are merged over defaults', () => {
        const homePage = new HomePage()
        homePage.setPropertyValue(
            'options',
            {selectors: {header: '.custom-header'}, trackingCode: 'custom'}
        )

        homePage._extendOptions()

        expect(homePage.options.trackingCode).toStrictEqual('custom')
        expect(homePage.options.selectors.header)
            .toStrictEqual('.custom-header')
        expect(homePage.options.selectors.section)
            .toStrictEqual(HomePage._defaultOptions.selectors.section)
        expect(homePage.options.languages).toStrictEqual(['enUS', 'deDE'])
    })
    /// endregion
    /// region applyGreeting
    const createGreetingHeadline = (timeBased?: string): HTMLElement => {
        const domNode = document.createElement('h1')
        domNode.innerHTML = 'initial'
        if (timeBased !== undefined)
            domNode.setAttribute('data-timebased', timeBased)

        return domNode
    }
    const greets = JSON.stringify([
        {enUS: 'Morning', deDE: 'Morgen'},
        {enUS: 'Evening', deDE: 'Abend'}
    ])
    test.each([
        [0, 'Morning<!--deDE:Morgen-->'],
        [8, 'Morning<!--deDE:Morgen-->'],
        [11, 'Morning<!--deDE:Morgen-->'],
        [12, 'Evening<!--deDE:Abend-->'],
        [20, 'Evening<!--deDE:Abend-->'],
        [23, 'Evening<!--deDE:Abend-->']
    ])('applyGreeting at %p o\'clock', (hours, expected) => {
        jest.spyOn(Date.prototype, 'getHours').mockReturnValue(hours)

        const domNode = createGreetingHeadline(greets)
        root.greetingHeadlineDomNodes =
            [domNode] as unknown as NodeListOf<HTMLElement>

        root.applyGreeting()

        expect(domNode.innerHTML).toStrictEqual(expected)
    })
    test.each([undefined, '[]'])(
        'applyGreeting keeps headline with time based value %p',
        (timeBased) => {
            const domNode = createGreetingHeadline(timeBased)
            root.greetingHeadlineDomNodes =
                [domNode] as unknown as NodeListOf<HTMLElement>

            root.applyGreeting()

            expect(domNode.innerHTML).toStrictEqual('initial')
        }
    )
    test('applyGreeting without headlines', () => {
        root.greetingHeadlineDomNodes = null

        expect(() => {
            root.applyGreeting()
        }).not.toThrow()
    })
    /// endregion
    /// region switchLanguageButton
    const createLanguageComponent = (
        domNodes: Array<HTMLElement>
    ): WebInternationalization => ({
        switchLanguageButtonDomNodes: domNodes,
        options: {selection: ['enUS', 'deDE']}
    }) as unknown as WebInternationalization
    test.each([
        ['deDE', '#lang-enUS', 'en'],
        ['enUS', '#lang-deDE', 'de']
    ])(
        'switchLanguageButton to %p',
        (newLanguage, expectedHref, expectedText) => {
            const domNode = document.createElement('a')
            domNode.setAttribute('href', '#lang-deDE')

            root.switchLanguageButton(
                newLanguage, createLanguageComponent([domNode])
            )

            expect(domNode.getAttribute('href')).toStrictEqual(expectedHref)
            expect(domNode.innerText).toStrictEqual(expectedText)
        }
    )
    test('switchLanguageButton ignores buttons without link', () => {
        const domNode = document.createElement('a')
        domNode.innerText = 'unchanged'

        root.switchLanguageButton('deDE', createLanguageComponent([domNode]))

        expect(domNode.hasAttribute('href')).toStrictEqual(false)
        expect(domNode.innerText).toStrictEqual('unchanged')
    })
    /// endregion
    /// region switchConsentManagerLanguage
    describe('switchConsentManagerLanguage', (): void => {
        const context = globalThis as unknown as {
            KLARO_CONFIGURATION?: {lang?: string}
            klaro?: {render: (configuration: object, options: object) => void}
        }

        afterEach(() => {
            delete context.KLARO_CONFIGURATION
            delete context.klaro
        })

        test('without consent manager configuration', () => {
            expect(() => {
                root.switchConsentManagerLanguage('deDE')
            }).not.toThrow()
        })
        test('switches language and re-renders consent manager', () => {
            const render = jest.fn()
            context.KLARO_CONFIGURATION = {lang: 'en'}
            context.klaro = {render}

            root.switchConsentManagerLanguage('deDE')

            expect(context.KLARO_CONFIGURATION.lang).toStrictEqual('de')
            expect(document.documentElement.lang).toStrictEqual('de')
            expect(render).toHaveBeenCalledTimes(1)
            expect(render).toHaveBeenCalledWith(context.KLARO_CONFIGURATION, {})
        })
        test('does nothing if language is already selected', () => {
            const render = jest.fn()
            context.KLARO_CONFIGURATION = {lang: 'en'}
            context.klaro = {render}

            root.switchConsentManagerLanguage('enUS')

            expect(context.KLARO_CONFIGURATION.lang).toStrictEqual('en')
            expect(render).not.toHaveBeenCalled()
        })
        test('only adjusts configuration if not loaded yet', () => {
            context.KLARO_CONFIGURATION = {lang: 'en'}

            expect(() => {
                root.switchConsentManagerLanguage('deDE')
            }).not.toThrow()
            expect(context.KLARO_CONFIGURATION.lang).toStrictEqual('de')
        })
    })
    /// endregion
    /// region unRender
    test('unRender clears third party instances', () => {
        const destroy = jest.fn()
        root.projectSwiperInstances =
            [{destroy}] as unknown as HomePage['projectSwiperInstances']
        root.waveSurferInstances =
            [{destroy}] as unknown as HomePage['waveSurferInstances']

        root.unRender('test')

        expect(destroy).toHaveBeenCalledTimes(2)
        expect(root.projectSwiperInstances).toStrictEqual([])
        expect(root.waveSurferInstances).toStrictEqual([])
    })
    /// endregion
    // endregion
})
