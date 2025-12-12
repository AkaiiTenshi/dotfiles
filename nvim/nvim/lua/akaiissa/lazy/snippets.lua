return {
    {
        "l3mon4d3/luasnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            local f = ls.function_node

            -- Extend filetypes
            ls.filetype_extend("cpp", { "c", "clangd" })

            -- Keymaps
            vim.keymap.set({"i"}, "<c-s>e", function() ls.expand() end, {silent = true})
            vim.keymap.set({"i", "s"}, "<c-s>;", function() ls.jump(1) end, {silent = true})
            vim.keymap.set({"i", "s"}, "<c-s>,", function() ls.jump(-1) end, {silent = true})
            vim.keymap.set({"i", "s"}, "<c-e>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, {silent = true})

            -- =====================
            -- Advanced C++ CLASS SNIPPETS
            -- =====================
            ls.add_snippets("cpp", {
                -- Advanced Orthodox Canonical Form snippet with getters/setters
                s("class_ocf", {
                    t({"#ifndef "}),
                    f(function(args) return args[1][1]:upper() .. "_HPP" end, {1}),
                    t({"", "# define ", ""}),
                    f(function(args) return args[1][1]:upper() .. "_HPP" end, {1}),
                    t({"", "class "}), i(1, "ClassName"), t({" {", "private:"}),
                    t({"", "", "public:"}),
                    t({"", "    // Orthodox Canonical Form", ""}),
                    t({"	"}), f(function(args) return args[1][1] end, {1}), t("(); // Default constructor"),
                    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t("(const "), f(function(args) return args[1][1] end, {1}), t(" &other); // Copy constructor"),
                    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t(" &operator=(const "), f(function(args) return args[1][1] end, {1}), t(" &other); // Copy assignment"),
                    t({"", "    ~"}), f(function(args) return args[1][1] end, {1}), t("()"), t("; // Destructor"),
                    t({"", "};", "", "#endif"})
                }),

                -- Simple constructor + destructor snippet
                s("class_simple", {
                    t({"#ifndef "}),
                    f(function(args) return args[1][1]:upper() .. "_HPP" end, {1}),
                    t({"", "#define "}),
                    f(function(args) return args[1][1]:upper() .. "_HPP" end, {1}),
                    t({"", "", "#include <iostream>", "#include <string>", ""}),
                    t("class "), i(1, "ClassName"), t({" {", "private:"}),
                    t({"", "    // attributes"}), i(2, "// type _attribute;"),
                    t({"", "", "public:"}),
                    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t("(); // Constructor"),
                    t({"", "    ~"}), f(function(args) return args[1][1] end, {1}), t("; // Destructor"),
                    t({"", "};", "", "#endif"})
                }),
            })
        end,
    }
}

