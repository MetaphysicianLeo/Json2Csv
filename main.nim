import json
import tables


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
    
proc find[T](s: seq[T], v: T): bool = 
    result = false
    for x in s:
        if x == v:
            result = true
            return
    return

proc getJsonNodeToString(o: JsonNode, key: string): string = 
    let x = o.getOrDefault(key)
    if x == nil or x.kind == JNull:
        result = "null"
    else:
        assert not (x.kind == JObject or x.kind == JArray)
        result = $x


proc main(): int = 
    var s: string
    withOpen(f, "input.json", fmRead):
        s = f.readAll

    let content = parseJson(s)

    case content.kind
    of JObject:
        discard
    of JArray:
        discard
    else:
        echo "can't turn into CSV"
        quit(1)

    var tableHead: seq[string] = @[]

    for i in content.items:
        assert i.kind == JObject
        for key in i.keys():
            if not tableHead.find(key):
                tableHead.add(key)

    var tableValue: seq[seq[string]] =  @[]

    for i in content.items:
        assert i.kind == JObject
        var tmp: seq[string] = @[]
        for key in tableHead:
            tmp.add(i.getJsonNodeToString(key))
        tableValue.add(tmp)

    var value = ""

    for i, x in tableHead.mpairs:
        if i == tableHead.len - 1:
            value &= $x & "\n"
        else:        
            value &= $x & ","

    for line in tableValue:
        for i, v in line:
            if i == tableHead.len - 1:
                value &= $v & "\n"
            else:        
                value &= $v & ","
    
    withOpen(f, "output.csv", fmWrite):
        f.write(value)

quit(main())
