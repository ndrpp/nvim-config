---@brief
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---
--- ```sh
--- npm install [-g] @biomejs/biome
--- ```
---
--- ### Monorepo support
---
--- `biome` supports monorepos by default. It will automatically find the `biome.json` corresponding to the package you are working on, as described in the [documentation](https://biomejs.dev/guides/big-projects/#monorepo). This works without the need of spawning multiple instances of `biome`, saving memory.

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
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'astro',
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescriptreact',
    'vue',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = {
      'package-lock.json',
      'yarn.lock',
      'pnpm-lock.yaml',
      'bun.lockb',
      'bun.lock',
      'deno.lock',
    }
    -- Set a lower priority to avoid spawning multiple servers on monorepos
    local biome_config_files = { 'biome.json', 'biome.jsonc' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, biome_config_files, { '.git' } }
      or vim.list_extend(root_markers, vim.list_extend(biome_config_files, { '.git' }))

    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    -- We know that the buffer is using Biome if it has a config file
    -- in its directory tree.
    local filename = vim.api.nvim_buf_get_name(bufnr)
    biome_config_files = insert_package_json(biome_config_files, 'biomejs', filename)
    local is_buffer_using_biome = vim.fs.find(biome_config_files, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_biome then
      return
    end

    on_dir(project_root)
  end,
}
