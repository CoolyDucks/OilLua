# OilLua 🐍✨

**Author:** CoolyDucks  
**License:** Boost Software License (BSL-1.0)  

OilLua is an **extended Lua scripting language** designed to combine the simplicity and flexibility of Lua with **extra features** for modern scripting, game development, and custom projects.  
Write scripts more expressively with **TAGs, COLOR, classes, and the z library**! 🚀

---

## Key Features ⭐

- **TAG System 🏷️** – Organize and label objects, variables, or elements for clarity.  
- **COLOR Support 🎨** – Easily define and use RGB colors in scripts.  
- **Class Support 🏛️** – Provides OOP-like behavior with tables and methods.  
- **z Library 🗜️** – Compress and decompress strings efficiently.  
- **Easy Scripting 🖋️** – Write Lua-like scripts with enhanced capabilities.  
- **Future Low-Level / Machine Code ⚡** – High-performance compilation for secure deployment.

---

## Example Usage 📝

```oilua
TAG=BLACK
Black=<COLOR#0.0.0>

Dog = {}
Dog.__index = Dog

function Dog:new(o)
    o = o or {}
    setmetatable(o, Dog)
    return o
end

function Dog:bark()
    print("Woof! I am a dog. 🐶")
    print("My color is:", Black.r, Black.g, Black.b)
end

local d = Dog:new()
d:bark()


# Tutorial 👌

- Android (Termux Only)
mkdir OilLua
cd ~/OilLua
git https://github.com/CoolyDucks/OilLua
pkg install lua5.3
lua oillua.lua YOURproject.oil

- Linux

pkg install lua5.3
lua oillua.lua YOURproject.oil



