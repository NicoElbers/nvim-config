local opt = vim.opt

-- set line number options
opt.nu = true
opt.rnu = true

opt.scrolloff = 10

-- set search options
opt.hlsearch = false
opt.ignorecase = true

-- set write options
opt.autowrite = true

-- set backup options
opt.backup = false
opt.writebackup = true
opt.backupext =".bak"

print(vim.fn.stdpath "data")
