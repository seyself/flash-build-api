{exec} = require 'child_process'

packageTargets = {
    android: [
        "apk"
        "apk‑captive‑runtime"
        "apk-debug"
        "apk-emulator"
        "apk-profile"
    ]
    ios: [
        "ipa-ad-hoc"
        "ipa-app-store"
        "ipa-debug"
        "ipa-test"
        "ipa-debug-interpreter"
        "ipa-debug-interpreter-interpreter-simulator"
        "ipa-test-interpreter"
        "ipa-test-interpreter-simulator"
    ]
    air: [
        "air"
        "airn"
        "ane"
        "native"
    ]
}

packageTargets.all = []
    .concat(packageTargets.air)
    .concat(packageTargets.android)
    .concat(packageTargets.ios)

pushToMember = (target, member, value) ->
    (target[member] || target[member] = []).push(value)

getFlexHome = (args)->
    flexHome = args.flexHome || process.env.FLEX_HOME
    try
        if !flexHome then throw new Error("Set the environment variable 'FLEX_HOME' to a valid flex sdk")
    catch e
        throw e
    
    return flexHome

inQuotes = (text) ->
    text = text
            .replace(/\\/g, "\\\\")
            .replace(/\"/g, "\\\"")
    return "\"#{text}\""

is_plain_obj = ( obj )->
  if !obj ||
      {}.toString.call( obj ) != '[object Object]' ||
      obj.nodeType ||
      obj.setInterval
    return false

  has_own                   = {}.hasOwnProperty;
  has_own_constructor       = has_own.call( obj, 'constructor' );
  has_is_property_of_method = has_own.call( obj.constructor.prototype, 'isPrototypeOf' );

  # Not own constructor property must be Object
  if  obj.constructor &&
      !has_own_constructor &&
      !has_is_property_of_method
    return false;

  # Own properties are enumerated firstly, so to speed up,
  # if last one is own, then all properties are own.
  key == undefined
  for key in obj
      continue

  return key == undefined || has_own.call( obj, key );

allInQuotes = (input) ->
    result = []
    if input? then for part, pos in input
        result[pos] = inQuotes(part)
    return result

deepExtend = (a, b)->
    target = {}
    for part in [a, b]
        for name, value of part
            nowValue = target[name]
            if nowValue == value
            else if Array.isArray(value) and Array.isArray(nowValue)
                target[name] = nowValue.concat(value)
            else if is_plain_obj(value) and is_plain_obj(nowValue)
                target[name] = deepExtend(nowValue, value)
            else
                target[name] = value
    return target

addDebugFlags = (flags, useDebugFlag)->
    flags['CONFIG::release'] = !useDebugFlag
    flags['CONFIG::debug'] = useDebugFlag

addDefinesSpecially = (args, argList, useDebugFlag=false)->
    args.define ?= {}
    addDebugFlags(args.define, useDebugFlag)
    for name, value of args.define
        if typeof value == "string"
            value = inQuotes("'#{value}'")
        else
            value = value.toString()
        argList.push("-define=#{name},#{value}")

    return argList

addRegularArgument = (name, value, separator)->
    arg = "-#{name}#{separator}"
    if typeof value == "string"
        if !isNaN(parseInt(value))
            arg += value
        else if value.toLowerCase() == "true"
            arg += "true"
        else if value.toLowerCase() == "false"
            arg += "false"
        else
            arg += inQuotes(value)
    else
        arg += allInQuotes(value).join(",")

addRegularArguments = (args, argList, separator, ignore...)->
    for name, value of args
        if ignore.indexOf(name) == -1
            argList.push addRegularArgument(name, value, separator)
    return argList

pushToDeepMember = (target, member, value) ->
    dotIndex = member.indexOf(".")
    if dotIndex != -1
        childName = member.substring(0,dotIndex)
        member = member.substring(dotIndex+1)
        childNode = (target[childName] || target[childName] = {})
        pushToMember(childNode, member, value)
    else
        pushToMember(target, member, value)

getPlatformForTarget = (target)->
    if packageTargets.android.indexOf(target) != -1
        return 'android'
    else if packageTargets.ios.indexOf(target) != -1
        return 'ios'

executeJar = (jar, args, root, onComplete) ->
    start = Date.now()
    cmd = "java -Xmx384m -Djava.awt.headless=true -Dsun.io.useCanonCaches=false -jar \"#{jar}\" #{args}"
    console.info cmd
    exec cmd, {cwd: root}, (error, stdout, stderr) ->
        if onComplete
            result = {
                cmd
                error
                stderr
                stdout
                path: root
                duration: Date.now()-start
            }
            if error
                onComplete(result, null)
            else
                onComplete(null, result)
        else
            if error
                console.error stderr
            else
                console.info stdout


module.exports = {
    packageTargets
    getPlatformForTarget
    pushToMember
    deepExtend
    getFlexHome
    inQuotes
    allInQuotes
    addDefinesSpecially
    addRegularArguments
    addRegularArgument
    pushToDeepMember
    executeJar
    genericAdt: require "./genericAdt"
    parseXml: require "./parseXml"
}