package("magic_enum")
    set_kind("library", {headeronly = true})

    set_homepage("https://github.com/Neargye/magic_enum")
    set_description("Static reflection for enums (to string, from string, iteration) for modern C++, work with any enum type without any macro or boilerplate code")
    set_license("MIT")

    add_urls("https://github.com/Neargye/magic_enum/archive/refs/tags/$(version).tar.gz",
             "https://github.com/Neargye/magic_enum.git")
    add_versions("v0.7.3", "b8d0cd848546fee136dc1fa4bb021a1e4dc8fe98e44d8c119faa3ef387636bf7")

    add_deps("cmake")

    on_install(function (package)
        local configs = {
            "-DMAGIC_ENUM_OPT_BUILD_EXAMPLES=OFF",
            "-DMAGIC_ENUM_OPT_BUILD_TESTS=OFF",
            "-DMAGIC_ENUM_OPT_INSTALL=ON"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        import("package.tools.cmake").install(package, configs, {buildir = "build"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            enum class Color { RED = 2, BLUE = 4, GREEN = 8 };
            void test() {
                Color color = Color::RED;
                auto color_name = magic_enum::enum_name(color);
            }
        ]]}, {configs = {languages = "c++17"}, includes = "magic_enum.hpp"}))
    end)
