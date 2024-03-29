if DSBLT:IsDorhud() then return end

local test_menu_id = "test_menu_id"

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_MyMod", function(menu_manager, nodes)
    MenuHelper:NewMenu(test_menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_MyMod", function(menu_manager, nodes)
    MenuHelper:AddDivider({
        id = "example_divider_1",
        size = 16,
        menu_id = test_menu_id
    })
    MenuHelper:GetMenu(test_menu_id).test_button_callback = function() end
    MenuHelper:AddButton({
        id = "example_button",
        title = "example_mod_test_button",
        desc = "example_mod_test_button_desc",
        callback = "test_button_callback",
        menu_id = test_menu_id,
        priority = 10,
    })
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_MyMod", function(menu_manager, nodes)
    MenuCallbackHandler["test_button_callback"] = function() end
    nodes[test_menu_id] = MenuHelper:BuildMenu(test_menu_id, {area_bg = "full"})
    MenuHelper:AddMenuItem(nodes.blt_options, test_menu_id, test_menu_id .. "_menubtn", test_menu_id .. "_desc")
end)

-- local menuOptTypes = {
-- }


-- _G.DSBLT.optionsMenus = _G.DSBLT.optionsMenus or {
--     -- Raw mod names
--     registeredMenus = {},

--     -- Menu IDs
--     -- Structured as follows:

--     -- Raw control names
--     --[[
--         registeredControls = { [menuId] = { {control1}, {control2}, ... } }
--     --]]
--     registeredControls = {},

--     currentMenu = nil,
-- }

-- local menuModule = _G.DSBLT.optionsMenus

-- function menuModule:MenuExists(id)
--     if MenuHelper == nil then return false end
--     for _, v in next, self.createdMenus do
--         if v == id then return true end
--     end
--     return false
-- end

-- local myMod = {}
-- myMod._data = {}
-- Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_Combo", function( menu_manager )
--     MenuHelper:LoadFromJsonFile( DSBLT:ModPath("DSBLT") .. "menu.json", myMod, myMod._data )
-- end )

-- Hooks:Add("CoreMenuData.LoadDataMenu", "DSBLT.CoreMenuData.LoadDataMenu", function(menu_id, menu)
--     if menu_id ~= "start_menu" and menu_id ~= "pause_menu" then return end

--     menuModule.currentMenu = menu
    
-- end)

-- local test_menu_id = "dsblt_menu_test_id"

-- Hooks:Add("MenuManager_Base_SetupModOptionsMenu", "MenuManagerSetupCustomMenus_DSBLT", function(menu_manager, nodes)
--     MenuHelper:NewMenu(test_menu_id)

--     -- I've no idea why, but the new menu doesn't have the right metatable
--     -- Unless I do this
--     -- local createdMenu = MenuHelper:GetMenu(test_menu_id)
--     -- local blt_options_meta = getmetatable(nodes.blt_options)
--    -- setmetatable(createdMenu, blt_options_meta)
-- end)

-- Hooks:Add("MenuManager_Base_PopulateModOptionsMenu", "MenuManagerPopulateCustomMenus_DSBLT", function(menu_manager, nodes)
--     --DSBLT:LogTable(nodes.blt_options, -1, "blt_options = {")
--     --DSBLT:LogTable(getmetatable(nodes.blt_options), 1, "blt_options metatable = {")
--     --DSBLT:Log("")
--     MenuHelper:AddDivider({
--         id = "example_divider_1",
--         size = 16,
--         menu_id = test_menu_id
--     })
-- end)

-- Hooks:Add("MenuManager_Base_BuildModOptionsMenu", "MenuManagerBuildCustomMenus_DSBLT", function(menu_manager, nodes)
--     -- local madeMenu = MenuHelper:GetMenu(test_menu_id)
--     -- rawset(madeMenu, "_parameters", {
--     --     back_callback_name={"test_callback"},
--     --     back_callback={
--     --         test_callback=function() end
--     --     },
--     --     stencil_align="center",
--     --     name=test_menu_id,
--     --     topic_id=test_menu_id .. "_topic",
--     --     stencil_image="bg_options",
--     --     refresh = {function() end},
--     --     modifier = {function() end}
--     -- })
--     -- rawset(madeMenu, "_legends", {[1] = {string_id = "menu_legend_select"}, [2] = {string_id = "menu_legend_back"}})
--     -- rawset(madeMenu, "_default_item_name", "back")
--     -- rawset(madeMenu, "test_callback", function() end)
--     -- rawset(madeMenu, "_items", rawget(madeMenu, "_items_list"))
--     -- DSBLT:LogTable(madeMenu, -1, "madeMenu = {")
--     MenuHelper:BuildMenu(test_menu_id, {area_bg = "full"})
--     MenuHelper:AddMenuItem(nodes.blt_options, test_menu_id, test_menu_id .. "_menubtn", test_menu_id .. "_desc")
--     -- DSBLT:LogTable(
--     --     MenuHelper:AddMenuItem(nodes.blt_options, test_menu_id, test_menu_id .. "_menubtn", test_menu_id .. "_desc"),
--     --     -1,
--     --     "AddMenuItem Result = {"
--     -- )
--     -- DSBLT:LogTable(
--     --     nodes.options._items,
--     --     -1,
--     --     "nodes.options._items = {"
--     -- )
-- end)

