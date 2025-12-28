Class %ZPython.Dict Extends %RegisteredObject
{

Property %Proxy As %SYS.Python [ Private ];

Method %OnNew(pPythonDict As %SYS.Python = "") As %Status
{
    If (pPythonDict = "") {
        Set ..%Proxy = ##class(%SYS.Python).Builtins().dict()
    }
    Else {
        Set ..%Proxy = pPythonDict
    }
    Return $$$OK
}

Method Set(
	pKey,
	pDefault) [ CodeMode = expression ]
{
..setdefault(pKey,pDefault)
}

Method setdefault(
	pKey,
	pDefault) [ CodeMode = expression ]
{
..%Proxy.setdefault(pKey,pDefault)
}

Method SetAt(
	pKey,
	pValue) [ CodeMode = expression ]
{
$Method(..%Proxy,"__setitem__",pKey,pValue)
}

Method Count() As %Integer [ CodeMode = expression ]
{
$Method(..%Proxy,"__len__")
}

Method len() [ CodeMode = expression ]
{
..Count()
}

Method pop(pIndex As %Integer = "")
{
    If pIndex="" Return ..%Proxy.pop()
    Return ..%Proxy.pop(pIndex)
}

Method popitem() [ CodeMode = expression ]
{
..%Proxy.popitem()
}

Method copy()
{
}

Method %IsDefined(pKey) [ CodeMode = expression ]
{
..contains(pKey)
}

Method contains(pKey) [ CodeMode = expression ]
{
$Method(..%Proxy,"__contains__",pKey)
}

Method GetAt(pKey) [ CodeMode = expression ]
{
$Method(..%Proxy,"__getitem__",pKey)
}

Method Remove(pKey) [ CodeMode = expression ]
{
..del(pKey)
}

Method Delete(pKey) [ CodeMode = expression ]
{
..del(pKey)
}

Method del(pKey) [ CodeMode = expression ]
{
$Method(..%Proxy,"__delitem__",pKey)
}

Method values() [ CodeMode = expression ]
{
..%Proxy.values()
}

Method items() [ CodeMode = expression ]
{
..%Proxy.items()
}

Method extend(pyList As %ObjectHandle)
{
	If pyList.%IsA("EmbeddedPy.List"){
		Set pyList=pyList.GetProxy()
	}
	Do ..%Proxy.extend(pyList)
}

/// Return a list of all the keys used in the dictionary d.
/// >>> tel = {'jack': 4098, 'sape': 4139}
/// >>> list(tel)
/// ['jack', 'sape']
Method List() [ CodeMode = expression ]
{
##class(%SYS.Python).Builtins().list(..%Proxy)
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
	Return ##class(%ZPython.DictIterator).%New(..%Proxy)
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
