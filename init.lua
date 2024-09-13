registerForEvent("onInit", function()
  ImGui.SetNextWindowPos(300, 600, ImGuiCond.FirstUseEver)
  ImGui.SetNextWindowSize(300, 600, ImGuiCond.Appearing)
  local head_slot
end)
registerForEvent("onOverlayOpen", function()
  drawWindow = true
end)


registerForEvent("onOverlayClose", function()
  drawWindow = false
end)
function itemvalue(equip)
  local printinv1 = "Game.AddToInventory(\""
  local printinv2 = "\", 1)"
  itemchecker = Game.GetScriptableSystemsContainer():Get("EquipmentSystem"):GetActiveItem(GetPlayer(), equip)
  if itemchecker.id.hash ~= 0 then
    return RPGManager.GetItemRecord((itemchecker)):AppearanceName().value
  else
    return " Slot is empty!"
  end
end

registerForEvent("onDraw", function()
  if (drawWindow) then
    ImGui.Begin("Slot .app + Meshappeareance Extractor")
    ImGui.Text("Click on the slots to print out")
    ImGui.Text("its .app and meshappearance in console")
    if (ImGui.Button("Head")) then
      print(itemvalue(gamedataEquipmentArea.Head))
    end
    if (ImGui.Button("Face")) then
      print(itemvalue(gamedataEquipmentArea.Face))
    end
    if (ImGui.Button("Outer Torso")) then
      print(itemvalue(gamedataEquipmentArea.OuterChest))
    end
    if (ImGui.Button("Inner Torso")) then
      print(itemvalue(gamedataEquipmentArea.InnerChest))
    end
    if (ImGui.Button("Special slot")) then
      print(itemvalue(gamedataEquipmentArea.Outfit))
    end
    if (ImGui.Button("Legs")) then
      print(itemvalue(gamedataEquipmentArea.Legs))
    end
    if (ImGui.Button("Feet")) then
      print(itemvalue(gamedataEquipmentArea.Feet))
    end


    if ImGui.Button("print") then
      local file = io.open("forreal.txt", "w")

      local printallarray = {
        gamedataEquipmentArea.Head,
        gamedataEquipmentArea.Face,
        gamedataEquipmentArea.OuterChest,
        gamedataEquipmentArea.InnerChest,
        gamedataEquipmentArea.Outfit,
        gamedataEquipmentArea.Legs,
        gamedataEquipmentArea.Feet
      }

      if file then
        for i = 1, #printallarray do
          -- Correcting the concatenation and using file:write
          file:write("Code " .. itemvalue(printallarray[i]) .. " done")
          file:write("\n")
        end
        file:close()
      else
        print("Error opening file!")
      end
    end
    ImGui.SetWindowSize(375, 400)
    ImGui.End()
  end
end)
