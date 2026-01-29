local function setup()
	ps.sub("ind-sort", function(opt)
		local cwd = cx.active.current.cwd
		if cwd:starts_with("/home/simone/pics/fave") then
			opt.by, opt.reverse, opt.dir_first = "mtime", true, true
		end
		return opt
	end)
end

return { setup = setup }
