return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          done_icon = "✔",
          progress_icon = { "dots" },
        },
      },
      notification = {
        window = {
          winblend = 0,
          border = "none",
        },
      },
    },
  }
}
