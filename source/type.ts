// -*- coding: utf-8 -*-
/** @module type */
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
import {HeadroomOptions} from 'headroom'
import {SwiperOptions} from 'swiper'
import {KnownEventName} from 'web-component-wrapper/type'
// region exports
export interface DefaultOptions {
    trackingCode: string
    maximumFooterHeightInPercent: number
    backgroundDependentHeightSections: Array<string>
    maximumBackgroundDependentHeight: number
    hideMobileMenuAfterSelection: boolean

    headroom: HeadroomOptions

    languages: Array<string>

    priorityNavigation: {
        initClass: string
        mainNavWrapper: string
        mainNav: string
        navDropdownClassName: string
        navDropdownToggleClassName: string
        navDropdownLabel: string
        navDropdownBreakpointLabel: string
        breakPoint: number
        throttleDelay: number
        offsetPixels: number
        count: boolean

        moved: () => void
        movedBack: () => void
    }

    selectors: {
        header: string
        swiper: string
        curriculumVitaeLink: string
        section: string
        sectionSwiperWrapper: string
        navigationButtons: string
    }

    swiper: SwiperOptions
}
export type Options = DefaultOptions

export interface TrackingItem {
    context?: string
    event: string
    eventType: string
    icon?: string
    label: string
    reference: string
    subject: string
    value?: number
    userInteraction: boolean
}
// endregion
