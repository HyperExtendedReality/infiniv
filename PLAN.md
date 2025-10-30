1\. Build a C++ Wrapper for the SpacetimeDB Rust SDK: Create a C++ wrapper using Rust's Foreign Function Interface (FFI) to expose the Rust SDK's functionality to your C++ codebase.

2\. Integrate a WASM Runtime: Embed a WASM runtime (like Wasmer or Wasmtime) into your game client and server to execute the compiled game logic.

3\. Create a `citizen-scripting-wasm` Component: Develop a new scripting component responsible for managing the lifecycle of the WASM modules.

4\. Connect Scripting to the SpacetimeDB Wrapper: Enable the new WASM scripting component to communicate with the SpacetimeDB wrapper for all data and state synchronization.



&nbsp;Overall Goal:



&nbsp; Integrate SpacetimeDB for state management and a WASM-based scripting engine for game logic, leveraging Rust

&nbsp;  for the SpacetimeDB client and a C++ WASM runtime.



&nbsp; ---



&nbsp; Phase 1: SpacetimeDB Rust Client Wrapper (C++ FFI)



&nbsp; Objective: Create a C++-callable library that interacts with the SpacetimeDB Rust client SDK.

&nbsp; Rationale: Provides a high-performance, cross-platform interface to SpacetimeDB from the existing C++

&nbsp; codebase.



&nbsp; Steps:



&nbsp;  1. Set up Rust Development Environment:

&nbsp;      \* Action: Ensure Rust toolchain (rustup, cargo) is installed.

&nbsp;      \* Command: rustup install stable (if not already installed)



&nbsp;  2. Create a New Rust Crate (`spacetime\_client\_ffi`):

&nbsp;      \* Action: Create a new Rust library crate that will expose C-compatible functions.

&nbsp;      \* Command: cargo new --lib spacetime\_client\_ffi

&nbsp;      \* File: spacetime\_client\_ffi/Cargo.toml



&nbsp;   1         \[package]

&nbsp;   2         name = "spacetime\_client\_ffi"

&nbsp;   3         version = "0.1.0"

&nbsp;   4         edition = "2021"

&nbsp;   5

&nbsp;   6         \[lib]

&nbsp;   7         crate-type = \["cdylib"] # This creates a C-compatible dynamic library

&nbsp;   8

&nbsp;   9         \[dependencies]

&nbsp;  10         # Add SpacetimeDB Rust client SDK here once available or use a placeholder

&nbsp;  11         # spacetimedb-sdk = "0.x.x"

&nbsp;  12         # For now, we'll use a dummy dependency or assume direct FFI to C++



&nbsp;  3. Implement SpacetimeDB Client Logic in Rust:

&nbsp;      \* Action: Write Rust code to connect to SpacetimeDB, subscribe to tables, send reducers, and handle

&nbsp;        events. Expose these functionalities as extern "C" functions.

&nbsp;      \* File: spacetime\_client\_ffi/src/lib.rs



&nbsp;    1         use std::ffi::{CStr, CString};

&nbsp;    2         use std::os::raw::c\_char;

&nbsp;    3

&nbsp;    4         // Placeholder for SpacetimeDB client connection

&nbsp;    5         // In a real scenario, this would use the spacetimedb-sdk

&nbsp;    6         struct SpacetimeDBClient {

&nbsp;    7             // ... actual client state ...

&nbsp;    8             connection\_status: bool,

&nbsp;    9         }

&nbsp;   10

&nbsp;   11         impl SpacetimeDBClient {

&nbsp;   12             fn new() -> Self {

&nbsp;   13                 SpacetimeDBClient {

&nbsp;   14                     connection\_status: false,

&nbsp;   15                 }

&nbsp;   16             }

&nbsp;   17

&nbsp;   18             fn connect(\&mut self, url: \&str) -> bool {

&nbsp;   19                 println!("Rust client connecting to: {}", url);

&nbsp;   20                 // Simulate connection logic

&nbsp;   21                 self.connection\_status = true;

&nbsp;   22                 true

&nbsp;   23             }

&nbsp;   24

&nbsp;   25             fn disconnect(\&mut self) {

&nbsp;   26                 println!("Rust client disconnecting.");

&nbsp;   27                 self.connection\_status = false;

&nbsp;   28             }

&nbsp;   29

&nbsp;   30             fn is\_connected(\&self) -> bool {

&nbsp;   31                 self.connection\_status

&nbsp;   32             }

&nbsp;   33

&nbsp;   34             // Example: Send a reducer (game action)

&nbsp;   35             fn send\_reducer(\&self, reducer\_name: \&str, payload\_json: \&str) -> bool {

&nbsp;   36                 if self.connection\_status {

&nbsp;   37                     println!("Sending reducer '{}' with payload: {}", reducer\_name, payload\_json);

&nbsp;   38                     // In a real scenario, this would use the SpacetimeDB SDK to send the reducer

&nbsp;   39                     true

&nbsp;   40                 } else {

&nbsp;   41                     false

&nbsp;   42                 }

&nbsp;   43             }

&nbsp;   44

&nbsp;   45             // Example: Subscribe to a table

&nbsp;   46             fn subscribe\_to\_table(\&self, table\_name: \&str) -> bool {

&nbsp;   47                 if self.connection\_status {

&nbsp;   48                     println!("Subscribing to table: {}", table\_name);

&nbsp;   49                     // In a real scenario, this would use the SpacetimeDB SDK

&nbsp;   50                     true

&nbsp;   51                 } else {

&nbsp;   52                     false

&nbsp;   53                 }

&nbsp;   54             }

&nbsp;   55         }

