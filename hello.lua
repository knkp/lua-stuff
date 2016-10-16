-- testing input stuff

local inputStr = string.format("hello")

inputStr = io.read()

print(inputStr)


---- flow control ----


if string.find(inputStr, "hello") then
	print("found it")
else
	print("didn't find it")
end

print("hello madi")