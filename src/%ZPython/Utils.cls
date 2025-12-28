/// Provides a utility bridge between InterSystems IRIS ObjectScript and Embedded Python. <br/>
/// This class serves as a central factory for creating Python data structures and
/// managing the interaction between the two environments.
Class %ZPython.Utils [ Abstract ]
{

/// Creates and returns a new raw Python dictionary object (equivalent to {} in Python). <br/>
/// This dictionary is returned as a %SYS.Python object proxy,
/// allowing you to manage key-value pairs directly from ObjectScript. <br/>
/// <b>Example:</b> <br/>
/// <example>
///     Set dict = ##class(EmbeddedPy.Bridge).pyDict()
///     Do dict."__setitem__"("status", 200)
///     Write dict.get("status")
/// </example>
ClassMethod pyDict() As %SYS.Python
{
    Return ..Builtins().dict()
}

/// Returns enhanced ZPython.Dict wrapper object for iris convenience. <br/>
/// This object provides additional methods and properties for easier manipulation
ClassMethod zpyDict(pPyObj As %SYS.Python = "") As %ZPython.Dict
{
    Return ##class(%ZPython.Dict).%New(pPyObj)
}

/// Creates and returns a new raw Python list object (equivalent to [] in Python). <br/>
/// This list is returned as a %SYS.Python object, which acts as a proxy,
/// allowing you to call Python methods like .append() or .extend() directly from ObjectScript. <br/>
/// <b>Example:</b> <br/>
/// <EXAMPLE>
///     Set list = ##class(EmbeddedPy.Bridge).pyList()
///     Do list.append("First Item")
/// </EXAMPLE>
ClassMethod pyList() As %SYS.Python
{
    Return ..Builtins().list()
}

/// Returns enhanced ZPython.List wrapper object for iris convenience. <br/>
/// This object provides additional methods and properties for easier manipulation
ClassMethod zpyList(pPyObj As %SYS.Python = "") As %ZPython.List
{
    Return ##class(%ZPython.List).%New(pPyObj)
}

/// Creates a Python tuple. <br/>
/// If <var>pData</var> is provided (as an IRIS $ListBuild or a %SYS.Python list),
/// it populates the tuple during creation. <br/>
/// <b>Example:</b> <br/>
/// <example>
///     // Create from IRIS list
/// 		Set list = $lb("Red", "Green", "Blue")
///     Set tuple = ##class(EmbeddedPy.Bridge).pyTuple(list)
/// </example>
ClassMethod pyTuple(pData As %List) As %SYS.Python
{
    If pData = "" {
        Return ..Builtins().tuple()
    }
    Return ..Builtins().tuple(##class(%SYS.Python).ToList(pData))
}

/// Creates a Python Set (equivalent to {x, y} in Python).
/// Sets automatically handle unique values and are highly optimized for membership testing.
ClassMethod pySet(pData As %List = "") As %SYS.Python
{
    Set builtins = ..Builtins()
    If pData = "" {
	    Return builtins.set()
    }
    Return builtins.set(##class(%SYS.Python).ToList(pData))
}

/// Converts an IRIS %DynamicObject or %DynamicArray into a Python Dict or List.
ClassMethod pyJSON(pDAO As %DynamicAbstractObject) As %SYS.Python
{
	If '$IsObject(pDAO)||('pDAO.%IsA("%Library.DynamicAbstractObject")) {
		Quit ""
	}
    Set jsonString = pDAO.%ToJSON()
    Set jsonLib =..Import("json")
    Return jsonLib.loads(jsonString)
}

/// Converts a Python object (Dict or List) back into an IRIS %DynamicAbstractObject.
/// Usage: Set irisObj = ##class(EmbeddedPy.Bridge).fromPyJSON(pyObject)
ClassMethod fromPyJSON(pyObject As %SYS.Python) As %DynamicAbstractObject
{
	If '$IsObject(pyObject)||('pyObject.%IsA("%SYS.Python")) {
		Quit ""
	}
    Return ##class(%DynamicAbstractObject).%FromJSON(..Import("json").dumps(pyObject))
}

/// Converts a Python List [1,2,3] into an IRIS %DynamicArray [1,2,3].
/// <EXAMPLE>
/// 	Set irisArray = ##class(EmbeddedPy.Bridge).pyListToDynamic(pyList)
/// </EXAMPLE>
ClassMethod pyListToDA(pyObject As %SYS.Python) As %DynamicArray
{
	If '$IsObject(pyObject)||('pyObject.%IsA("%SYS.Python")) {
		Quit ""
	}
	Return ##class(%DynamicArray).%FromJSON(..Import("json").dumps(pyObject))
}

