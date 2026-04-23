({
    handleDirectField: function(cmp) {
        var displayField = cmp.get("v.displayField");
        var directValue = cmp.get("v.simpleRecord." + displayField);
        var autoRename = cmp.get("v.autoRename");
        var customTabLabel = cmp.get("v.customTabLabel");
        
        if (directValue && !customTabLabel) {
            cmp.set("v.customTabLabel", directValue);
        }
        
        if (autoRename && directValue) {
            this.renameTab(cmp);
        }
    },
    
    renameTab: function(cmp) {
        var workspaceAPI = cmp.find("workspace");
        var customTabLabel = cmp.get("v.customTabLabel");
        var sourceType = cmp.get("v.sourceType");
        var displayField = cmp.get("v.displayField");
        
        var finalLabel = customTabLabel;
        
        if (!finalLabel) {
            if (sourceType === "direct") {
                finalLabel = cmp.get("v.simpleRecord." + displayField);
            } else {
                finalLabel = cmp.get("v.targetRecord." + displayField);
            }
        }
        
        if (finalLabel && workspaceAPI) {
            workspaceAPI.getFocusedTabInfo()
                .then(function(response) {
                    var focusedTabId = response.tabId;
                    return workspaceAPI.setTabLabel({
                        tabId: focusedTabId,
                        label: finalLabel
                    });
                })
                .catch(function(error) {
                    document.title = finalLabel;
                });
        } else if (finalLabel) {
            document.title = finalLabel;
        }
    }
})