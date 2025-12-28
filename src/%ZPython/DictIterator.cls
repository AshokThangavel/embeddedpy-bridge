/// Iterator for %ZPython.Dict objects.
/// Allows standard ObjectScript traversal of Python dictionaries.
Class %ZPython.DictIterator Extends %RegisteredObject
{

Property Iter As %ObjectHandle;

Property Builtins [ InitialExpression = {##class(%SYS.Python).Builtins()} ];

Method %OnNew(pProxy As %SYS.Python) As %Status
{
    Try {
        Set items = pProxy.items()
        Set ..Iter = $Method(items,"__iter__")
        Return $$$OK
    }
    Catch {
        Return 0
    }
}

/// Retrieves the next key-value pair.
/// Usage: While iter.%GetNext(.key, .val) { ... }
Method %GetNext(
	Output key,
	Output value) As %Boolean
{
    Try {
        Set tuple = ..Builtins.next(..Iter)
        Set key = $Method(tuple,"__getitem__",0)
        Set value = $Method(tuple,"__getitem__",1)
    }
    Catch {
        Return 0
    }
    Return $$$OK
}

}
