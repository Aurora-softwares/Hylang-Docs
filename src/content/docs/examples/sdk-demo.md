---
title: "SDK Demo"
---

> Development reference from [Hylang-Compiler](https://github.com/Aurora-softwares/Hylang-Compiler/tree/Development). Commands and source paths on this page are relative to that repository checkout. For current task status, use the [development project](https://github.com/orgs/Aurora-softwares/projects/4).

This SDK workspace demonstrates project build/test/check/format commands and local registry publish/search/install with a consumer executable. Run from the compiler repository root after building `build/hy`. These workspace/package commands require the C++ SDK; they are not native compiler commands.

```bash
./build/hy build samples/sdk_demo/SdkDemo.hyproj
./build/hy test samples/sdk_demo/SdkDemo.hyproj
./build/hy fmt --check samples/sdk_demo
./build/hy check samples/sdk_demo/SdkDemo.hyproj --json
./build/hy package init-registry build/local-registry
./build/hy package publish samples/sdk_demo/SdkDemo.Core/SdkDemo.Core.hyproj --registry build/local-registry
./build/hy package search SdkDemo --registry build/local-registry
./build/hy package install samples/sdk_demo/SdkDemo.Consumer/SdkDemo.Consumer.hyproj SdkDemo.Core --registry build/local-registry
./build/hy run samples/sdk_demo/SdkDemo.Consumer/SdkDemo.Consumer.hyproj
```
