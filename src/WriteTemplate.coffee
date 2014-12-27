Handlebars = require './Handlebars'
fs = require 'fs'
merge = require './TemplateMerge'


if process.argv.length < 3
	throw new Error("usage: <configuration.json>")

# load the configuration
configuration = Require(process.argv[2])

# load the array of files
template = Require(configuration.input)
temp = []

# read each file and process with handlebars
read = (file, properties) ->
	raw = fs.readFileSync("#{Require.root}/#{file}", 'utf8')

	# remove C-style comments from JSON files
	if file.indexOf('.json') > 0

		# remove line comments
		raw = raw.replace(/\/\/(.*?)\r?\n/g, '')

		# remove block comments
		raw = raw.replace(/\/\*([^]*?)\*\//g, '')

	compiled = Handlebars.compile(raw)(properties)
	return JSON.parse(compiled)

# for each file, do handlebars rendering
for file in template
	if file instanceof String or (typeof file).toLowerCase() is 'string'
		temp.push read(file, configuration.properties)
	else
		temp.push file

template = temp
temp = undefined

merge(template, configuration.output)