CKEDITOR.plugins.add('equipments', {
    init: function(editor) {

        function defineDialog(macroName, options) {
            CKEDITOR.dialog.add("dlg_"+macroName, function(editor) {
                return {
                    title: options.dialogTitle,
                    minWidth: 300,
                    minHeight: 60,
                    contents: [{
                        id: 'defaultTab',
                        elements: [
                            {   id: "equipments_equipment",
                                type: "text",
                                label: Equipments.strings['equipments_cke_equipment'],
                                labelLayout: 'horizontal',
                                size: 32,
                                required: !0,
                                validate: function() {
                                    return this.getValue() !== "";
                                }
                            }
                        ]
                    }],
                    onOk: function() {
                        var equipment  = this.getValueOf('defaultTab', 'equipments_equipment');
                        editor.insertText('{{equipment('+equipment+')}}');
                    }
                };
            });

            editor.addCommand('cmd_'+macroName, new CKEDITOR.dialogCommand('dlg_'+macroName));
            editor.ui.addButton( 'btn_'+macroName, {
                label  : options.buttonLabel,
                command: 'cmd_'+macroName,
                icon   : options.buttonIcon
            });
        }

        defineDialog('equipments_link', {
            dialogTitle: Equipments.strings['equipments_cke_link_dlgtitle'],
            buttonLabel: Equipments.strings['equipments_cke_link_btnlabel'],
            buttonIcon : this.path+'/../../images/jstb_equipments_link.svg'
        });
    }
});
