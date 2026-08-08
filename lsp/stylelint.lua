---@brief
---
--- https://github.com/stylelint/vscode-stylelint/tree/main/packages/language-server
---
--- `stylelint-language-server` can be installed via npm `npm install -g @stylelint/language-server`.
--- ```

local lsp = vim.lsp

local stylelint_config_files = {
  '.stylelintrc',
  '.stylelintrc.mjs',
  '.stylelintrc.cjs',
  '.stylelintrc.js',
  '.stylelintrc.json',
  '.stylelintrc.yaml',
  '.stylelintrc.yml',
  'stylelint.config.mjs',
  'stylelint.config.cjs',
  'stylelint.config.js',
}

--- Appends `new_names` to `root_files` if `field` is found in any such file in any ancestor of `fname`.
---
--- NOTE: this does a "breadth-first" search, so is broken for multi-project workspaces:
--- https://github.com/neovim/nvim-lspconfig/issues/3818#issuecomment-2848836794
---
--- @param root_files string[] List of root-marker files to append to.
--- @param new_names string[] Potential root-marker filenames (e.g. `{ 'package.json', 'package.json5' }`) to inspect for the given `field`.
--- @param field string | string[] Field(s) to search for in the given `new_names` files.
--- @param fname string Full path of the current buffer name to start searching upwards from.
--- @param match_mode? 'all' | 'any' Match mode - all or any field passed as `field`
function root_markers_with_field(root_files, new_names, field, fname, match_mode)
  local path = vim.fn.fnamemodify(fname, ':h')
  local found = vim.fs.find(new_names, { path = path, upward = true, type = 'file' })
  local fields = type(field) == 'string' and { field } or field
  local to_find = vim.deepcopy(fields)
  local matcher = (match_mode or 'any') == 'any'
      and function(line)
        return vim.iter(fields):any(function(s)
          return line:find(s)
        end)
      end
    or function(line)
      to_find = vim
        .iter(to_find)
        :filter(function(s)
          return not line:find(s)
        end)
        :totable()
      if #to_find == 0 then
        to_find = vim.deepcopy(files)
        return true
      end
      return false
    end
  for _, f in ipairs(found or {}) do
    -- Match the given `field`.
    local file = assert(io.open(f, 'r'))
    for line in file:lines() do
      if matcher(line) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
    file:close()
  end

  return root_files
end

function insert_package_json(root_files, field, fname)
    return root_markers_with_field(root_files, { 'package.json', 'package.json5' }, field, fname)
end

---@type vim.lsp.Config
return {
  cmd = { 'stylelint-language-server', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'html',
    'less',
    'scss',
    'vue',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })

    -- exclude deno
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
      return
    end

    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    -- We know that the buffer is using Stylelint if it has a config file
    -- in its directory tree.
    --
    -- Stylelint support package.json files as config files.
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local stylelint_config_files_with_package_json =
      insert_package_json(stylelint_config_files, 'stylelintConfig', filename)
    local is_buffer_using_stylelint = vim.fs.find(stylelint_config_files_with_package_json, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_stylelint then
      return
    end

    on_dir(project_root)
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspStylelintFixAll', function()
      client:request_sync('workspace/executeCommand', {
        command = 'stylelint.applyAutoFix',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})
  end,
  -- Refer to https://github.com/stylelint/vscode-stylelint?tab=readme-ov-file#extension-settings for documentation.
  ---@type lspconfig.settings.stylelint_language_server
  settings = {
    stylelint = {
      validate = { 'css', 'postcss' },
      snippet = { 'css', 'postcss' },
    },
  },
}
