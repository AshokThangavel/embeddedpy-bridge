# embeddedpy-bridge

A high-level ObjectScript wrapper and utility bridge for **InterSystems IRIS Embedded Python**.

This library simplifies the interaction between ObjectScript and Python by providing familiar, IRIS-style syntax for Python data structures, automated system-wide mapping, and seamless data conversion.

## 🚀 Key Features

* **Native Wrappers**: Use Python `list` and `dict` objects with familiar methods like `GetAt()`, `SetAt()`, and `Count()`.
* **Iterators**: Standard ObjectScript iterator support (`While iter.%GetNext()`).
* **Auto-Mapping**: Automatic `%Z` package mapping to make the bridge available in all namespaces.
* **Data Conversion**: One-line conversion between Python objects and IRIS Dynamic Objects/Arrays.

## 📦 Installation

### Via ZPM (IPM)

```objectscript
zpm "install embeddedpy-bridge"
```
### Via Docker

#### Clone the Repository
```bash
git clone https://github.com/AshokThangavel/embeddedpy-bridge.git
cd embeddedpy-bridge
````

Build and start the app using Docker Compose:

```bash
docker-compose up --build
```

#### Stopping the Application

To stop and remove the running containers:

```bash
docker-compose down
```

### Naming Convention: The `py` Prefix
To ensure code clarity and distinguish between native InterSystems IRIS objects and Python-specific utilities, this library uses a **`py` prefix** for all core bridge methods:
> * **`pyDict()`** / **`pyList()`**: Explicitly indicates the creation of a Python-backed wrapper.
> * **`pyJSON()`**: Distinguishes the conversion logic from native `%ToJSON()` methods.
> * **`pyIsNone()`**: Clarifies that we are checking for the Python `None` singleton specifically.
>
This naming strategy prevents confusion when working in complex classes that mix ObjectScript logic with Embedded Python.

## 🛠 Usage Samples

### Create Python Dictionary object
Create python Dictionary object directly
```objectscript
Set pyDict = ##class(%ZPython.Utils).pyDict()
```

### Working with Dictionaries (`%ZPython.Dict`)

Forget complex Python proxy syntax. Use the dictionary wrapper just like an IRIS object.

```objectscript
// Create a new wrapped dictionary
Set pyDict = ##class(%ZPython.Utils).zpyDict()

Do pyDict.SetAt("Status", "Active")
Do pyDict.SetAt("Version", 1.2)

// Iterate through keys and values
Set iter = pyDict.%GetIterator()
While iter.%GetNext(.key, .val) {
    Write "Key: ", key, " Value: ", val, !
}

// Convert to IRIS Dynamic Object
Set dynObj = pyDict.ToDO()
Write dynObj.%ToJSON()

```

### Create Python list object
Create python list object directly
```objectscript
Set pyList = ##class(%ZPython.Utils).pyList()
```

### 2. Working with Lists (`%ZPython.List`)

Easily manage Python lists with 1-based indexing options or standard append methods.

```objectscript
Set pyList = ##class(%ZPython.Utils).zpyList()

Do pyList.Append("First Item")
Do pyList.Append("Second Item")

Write "Total items: ", pyList.Count(), !

// Access by index
Write "Item 1: ", pyList.GetAt(0), !

```

### 3. Smart JSON Bridge

The `pyJSON` method handles the heavy lifting of converting IRIS Dynamic Objects into raw Python Dictionaries/Lists.

```objectscript
Set dynamic = {"name": "John", "roles": ["Admin", "User"]}
Set pyObj = ##class(%ZPython.Utils).pyJSON(dynamic)

// pyObj is now a true %SYS.Python object (dict)
Write ##class(%ZPython.Utils).IsType(pyObj, "dict") // Returns 1

```

---

## 🔧 API Reference

### `%ZPython.Utils`

| Method | Description |
| --- | --- |
| `pyDict(pProxy)` | Creates or wraps a Python dictionary. |
| `pyList(pProxy)` | Creates or wraps a Python list. |
| `pyJSON(pDynObj)` | Converts Dynamic Object to raw Python object. |
| `IsNone(pObj)` | Robust check if an object is Python `None`. |

### `%ZPython.Dict` / `%ZPython.List`

* `GetAt(index/key)`: Retrieve a value.
* `SetAt(val, index/key)`: Set a value.
* `Count()`: Get the size of the collection.
* `%GetIterator()`: Returns an IRIS-compatible iterator.


## 📜 License

MIT License. Feel free to use and contribute!