&nbsp;   56

&nbsp;   57         // Global client instance (for simplicity in FFI, consider thread-safety for real apps)

&nbsp;   58         static mut CLIENT: Option<SpacetimeDBClient> = None;

&nbsp;   59

&nbsp;   60         #\[no\_mangle]

&nbsp;   61         pub extern "C" fn spacetimedb\_client\_init() {

&nbsp;   62             unsafe {

&nbsp;   63                 if CLIENT.is\_none() {

&nbsp;   64                     CLIENT = Some(SpacetimeDBClient::new());

&nbsp;   65                     println!("SpacetimeDB client initialized.");

&nbsp;   66                 }

&nbsp;   67             }

&nbsp;   68         }

&nbsp;   69

&nbsp;   70         #\[no\_mangle]

&nbsp;   71         pub extern "C" fn spacetimedb\_client\_connect(url\_ptr: \*const c\_char) -> bool {

&nbsp;   72             unsafe {

&nbsp;   73                 if let Some(client) = CLIENT.as\_mut() {

&nbsp;   74                     let c\_str = CStr::from\_ptr(url\_ptr);

&nbsp;   75                     let url = c\_str.to\_str().unwrap();

&nbsp;   76                     client.connect(url)

&nbsp;   77                 } else {

&nbsp;   78                     false

&nbsp;   79                 }

&nbsp;   80             }

&nbsp;   81         }

&nbsp;   82

&nbsp;   83         #\[no\_mangle]

&nbsp;   84         pub extern "C" fn spacetimedb\_client\_disconnect() {

&nbsp;   85             unsafe {

&nbsp;   86                 if let Some(client) = CLIENT.as\_mut() {

&nbsp;   87                     client.disconnect();

&nbsp;   88                 }

&nbsp;   89             }

&nbsp;   90         }

&nbsp;   91

&nbsp;   92         #\[no\_mangle]

&nbsp;   93         pub extern "C" fn spacetimedb\_client\_is\_connected() -> bool {

&nbsp;   94             unsafe {

&nbsp;   95                 CLIENT.as\_ref().map\_or(false, |client| client.is\_connected())

&nbsp;   96             }

&nbsp;   97         }

&nbsp;   98

&nbsp;   99         #\[no\_mangle]

&nbsp;  100         pub extern "C" fn spacetimedb\_client\_send\_reducer(

&nbsp;  101             reducer\_name\_ptr: \*const c\_char,

&nbsp;  102             payload\_json\_ptr: \*const c\_char,

&nbsp;  103         ) -> bool {

&nbsp;  104             unsafe {

&nbsp;  105                 if let Some(client) = CLIENT.as\_ref() {

&nbsp;  106                     let reducer\_name = CStr::from\_ptr(reducer\_name\_ptr).to\_str().unwrap();

&nbsp;  107                     let payload\_json = CStr::from\_ptr(payload\_json\_ptr).to\_str().unwrap();

&nbsp;  108                     client.send\_reducer(reducer\_name, payload\_json)

&nbsp;  109                 } else {

&nbsp;  110                     false

&nbsp;  111                 }

&nbsp;  112             }

&nbsp;  113         }

&nbsp;  114

&nbsp;  115         #\[no\_mangle]

&nbsp;  116         pub extern "C" fn spacetimedb\_client\_subscribe\_to\_table(

&nbsp;  117             table\_name\_ptr: \*const c\_char,

&nbsp;  118         ) -> bool {

&nbsp;  119             unsafe {

&nbsp;  120                 if let Some(client) = CLIENT.as\_ref() {

&nbsp;  121                     let table\_name = CStr::from\_ptr(table\_name\_ptr).to\_str().unwrap();

&nbsp;  122                     client.subscribe\_to\_table(table\_name)

&nbsp;  123                 } else {

&nbsp;  124                     false

&nbsp;  125                 }

&nbsp;  126             }

&nbsp;  127         }

&nbsp;  128

&nbsp;  129         // Function to free CString allocated by Rust (if any were returned)

&nbsp;  130         #\[no\_mangle]

&nbsp;  131         pub extern "C" fn spacetimedb\_client\_free\_string(s: \*mut c\_char) {

&nbsp;  132             unsafe {

&nbsp;  133                 if s.is\_null() { return }

&nbsp;  134                 \_ = CString::from\_raw(s);

&nbsp;  135             }

&nbsp;  136         }



&nbsp;  4. Build the Rust Crate:

&nbsp;      \* Action: Compile the Rust code into a dynamic library.

&nbsp;      \* Command: cargo build --release

&nbsp;      \* Result: A .dll (Windows), .so (Linux), or .dylib (macOS) file will be generated in target/release/.



&nbsp;  5. Create C++ Header for FFI:

&nbsp;      \* Action: Define a C++ header file that declares the extern "C" functions from the Rust library.

&nbsp;      \* File: shared/SpacetimeDBClientFFI.h (or similar, following project conventions)



