-- collision_classes.lua

function setup(world)

    world:setExplicitCollisionEvents(true)

    -- Add collision classes
    world:addCollisionClass('field', {ignores = {'field'}})
    world:addCollisionClass('hearing', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('passage', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('low_furniture', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('boundaries', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('window', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('destroyed_window', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('enemy_dead', {ignores = {'field', 'hearing'}})
    world:addCollisionClass('wall', {ignores = {'field', 'hearing'}})

    world:addCollisionClass('player', {
        enter = {'field', 'hearing', 'passage'},
        ignores = {'passage', 'destroyed_window', 'enemy_dead', 'field', 'hearing'}
    })

    world:addCollisionClass('enemy', {
        enter = {'wall', 'low_furniture', 'enemy', 'player'},
        ignores = {'field', 'hearing', 'enemy_dead', 'destroyed_window'}
    })

    world:addCollisionClass('bullet', {
        enter = {'wall', 'window', 'enemy', 'player'},
        ignores = {'low_furniture', 'destroyed_window', 'boundaries', 'enemy_dead', 'field', 'hearing', 'bullet', 'player', 'enemy', 'window', 'passage'},
        pre = {'wall'},
    })
end

return { setup = setup }