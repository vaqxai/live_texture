include("shared.lua")

function ENT:UpdateLiveTexture(w, h)
    local rt_tex = GetRenderTarget( "rt_" .. self:EntIndex(), w, h)

    render.PushRenderTarget(rt_tex)
    render.Clear(255, 255, 255, 255)

    cam.Start2D()
        local a = math.abs(math.sin(CurTime())) * 255
        local b = math.abs(math.cos(CurTime())) * 255
        local c = math.abs(math.sin(CurTime())) * 255

        local col = Color(a, b, c)
        surface.SetDrawColor(col)
        surface.DrawRect(10, 10, 20, 20)

    cam.End2D()

    render.PopRenderTarget()
end

function ENT:CreateLiveTexture()

    local mat, _ = Material(self:GetMaterials()[1])
    local old_flags = mat:GetInt("$flags")
    mat:SetInt("$flags", bit.bor(mat:GetInt("$flags"), 32768))

    local rt_tex = GetRenderTarget( "rt_" .. self:EntIndex(), mat:Width(), mat:Height())

    render.PushRenderTarget(rt_tex)
    render.Clear(255, 255, 255, 255)

    cam.Start2D()
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, mat:Width(), mat:Height())

        surface.SetDrawColor(255, 0, 0)
        surface.SetFont("DermaLarge")
        surface.SetTextPos(0, 0)
        surface.SetTextColor(255, 0, 0)
        surface.DrawText("Hello, " .. LocalPlayer():Nick() .. "!")
    cam.End2D()

    render.PopRenderTarget()

    mat:SetInt("$flags", old_flags)

    local props = mat:GetKeyValues()
    props["$basetexture"] = "rt_" .. self:EntIndex()

    local new_mat = CreateMaterial("rtmat_" .. self:EntIndex(), "VertexLitGeneric", props)

    return new_mat
end

function ENT:Think()
    if self.LiveTexture == nil then
        self.LiveTexture = self:CreateLiveTexture()
        self:SetMaterial("!rtmat_" .. self:EntIndex())
    else
        self:UpdateLiveTexture(self.LiveTexture:Width(), self.LiveTexture:Height())
    end
end