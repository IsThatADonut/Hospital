-- Help command

-- Register new command /help
RegisterCommand("help", function()
    -- when /help i used the following msg will be printed to client
    msg("Enter your text here")
end, false)

--Function with the new event trigger
function msg(text)
    -- Triggering new event chat:addMessage instead of depreceated "chatMessage"
    TriggerEvent("chat:addMessage", {
        -- Color of the msg printer
        color = {255,0,0},
        -- Allowed to use more than 1 line? true/false
        multiline = true,
       -- arguments = {author, otherargs...}
        args = {"[Server]", text}
    })
end
