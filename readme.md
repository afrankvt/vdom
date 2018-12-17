# Vdom - A Virtual DOM API for Fantom

```fantom

// create vdom tree
v1 := VElem("h1") {
  it->style = "color: blue"
  it.text   = "Hello, World"
}

// initial render to DOM node
elem := VDom.render(v1)

// generate a new vdom tree
v1 := VElem("h1") {
  it->style = "color: red"
  it.text   = "Hello, World"
}

// patch existing DOM with changes
VDom.patch(elem, v2)
```