/// Converts a Python dictionary {'a':'test'} into an IRIS %DynamicArray [1,2,3].
/// <EXAMPLE>
/// 	Set irisArray = ##class(EmbeddedPy.Bridge).pyDictToDO(pyDict)
/// </EXAMPLE>
ClassMethod pyDictToDO(pyObject As %SYS.Python) As %DynamicObject
{
	If '$IsObject(pyObject)||('pyObject.%IsA("%SYS.Python")) {
		Quit ""
	}
    Return ##class(%DynamicArray).%FromJSON(..Import("json").dumps(pyObject))
}

/// Checks if a Python object is of a certain type (e.g., "list", "dict", "str").
/// Usage: If ##class(EmbeddedPy.Bridge).isType(obj, "dict") { ... }
ClassMethod IsType(
	pObj As %SYS.Python,
	pTypeName As %String) As %Boolean
{
	Try{
    	Set typeObj = $Property(..Builtins(), pTypeName)
    	Return ..Builtins().isinstance(pObj, typeObj)
	}
	Catch {}
	Return ""
}

ClassMethod IsDict(pObj) [ CodeMode = expression ]
{
..IsType(pObj,"dict")
}

ClassMethod IsStr(pObj) [ CodeMode = expression ]
{
..IsType(pObj, "str")
}

/// Checks if the object is Python Bytes (binary).
ClassMethod IsBytes(pObj) [ CodeMode = expression ]
{
..IsType(pObj, "bytes")
}

/// Checks if the object is Python Bytes (binary).
ClassMethod IsList(pObj) [ CodeMode = expression ]
{
..IsType(pObj, "list")
}

ClassMethod IsInt(pObj) [ CodeMode = expression ]
{
..IsType(pObj, "int")
}

ClassMethod IsFloat(pObj) [ CodeMode = expression ]
{
..IsType(pObj, "float")
}

ClassMethod IsBool(pObj) [ CodeMode = expression ]
{
..IsType(pObj, "bool")
}

/// Checks if the Python object is None.
ClassMethod IsNone(pObj) As %Boolean
{
	Quit $$$ERROR($$$NotImplemented)
    ;If '$IsObject(pObj) Return 1 // If it's not even an OREF, treat as null"
}

/// Checks if a Python object has a specific attribute or method.
/// Usage: If ##class(EmbeddedPy.Bridge).HasAttr(pObj, "append") { ... }
ClassMethod HasAttr(
	pObj As %SYS.Python,
	pAttrName As %String) As %Boolean
{
    If '$IsObject(pObj) Return 0
    Return ..Builtins().hasattr(pObj, pAttrName)
}

/// Checks if an object can be looped over (like a list, tuple, or dict).
ClassMethod IsIterable(pObj) As %Boolean
{
    If '$IsObject(pObj) Return 0
    Return ..Builtins().hasattr(pObj, "__iter__")
}

/// Extracts the last Python error traceback as an IRIS formatted string.
ClassMethod PyExceToIRISFormat(pyException) As %Status
{
	Set ex = ..Builtins().type(pyException)
	Set error = $Property(ex, "__name__")
	Set error = "<"_$ZConvert(error,"U")_">"

	Set traceback = ..Import("traceback")

	Set tb = $Property(pyException, "__traceback__")
	Set frames = $Method(traceback,"extract_tb",tb)
	Set lastFrame = $Method(frames,"__getitem__",-1)

	Set file= $Property(lastFrame,"filename")
	Set line= $Property(lastFrame,"lineno")
	Set function= $Property(lastFrame,"name")
	Set code = $Property(lastFrame,"line")

	Set msg = function_"+"_line_"^"_file

    Set error = $$$ERROR(2603,msg)
    Quit error
}

/// Converts an IRIS string or stream into Python Bytes.
/// Essential for binary file handling (Images, PDFs, etc.)
/// Converts an IRIS string/stream into Python Bytes for binary handling.
ClassMethod pyBytes(pData As %String) As %SYS.Python [ CodeMode = expression ]
{
..Builtins().bytes(pData, "utf-8")
}

ClassMethod Builtins() [ CodeMode = expression ]
{
##class(%SYS.Python).Builtins()
}

ClassMethod Import(pPackage As %String = "") [ CodeMode = expression ]
{
##class(%SYS.Python).Import(pPackage)
}

}
