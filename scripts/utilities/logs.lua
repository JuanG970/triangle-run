function write_log(message)
    if devmode == true and logfile != nil then
        printh(message, logfile)
    end
end

