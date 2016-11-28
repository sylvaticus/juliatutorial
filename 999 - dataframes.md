# Dataframes

Julia has a library to handle tabular data, in a way similar to R or Pandas dataframes. The approach and the function names are similar, altought the way of actually access the API may be a bit different.

Load the library: \`using DataArrays, DataFrames\`

Read a CSV file: myData = \`readtable\("mydatafile.csv", separator = ';'\)\`

Concatenate different dataframes \(with same structure\): \`df = vcat\(my\_df\_list\)\`

Delete columns by name: \`delete!\(df, \[:col1, :col2\]\)\`

Replace values based to a dictionary : \`mydf\[:col1\] = map\(akey -&gt;myDict\[akey\], mydf\[:col1\]\)\`

\(the original data to replace can be in a different column or a totally different dataframe\)

