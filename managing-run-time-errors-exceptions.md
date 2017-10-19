# Managing run-time errors (exceptions)

Run-time errors can be handled with the try/catch block:

```
try
  # ..some dangerous code..
catch
  # ..what to do if an error happens, most likely send an error message using:
  error("My detailed message")
end
```

You can also check for a specific type of exception, e.g.:

```
function vol_(region=NA, d1=NA, dc=NA, year=NA) 
    try
        return t["vol",region,d1,dc,year]
    catch  e
        if isa(e, KeyError)
          return NA
        end
        rethrow(e)
    end
end
```
