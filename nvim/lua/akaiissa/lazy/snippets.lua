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

            -- HTML snippets
            ls.add_snippets("html", {
                s("!", {
                    t({
                        "<!DOCTYPE html>",
                        "<html lang=\"en\">",
                        "<head>",
                        "    <meta charset=\"UTF-8\">",
                        "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
                        "    <title>",
                    }),
                    i(1, "Document"),
                    t({
                        "</title>",
                        "</head>",
                        "<body>",
                        "    ",
                    }),
                    i(2),
                    t({
                        "",
                        "</body>",
                        "</html>"
                    }),
                }),
            })

            -- JavaScript/TypeScript snippets
            ls.add_snippets("javascript", {
                s("log", { t("console.log("), i(1), t(")") }),
                s("imp", { t("import "), i(1, "name"), t(" from '"), i(2, "module"), t("'") }),
                s("exp", { t("export default "), i(1) }),
                s("fn", { 
                    t("function "), 
                    i(1, "name"), 
                    t("("), 
                    i(2), 
                    t(") {"),
                    t({ "", "  " }),
                    i(3),
                    t({ "", "}" })
                }),
                s("afn", { 
                    t("("), 
                    i(1), 
                    t(") => {"),
                    t({ "", "  " }),
                    i(2),
                    t({ "", "}" })
                }),
            })

            -- React snippets
            ls.add_snippets("javascriptreact", {
                s("rfc", {
                    t("export default function "),
                    i(1, "Component"),
                    t("() {"),
                    t({ "", "  return (" }),
                    t({ "", "    <div>" }),
                    t({ "", "      " }),
                    i(2),
                    t({ "", "    </div>" }),
                    t({ "", "  )" }),
                    t({ "", "}" }),
                }),
                s("useState", { 
                    t("const ["), 
                    i(1, "state"), 
                    t(", set"), 
                    i(2, "State"), 
                    t("] = useState("), 
                    i(3, "null"), 
                    t(")") 
                }),
                s("useEffect", {
                    t("useEffect(() => {"),
                    t({ "", "  " }),
                    i(1),
                    t({ "", "}, [" }),
                    i(2),
                    t("])")
                }),
            })

            -- TypeScript React snippets
            ls.add_snippets("typescriptreact", {
                s("rfc", {
                    t("export default function "),
                    i(1, "Component"),
                    t("() {"),
                    t({ "", "  return (" }),
                    t({ "", "    <div>" }),
                    t({ "", "      " }),
                    i(2),
                    t({ "", "    </div>" }),
                    t({ "", "  )" }),
                    t({ "", "}" }),
                }),
                s("useState", { 
                    t("const ["), 
                    i(1, "state"), 
                    t(", set"), 
                    i(2, "State"), 
                    t("] = useState<"), 
                    i(3, "Type"), 
                    t(">("), 
                    i(4, "null"), 
                    t(")") 
                }),
                s("useEffect", {
                    t("useEffect(() => {"),
                    t({ "", "  " }),
                    i(1),
                    t({ "", "}, [" }),
                    i(2),
                    t("])")
                }),
            })

            -- CSS snippets
            ls.add_snippets("css", {
                s("@media", {
                    t("@media (max-width: "),
                    i(1, "768px"),
                    t(") {"),
                    t({ "", "  " }),
                    i(2),
                    t({ "", "}" }),
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

                        local class_name
                        for _, l in ipairs(lines) do
                            -- Recherche du mot "class" suivi du nom de la classe
                            local found = l:match("^%s*class%s+([%w_]+)")

                            -- Comparaison directe avec le nom du fichier extrait
                            if found == filename then
                                class_name = found
                                break
                            end
                        end

                        if not class_name then
                            print("Alerte : Aucune classe correspondant au nom du fichier '" .. (filename or "inconnu") .. "' n'a été trouvée.")
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
                            elseif l:match("^%s*public%s*:") or l:match("^%s*protected%s*:") then
                                in_private = false
                            elseif in_private then
                                -- Pattern amélioré : 
                                -- 1. On cherche le type (peut contenir const, des espaces, des ::, <>)
                                -- 2. On cherche le nom (lettres, chiffres, underscores)
                                -- 3. On ignore l'init si elle existe déjà dans le .hpp
                                local type_part, name_part = l:match("^%s*(.-)%s+([%w_]+)%s*;")

                                if type_part and name_part then
                                    -- Nettoyage des espaces superflus
                                    type_part = type_part:gsub("^%s+", ""):gsub("%s+$", "")
                                    table.insert(attrs, { type = type_part, name = name_part })
                                end
                            end
                        end

                        -- Helper pour init par défaut
                        local function default_init_for_type(typ)
                            local ty = typ:lower()

                            -- On cherche si c'est un pointeur
                            if ty:match("%*") then
                                return "(NULL)"
                                -- Nombres entiers
                            elseif ty:match("int") or ty:match("size_t") or ty:match("short") or ty:match("long") then
                                return "(0)"
                                -- Nombres flottants
                            elseif ty:match("float") or ty:match("double") then
                                return "(0.0)"
                                -- Booléens
                            elseif ty:match("bool") then
                                return "(false)"
                                -- Strings
                            elseif ty:match("string") then
                                return "(\"default\")"
                                -- Caractères
                            elseif ty:match("char") then
                                return "('\\0')"
                                -- Par défaut, constructeur vide
                            else
                                return "()"
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
                        table.insert(out, "}")
                        table.insert(out, "")
                        table.insert(out, class_name .. "::" .. class_name .. "(const " .. class_name .. " &other)" .. copy_initializer .. " {")
                        table.insert(out, "}")
                        table.insert(out, "")
                        table.insert(out, class_name .. " &" .. class_name .. "::operator=(const " .. class_name .. " &other) {")
                        table.insert(out, "    if (this != &other) {")
                        for _, ln in ipairs(copy_lines) do table.insert(out, "        " .. ln) end
                        table.insert(out, "    }")
                        table.insert(out, "    return *this;")
                        table.insert(out, "}")
                        table.insert(out, "")
                        table.insert(out, class_name .. "::~" .. class_name .. "() {")
                        table.insert(out, "}")

                        return out
                    end, {}),
                }),
            })
        end
    }
}
