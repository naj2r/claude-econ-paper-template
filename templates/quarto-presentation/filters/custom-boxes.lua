-- custom-boxes.lua
-- Converts Quarto div classes to LaTeX environments for Beamer output.
-- For RevealJS/PPTX, divs pass through naturally (styled by CSS / ignored).
-- For Beamer, wraps content in \begin{envname}...\end{envname}
-- matching environments defined in styles/beamer-preamble.tex.

-- All box classes that need LaTeX environment wrapping
local box_classes = {
  "keybox",
  "resultbox",
  "methodbox",
  "highlightbox",
  "assumptionbox",
  "eqbox",
  "softbox",
  "quotebox"
}

function Div(el)
  -- Only transform for Beamer output
  if FORMAT ~= "beamer" then
    return el
  end

  for _, cls in ipairs(box_classes) do
    if el.classes:includes(cls) then
      local beginenv = pandoc.RawBlock("latex", [[\begin{]] .. cls .. [[}]])
      local endenv = pandoc.RawBlock("latex", [[\end{]] .. cls .. [[}]])
      local blocks = pandoc.List({beginenv})
      blocks:extend(el.content)
      blocks:insert(endenv)
      return blocks
    end
  end

  return el
end