&nbsp;   1         #pragma once

&nbsp;   2

&nbsp;   3         #ifdef \_\_cplusplus

&nbsp;   4         extern "C" {

&nbsp;   5         #endif

&nbsp;   6

&nbsp;   7         // Initialize the SpacetimeDB client

&nbsp;   8         void spacetimedb\_client\_init();

&nbsp;   9

&nbsp;  10         // Connect to a SpacetimeDB instance

&nbsp;  11         bool spacetimedb\_client\_connect(const char\* url);

&nbsp;  12

&nbsp;  13         // Disconnect from SpacetimeDB

&nbsp;  14         void spacetimedb\_client\_disconnect();

&nbsp;  15

&nbsp;  16         // Check if connected

&nbsp;  17         bool spacetimedb\_client\_is\_connected();

&nbsp;  18

&nbsp;  19         // Send a reducer (game action)

&nbsp;  20         bool spacetimedb\_client\_send\_reducer(const char\* reducer\_name, const char\* payload\_json);

&nbsp;  21

&nbsp;  22         // Subscribe to a table

&nbsp;  23         bool spacetimedb\_client\_subscribe\_to\_table(const char\* table\_name);

&nbsp;  24

&nbsp;  25         // Free a string allocated by Rust

&nbsp;  26         void spacetimedb\_client\_free\_string(char\* s);

&nbsp;  27

&nbsp;  28         #ifdef \_\_cplusplus

&nbsp;  29         }

&nbsp;  30         #endif



&nbsp;  6. Integrate into C++ Build System:

