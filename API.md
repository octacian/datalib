# datalib API
This documentation is also available at the official [datalib Wiki](http://208.69.243.45:3000/octacian/datalib/wiki). Divided into several parts, one for each main topic, this documentation includes all functions available for use from other mods.

## Global Variables
Variables available for use within functions documented in the below sections.

* `datalib` : defines modname for global functions
* `datalib.modpath` : datalib Modpath for use with the dmAPI.
* `datalib.worldpath` : path of current world for use with the dmAPI.
* `datalib.datapath` : datalib folder within the world path for use with the dmAPI. It is recommended that you store general data within this folder rather than cluttering the root world directory.

## Data Manipulation API (dmAPI)
API for manipulating data stored within external files. Global variables are provided as mentioned above for storing files withing the `modpath`, `worldpath`, and `datapath`. It is recommended that you store unique files within the `datapath` as this prevents cluttering of the root world directory.

### initdata
**Usage:** `datalib.initdata()`

Initializes directory with in the world path in which datalib stores most of its data. Must be run before data can be written within the `datapath` (called within `init.lua`).

### exists
**Usage:** `datalib.exists(path)`

Checks the file specified through `path` returning true if it exists, and false if it does not.

### mkdir
**Usage:** `datalib.mkdir(path)`

Make a directory at the specified `path`.

### rmdir
**Usage:** `datalib.rmdir(path)`

Recursively delete all contents of a directory (files, sub-directories, etc...)

### create
**Usage:** `datalib.create(path)`

Create file in location specified by `path`. Returns true if already exists, nothing if creation is successful, also printing like output to the log.

### write
**Usage:** `datalib.write(path, data, serialize)`

Write data to file. File path is specified in `path`. Data to write is specified with field `data` and supports any value including strings, booleans, and integers. The `serialize` option tells datalib whether or not to run `minetest.serialize` on the data before writing, and is by default set to `true` if left blank.

### read
**Usage:** `datalib.read(path, deserialize)`

Load data from file (`path`) and return through variable `data`. The `deserialize` option tells datalib whether or not to run `minetest.deserialize` on the data before returning, and is by default set to `true` if left blank.

### copy
**Usage:** `datalib.copy(path, new)`
**Shortcut:** `datalib.cp(path, new)`

Copy the contents of a file to another file. `path` indicates the location of the original, while `new` indicates the path where the copy will be placed.

### table.write
**Usage:** `datalib.table.write(path, table)`

Write table to file. File path is specified in `path`. Table to write is specified with field `table` and is designed for use with tables. The only difference between `write_table` and `write_file` is that `write_table` always serializes the data with `minetest.serialize` before writing because tables cannot be directly written to files, however, they must first be converted to strings through serialization.

### table.load
**Usage:** `datalib.table.load(path)`

Load table from file (`path`) and return through variable `table`. The only difference between `load_table` and `load_file` is that `load_table` always deserializes the data with `minetest.deserialize` to convert previously written string back to a table.

### dofile
**Usage:** `datalib.dofile(path)`

Syntax as with the `dofile` command, the only difference being the function checks whether the file exists (using `check_file`) before running dofile to prevent errors. File specified through `path` is run as Lua, and returns `true` if successful, and `false` if unsuccessful (indicates file does not exist).
