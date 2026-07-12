vim.filetype.add({
  extension = {
    tfstate = "json",
  },
  pattern = {
    [".*%.tfstate%.backup"] = "json",
  },
})
