#!/usr/bin/env coffee
# -*- coding: utf-8 -*-

# region header

# Copyright Torben Sickert 16.12.2012

# License
# -------

# This library written by Torben Sickert stand under a creative commons naming
# 3.0 unported license. see http://creativecommons.org/licenses/by/3.0/deed.de

# endregion

## standalone
##
this.less =
    env: 'development'
    async: false
    fileAsync: false
    poll: 1000
    functions: {}
    dumpLineNumbers: 'all'
    relativeUrls: false
    rootpath: ''
    logLevel: 0
    #sourceMap: true
##

## standalone
## this.jQuery.noConflict() ($) ->
##     $.HomePage googleTrackingCode: 'UA-40192634-1'
this.require [['jQuery.HomePage', 'jquery-homePage-1.0.coffee']], ($) =>
    ###
        Embed $ and require full compatible to all other JavaScripts. The
        global scope is clean after this sequence. The given function is called
        when the dom-tree was loaded.
    ###
    this.require.clearOldPathReminder()
    $.noConflict() ($) -> $.HomePage
        googleTrackingCode: 'UA-40192634-1', logging: true
##

# region vim modline

# vim: set tabstop=4 shiftwidth=4 expandtab:
# vim: foldmethod=marker foldmarker=region,endregion:

# endregion
