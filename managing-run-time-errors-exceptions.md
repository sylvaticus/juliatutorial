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



