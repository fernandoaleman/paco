-- paco nvim options. Loaded by LazyVim before plugins.

-- nvim-treesitter's `main` branch installs parsers to stdpath("data")/site
-- but doesn't add that directory to runtimepath automatically. Without
-- this, :checkhealth nvim-treesitter reports
-- `ERROR: <site dir> is not in runtimepath` and compiled parsers
-- aren't loaded.
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
