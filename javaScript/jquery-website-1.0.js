/// require

// region header

/*!
    jQuery plugin for "jquery-1.9.1".

    Copyright see require on https://github.com/thaibault/require

    Conventions see require on https://github.com/thaibault/require

    @author t.sickert@gmail.com (Torben Sickert)
    @version 1.0 stable
    @requires require-1.0+
              jquery-1.9.1+
              jquery-tools-1.0+
              bootstrap-2.3.1+
    @fileOverview
    This module provides common resuable logic for every jquery non trivial
    plugin.
*/

/**
    @name jQuery
    @see www.jquery.com
*/
/// standalone ;(function(jQuery) {
;window.require([
    ['less', 'less-1.3.3'],

    ['jQuery.Tools', 'jquery-tools-1.0'],

    ['jQuery.fn.button', 'bootstrap-2.3.1']],
    function(less, jQuery) {
///

// endregion

// region plugins

    /**
        @memberOf jQuery
        @class
    */
    var Website = function() {

    // region protected properties

        /**
            Saves default options for manipulating the default behaviour.

            @property {Object}
        */
        this._options = {
            'logging': false,
            'domNodeSelectorPrefix': 'body'};

    // endregion

    // region public methods

        /**
            @description Initializes the interactive web app.

            @param {Object} options An options object.

            @returns {jQuery.Tools} Returns the current instance.
        */
        this.initialize = function(options) {
            if (options)
                jQuery.extend(true, this._options, options);
            this.log('Here we go dynamic :-)');
            return this/*._handleGooleAnalytics()*/;
        };

    // endregion

    // region protected methods

        this._handleGooleAnalytics = function() {
            // TODO check if "_gaq" has to be global.
            var _gaq = [['_setAccount', 'UA-XXXXX-X'], ['_trackPageview']];
            jQuery('script')[0].parent().before(jQuery('<script>').attr(
                'src', ('https:' == location.protocol ? '//ssl' : '//www') +
                    '.google-analytics.com/ga.js'));
            return this;
        };

    // endregion

    };

    /** @ignore */
    jQuery.Website = function() {
        var self = jQuery.Tools()._extend(new Website());
        self.__name__ = 'Website';
        return self._controller.apply(self, arguments);
    };

// endregion

/// standalone })(window.jQuery);
});