-- function menuModule:AddMenu(menuName)
--     -- local new_node = {
-- 	-- 	_meta = "node",
-- 	-- 	name = "blt_options",
-- 	-- 	topic_id = "blt_options_menu_lua_mod_options",
-- 	-- 	stencil_align = "center", -- PDTH
-- 	-- 	stencil_image = "bg_options", -- PDTH
-- 	-- 	refresh = "BLTModOptionsInitiator",
-- 	-- 	back_callback = "perform_blt_save",
-- 	-- 	modifier = "BLTModOptionsInitiator",
-- 	-- 	[1] = {
-- 	-- 		_meta = "legend",
-- 	-- 		name = "menu_legend_select"
-- 	-- 	},
-- 	-- 	[2] = {
-- 	-- 		_meta = "legend",
-- 	-- 		name = "menu_legend_back"
-- 	-- 	},
-- 	-- 	[3] = {
-- 	-- 		_meta = "default_item",
-- 	-- 		name = "back"
-- 	-- 	},
-- 	-- 	[4] = {
-- 	-- 		_meta = "item",
-- 	-- 		name = "back",
-- 	-- 		text_id = "menu_back",
-- 	-- 		back = true,
-- 	-- 		previous_node = true,
-- 	-- 		visible_callback = "is_pc_controller"
-- 	-- 	},
-- 	-- 	[5] = {
-- 	-- 		_meta = "item",
-- 	-- 		name = "blt_settings",
-- 	-- 		text_id = "blt_settings",
-- 	-- 		help_id = "blt_settings_desc",
-- 	-- 		next_node = "blt_settings",
-- 	-- 		priority = 1
-- 	-- 	}
-- 	-- }
-- 	-- table.insert(menu, new_node)
-- end

-- local function getProtoControl(menuId, details)
--     return {
--         -- Common fields
--         id = details.text_id,
--         menu_id = menuId,
--         title = details.text_id,
--         desc = details.help_id,
--         value = details.default_value or nil,
--         callback = "DSBLTGenericMenuCallback",

--         -- Divider-specific
--         size = details.size or nil,

--         -- Toggle-specific

--         -- Multichoice-specific
--         items = details.choices or nil,

--         -- Keybind-specific


--         -- Text-input-specific


--         -- Slider-specific
--         step = details.precision or nil
--     }
-- end

-- function menuModule:AddControl(menuId, controlDetails)
--     -- local id = DSBLT:HookId("menu", menuId)
--     -- if not self:MenuExists(id) then
--     --     menuModule:AddMenu(menuId)
--     -- end
--     -- if (not self:MenuExists(id)) or MenuHelper == nil or MenuCallbackHandler == nil then
--     --     DSBLT:Log("Adding pending menu control \"" .. controlDetails.text_id .. "\" to menu \"" .. id .. "\"")
--     --     self.pendingControls[menuId] = self.pendingControls[menuId] or {}
--     --     self.pendingControls[menuId][controlDetails.text_id] = self.pendingControls[menuId][controlDetails.text_id] or controlDetails
--     --     return
--     -- end

--     -- MenuCallbackHandler["DSBLTGenericMenuCallback"] = function(node) end

--     -- local controlType = controlDetails.type

--     -- local protoControl = getProtoControl(id, controlDetails)
--     -- DSBLT:Log("Adding control \"" .. protoControl.id .. "\" to menu \"" .. protoControl.menu_id .. "\"")

--     -- if controlType == "boolean" then
--     --     MenuHelper:AddToggle(protoControl)
--     -- elseif controlType == "divider" then
--     --     MenuHelper:AddDivider(protoControl)
--     -- elseif controlType == "text" then
--     --     -- I think this is the text input lol
--     --     MenuHelper:AddInput(protoControl)
--     -- elseif controlType == "number" then
--     --     MenuHelper:AddSlider(protoControl)
--     -- elseif controlType == "multi_choice" then
--     --     MenuHelper:AddMultipleChoice(protoControl)
--     -- elseif controlType == "keybind" then
--     --     MenuHelper:AddKeybinding(protoControl)
--     -- else
--     --     error("Unrecognised controlType \"" .. controlType .. "\"")
--     -- end
-- end

-- function menuModule:GetMenu(id)
--     if MenuHelper == nil then return nil end
--     return MenuHelper:GetMenu(id)
-- end --]]