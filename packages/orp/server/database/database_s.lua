sql = false

local SQL_HOST = "localhost"
local SQL_PORT = 3306
local SQL_USER = "orp"
local SQL_PASS = "e5CfZb@Olyp%iT4v@&ch"
local SQL_DATABASE = "orp"
local SQL_CHAR = "utf8mb4"
local SQL_LOGL = "debug"

-- Setup a MariaDB connection when the package/server starts
AddEvent("OnPackageStart", function ()
	mariadb_log(SQL_LOGL)

	sql = mariadb_connect(SQL_HOST .. ':' .. SQL_PORT, SQL_USER, SQL_PASS, SQL_DATABASE)

	if (sql ~= false) then
		print("MariaDB: Connected to " .. SQL_HOST)
		mariadb_set_charset(sql, SQL_CHAR)

		CallEvent('LoadVehicles')
		CallEvent('LoadFactions')
	else
		print("MariaDB: Connection failed to " .. SQL_HOST .. ", see mariadb_log file")

		-- Immediately stop the server if we cannot connect
		ServerExit()
	end
end)

-- Cleanup the MariaDB connection when the package/server stops
AddEvent("OnPackageStop", function ()
	CallEvent('UnloadVehicles')
	CallEvent('UnloadFactions')
	mariadb_close(sql)
end)