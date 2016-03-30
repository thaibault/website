#!/usr/bin/env coffee
# -*- coding: utf-8 -*-

# region header

# Copyright Torben Sickert 16.12.2012

# License
# -------

# This library written by Torben Sickert stand under a creative commons naming
# 3.0 unported license. see http://creativecommons.org/licenses/by/3.0/deed.de

# endregion

this.jQuery.noConflict() ($) -> $.HomePage(
    googleTrackingCode: 'UA-40192634-1', language:
        allowedLanguages: ['enUS', 'deDE']
        sessionDescription: 'website{1}')

# region vim modline

# vim: set tabstop=4 shiftwidth=4 expandtab:
# vim: foldmethod=marker foldmarker=region,endregion:

# endregion
