Class %ZPython.List Extends %RegisteredObject
{

Property %Proxy As %SYS.Python [ Private ];

/// Constructor to wrap an existing Python list
Method %OnNew(pPythonList As %SYS.Python = "") As %Status
{
    If (pPythonList = "") {
        Set ..%Proxy = ##class(%SYS.Python).Builtins().list()
    } Else {
        Set ..%Proxy = pPythonList
    }
    Return $$$OK
}

Method Append(pItem)
{
    Do ..%Proxy.append(pItem)
}

Method Insert(pItem)
{
    Do ..Append(pItem)
}

Method Push(pItem)
{
	Do ..Append(pItem)
}

Method SetAt(
	pIndex,
	pValue)
{
	Do ..setitem(pIndex, pValue)
}

Method setitem(
	pIndex,
	pValue)
{
	Do $Method(..%Proxy,"__setitem__",pIndex, pValue)
}

Method delete(pIndex)
{
	Do $Method(..%Proxy,"__delitem__",pIndex)
}

Method contains(pValue) [ CodeMode = expression ]
{
$Method(..%Proxy,"__contains__",pValue)
}

Method GetAt(pIndex As %Integer) [ CodeMode = expression ]
{
$Method(..%Proxy,"__getitem__",pIndex)
}

Method Count() As %Integer [ CodeMode = expression ]
{
$Method(..%Proxy,"__len__")
}

Method len() [ CodeMode = expression ]
{
..Count()
}

Method Pop(pIndex As %Integer = "")
{
    If pIndex="" Return ..%Proxy.pop()
    Return ..%Proxy.pop(pIndex)
}

Method extend(pyList As %ObjectHandle)
{
	If pyList.%IsA("EmbeddedPy.List"){
		Set pyList=pyList.GetProxy()
	}
	Do ..%Proxy.extend(pyList)
}

Method Clear()
{
    Do ..%Proxy.clear()
}

Method %GetProxy() [ CodeMode = expression ]
{
..%Proxy
}

/// Returns a Python Iterator object for this list
Method %GetIterator() As %SYS.Python
{
	Return ##class(%ZPython.ListIterator).%New(..%Proxy)
}

/// Convert the whole thing to an IRIS Dynamic Array in one shot
Method ToDAO() As %DynamicArray
{
    Set json = ##class(%SYS.Python).Import("json").dumps(..%Proxy)
    Return ##class(%DynamicArray).%FromJSON(json)
}

Method %DispatchMethod(
	methodName As %String(MAXLEN=""),
	args...)
{
	Quit $$$ERROR($$$NotImplemented)
}

}
