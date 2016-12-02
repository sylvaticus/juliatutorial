# Pointers and memory considerations

## Copy issues

Equal sign \(a=b\)

* simple types are deep copied
* containers of simple types \(or other containers\) are shadow copied \(their internal is only referenced, not copied\)

copy\(x\)

* simple types are deep copy
* containers of simple types are deep copied
* containers of containers: the content is shadow copied \(the content of the content is only referenced, not copied\)

deepcopy\(x\)

* everything is deepcopy recursively

## The \`:\` operator