&nbsp;      \* Action: Modify premake5.lua files (or component.lua if that's the primary build config) to link against

&nbsp;         the generated Rust library.

&nbsp;      \* Example (conceptual `component.lua` for a new `citizen-spacetimedb-client` component):



&nbsp;   1         -- components/citizen-spacetimedb-client/component.lua

&nbsp;   2         return function()

&nbsp;   3             add\_dependencies {

&nbsp;   4                 "citizen:scripting:core", -- If it needs scripting context

&nbsp;   5                 -- ... other dependencies ...

&nbsp;   6             }

&nbsp;   7

&nbsp;   8             -- Assuming the Rust library is placed in a known location, e.g., deplibs/lib

&nbsp;   9             links { "spacetime\_client\_ffi" }

&nbsp;  10             libdirs { \_ROOTPATH .. "/deplibs/lib" }

&nbsp;  11             includedirs { \_ROOTPATH .. "/shared" } -- For SpacetimeDBClientFFI.h

&nbsp;  12         end

&nbsp;      \* Action: Copy the generated Rust library (spacetime\_client\_ffi.dll/.so/.dylib) to a location accessible

&nbsp;        by the C++ build system (e.g., deplibs/lib).



&nbsp; ---



&nbsp; Phase 2: WASM Scripting Engine Integration



&nbsp; Objective: Embed a WASM runtime (e.g., Wasmtime) into the C++ application to execute game logic.

&nbsp; Rationale: Allows for flexible, sandboxed, and potentially hot-reloadable game logic written in

&nbsp; WASM-compilable languages.



&nbsp; Steps:



&nbsp;  1. Choose a WASM Runtime and Integrate:

&nbsp;      \* Action: Select a C++-friendly WASM runtime (e.g., Wasmtime, Wasmer). For this example, let's assume

&nbsp;        Wasmtime.

&nbsp;      \* Action: Download/build Wasmtime C API and integrate its headers and libraries into the project's

&nbsp;        deplibs.

&nbsp;      \* File: components/citizen-scripting-wasm/component.lua (conceptual)



&nbsp;   1         -- components/citizen-scripting-wasm/component.lua

&nbsp;   2         return function()

&nbsp;   3             add\_dependencies {

&nbsp;   4                 "citizen:scripting:core",

&nbsp;   5                 -- ... other dependencies ...

&nbsp;   6             }

&nbsp;   7

&nbsp;   8             links { "wasmtime" } -- Link against Wasmtime library

&nbsp;   9             libdirs { \_ROOTPATH .. "/deplibs/lib" }

&nbsp;  10             includedirs { \_ROOTPATH .. "/deplibs/include/wasmtime" }

&nbsp;  11         end



&nbsp;  2. Create `citizen-scripting-wasm` Component:

&nbsp;      \* Action: Create a new component to manage the WASM runtime and script execution.

&nbsp;      \* File: components/citizen-scripting-wasm/component.json



&nbsp;   1         {

&nbsp;   2             "name": "citizen:scripting:wasm",

&nbsp;   3             "version": "0.1.0",

&nbsp;   4             "dependencies": \[

&nbsp;   5                 "fx\[2]",

&nbsp;   6                 "citizen:scripting:core",

&nbsp;   7                 "citizen:spacetimedb-client" // Dependency on our new SpacetimeDB client wrapper

&nbsp;   8             ],

&nbsp;   9             "provides": \[]

&nbsp;  10         }

&nbsp;      \* File: components/citizen-scripting-wasm/src/WasmScriptRuntime.h



&nbsp;   1         #pragma once

&nbsp;   2         #include <string>

&nbsp;   3         #include <vector>

&nbsp;   4         #include <functional>

&nbsp;   5         #include "wasmtime.h" // Wasmtime C API header

&nbsp;   6

&nbsp;   7         namespace fx

&nbsp;   8         {

&nbsp;   9             class WasmScriptRuntime

&nbsp;  10             {

&nbsp;  11             public:

&nbsp;  12                 WasmScriptRuntime();

&nbsp;  13                 ~WasmScriptRuntime();

&nbsp;  14

&nbsp;  15                 bool Initialize();

&nbsp;  16                 bool LoadModule(const std::string\& moduleName, const std::vector<uint8\_t>\& wasmBytes);

&nbsp;  17                 bool CallFunction(const std::string\& moduleName, const std::string\& funcName, const

&nbsp;     std::vector<std::string>\& args);

&nbsp;  18

&nbsp;  19                 // Expose C++ functions to WASM (host functions)

&nbsp;  20                 void RegisterHostFunction(const std::string\& moduleName, const std::string\& funcName,

&nbsp;     wasm\_func\_callback\_t callback);

&nbsp;  21

&nbsp;  22             private:

&nbsp;  23                 wasm\_engine\_t\* engine;

&nbsp;  24                 wasm\_store\_t\* store;

&nbsp;  25                 // Map to store instantiated modules

&nbsp;  26                 // std::map<std::string, wasm\_instance\_t\*> modules;

&nbsp;  27                 // ... more complex state management for modules and functions

&nbsp;  28             };

&nbsp;  29         }

&nbsp;      \* File: components/citizen-scripting-wasm/src/WasmScriptRuntime.cpp



&nbsp;    1         #include "WasmScriptRuntime.h"

&nbsp;    2         #include <iostream>

&nbsp;    3

&nbsp;    4         // Include our SpacetimeDB FFI header

&nbsp;    5         #include "SpacetimeDBClientFFI.h"

&nbsp;    6

&nbsp;    7         namespace fx

&nbsp;    8         {

&nbsp;    9             WasmScriptRuntime::WasmScriptRuntime() : engine(nullptr), store(nullptr) {}

&nbsp;   10

&nbsp;   11             WasmScriptRuntime::~WasmScriptRuntime()

&nbsp;   12             {

&nbsp;   13                 // Cleanup Wasmtime resources

&nbsp;   14                 if (store) wasm\_store\_delete(store);

&nbsp;   15                 if (engine) wasm\_engine\_delete(engine);

&nbsp;   16             }

&nbsp;   17

&nbsp;   18             bool WasmScriptRuntime::Initialize()

&nbsp;   19             {

&nbsp;   20                 engine = wasm\_engine\_new();

&nbsp;   21                 if (!engine) {

&nbsp;   22                     std::cerr << "Failed to create wasm engine" << std::endl;

&nbsp;   23                     return false;

&nbsp;   24                 }

&nbsp;   25                 store = wasm\_store\_new(engine);

&nbsp;   26                 if (!store) {

&nbsp;   27                     std::cerr << "Failed to create wasm store" << std::endl;

&nbsp;   28                     return false;

&nbsp;   29                 }

&nbsp;   30

&nbsp;   31                 // Initialize SpacetimeDB client

&nbsp;   32                 spacetimedb\_client\_init();

&nbsp;   33

&nbsp;   34                 std::cout << "WASM Script Runtime initialized." << std::endl;

&nbsp;   35                 return true;

&nbsp;   36             }

&nbsp;   37

&nbsp;   38             bool WasmScriptRuntime::LoadModule(const std::string\& moduleName, const std::vector<uint8\_t>\&

&nbsp;      wasmBytes)

&nbsp;   39             {

&nbsp;   40                 // Example: Load and instantiate a WASM module

&nbsp;   41                 wasm\_byte\_vec\_t wasm\_bytes;

&nbsp;   42                 wasm\_byte\_vec\_new(\&wasm\_bytes, wasmBytes.size(), wasmBytes.data());

&nbsp;   43

&nbsp;   44                 wasm\_module\_t\* module = wasm\_module\_new(store, \&wasm\_bytes);

&nbsp;   45                 wasm\_byte\_vec\_delete(\&wasm\_bytes);

&nbsp;   46

&nbsp;   47                 if (!module) {

&nbsp;   48                     std::cerr << "Failed to create wasm module from bytes" << std::endl;

&nbsp;   49                     return false;

&nbsp;   50                 }

&nbsp;   51

&nbsp;   52                 // In a real implementation, you'd handle imports and exports

&nbsp;   53                 // For now, a simple instantiation

&nbsp;   54                 wasm\_instance\_t\* instance = wasm\_instance\_new(store, module, nullptr, nullptr);

&nbsp;   55                 if (!instance) {

&nbsp;   56                     std::cerr << "Failed to instantiate wasm module" << std::endl;

&nbsp;   57                     wasm\_module\_delete(module);

&nbsp;   58                     return false;

&nbsp;   59                 }

&nbsp;   60

&nbsp;   61                 // Store the module and instance for later use

&nbsp;   62                 // modules\[moduleName] = instance; // Requires proper map and cleanup

&nbsp;   63

&nbsp;   64                 wasm\_module\_delete(module); // Module can be deleted after instantiation

&nbsp;   65

&nbsp;   66                 std::cout << "WASM module '" << moduleName << "' loaded." << std::endl;

&nbsp;   67                 return true;

&nbsp;   68             }

&nbsp;   69

&nbsp;   70             bool WasmScriptRuntime::CallFunction(const std::string\& moduleName, const std::string\&

&nbsp;      funcName, const std::vector<std::string>\& args)

&nbsp;   71             {

&nbsp;   72                 // This is a highly simplified example.

&nbsp;   73                 // In reality, you'd retrieve the instance, find the exported function,

&nbsp;   74                 // convert args to wasm\_val\_t, call, and convert results.

&nbsp;   75

&nbsp;   76                 std::cout << "Calling WASM function '" << funcName << "' in module '" << moduleName << "'

&nbsp;      with args: ";

&nbsp;   77                 for (const auto\& arg : args) {

&nbsp;   78                     std::cout << arg << " ";

&nbsp;   79                 }

&nbsp;   80                 std::cout << std::endl;

&nbsp;   81

&nbsp;   82                 // Example: Call a SpacetimeDB FFI function from C++ (which WASM would also call)

&nbsp;   83                 if (funcName == "connectToSpacetimeDB") {

&nbsp;   84                     if (!args.empty()) {

&nbsp;   85                         bool connected = spacetimedb\_client\_connect(args\[0].c\_str());

&nbsp;   86                         std::cout << "SpacetimeDB connection attempt: " << (connected ? "SUCCESS" :

&nbsp;      "FAILED") << std::endl;

&nbsp;   87                         return connected;

&nbsp;   88                     }

&nbsp;   89                 } else if (funcName == "sendGameReducer") {

&nbsp;   90                     if (args.size() >= 2) {

&nbsp;   91                         bool sent = spacetimedb\_client\_send\_reducer(args\[0].c\_str(), args\[1].c\_str());

&nbsp;   92                         std::cout << "Reducer '" << args\[0] << "' sent: " << (sent ? "SUCCESS" : "FAILED"

&nbsp;      ) << std::endl;

&nbsp;   93                         return sent;

&nbsp;   94                     }

&nbsp;   95                 }

&nbsp;   96

&nbsp;   97                 return true; // Placeholder

&nbsp;   98             }

&nbsp;   99

&nbsp;  100             void WasmScriptRuntime::RegisterHostFunction(const std::string\& moduleName, const

&nbsp;      std::string\& funcName, wasm\_func\_callback\_t callback)

&nbsp;  101             {

&nbsp;  102                 // This would involve creating a wasm\_func\_t and adding it to the imports

&nbsp;  103                 // when instantiating a module.

&nbsp;  104                 std::cout << "Registering host function: " << funcName << " for module " << moduleName <<

&nbsp;      std::endl;

&nbsp;  105             }

&nbsp;  106         }



&nbsp;  3. Expose SpacetimeDB FFI to WASM (Host Functions):

&nbsp;      \* Action: Define C++ functions that wrap the SpacetimeDBClientFFI.h functions and expose them to the WASM

&nbsp;         runtime as host functions.

&nbsp;      \* File: components/citizen-scripting-wasm/src/WasmHostFunctions.cpp (conceptual)



&nbsp;   1         #include "WasmScriptRuntime.h"

&nbsp;   2         #include "SpacetimeDBClientFFI.h"

&nbsp;   3         #include "wasmtime.h" // For wasm\_val\_t and related types

&nbsp;   4         #include <iostream>

&nbsp;   5

&nbsp;   6         // Example host function: WASM calls this to connect to SpacetimeDB

&nbsp;   7         wasm\_trap\_t\* host\_connect\_spacetimedb(

&nbsp;   8             void\* env, const wasm\_val\_vec\_t\* args, wasm\_val\_vec\_t\* results) {

&nbsp;   9             // args\[0] should be a pointer to the URL string in WASM memory

&nbsp;  10             // results\[0] will be a boolean indicating success

&nbsp;  11

&nbsp;  12             // This requires careful handling of WASM memory to read the string

&nbsp;  13             // For simplicity, let's assume a direct string for now (not ideal for real WASM)

&nbsp;  14             // In a real scenario, you'd get the WASM memory, read the string from the pointer/length.

&nbsp;  15

&nbsp;  16             // Placeholder: Directly call the C++ FFI function

&nbsp;  17             const char\* url = "ws://localhost:8000"; // Example URL, should come from WASM

&nbsp;  18             bool connected = spacetimedb\_client\_connect(url);

&nbsp;  19

&nbsp;  20             results->data\[0] = WASM\_I32\_VAL(connected ? 1 : 0); // Return 1 for true, 0 for false

&nbsp;  21             return nullptr; // No trap

&nbsp;  22         }

&nbsp;  23

&nbsp;  24         // Example host function: WASM calls this to send a reducer

&nbsp;  25         wasm\_trap\_t\* host\_send\_reducer(

&nbsp;  26             void\* env, const wasm\_val\_vec\_t\* args, wasm\_val\_vec\_t\* results) {

&nbsp;  27             // args\[0] = reducer\_name\_ptr, args\[1] = payload\_json\_ptr

&nbsp;  28             // results\[0] = boolean success

&nbsp;  29

&nbsp;  30             // Again, careful WASM memory handling needed to read strings

&nbsp;  31             const char\* reducer\_name = "move\_player"; // Example

&nbsp;  32             const char\* payload\_json = "{\\"x\\":10,\\"y\\":20}"; // Example

&nbsp;  33

&nbsp;  34             bool sent = spacetimedb\_client\_send\_reducer(reducer\_name, payload\_json);

&nbsp;  35

&nbsp;  36             results->data\[0] = WASM\_I32\_VAL(sent ? 1 : 0);

&nbsp;  37             return nullptr;

&nbsp;  38         }

&nbsp;  39

&nbsp;  40         // Function to register all host functions

&nbsp;  41         void RegisterWasmHostFunctions(fx::WasmScriptRuntime\& runtime) {

&nbsp;  42             // This would be called during module loading/instantiation

&nbsp;  43             // runtime.RegisterHostFunction("spacetimedb\_connect", host\_connect\_spacetimedb);

&nbsp;  44             // runtime.RegisterHostFunction("spacetimedb\_send\_reducer", host\_send\_reducer);

&nbsp;  45             std::cout << "Registered SpacetimeDB host functions for WASM." << std::endl;

&nbsp;  46         }



&nbsp; ---



&nbsp; Phase 3: Integration and Usage



&nbsp; Objective: Integrate the WASM scripting engine and SpacetimeDB client into the existing game client/server

&nbsp; logic.



&nbsp; Steps:



&nbsp;  1. Modify Game State Management (`citizen-server-impl`):

&nbsp;      \* Action: The existing ServerGameState (from ServerGameState.h/.cpp) would likely be modified to interact

&nbsp;         with SpacetimeDB instead of its current state management.

&nbsp;      \* Example (conceptual change in `ServerGameState.cpp`):



&nbsp;   1         // Old way:

&nbsp;   2         // void ServerGameState::UpdatePlayerPosition(int playerId, float x, float y) {

&nbsp;   3         //     m\_playerStates\[playerId].x = x;

&nbsp;   4         //     m\_playerStates\[playerId].y = y;

&nbsp;   5         //     // Notify clients

&nbsp;   6         // }

&nbsp;   7

&nbsp;   8         // New way (using SpacetimeDB):

&nbsp;   9         #include "SpacetimeDBClientFFI.h"

&nbsp;  10         #include "json.hpp" // Assuming you have a JSON library like nlohmann/json

&nbsp;  11

&nbsp;  12         void ServerGameState::InitializeSpacetimeDB() {

&nbsp;  13             spacetimedb\_client\_init();

&nbsp;  14             spacetimedb\_client\_connect("ws://localhost:8000"); // Connect to your SpacetimeDB instance

&nbsp;  15             spacetimedb\_client\_subscribe\_to\_table("PlayerPositions"); // Subscribe to relevant tables

&nbsp;  16         }

&nbsp;  17

&nbsp;  18         void ServerGameState::SendPlayerMoveReducer(int playerId, float x, float y) {

&nbsp;  19             nlohmann::json payload;

&nbsp;  20             payload\["player\_id"] = playerId;

&nbsp;  21             payload\["x"] = x;

&nbsp;  22             payload\["y"] = y;

&nbsp;  23

&nbsp;  24             spacetimedb\_client\_send\_reducer("move\_player", payload.dump().c\_str());

&nbsp;  25         }

&nbsp;  26

&nbsp;  27         // You would also need to handle incoming SpacetimeDB updates to update your local game state

&nbsp;  28         // This would likely involve callbacks registered with the Rust FFI client.



&nbsp;  2. Modify Scripting Host (`citizen-scripting-core` or `scripting-server`):

&nbsp;      \* Action: The existing scripting host would need to be updated to recognize and load WASM modules via the

&nbsp;         citizen-scripting-wasm component.

&nbsp;      \* Example (conceptual `ScriptingHost.cpp`):



&nbsp;   1         #include "WasmScriptRuntime.h"

&nbsp;   2         // ... other includes ...

&nbsp;   3

&nbsp;   4         namespace fx

&nbsp;   5         {

&nbsp;   6             class ScriptingHost {

&nbsp;   7             private:

&nbsp;   8                 WasmScriptRuntime m\_wasmRuntime;

&nbsp;   9                 // ... other scripting runtimes (Lua, V8) ...

&nbsp;  10

&nbsp;  11             public:

&nbsp;  12                 void Initialize() {

&nbsp;  13                     m\_wasmRuntime.Initialize();

&nbsp;  14                     // ... initialize other runtimes ...

&nbsp;  15                 }

&nbsp;  16

&nbsp;  17                 void LoadScript(const std::string\& scriptPath, ScriptType type) {

&nbsp;  18                     if (type == ScriptType::WASM) {

&nbsp;  19                         // Read WASM bytes from scriptPath

&nbsp;  20                         std::vector<uint8\_t> wasmBytes = ReadWasmFile(scriptPath);

&nbsp;  21                         m\_wasmRuntime.LoadModule(scriptPath, wasmBytes);

&nbsp;  22                     } else {

&nbsp;  23                         // ... handle other script types ...

&nbsp;  24                     }

&nbsp;  25                 }

&nbsp;  26

&nbsp;  27                 void CallScriptFunction(const std::string\& scriptPath, const std::string\& funcName, const

&nbsp;     std::vector<std::string>\& args) {

&nbsp;  28                     // Determine script type and call appropriate runtime

&nbsp;  29                     m\_wasmRuntime.CallFunction(scriptPath, funcName, args);

&nbsp;  30                 }

&nbsp;  31             };

&nbsp;  32         }



&nbsp;  3. WASM Game Logic Development:

&nbsp;      \* Action: Game logic (e.g., player movement, inventory, interactions) would be written in a language like

&nbsp;         Rust, compiled to WASM, and then loaded by the citizen-scripting-wasm component.

&nbsp;      \* Example (conceptual Rust WASM module `game\_logic.rs`):



&nbsp;   1         // game\_logic/src/lib.rs

&nbsp;   2         #\[no\_mangle]

&nbsp;   3         pub extern "C" fn init\_game\_logic() {

&nbsp;   4             // Call host function to connect to SpacetimeDB

&nbsp;   5             // This would require defining an import in the WASM module and linking it

&nbsp;   6             // extern "C" {

&nbsp;   7             //     fn spacetimedb\_connect(url\_ptr: \*const u8, url\_len: usize) -> i32;

&nbsp;   8             // }

&nbsp;   9             // unsafe { spacetimedb\_connect(...) };

&nbsp;  10             println!("WASM game logic initialized!");

&nbsp;  11         }

&nbsp;  12

&nbsp;  13         #\[no\_mangle]

&nbsp;  14         pub extern "C" fn on\_player\_move(player\_id: u32, x: f32, y: f32) {

&nbsp;  15             println!("WASM: Player {} moved to ({}, {})", player\_id, x, y);

&nbsp;  16             // Call host function to send reducer to SpacetimeDB

&nbsp;  17             // extern "C" {

&nbsp;  18             //     fn spacetimedb\_send\_reducer(reducer\_name\_ptr: \*const u8, reducer\_name\_len: usize,

&nbsp;     payload\_ptr: \*const u8, payload\_len: usize) -> i32;

&nbsp;  19             // }

&nbsp;  20             // unsafe { spacetimedb\_send\_reducer(...) };

&nbsp;  21         }

