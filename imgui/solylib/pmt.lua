local pmtPointer = 0x00A8DC94
local pmtWeaponOffset = 0x00
local pmtArmorOffset = 0x04
local pmtUnitOffset = 0x08
local pmtMagOffset = 0x10
local pmtToolOffset = 0x0C

local function _GetItemUnitxtID(type, group, index)
    local id = -1

    local address = pso.read_u32(pmtPointer)
    if address ~= 0 then
        if type == 0 then
            address = pso.read_u32(address + pmtWeaponOffset)
            if address ~= 0 then
                local groupAddress = address + 8 * group

                local count = pso.read_u32(groupAddress)
                address = pso.read_u32(groupAddress + 4)

                if index < count and address ~= 0 then
                    id = pso.read_i32(address + 44 * index)
                end
            end
        elseif type == 1 then
            if group == 1 or group == 2 then
                address = pso.read_u32(address + pmtArmorOffset)
                if address ~= 0 then
                    address = address + 8 * (group - 1)

                    local count = pso.read_u32(address)
                    address = pso.read_u32(address + 4)

                    if index< count and address ~= 0 then
                        id = pso.read_i32(address + 32 * index)
                    end
                end
            elseif group == 3 then
                address = pso.read_u32(address + pmtUnitOffset)

                local count = pso.read_u32(address)
                address = pso.read_u32(address + 4)

                if index < count and address ~= 0 then
                    id = pso.read_i32(address + 20 * index)
                end
            end
        elseif type == 2 then
            address = pso.read_u32(address + pmtMagOffset)

            local count = pso.read_u32(address)
            address = pso.read_u32(address + 4)
            if group < count and address ~= 0 then
                id = pso.read_i32(address + 28 * group)
            end
        elseif type == 3 then
            address = pso.read_u32(address + pmtToolOffset)
            if address ~= 0 then
                local groupAddress = address + 8 * group

                local count = pso.read_u32(groupAddress)
                address = pso.read_u32(groupAddress + 4)

                if index < count and address ~= 0 then
                    id = pso.read_i32(address + 24 * index)
                end
            end
        end
    end

    return id
end

local function GetItemUnitxtID(data)
    return _GetItemUnitxtID(data[1], data[2], data[3])
end

return
{
    GetItemUnitxtID = GetItemUnitxtID,
}
