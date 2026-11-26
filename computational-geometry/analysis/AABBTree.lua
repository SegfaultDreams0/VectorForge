-- computational-geometry implementation for AABBTree
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.

local Module = {}
function Module.Build(items,leafSize)
    assert(#items>0,"AABB tree requires at least one item"); local limit=leafSize or 4
    local function build(indices)
        local minimum={math.huge,math.huge,math.huge}; local maximum={-math.huge,-math.huge,-math.huge}
        for _,index in ipairs(indices) do for axis=1,3 do minimum[axis]=math.min(minimum[axis],items[index].Min[axis]); maximum[axis]=math.max(maximum[axis],items[index].Max[axis]) end end
        local node={Min=minimum,Max=maximum}
        if #indices<=limit then node.Indices=indices; return node end
        local axis=1; if maximum[2]-minimum[2]>maximum[axis]-minimum[axis] then axis=2 end; if maximum[3]-minimum[3]>maximum[axis]-minimum[axis] then axis=3 end
        table.sort(indices,function(a,b) return (items[a].Min[axis]+items[a].Max[axis])<(items[b].Min[axis]+items[b].Max[axis]) end)
        local middle=math.floor(#indices/2); local left,right={},{}
        for i=1,middle do left[i]=indices[i] end; for i=middle+1,#indices do right[#right+1]=indices[i] end
        node.Left=build(left); node.Right=build(right); return node
    end
    local indices=table.create(#items); for i=1,#items do indices[i]=i end
    local root=build(indices); root.Items=items; return root
end
function Module.QueryPoint(tree,point)
    local hits={}; local function contains(node)
        for axis=1,3 do if point[axis]<node.Min[axis] or point[axis]>node.Max[axis] then return false end end; return true
    end
    local function visit(node)
        if not contains(node) then return end
        if node.Indices then for _,index in ipairs(node.Indices) do local item=node.Items and node.Items[index]; if item then table.insert(hits,index) end end
        else visit(node.Left); visit(node.Right) end
    end
    visit(tree); return hits
end

return Module
