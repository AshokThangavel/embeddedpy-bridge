ROUTINE %ZPython [Type=INC]

/// Create new python data structures
#define pyDict      ##class(%ZPython.Utils).pyDict()
#Define pyList      ##class(%ZPython.Utils).pyList()
#Define pyTuple     ##class(%ZPython.Utils).pyTuple()

#Define zpyIRISDict     ##class(%ZPython.Dict).%New()
#Define zpyIRISList     ##class(%ZPython.List).%New()


///IRIS DynamicObject to python JSON Object
#Def1arg TopyJSON(%dao)   ##class(%ZPython.Utils).pyJSON(%dao)

///python JSON Object to IRIS DynamicObject
#Define FromPyJSON(%pyObject) ##class(%ZPython.Utils).fromPyJSON(%pyObject)

#Def1Arg pyListToDA(%pyList) ##class(%ZPython.Utils).pyListToDA(%pyList)

#Def1Arg pyDictToDO(%pyDict) ##class(%ZPython.Utils).pyDictToDO(%pyDict)

#Def1Arg IsPyList(%obj)  ##class(%ZPython.Utils).IsList(%obj)

#Def1Arg IsPyDict(%obj)  ##class(%ZPython.Utils).IsDict(%obj)

#Def1Arg IsPyStr(%str)  ##class(%ZPython.Utils).IsStr(%str)

#Def1Arg IsPyInt(%int)  ##class(%ZPython.Utils).IsInt(%int)

#Def1Arg IsPyFloat(%float)  ##class(%ZPython.Utils).IsFloat(%float)

#Def1Arg IsPyBool(%bool)  ##class(%ZPython.Utils).IsBool(%bool)


#Define pyTrue      ##class(%SYS.Python).True()
#Define pyFalse     ##class(%SYS.Python).False()


#Def1Arg PyExceToIRIS(%pyExec) ##class(%ZPython.Utils).PyExceToIRISFormat(%pyExec)
