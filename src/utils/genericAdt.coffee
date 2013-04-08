{getFlexHome, addRegularArguments, executeJar, getPlatformForTarget, deepExtend} = require './index'
{exec} = require 'child_process'

executeWithPlatform = (command, commandArgs, args, root, platform, onComplete)->
    flexHome = getFlexHome(args)
    argList = []
    addArgs = {}
    addArgs[command] = null
    addArgs.platform = platform
    if args.device then addArgs.device = args.device
    addRegularArguments(deepExtend(addArgs, commandArgs), argList, " ")
    executeJar "#{flexHome}/lib/adt.jar", argList.join(" "), root, onComplete

module.exports = {
    executeWithPlatform: executeWithPlatform
    execute: (command, commandArgs, args, root, onComplete)->
        platform = getPlatformForTarget(args.target)
        if platform?
            executeWithPlatform(command, commandArgs, args, root, platform, onComplete)
        else
            onComplete(new Error("Don't now how to #{command} -target='#{args.target}'"))
}