registerForEvent("onOverlayOpen", function()
    drawWindow = true
end)


registerForEvent("onOverlayClose", function()
    drawWindow = false
end)
function getitem(equip)
    local equipexist = Game.GetScriptableSystemsContainer():Get("EquipmentSystem"):GetActiveItem(GetPlayer(), equip)
    if equipexist.id.hash ~= 0 then
        return equipexist
    else
        return 0
    end
end

local EqExprntstuffsettings = {
    itemdisp = false,
    printasgameinv = false
}

function itemvalue(equip)
    if (getitem(equip) ~= 0) then
        return RPGManager.GetItemRecord((getitem(equip))):AppearanceName().value
    else
        return "Slot is empty!"
    end
end

function itemcommand(equip)
    printinv1 = "Game.AddToInventory(\""
    printinv2 = "\", 1)"
    if (getitem(equip) ~= 0) then
        return (printinv1 .. getitem(equip).id.value .. printinv2)
    else
        return "Slot is empty!"
    end
end
local alert = ""
function printapp()
    local file = io.open("appnames.txt", "w")
    if file then
        for key, value in pairs(clothingitems) do
            file:write(key)
            file:write(itemvalue(value))
            file:write("\n")
        end
        file:flush();
    else
        print("Error opening file!")
    end
    file:close()
    print("Mesh app names printed in appnames.txt in the folder of this tool!")
end

function printitemval()
    local file = io.open("values.txt", "w")
    if file then
        for key, value in pairs(clothingitems) do
            file:write(key)
            file:write("\n")
            file:write(itemcommand(value))
            file:write("\n")
        end
        file:flush();
    else
        print("Error opening file!")
    end
    file:close()
    print("Item values printed in values.txt in the folder of this tool!")
end


function EqExMain()
    local slots = TweakDBInterface.GetCharacterRecord(GetPlayer():GetRecordID()):AttachmentSlots()
    local itemarr = {}
    local nooutfit = ""
    for k, item in pairs(slots) do
        -- local slotName = GetLocalizedTextByKey(StringToName(TweakDBInterface.GetAttachmentSlotRecord(item:GetID()):LocalizedName()))
        local slotName = TweakDBInterface.GetAttachmentSlotRecord(item:GetID())
        local slottest = GetLocalizedTextByKey(StringToName(slotName:LocalizedName()))
        local ItemName = Game.GetTransactionSystem():GetItemInSlot(GetPlayer(), item:GetID())
        if (ItemName ~= nil and slottest ~= nil and slottest ~= "") then
            nooutfit = nooutfit .. TDBID.ToStringDEBUG(TweakDBInterface.GetAttachmentSlotRecord(item:GetID()):GetID())
            local itemobj = { slotName, ItemName }
            table.insert(itemarr, itemobj)
            -- table.insert(itemarr,item)
        end
        
    end
    alert = ""
    if(nooutfit == "") then
       alert ="You're not using an outfit, use to utilize the buttons below"
    end
    return itemarr
end

function eqexiteminfo()
    local slots = EqExMain()
    local usedslotnames = ""
    local ItemDispName = ""
    for k, item in pairs(slots) do
        -- local slotName = GetLocalizedTextByKey(StringToName(TweakDBInterface.GetAttachmentSlotRecord(item:GetID()):LocalizedName()))
        -- local ItemName = Game.GetTransactionSystem():GetItemInSlot(GetPlayer(),item:GetID())
        local slotName    = GetLocalizedTextByKey(StringToName(item[1]:LocalizedName()))
        local ItemName    = item[2]
        -- local itTest = slots[k].itemobj.ItemName
        local ItemInvName = ItemID.GetTDBID(ItemName.GetItemID(ItemName))
        if (EqExprntstuffsettings.itemdisp) then
            ItemDispName = '\nItem Name:' ..
            GetLocalizedTextByKey(TweakDBInterface.GetItemRecord(ItemInvName):DisplayName())
        end
        local ItemMeshName = TweakDBInterface.GetItemRecord(ItemInvName):AppearanceName()
        usedslotnames = usedslotnames ..
        slotName ..
        ItemDispName .. '\n' .. NameToString(ItemMeshName) .. '\n-------------------------------------------------\n'
    end

    return usedslotnames
end

function eqexitemcodes()
    local slots = EqExMain()
    local command = ""
    for k, item in pairs(slots) do
        local slotName = TDBID.ToStringDEBUG(item[1]:GetID())
        local ItemName = item[2]
        local ItemInvName = ItemID.GetTDBID(ItemName.GetItemID(ItemName))

        if (EqExprntstuffsettings.printasgameinv) then
            command = command .. "Game.AddToInventory(\"" .. TDBID.ToStringDEBUG(ItemInvName) .. "\", 1) "
        else
            command = command ..
            "EquipmentEx.EquipItem(\"" .. TDBID.ToStringDEBUG(ItemInvName) .. "\", \"" .. slotName .. "\") "
        end
    end
    return command
end

local MeshApp = "Empty.. for now"
local IID = "Game.AddToInventory(\"Items.Q005_Johnny_Glasses" .. ", 1)"
local EqExIID = ""