&nbsp;  22

&nbsp;  23         // Other game logic functions...

&nbsp;      \* Action: Compile this Rust code to WASM using wasm-pack or cargo build --target wasm32-unknown-unknown.



&nbsp; ---



&nbsp; Custom Stack Example (Natives Conversion)



&nbsp; You asked for an example of converting a custom stack, specifically if one file handles all the natives. Let's

&nbsp;  assume you have a file like components/scripting-gta/src/Natives.cpp that registers a bunch of native

&nbsp; functions for your existing scripting engines.



&nbsp; Current Native Registration (Conceptual `Natives.cpp`):



&nbsp;   1 // components/scripting-gta/src/Natives.cpp

&nbsp;   2

&nbsp;   3 // Example native function

&nbsp;   4 void Native\_SET\_PLAYER\_HEALTH(int player\_id, int health) {

&nbsp;   5     // ... game engine call to set player health ...

&nbsp;   6     std::cout << "Setting player " << player\_id << " health to " << health << std::endl;

&nbsp;   7 }

&nbsp;   8

&nbsp;   9 // Function to register natives for a scripting engine (e.g., Lua)

&nbsp;  10 void RegisterLuaNatives(lua\_State\* L) {

&nbsp;  11     lua\_register(L, "SET\_PLAYER\_HEALTH", \[](lua\_State\* L) {

&nbsp;  12         int player\_id = luaL\_checkinteger(L, 1);

&nbsp;  13         int health = luaL\_checkinteger(L, 2);

&nbsp;  14         Native\_SET\_PLAYER\_HEALTH(player\_id, health);

&nbsp;  15         return 0;

&nbsp;  16     });

&nbsp;  17     // ... register many other natives ...

&nbsp;  18 }

