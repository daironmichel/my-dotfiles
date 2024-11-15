return {
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
        "marilari88/neotest-vitest",
        "thenbe/neotest-playwright",
      },
      opts = {
        adapters = {
          ["neotest-vitest"] = {
            -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
            -- filter_dir = function(name, rel_path, root)
            --   return name ~= "frontend"
            -- end,
  
            -- is_test_file = function(file_path)
            --   if string.match(file_path, "/tests") then
            --     return true
            --   end
            --
            --   return string.match(file_path, ".*(?:test|spec)\\.tsx?")
            -- end,
          },
          ["neotest-python"] = {
            runner = "pytest",
          },
          ["neotest-playwright"] = {
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          },
        },
      },
    },
  }