registerForEvent("onDraw", function()
    if (drawWindow) then
        if ImGui.Begin('Clothing Slot Info Tool', true) then
            ImGui.Text("Pressing one of the clothing buttons")
            ImGui.Text("Outputs both the mesh app and item code")

            ImGui.Text("Head                            Upper Body")

            clothingitems = {
                HeadSlot = gamedataEquipmentArea.Head,
                FaceSlot = gamedataEquipmentArea.Face,
                OuterChestSlot = gamedataEquipmentArea.OuterChest,
                InnerChestSlot = gamedataEquipmentArea.InnerChest,
                OutfitSlot = gamedataEquipmentArea.Outfit,
                LegsSlot = gamedataEquipmentArea.Legs,
                FeetSlot = gamedataEquipmentArea.Feet
            }

            if ImGui.Button('Head', 175, 35) then
                MeshApp = itemvalue(clothingitems.HeadSlot)
                IID = itemcommand(clothingitems.HeadSlot)
            end

            ImGui.SameLine()

            if ImGui.Button('Outer Torso', 175, 35) then
                MeshApp = itemvalue(clothingitems.OuterChestSlot)
                IID = itemcommand(clothingitems.OuterChestSlot)
            end

            if ImGui.Button('Face', 175, 35) then
                MeshApp = itemvalue(clothingitems.FaceSlot)
                IID = itemcommand(clothingitems.FaceSlot)
            end

            ImGui.SameLine()

            if ImGui.Button('Inner Torso', 175, 35) then
                MeshApp = itemvalue(clothingitems.InnerChestSlot)
                IID = itemcommand(clothingitems.InnerChestSlot)
            end

            ImGui.Text("Lower Body")

            if ImGui.Button('Legs', 175, 35) then
                MeshApp = itemvalue(clothingitems.LegsSlot)
                IID = itemcommand(clothingitems.LegsSlot)
            end

            ImGui.SameLine()

            if ImGui.Button('Outfit', 175, 35) then
                MeshApp = itemvalue(clothingitems.OutfitSlot)
                IID = itemcommand(clothingitems.OutfitSlot)
            end

            if ImGui.Button('Feet', 175, 35) then
                MeshApp = itemvalue(clothingitems.FeetSlot)
                IID = itemcommand(clothingitems.FeetSlot)
            end
            ImGui.Text("")

            MeshApp = ImGui.InputText('MeshApp', MeshApp, 100, ImGuiInputTextFlags.ReadOnly)
            IID = ImGui.InputText('ItemCommand', IID, 100, ImGuiInputTextFlags.ReadOnly)

            ImGui.Text("")

            ImGui.Text("Export all slots to a .txt file")

            if ImGui.Button('Slot mesh app', 175, 35) then
                printapp()
            end
        end

        ImGui.SameLine()

        if ImGui.Button('Slot Item name', 175, 35) then
            printitemval()
        end

        if ImGui.Button('Export Both', 360, 35) then
            printapp()
            printitemval()
        end

        if not ModArchiveExists("EquipmentEx.archive") then
            ImGui.Text("EquipmentEx is not detected, the buttons below may not output anything")
        end
            ImGui.Separator()
            ImGui.Text('EquipmentEx commands for currently-worn outfit:')
            ImGui.Text("Include:")


            ImGui.Text(alert)
            if ImGui.Button('Print item app names to console', 360, 35) then
                local prnt = eqexiteminfo()
                print(prnt)
                FTLog(prnt)
            end
            if (ImGui.IsItemHovered()) then
                ImGui.SetTooltip(
                "This will print the used slot and its active item's app name\nExample: Legs\\Outer:l1_pants_03_q001_start_")
            end

            ImGui.SameLine()

            local itemDispValue, itemDispPressed = ImGui.Checkbox("Include Item Inventory Name",
                EqExprntstuffsettings.itemdisp)
            if itemDispPressed then
                EqExprntstuffsettings.itemdisp = itemDispValue
            end
            if (ImGui.IsItemHovered()) then
                ImGui.SetTooltip("Include the name of items when outputing them to console\nExample: V's Pants")
            end


            if ImGui.Button('Print item command codes in Console', 360, 35) then
                local prnt = eqexitemcodes()
                print(prnt)
                FTLog(prnt)
            end
            ImGui.SameLine()
            local prntasinvValue, prntasinvPressed = ImGui.Checkbox("Output as AddToInventory instead",
                EqExprntstuffsettings.printasgameinv)
            if prntasinvPressed then
                EqExprntstuffsettings.printasgameinv = prntasinvValue
            end
            if (ImGui.IsItemHovered()) then
                ImGui.SetTooltip("Output as AddToInventory instead of EquipmentEx.EqiupItems")
            end
            if ImGui.Button('Save item and mesh app info to File ', 360, 35) then
                local file = io.open("EqEx_CurrentOutfitInfo.txt", "w")
                if file then
                        file:write(eqexiteminfo())
                        file:write("\n")
                        file:write(eqexitemcodes())
                        file:write("\n")                    
                    file:flush();
                else
                    print("Error opening file!")
                end
                file:close()
                print("Item values printed in EqEx_CurrentOutfitInfo.txt in the CET folder of this tool!")
            end
            if (ImGui.IsItemHovered()) then
                ImGui.SetTooltip("Item code output style depend on the above checkboxes")
            end

            ImGui.Text('Check Console or Game Log for EquipmentEx Codes')
        end
    
        ImGui.End()
end)