&nbsp;  19

&nbsp;  20 // Function to register natives for another scripting engine (e.g., V8)

&nbsp;  21 void RegisterV8Natives(v8::Isolate\* isolate, v8::Local<v8::ObjectTemplate> global) {

&nbsp;  22     global->Set(v8::String::NewFromUtf8(isolate, "SET\_PLAYER\_HEALTH").ToLocalChecked(),

&nbsp;  23                 v8::FunctionTemplate::New(isolate, \[](const v8::FunctionCallbackInfo<v8::Value>\& info) {

&nbsp;  24         // ... extract args, call Native\_SET\_PLAYER\_HEALTH ...

&nbsp;  25     }));

&nbsp;  26     // ... register many other natives ...

&nbsp;  27 }



&nbsp; Conversion for WASM (Conceptual `WasmHostFunctions.cpp` and `Natives.cpp` modification):



&nbsp; To expose these natives to WASM, you would:



&nbsp;  1. Create WASM-compatible Host Functions:

&nbsp;      \* Action: For each native, create a wasm\_trap\_t\* function that the WASM runtime can call. These functions

&nbsp;         will extract arguments from wasm\_val\_vec\_t, call the underlying C++ native, and return results.

&nbsp;      \* File: components/citizen-scripting-wasm/src/WasmHostFunctions.cpp



