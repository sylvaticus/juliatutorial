# 7 - Managing run-time errors \(exceptions\)

Run-time errors can be handled with the try/catch block:

```julia
try
  # ..some dangerous code..
catch
  # ..what to do if an error happens, most likely send an error message using:
  error("My detailed message")
end
```

You can also check for a specific type of exception, e.g.:

```julia
function volume(region, year) 
    try
        return data["volume",region,year]
    catch  e
        if isa(e, KeyError)
          return missing
        end
        rethrow(e)
    end
end
```

