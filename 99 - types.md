# Types

Types are what in other langauges are called classes, or structured data: they define the kind of information that is embedded in the type, that is a set of fields (aka properties in other languages), and then individual istances of objects can be made with specific values for the fields defined in the type.

Some syntax:

`a::B` means "a must be of type B"

`A<:B` means "A must be a subtype of B".

## Defining a type

```
type MyOwnType
  property1
  property2::String
end
```

For increasing performances you can optionally specify which type is each field, like for `property2`.

You can use templates also in type declaration:

```
type MyOwnType{T<:Number}
 property1
 property2::String
 property3::T
end
```

Use the keyword `immutable` in place of `type` when you want that once an object of that type has been constructed, its fields can no longer be changed. They are faster!

You can create abstract types using the keyword `abstract`. Abstract classes do not have any field, and objects can not be instantiated from them, altought concrete types can be defined as subtypes of them.

Actually you can create a whole hierarchy of abstract classes:

```
abstract MyOwnAbstractType <: MyOwnGenericAbstractType
type AConcreteType <: MyOwnAbstractType
  property1
  property2::String
end
```

## Initialising an object and accessing its fields

```
myObject = MyOwnType("something","something",10)
a = myObject.property3 # 10
```

## More on types

To know all parents types of a type:  `supertype(MyType)`

To know all childs of a type:  `subtype(MyType)`

This is the complete type hierarchy of `Number` in Julia (credits to Wikipedia):

![](/imgs/type_hierarchy_for_julia_numbers.png)










