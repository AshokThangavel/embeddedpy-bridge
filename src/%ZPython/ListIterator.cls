/// Iterator for %ZPython.List objects.
/// Allows standard ObjectScript traversal of Python lists.
Class %ZPython.ListIterator Extends %RegisteredObject
{

Property Iter As %ObjectHandle [ Internal, Private ];

Property Index As %Integer [ InitialExpression = 0, Private ];

Property Builtins [ InitialExpression = {##class(%SYS.Python).Builtins()}, Private ];

Method %OnNew(pProxy) As %Status
{
    Try {
        Set ..Iter = $Method(pProxy,"__iter__")
        Return $$$OK
    }
    Catch {
        Return 0
    }
}

Method %GetNext(
	Output key,
	Output value) As %Boolean
{
    Try {
	    Set value = ..Builtins.next(..Iter)
        Set key = ..Index
        Set ..Index = ..Index + 1
        Return 1
    }
    Catch {
        Return 0
    }
}

}
