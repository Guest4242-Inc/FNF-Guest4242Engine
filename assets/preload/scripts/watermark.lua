function onCreate()
    -- Create the watermark text
    makeLuaText('watermark', 'Guest4242 Engine v0.0.1', 0, 0, 0)
    setTextSize('watermark', 16)
    setTextAlignment('watermark', 'center')
    screenCenter('watermark', 'x')
    setProperty('watermark.y', 10) -- Position near top of screen
    setProperty('watermark.alpha', 0.7) -- 70% opacity
    addLuaText('watermark')

    -- Make sure it stays on top and doesn't scroll
    setObjectCamera('watermark', 'other')
    setObjectOrder('watermark', 99999)
end

