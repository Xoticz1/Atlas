local Players = game:GetService("Players")
local lp = Players.LocalPlayer
while not lp do task.wait() lp = Players.LocalPlayer end
local g = getgenv()
if not g.__atlas_per_account then
    g.__atlas_per_account = true
    local base = "atlas_" .. lp.Name
    local wrap = newcclosure or function(f) return f end
    local raw = {}
    for _, k in ipairs({ "writefile", "readfile", "appendfile", "isfile", "isfolder", "makefolder", "delfile", "delfolder", "loadfile", "listfiles" }) do
        raw[k] = g[k]
    end
    if not raw.isfolder(base) then
        raw.makefolder(base)
        if raw.isfolder("atlas") then
            for _, p in ipairs(raw.listfiles("atlas")) do
                local name = string.match(string.gsub(p, "\\", "/"), "([^/]+)$")
                if name and raw.isfile(p) then raw.writefile(base .. "/" .. name, raw.readfile(p)) end
            end
        end
    end
    local function map(p)
        if type(p) ~= "string" then return p end
        local q = string.gsub(p, "\\", "/")
        if q == "atlas" then return base end
        if string.sub(q, 1, 6) == "atlas/" then return base .. string.sub(q, 6) end
        return p
    end
    for _, k in ipairs({ "writefile", "readfile", "appendfile", "isfile", "isfolder", "makefolder", "delfile", "delfolder", "loadfile" }) do
        local f = raw[k]
        if f then g[k] = wrap(function(p, ...) return f(map(p), ...) end) end
    end
    local lf = raw.listfiles
    if lf then
        g.listfiles = wrap(function(p, ...)
            local mp = map(p)
            local out = lf(mp, ...)
            if mp ~= p and type(out) == "table" then
                for i, v in ipairs(out) do
                    local n = string.gsub(v, "\\", "/")
                    if string.sub(n, 1, #base + 1) == base .. "/" then out[i] = "atlas/" .. string.sub(n, #base + 2) end
                end
            end
            return out
        end)
    end
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/rewrite.lua"))()