&nbsp;   1         #include "WasmScriptRuntime.h"

&nbsp;   2         #include "wasmtime.h"

&nbsp;   3         #include <iostream>

&nbsp;   4

&nbsp;   5         // Forward declaration of the actual native implementation

&nbsp;   6         // In a real scenario, you'd include the header where Native\_SET\_PLAYER\_HEALTH is declared

&nbsp;   7         void Native\_SET\_PLAYER\_HEALTH(int player\_id, int health);

&nbsp;   8

&nbsp;   9         // WASM Host Function for SET\_PLAYER\_HEALTH

&nbsp;  10         wasm\_trap\_t\* host\_SET\_PLAYER\_HEALTH(

&nbsp;  11             void\* env, const wasm\_val\_vec\_t\* args, wasm\_val\_vec\_t\* results) {

&nbsp;  12             if (args->num\_elems != 2 || args->data\[0].kind != WASM\_I32 || args->data\[1].kind != WASM\_I32)

&nbsp;     {

&nbsp;  13                 // Handle error: incorrect arguments

&nbsp;  14                 return wasm\_trap\_new(wasm\_store\_new(nullptr), wasm\_byte\_vec\_new\_uninitialized(nullptr, 0

&nbsp;     )); // Simplified error

&nbsp;  15             }

&nbsp;  16

&nbsp;  17             int player\_id = args->data\[0].of.i32;

&nbsp;  18             int health = args->data\[1].of.i32;

&nbsp;  19

&nbsp;  20             Native\_SET\_PLAYER\_HEALTH(player\_id, health);

&nbsp;  21

&nbsp;  22             // No return value for this native

&nbsp;  23             return nullptr;

&nbsp;  24         }

