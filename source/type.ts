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
import {HeadroomOptions} from 'headroom.js'
import {SwiperOptions} from 'swiper/types'
// region exports
export interface DefaultOptions {
    trackingCode: string
    maximumFooterHeightInPercent: number
    backgroundDependentHeightSections: Array<string>
    maximumBackgroundDependentHeight: number
    hideMobileMenuAfterSelection: boolean

    headroom: HeadroomOptions

    languages: Array<string>

    selectors: {
        header: string
        navigation: string
        navigationButtons: string
        switchLanguageButtons: string

        section: string

        swiper: string
        sectionSwiperWrapper: string

        waveSurfer: string
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
