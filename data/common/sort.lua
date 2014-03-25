sortFunc = {}

function sortFunc.sortTable(t, func)
    local a = {}
    for k,v in pairs(t) do 
        table.insert(a, #a+1, v)
    end
    table.sort(a, func)
    return a
end