&nbsp;  25

&nbsp;  26         // Function to register all WASM host natives

&nbsp;  27         void RegisterWasmNatives(fx::WasmScriptRuntime\& runtime, wasm\_linker\_t\* linker) {

&nbsp;  28             // This would be called during WASM module instantiation

&nbsp;  29             // For each native, create a wasm\_func\_t and add it to the linker

&nbsp;  30             // wasm\_func\_t\* func = wasm\_func\_new(runtime.store, wasm\_func\_type\_new(...),

&nbsp;     host\_SET\_PLAYER\_HEALTH, nullptr);

&nbsp;  31             // wasm\_linker\_define\_func(linker, "env", "SET\_PLAYER\_HEALTH", func);

&nbsp;  32

&nbsp;  33             std::cout << "Registered WASM host native: SET\_PLAYER\_HEALTH" << std::endl;

&nbsp;  34             // ... register other natives ...

&nbsp;  35         }



&nbsp;  2. Modify `Natives.cpp` (Optional, for shared native logic):

&nbsp;      \* Action: If Natives.cpp contains the core C++ implementation of the natives, you might not need to

&nbsp;        change it much, just ensure the functions are callable from your WASM host functions.



&nbsp;  3. WASM Module Calling Native (Conceptual Rust WASM `game\_logic.rs`):

&nbsp;      \* Action: In your Rust WASM module, you would declare the native as an extern function and call it.

&nbsp;      \* File: game\_logic/src/lib.rs



&nbsp;   1         // game\_logic/src/lib.rs

&nbsp;   2         #\[link(wasm\_import\_module = "env")] // Assuming "env" is the module name for host functions

&nbsp;   3         extern "C" {

&nbsp;   4             fn SET\_PLAYER\_HEALTH(player\_id: i32, health: i32);

&nbsp;   5         }

&nbsp;   6

&nbsp;   7         #\[no\_mangle]

&nbsp;   8         pub extern "C" fn set\_player\_health\_from\_wasm(player\_id: i32, health: i32) {

&nbsp;   9             println!("WASM: Calling host function SET\_PLAYER\_HEALTH for player {} with health {}",

&nbsp;     player\_id, health);

&nbsp;  10             unsafe {

&nbsp;  11                 SET\_PLAYER\_HEALTH(player\_id, health);

&nbsp;  12             }

&nbsp;  13         }



&nbsp; ---



&nbsp; Summary of Key Changes and New Components:



&nbsp;  \* New Rust Crate: spacetime\_client\_ffi (builds to a .dll/.so/.dylib)

&nbsp;  \* New C++ Header: shared/SpacetimeDBClientFFI.h (declares Rust FFI functions)

&nbsp;  \* New Component: components/citizen-spacetimedb-client (conceptual, to manage the C++ wrapper around Rust

&nbsp;    FFI)

&nbsp;  \* New Component: components/citizen-scripting-wasm (manages WASM runtime, loads modules, registers host

&nbsp;    functions)

&nbsp;  \* Modified Build System: premake5.lua or component.lua files to link new libraries.

&nbsp;  \* Modified `ServerGameState`: To use SpacetimeDBClientFFI for state management.

&nbsp;  \* Modified Scripting Host: To load and execute WASM modules.

&nbsp;  \* New WASM Modules: Game logic written in Rust (or other WASM-compilable languages) and compiled to .wasm

&nbsp;    files.

&nbsp;  \* WASM Host Functions: C++ functions that expose existing game natives and SpacetimeDB client functionality

&nbsp;    to WASM modules.



&nbsp; This plan provides a detailed roadmap. The next step would be to start implementing Phase 1, beginning with

&nbsp; the Rust FFI client.

