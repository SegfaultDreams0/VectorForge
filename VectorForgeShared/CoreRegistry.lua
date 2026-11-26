-- core registry
local CoreRegistry = {}
local registered: {[string]: any} = {}
function CoreRegistry.Configure(core: {[string]: any})
    assert(type(core) == "table", "core registry expects a table")
    for name, module in pairs(core) do
        assert(type(name) == "string" and module ~= nil, "invalid core registration")
        registered[name] = module
    end
end
function CoreRegistry.Get(name: string) return registered[name] end
function CoreRegistry.Require(name: string)
    local module = registered[name]
    assert(module ~= nil, "VectorForge core module is not registered: " .. name)
    return module
end
function CoreRegistry.List()
    local names = {}
    for name in pairs(registered) do table.insert(names, name) end
    table.sort(names)
    return names
end
return CoreRegistry
