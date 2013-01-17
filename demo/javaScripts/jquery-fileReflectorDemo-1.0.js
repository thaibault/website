/// require

// region header

/*!
    jQuery plugin for "jquery-1.8.3".

    Copyright see require on https://github.com/thaibault/require

    Conventions see require on https://github.com/thaibault/require

    @author t.sickert@gmail.com (Torben Sickert)
    @version 0.9 alpha
    @requires less-1.3.0+
              require-1.0+
              jquery-1.8.3+
              jquery-tools-1.0+
              jquery-scrollTo-1.4.3.1+
    @fileOverview
    This plugin does all the magic stuff for the FileReflector demo.
*/

/// standalone
/// ;(function(jQuery) {
;window.require([
    ['less', 'less-1.3.0'],

    ['jQuery.Tools', 'jquery-tools-1.0'],

    ['jQuery.fn.scrollTo', 'jquery-scrollTo-1.4.3.1']],
    function(less, jQuery) {
///

// endregion

// region plugins

    /**
        @memberOf jQuery
        @class
        @extends jQuery.Tools
        @param {DomObject} domObject The dom object from where where the plugin
                           starts doing it's magic.
        @example
var fileReflectorDemo = jQuery.FileReflectorDemo({
    'panelEvent': 'hover',
    'domNodes': {'pageWrapper': 'div#page-wrapper',
                 'pageMask': 'div#page-mask'}
});

    */
    var FileReflectorDemo = function() {

    // region protected properties

        /**
            Saves default options for manipulating the demo's behaviour.

            @property {Object}
        */
        this._options = {
            'logging': false,
            'domNodeSelectorPrefix': 'body',
            'iFrameUrl': 'http://localhost:8080',
            'domNodes': {
                'demoPanel': 'a.panel[href="#demo"]',
                'pageWrapper': 'div.page-wrapper',
                'pageMask': 'div.page-mask',
                'demoFrame': 'div.page-wrapper div.page-mask div#demo ' +
                             'div.frame-wrapper'
            },
            'domNodeGroups': {
                'panel': 'a.panel',
                'panelSelectedClass': 'selected',
                'section': 'div.section'
            },
            'panelEvent': 'click'
        };
        /**
            Holds all dom nodes which should be unique.

            @property {Object}
        */
        this._domNodes = {};
        /**
            Holds all dom nodes which could be there more than once.

            @property {Object}
        */
        this._domNodeGroups = {};
        /**
            Saves that panel is initially locked till all contens are loaded.

            @property {Object}
        */
        this._initialPanelLock = true;

    // endregion

    // region public methods

        /**
            @description Initializes the FileReflectorDemo and merges given
                         options with default options. Graps all needed
                         dom nodes. This method also binds all needed event
                         handlers to there dom nodes with events.

            @param {Object} options Given options.

            @returns {jQuery.FileReflectorDemo} Returns the current instance.
        */
        this.initialize = function(options) {
            // Merge default plugin-options with given optons.
            if (options)
                jQuery.extend(true, this._options, options);
            // Grap all needed dom nodes.
            this._domNodes = this.grapDomNodes(this._options.domNodes);
            this._domNodeGroups = this.grapDomNodes(
                this._options.domNodeGroups);
            this.bind(
                this._domNodeGroups.panel, this._options.panelEvent,
                this.getMethod(this._onPanelElementEvent));
            this.bind(window, 'resize', this.getMethod(this._onResizeWindow));
            this.bind(
                this._domNodes.demoFrame.find('div'), 'click', this.getMethod(
                    this._onShowDemo));
            this._initialPanelLock = false;
            return this;
        };

    // endregion

    // region protected methods

        // region event methods

        /**
            @description This method is triggered if current section was
                         changed by panel to the demo section. It initializes
                         a framed context for the requested demo
                         FileReflectorGui instance. This method is only called
                         the first time the demo was selected.

            @param {Object} event The event object.

            @returns {jQuery.FileReflectorDemo} Returns the current instance.
        */
        this._onShowDemo = function(event) {
            var self = this;
            jQuery(event.target).fadeOut('slow', function() {
                jQuery(this).parent().append(jQuery('<iframe>').attr(
                    'src', self._options.iFrameUrl));
                jQuery(this).remove();
            });
            return this;
        };
        /**
            @description This method is triggered if current section was
                         changed by panel.

            @param {Object} event The event object.

            @returns {jQuery.FileReflectorDemo} Returns the current instance.
        */
        this._onPanelElementEvent = function(event) {
            event.preventDefault();
            if (!this._initialPanelLock)
                this.checkLock(
                    'slide',
                    this.getMethod('_handlePanelElementEvent', this, event),
                    true);
            return this;
        };
        /**
            @description This method is triggered if current section was
                         changed by panel. It locks the panel for prevent
                         triggering new events during the slide effect.

            @param {Object} event The event object.

            @returns {jQuery.FileReflectorDemo} Returns the current instance.
        */
        this._handlePanelElementEvent = function(thisFunction, event) {
            this.lock('slide');
            this._domNodeGroups.panel.removeClass(
                this._options.domNodeGroups.panelSelectedClass);
            var target = jQuery(event.target);
            target.addClass(this._options.domNodeGroups.panelSelectedClass);
            var self = this;
            this._domNodes.pageWrapper.scrollTo(
                target.attr('href'), 'slow', function() {
                    self.unlock('slide');
                }
            );
            return this;
        };
        /**
            @description This method is called if the window is resized.
                         It adapts the page mask and wrapper.

            @returns {jQuery.FileReflectorDemo} Returns the current instance.
        */
        this._onResizeWindow = function() {
            var width = jQuery(window).width();
            var height = jQuery(window).height();
            var mask_width = width * this._domNodeGroups.section.length;
            this._domNodeGroups.section.add(this._domNodes.pageWrapper).css({
                'width': width,
                'height': height
            });
            this._domNodes.pageMask.css({
                'width': mask_width,
                'height': height
            });
            this._domNodes.pageWrapper.scrollTo(
                jQuery(this._options.domNodeGroups.panel + '.' +
                    this._options.domNodeGroups.panelSelectedClass)
                        .attr('href'),
                0);
            return this;
        };
    };

        // endregion

    // endregion

    /** @ignore */
    jQuery.FileReflectorDemo = function() {
        var self = jQuery.Tools()._extend(new FileReflectorDemo());
        self.__name__ = 'FileReflectorDemo';
        return self._controller.apply(self, arguments);
    };

// endregion

/// standalone })(window.jQuery);
});
