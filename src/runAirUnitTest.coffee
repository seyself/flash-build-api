runUnitTest = require './runUnitTest'
path = require 'path'
{exec} = require 'child_process'
{getFlexHome} = require './utils'

module.exports = (args, cwd, onComplete)->
    try
        flexHome = getFlexHome(args)
    catch e
        onComplete e
        return

    cmd = (onComplete) ->
        try
            appXml = path.resolve(cwd, args.descriptor)
            appXmlFile = path.basename(appXml)
            cwd = path.dirname(appXml)
            cmd = "#{flexHome}/bin/adl #{appXmlFile} -profile extendedDesktop"
            console.info cmd, cwd
            return exec cmd, {cwd: cwd}, onComplete
        catch e
            console.error e.stack
            onComplete(e)
    runUnitTest cmd, onComplete