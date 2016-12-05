# Input/output

## File reading/writing

File reading/writing is similar to other languages where you first open the file, specify the modality (`r` read, `w` write or `a` append) and bind the file to an object, and finally operate on this object and close it when you are done:

Write:
```
f = open("afile.txt", "w")  # "w" for writing
write(f, "test\n")          # \n for newline
close(f)
```

Read:
```
f = open("afile.txt", "r")  # "r" for reading
filecontent = readstring(f) # attenction that it can be used only once. The second time, without reopening the file, would return an empty string
print(filecontent)
close(f)
```
or 
```

```



The effect of this is to create a file called newfile.txt in your present working directory with contents

testing
more testing

We can read the contents of newline.txt as follows

julia> f = open("newfile.txt", "r")  # Open for reading
IOStream(<file newfile.txt>)

julia> print(readall(f))
testing
more testing

julia> close(f)



