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

function itemvalue(equip)
    if (getitem(equip) ~= 0) then
        return RPGManager.GetItemRecord((getitem(equip))):AppearanceName().value
    else
        return "Slot is empty!"
    end
end

function itemcommand(equip)
    local printinv1 = "Game.AddToInventory(\""
    local printinv2 = "\", 1)"
    if (getitem(equip) ~= 0) then
        return (printinv1 .. getitem(equip).id.value .. printinv2)
    else
        return "Slot is empty!"
    end
end

function printapp()
    local file = io.open("appnames.txt", "w")
    if file then
        for key,value in pairs(clothingitems) do
          file:write(key)
          file:write(itemvalue(value))
          file:write("\n")
        end
        file:flush();
      else
        print("Error opening file!")
      end
      file:close()
end


function printitemval()
    local file = io.open("values.txt", "w")
    if file then
        for key,value in pairs(clothingitems) do
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
end


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

            ImGui.InputText('MeshApp', MeshApp, 100)
            ImGui.InputText('ItemCommand', IID, 100)


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

            ImGui.End()
        end   
end)
