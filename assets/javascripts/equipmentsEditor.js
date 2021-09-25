var Equipments = { settings: {redmineUrl: '/'}};

// The container for global settings
if(Equipments == 'undefined' || !Equipments)
    Equipments = {};

// Container for localized strings
Equipments.strings = {};

$(function() {
    if(typeof CKEDITOR === 'undefined') return false;

    var basePath = CKEDITOR.basePath;

    basePath = basePath.substr(0, basePath.indexOf("plugin_assets")+"plugin_assets".length);
    basePath = basePath.replace(/https?:\/\/[^\/]+/, "");
    CKEDITOR.plugins.addExternal('equipments', basePath+'/equipments/javascripts/', 'equipments_plugin.js');

    if(typeof(Object.getOwnPropertyDescriptor(CKEDITOR, 'editorConfig')) === "undefined") {
        // CKEDITOR.editorConfig is not patched: add a patch to intercept changes of the
        // editorConfig property and be able to apply more than one setup.
        var oldEditorConfig = CKEDITOR.editorConfig || null;

        Object.defineProperty(CKEDITOR, 'editorConfig', {
            get: function() { return oldEditorConfig; },
            set: function(newValue) {
                if(oldEditorConfig) {
                    var prevValue = oldEditorConfig;

                    oldEditorConfig = function(config) {
                        prevValue(config);
                        newValue(config);
                    }
                }
                else
                    oldEditorConfig = newValue;
            }
        });
    }

    CKEDITOR.editorConfig = function(config) {
        // Workaround for the configuration override.
        // The Redmine CKEditor plugin has its own config.js that resets 
        // any change to the extraPlugins property.
        // This code implements a setter on the config.extraPlugins property
        // so the new value is not replaced but instead appended to the
        // existing value. It is supported by the major modern browser (for
        // example from IE 9).
        if(typeof(Object.getOwnPropertyDescriptor(config, 'extraPlugins')) === "undefined") {
            var _extraPlugins = config.extraPlugins || '';

            Object.defineProperty(config, 'extraPlugins', {
                get: function() { return _extraPlugins; },
                set: function(newValue) {
                    if(_extraPlugins === '')
                        _extraPlugins = newValue;
                    else
                        _extraPlugins += ','+newValue;
                }
            });
        }

        // Same as before, but this time I want the equipments toolbar appended
        // after the default toolbar
        if(typeof(Object.getOwnPropertyDescriptor(config, 'toolbar')) === "undefined") {
            var _toolbar = config.toolbar || [];

            Object.defineProperty(config, 'toolbar', {
                get: function() {
                    return _toolbar.concat(config.extraToolbar);
                },
                set: function(newValue) {
                    _toolbar = newValue;
                }
            });
        }

        // Now we can proceed with the CKEDITOR setup
        var equipments_toolbar = [['btn_equipments_link']];

        config.extraPlugins = 'equipments';
        config.extraToolbar = (config.extraToolbar || []).concat(equipments_toolbar);
    }
});