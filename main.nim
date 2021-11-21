import json

template withOpen(
    file: untyped,
    filename: string,
    mode: FileMode,
    statements: untyped) =
    block:
        var file: File
        if open(file, filename, mode):
            try:
                statements
            finally:
                file.close()
        else:
            quit("cannot open: " & filename)
    


# let s = ( proc (x: File) : string =
#    result = x.readAll
#    x.close
# ) open("input.json", fmRead) 
# let jsonNode = parsejson(s)

var s: string
withOpen(f, "input.json", fmRead):
    s = f.readAll

let content = parseJson(s)

for x in content:
    echo x.kind