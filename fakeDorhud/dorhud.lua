if _G.DSBLT:IsDorhud() then return end

_G.DorHUD = {}

DorHUD.version = function(self)
    return "1.16.1.6"
end

DorHUD.conf = function(self, id)
    return _G.DSBLT.moduleOptions:GetOption(id)
end