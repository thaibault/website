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

    ['jQuery.fn.carousel', 'bootstrap-2.3.1'],
    
    ['jQuery.scrollTo', 'jquery-scrollTo-1.4.3.1'],
    ['jQuery.fn.waypoint', 'jquery-waypoints-2.0.2']],
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
            'domNodeSelectorPrefix': 'body.website',
            'startUpAnimationType': 'fade',
            'startUpAnimationDuration': 'slow',
            'startUpAnimationElementDelayInMiliseconds': 500,
            'domNodes': {
                'carousel': 'div.carousel.slide',
                'navigationButtons': 'div.navbar-wrapper ul.nav li a',
                'scrollToTopButtons': 'a[href="#top"]',
                'vieportOnTopIndicator': '#headerCarousel',
                'vieportNotOnTopIndicator': 'div.footer',
                'startUpAnimationClassPrefix': '.start-up-animation-number-'
            },
            'carouselOptions': {
                'interval': false,
                'pause': 'hover'}
        };
        /**
            Holds all needed dom nodes.

            @property {Object}
        */
        this._domNodes = {};

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
            this._domNodes = this.grapDomNodes(this._options.domNodes);
            this._domNodes.carousel.carousel(this._options.carouselOptions);
            this._handleStartUpEffects();
            this._addNavigationEvents();
            // TODO
            return this/*._handleGooleAnalytics()*/;
        };
        // TODO write destructor with waypoint disabling.

    // endregion

    // region protected methods

        this._handleStartUpEffects = function(elementNumber) {
            if (!elementNumber) {
                jQuery(
                    '[class^="' +
                    this.sliceDomNodeSelectorPrefix(
                        this._options.domNodes.startUpAnimationClassPrefix
                    ).substr(1) + '"]'
                ).hide();
                elementNumber = 1;
            }
            var self = this;
            window.setTimeout(function() {
                jQuery(
                    self._options.domNodes.startUpAnimationClassPrefix +
                    elementNumber
                ).show(
                    self._options.startUpAnimationDuration,
                    self._options.startUpAnimationType);
                if (jQuery(
                    self._options.domNodes.startUpAnimationClassPrefix +
                    (elementNumber + 1)).length)
                    self._handleStartUpEffects(elementNumber + 1);
                }, this._options.startUpAnimationElementDelayInMiliseconds);
            return this;
        };

        this._addNavigationEvents = function() {
            this._handleScrollToTopButton();
            var self = this;
            this.bind(this._domNodes.navigationButtons, 'click', function() {
                var clickedButton = this;
                self._domNodes.navigationButtons.each(function(index) {
                    if (clickedButton == this) {
                        // TODO scroll to top nur wenn man nich eh schon da ist.
                        jQuery.scrollTo('0px', 200, {'onAfter': function() {
                            self._domNodes.carousel.carousel(index);
                        }});
                        jQuery(this).parent('li').addClass('active');
                    } else
                        jQuery(this).parent('li').removeClass('active');
                });
            });
            return this;
        };

        this._handleScrollToTopButton = function() {
            this.bind(
                this._domNodes.scrollToTopButtons, 'click', function(event)
            {
                event.preventDefault();
                jQuery.scrollTo('0px', 800);
            });
            var self = this;
            self._domNodes.scrollToTopButtons.hide();
            // TODO wenn ein bischen runter gescrollt back to top einfaden.
            this._domNodes.vieportOnTopIndicator.waypoint(function() {
                self._domNodes.scrollToTopButtons.fadeOut();
            }, {'offset': -200});
            this._domNodes.vieportNotOnTopIndicator.waypoint(function() {
                self._domNodes.scrollToTopButtons.fadeIn('slow');
            }, {'offset': 600});
            // TODO beim hochscrollen wieder ausfaden.
            return this;
        };

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
