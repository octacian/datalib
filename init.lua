-- datalib/init.lua
datalib = {}
datalib.table = {} -- internal table global

-- logger
function datalib.log(content, log_type)
  if log_type == nil then log_type = "action" end
  minetest.log(log_type, "[datalib] "..content)
end

-- global path variables
datalib.modpath = minetest.get_modpath("datalib") -- modpath
datalib.worldpath = minetest.get_worldpath() -- worldpath
datalib.datapath = datalib.worldpath.."/datalib" -- path for general datalib storage
-- local path variables
local modpath = datalib.modpath
local worldpath = datalib.worldpath
local datapath = datalib.datapath

-- shortcuts
datalib.cp = datalib.copy

-- check if datalib world folder exists
function datalib.initdata()
  local f = io.open(datapath)
  if not f then
    if minetest.mkdir then
      minetest.mkdir(datapath) -- create directory if minetest.mkdir is available
      return
    else
      os.execute('mkdir "'..datapath..'"') -- create directory with os mkdir command
      return
    end
  end
  f:close() -- close file
end

datalib.initdata() -- initialize world data directory

-- check if file exists
function datalib.exists(path)
  local f = io.open(path, "r") -- open file
  if f ~= nil then f:close() return true else return false end
end

-- create folder
function datalib.mkdir(path)
  local f = io.open(path)
  if not f then
    if minetest.mkdir then
      minetest.mkdir(path) -- create directory if minetest.mkdir is available
      return
    else
      os.execute('mkdir "'..path..'"') -- create directory with os mkdir command
      return
    end
  else
  end
  f:close() -- close file
  return true
end

-- remove directory
function datalib.rmdir(path, log)
  if not io.open(path) then return false end -- file doesn't exist

  -- [local function] remove files
  local function rm_files(ppath, files)
    for _, f in ipairs(files) do
      os.remove(ppath.."/"..f)
    end
  end

  -- [local function] check and rm dir
  local function rm_dir(dpath)
    local files = minetest.get_dir_list(dpath, false)
    local subdirs = minetest.get_dir_list(dpath, true)
    rm_files(dpath, files)
    if subdirs then
      for _, d in ipairs(subdirs) do
        rm_dir(dpath.."/"..d)
      end
    end
    os.remove(dpath)
  end

  rm_dir(path)
  if log ~= false then datalib.log("Recursively removed directory at "..path) end -- log
end

-- create file
function datalib.create(path, log)
  -- check if file already exists
  if datalib.exists(path) == true then
    datalib.log("File ("..path..") already exists.") -- log
    return true -- exit and return
  end
  local f = io.open(path, "w") -- create file
  f:close() -- close file
  if log ~= false then datalib.log("Created file "..path) end -- log
end

-- write to file
function datalib.write(path, data, serialize, log)
  if not serialize then local serialize = false end -- if blank serialize = true
  local f = io.open(path, "w") -- open file for writing
  if serialize == true then local data = minetest.serialize(data) end -- serialize data
  f:write(data) -- write data
  f:close() -- close file
  if log ~= false then datalib.log('Wrote "'..data..'" to '..path) end -- log
end

-- append to file
function datalib.append(path, data, serialize, log)
  if not serialize then local serialize = false end -- if blank serialize = true
  local f = io.open(path, "a") -- open file for writing
  if serialize == true then local data = minetest.serialize(data) end -- serialize data
  f:write(data) -- write data
  f:close() -- close file
  if log ~= false then datalib.log('Appended "'..data..'" to '..path) end -- log
end

-- read file
function datalib.read(path, deserialize)
  if datalib.exists(path) ~= true then return false end -- check if exists
  local f = io.open(path, "r") -- open file for reading
  local data = f:read("*all") -- read and store file data in variable data
  if deserialize == true then local data = minetest.deserialize(data) end -- deserialize data
  return data -- return file contents
end

-- copy file
function datalib.copy(path, new, log)
  if not datalib.exists(path) then
    datalib.log(path.." does not exist. Cannot copy file.")
    return false
  end -- check if path exists
  local old = datalib.read(path, false) -- read
  datalib.create(new, false) -- create new
  datalib.write(new, old, false, false) -- write
  old = nil -- unset old
  if log ~= false then datalib.log("Copied "..path.." to "..new) end -- log
  return true -- successful
end

-- write table to file
function datalib.table.write(path, intable, log)
  local intable = minetest.serialize(intable) -- serialize intable
  local f = io.open(path, "w") -- open file for writing
  f:write(intable) -- write intable
  f:close() -- close file
  if log ~= false then datalib.log("Wrote table to "..path) end -- write table
end

-- load table from file
function datalib.table.read(path)
  if datalib.exists(path) ~= true then return false end -- check if exists
  local f = io.open(path, "r") -- open file for reading
  local externaltable = minetest.deserialize(f:read("*all")) -- deserialize and read externaltable
  f:close() -- close file
  return externaltable
end

-- dofile
function datalib.dofile(path)
  -- check if file exists
  if datalib.exists(path) == true then
    dofile(path)
    return true -- return true, successful
  else
    datalib.log("File "..path.." does not exist.")
    return false -- return false, unsuccessful
  end
end
