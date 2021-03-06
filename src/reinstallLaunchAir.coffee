module.exports = (args, path, onComplete)->
    start = Date.now()
    @reinstallAir args, path, (error, packageResult)=>
        if error then onComplete(error)
        else
            @launchAir args, path, (error, result)->
                if error then onComplete(error)
                else
                    result.parts.unshift(packageResult)
                    result.duration = Date.now()-start
                    onComplete(null, result)
