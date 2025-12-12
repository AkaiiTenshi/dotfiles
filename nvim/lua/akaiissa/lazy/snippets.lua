return {
    {
        "L3MON4D3/LuaSnip",
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

            ---------------------------------------------------
            -- Snippets C++ Class
            ---------------------------------------------------
            ls.add_snippets("cpp", {
                -- Orthodox Canonical Form HPP
                s("class_ocf", {
                    t({"#pragma once", ""}),
                    t({"", "class "}), i(1, "ClassName"), t({" {", "	private:"}),
                    t({"", "    // attributes"}), i(2, "// type _attribute;"),
                    t({"", "", "	public:"}),
                    t({"", "    // Orthodox Canonical Form", ""}),
                    t({"    "}), f(function(args) return args[1][1] end, {1}), t("();"),
                    t({"", "    "}), f(function(args) return args[1][1] end, {1}),
                    t("(const "), f(function(args) return args[1][1] end, {1}),
                    t(" &other);"),
                    t({"", "    "}), f(function(args) return args[1][1] end, {1}),
                    t(" &operator=(const "), f(function(args) return args[1][1] end, {1}),
                    t(" &other);"),
                    t({"", "    ~"}), f(function(args) return args[1][1] end, {1}), t("();"),
                    t({"", "};"}),
                }),

                -- Simple class HPP
                s("class_simple", {
                    t({"#ifndef "}),
                    f(function(args) return args[1][1]:upper() .. "_HPP" end, {1}),
                    t({"", "#define "}),
                    f(function(args) return args[1][1]:upper() .. "_HPP" end, {1}),
                    t({"", "", "#include <iostream>", "#include <string>", ""}),
                    t("class "), i(1, "ClassName"), t({" {", "public:"}),
                    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t("();"),
                    t({"", "    ~"}), f(function(args) return args[1][1] end, {1}), t("();"),
                    t({"", "};", "", "#endif"}),
                }),
            })

            ---------------------------------------------------
ls.add_snippets("cpp", {
    s("ocf_impl", {
        f(function(_, snip)
            local filepath = vim.api.nvim_buf_get_name(0)
            if not filepath or filepath == "" then
                return { "// Error: buffer has no filename" }
            end

            local filename = filepath:match("([^/]+)%.cpp$") -- exemple: Animal

            -- Chemins possibles pour le header
            local same_dir_hpp = filepath:gsub("%.cpp$", ".hpp")
            local includes_hpp = filepath:gsub("srcs/", "includes/"):gsub("%.cpp$", ".hpp")

            -- Trouver le .hpp existant
            local hpp_path
            local fh = io.open(same_dir_hpp, "r")
            if fh then
                fh:close()
                hpp_path = same_dir_hpp
            else
                fh = io.open(includes_hpp, "r")
                if fh then
                    fh:close()
                    hpp_path = includes_hpp
                else
                    return { "// Error: impossible de trouver le fichier .hpp pour " .. filename }
                end
            end

            -- Lire le header
            local lines = {}
            for line in io.lines(hpp_path) do
                table.insert(lines, line)
            end

            -- Trouver le nom de la classe
            local class_name
            for _, l in ipairs(lines) do
                local found = l:match("^%s*class%s+([%w_]+)")
                if found then
                    class_name = found
                    break
                end
            end
            if not class_name then
                return { "// Error: aucun nom de classe trouvé dans " .. hpp_path }
            end

            -- Extraire les attributs privés
            local attrs = {}
            local in_private = false
            for _, l in ipairs(lines) do
                if l:match("^%s*private%s*:") then
                    in_private = true
                elseif l:match("^%s*public%s*:") then
                    in_private = false
                elseif in_private then
                    local type_, name_, init = l:match("^%s*([%w_%:<>%s%,]+)%s+([%w_]+)%s*=%s*(.-);")
                    if not type_ then
                        type_, name_ = l:match("^%s*([%w_%:<>]+)%s+([%w_]+)%s*;")
                    end
                    if type_ and name_ then
                        type_ = type_:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
                        table.insert(attrs, { type = type_, name = name_, init = init })
                    end
                end
            end

            -- Helper pour init par défaut
            local function default_init_for_type(typ, explicit_init)
                if explicit_init and explicit_init ~= "" then
                    return "(" .. explicit_init .. ")"
                end
                local t = typ:lower()
                if t:match("int") or t:match("unsigned") or t:match("short") or t:match("long") or t:match("^size_t") then
                    return "(0)"
                elseif t:match("float") or t:match("double") then
                    return "(0.0)"
                elseif t:match("bool") then
                    return "(false)"
                elseif t:match("string") or t:match("std::string") then
                    return "(\"\")"
                elseif t:match("char") then
                    return "('\\0')"
                else
                    return "()" -- default construct
                end
            end

            -- Constructeur par défaut
            local init_parts = {}
            for _, a in ipairs(attrs) do
                local init = default_init_for_type(a.type, a.init)
                table.insert(init_parts, a.name .. init)
            end
            local default_initializer = #init_parts > 0 and " : " .. table.concat(init_parts, ", ") or ""

            -- Copy constructor
            local copy_parts = {}
            for _, a in ipairs(attrs) do
                table.insert(copy_parts, a.name .. "(other." .. a.name .. ")")
            end
            local copy_initializer = #copy_parts > 0 and " : " .. table.concat(copy_parts, ", ") or ""

            -- operator= body
            local copy_lines = {}
            if #attrs == 0 then
                table.insert(copy_lines, "    // Aucun attribut à copier")
            else
                for _, a in ipairs(attrs) do
                    table.insert(copy_lines, "    this->" .. a.name .. " = other." .. a.name .. ";")
                end
            end

            -- Génération finale
            local out = {}
            table.insert(out, '#include "' .. filename .. '.hpp"')
            table.insert(out, "")
            table.insert(out, class_name .. "::" .. class_name .. "()" .. default_initializer .. " {")
            table.insert(out, '    std::cout << "' .. class_name .. ' default constructor called" << std::endl;')
            table.insert(out, "}")
            table.insert(out, "")
            table.insert(out, class_name .. "::" .. class_name .. "(const " .. class_name .. " &other)" .. copy_initializer .. " {")
            table.insert(out, '    std::cout << "' .. class_name .. ' copy constructor called" << std::endl;')
            table.insert(out, "}")
            table.insert(out, "")
            table.insert(out, class_name .. " &" .. class_name .. "::operator=(const " .. class_name .. " &other) {")
            table.insert(out, '    std::cout << "' .. class_name .. ' copy assignment called" << std::endl;')
            table.insert(out, "    if (this != &other) {")
            for _, ln in ipairs(copy_lines) do table.insert(out, "        " .. ln) end
            table.insert(out, "    }")
            table.insert(out, "    return *this;")
            table.insert(out, "}")
            table.insert(out, "")
            table.insert(out, class_name .. "::~" .. class_name .. "() {")
            table.insert(out, '    std::cout << "' .. class_name .. ' destructor called" << std::endl;')
            table.insert(out, "}")

            return out
        end, {}),
    }),
})
end
	}
}
