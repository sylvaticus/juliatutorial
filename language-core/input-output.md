# 6 - Input - Output

## File reading/writing

File reading/writing is similar to other languages where you first `open` the file, specify the modality \(`r` read, `w` write or `a` append\) and bind the file to an object, and finally operate on this object and `close()` it when you are done.

A better alternative is however to encapsulate the file operations in a `do` block that closes the file automatically when the block ends:

Write:

```text
open("afile.txt", "w") do f  # "w" for writing
  write(f, "test\n")         # \n for newline
end
```

Read the whole file in a single operation:

```text
open("afile.txt", "r") do f   # "r" for reading
  filecontent = readstring(f) # attention that it can be used only once. The second time, without reopening the file, readstring() would return an empty string
  print(filecontent)
end
```

or, reading line by line:

```text
open("afile.txt", "r") do f
  for ln in eachline(f)
    print(ln)
  end
end
```

or, if you want to keep track of the line numbers:

```text
open("afile.txt", "r") do f
   for (i,ln) in enumerate(eachline(f))
     print(i)
     print(ln)
   end
end
```

