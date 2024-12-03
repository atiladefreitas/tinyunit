# TinyUnit

TinyUnit is a minimalist unit converter for Neovim, designed to seamlessly convert between different CSS units directly within your editor. Perfect for frontend developers who want to quickly convert measurements without leaving their editor.

https://github.com/user-attachments/assets/451ed70b-f771-447a-8186-d2cba03b32ee

## 🚀 Features

- 🪟 Convert units in a clean **floating window**
- 📏 Support for common CSS units (px, rem, em, vh, vw, mm, cm, in, pt)
- 🎯 Visual selection support for direct conversion
- ⚡ Fast and lightweight
- 🎨 Adapts to your Neovim **colorscheme**
- 🛠️ Compatible with **Lazy.nvim** for effortless installation

## 📦 Installation

### Prerequisites

- Neovim >= 0.8.0
- [Lazy.nvim](https://github.com/folke/lazy.nvim) as your plugin manager

### Using Lazy.nvim

```lua
return {
    "yourusername/tinyunit",
    config = function()
        require("tinyunit").setup({
            -- your custom config here (optional)
        })
    end,
}
```

### Default Configuration

TinyUnit comes with sensible defaults that you can override:


```lua
{
    window = {
        width = 30,         -- Width of the floating window
        height = 15,        -- Height of the floating window
        border = "rounded", -- Border style
        input_title = "Enter Value",
    },
    keymap = {
        open = "tc", -- Toggle converter window
        close = "q",         -- Close window
        convert = "",    -- Convert value
        escape = "",    -- Close window
    },
    units = {
        "px",
        "rem",
        "em",
        "vh",
        "vw",
        "mm",
        "cm",
        "in",
        "pt",
    },
    font = {
        base_size = 16,      -- Base font size in pixels (default: 16)
        -- Font size presets for different environments
        presets = {
            desktop = 16,    -- Desktop font size
            mobile = 16,     -- Mobile font size
            tablet = 16,     -- Tablet font size
            large_display = 16, -- Large display font size
        },
        -- Scale factors for relative units
        scale_factors = {
            heading1 = 2.0,    -- 32px
            heading2 = 1.5,    -- 24px
            heading3 = 1.25,   -- 20px
            small = 0.875,     -- 14px
            caption = 0.75,    -- 12px
        },
    },
}
```

## 🔑 Usage

### Basic Usage

1. Press `<leader>tc` to open the converter window
2. Enter a value with unit (e.g., "16px")
3. Press `<CR>` to see all possible conversions
4. Select a converted value and press `<CR>` to replace the original value

### Visual Selection

1. Select a value in your code (e.g., "16px")
2. Press `<leader>tc`
3. The converter will automatically convert the selected value
4. Choose a conversion and press `<CR>` to replace the selected text

## 🔄 Supported Conversions

TinyUnit supports conversions between the following units:

- px (pixels)
- rem (root em)
- em (relative to parent font size)
- vh (viewport height)
- vw (viewport width)
- mm (millimeters)
- cm (centimeters)
- in (inches)
- pt (points)

## 📥 Roadmap

- [ ] Custom conversion formulas
- [ ] More unit types (deg, rad, etc.)
- [x] Configuration for base font size
- [ ] Support for calc() expressions
- [ ] Unit conversion history

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Submit issues for bugs or feature requests
- Create pull requests with improvements
- Share feedback and suggestions

## 🌟 Acknowledgments

Special thanks to:
- The Neovim community
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- All contributors and users
