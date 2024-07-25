// #!/usr/bin/env babel-node
// -*- coding: utf-8 -*-
'use strict'
/* !
    region header
    Copyright Torben Sickert (info["~at~"]torben.website) 16.12.2012

    License
    -------

    This library written by Torben Sickert stand under a creative commons
    naming 3.0 unported license.
    See https://creativecommons.org/licenses/by/3.0/deed.de
    endregion
*/
// region imports
import {$} from 'clientnode'

import Website from './index'
// endregion
describe('Documentation', ():void => {
    let website:Website
    /*
        NOTE: Import plugins with side effects (augmenting "$" scope /
        registering plugin) when other imports are only used as type.
    */
    require('internationalisation')
    require('website-utilities')
    require('./index')
    beforeAll(async ():Promise<void> => {
        website = (await $.Website()) as Website
    })
    // region tests
    /// region public methods
    //// region special
    test('initialize', ():void => expect(website).toBeDefined())
    //// endregion
    /// endregion
    // endregion
})
